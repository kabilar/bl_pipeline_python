import os
import pathlib
import subprocess
import json
import pandas as pd
import datajoint as dj
import bl_pipeline.acquisition as acquisition
import utility.dj_shortcuts as dj_short
import re

# 
status_dict = acquisition.status_pipeline_dict

#FOR PNI endpoint
pni_ep_id = '6ce834d6-ff8a-11e6-bad1-22000b9a448b'
pni_ephys_root_data_dir   = '/jukebox/archive/brody/RATTER/PhysData/Raw/'
pni_ephys_sorted_data_dir = '/mnt/cup/labs/brody/RATTER/PhysData/Test_ephys_pipeline_NP_sorted/'

#For tiger endpoint
default_user = 'alvaros'
tiger_gpu_host = 'tigergpu.princeton.edu'
tiger_ep_dir = 'a9df83d2-42f0-11e6-80cf-22000b1701d1'
tiger_home_dir = '/tigress/' + default_user
tiger_ephys_root_data_dir = tiger_home_dir + '/ephys_raw/'
tiger_ephys_sorted_data_dir = tiger_home_dir + '/ephys_sorted/'
tiger_slurm_files_dir = tiger_home_dir + '/slurm_files/'
tiger_log_files_dir = tiger_home_dir + '/job_log/'

default_preprocessing_tool = 'kilosort2'
default_matlab_ver = 'R2020b'

#Slurm default values for queue job
slurm_dict_default = {
    'job-name': 'kilosort2',
    'nodes': 1,
    'ntasks': 1,
    'time': '5:00:00',
    'mem': '200G',
    'gres': 'gpu:1',
    'mail-user': 'alvaros@princeton.edu',
    'mail-type': ['begin', 'END'],
    'output': 'job_log/kilojob.log'
}

system_process = {
    'SUCCESS': 0
}

slurm_states = {
    'SUCCESS': 'COMPLETED'
}


def get_active_sessions():

    status_query = 'status_pipeline > ' + str(status_dict['ERROR']['Value'])
    status_query += ' and status_pipeline < ' + str(status_dict['CANONICAL_PIPELINE']['Value'])

    sessions_active = acquisition.AcquisitionSessionsTestAutoPipeline & status_query
    df_sessions = pd.DataFrame(sessions_active.fetch(as_dict=True))

    key_list = dj_short.get_primary_key_fields(acquisition.AcquisitionSessionsTestAutoPipeline)
    df_sessions['query_key'] = df_sessions.loc[:, key_list].to_dict(orient='records')

    return df_sessions

def create_slurm_params_file(slurm_dict):

    text_dict = ''
    for slurm_param in slurm_dict.keys():

        if isinstance(slurm_dict[slurm_param], list):
            for list_param in slurm_dict[slurm_param]:
                text_dict += '#SBATCH --' + str(slurm_param) + '=' + str(list_param) + '\n'
        else:
            text_dict += '#SBATCH --' + str(slurm_param) + '=' + str(slurm_dict[slurm_param]) + '\n'

    return text_dict


def create_str_from_dict(key_dict):

    slurm_file_name = ''
    for i in key_dict.keys():
        slurm_file_name += str(i) + '_' +  str(key_dict[i])
    return slurm_file_name

def write_slurm_file(slurm_path, slurm_text):

    f_slurm = open(slurm_path, "w")
    f_slurm.write(slurm_text)
    f_slurm.close()

def generate_slurm_kilosort_text(slurm_dict, matlab_ver, user_run, raw_file_path):

    slurm_text = '#!/bin/bash\n'
    slurm_text += create_slurm_params_file(slurm_dict)
    slurm_text += 'module load matlab/' + matlab_ver + '\n'
    slurm_text += 'cd /tigress/' + user_run + '\n'
    slurm_text += 'matlab -singleCompThread -nodisplay -nosplash -r "pause(1); ' + "disp('aqui la chides'); exit" + '"'
    #slurm_text += 'matlab -singleCompThread -nodisplay -nosplash -r "addpath(''/tigress/' + user_run +  "/run_kilosort/spikesorters/'); "
    #slurm_text += "run_ks2('/tigress/" + user_run + "/ephys_raw" + raw_file_path + "','/tigress/" + user_run + "/run_kilosort/tmp/'); exit" + '"' 

    return slurm_text

def scp_file_transfer(source, dest):

    p = subprocess.Popen(["scp", source, dest])
    transfer_status = p.wait()
    return transfer_status


def queue_slurm_file(ssh_user, slurm_file):

    id_slurm_job = -1
    command = ['ssh', ssh_user, 'sbatch', slurm_file]
    print(command)
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    print('aftercommand before comm')
    stdout, stderr = p.communicate()
    print('aftercommand after comm')
    print(stdout.decode('UTF-8'))
    print(stderr.decode('UTF-8'))
    if p.returncode == system_process['SUCCESS']:
        batch_job_sentence = stdout.decode('UTF-8')
        id_slurm_job   = batch_job_sentence.replace("Submitted batch job ","")
        id_slurm_job   = re.sub(r"[\n\t\s]*", "", id_slurm_job)

    return p.returncode, id_slurm_job


def check_slurm_job(ssh_user, jobid):
    
    state_job = 'FAIL'
    command = ['ssh', ssh_user, 'sacct', '--job', jobid, '--format=state']
    print(command)
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    stdout, stderr = p.communicate()
    if p.returncode == system_process['SUCCESS']:
        stdout = stdout.decode('UTF-8')
        state_job = stdout.split("\n")[2].strip()
        print(stdout)

    return state_job


def request_globus_transfer(source, destination):

    globus_command = ["globus", "transfer", source, destination, '--recursive', '--format', 'json']
    print(globus_command)
    s = subprocess.run(globus_command, capture_output=True)
    transfer_request = json.loads(s.stdout.decode('UTF-8'))
    return transfer_request


def request_globus_transfer_status(id_task):

    globus_command = ["globus", "task", "show", id_task, '--format', 'json']
    print(globus_command)
    s = subprocess.run(globus_command, capture_output=True)
    transfer_request = json.loads(s.stdout.decode('UTF-8'))
    return transfer_request


def globus_transfer_raw_ephys_pni_tiger(raw_rel_path):

    source_ep = pni_ep_id    +':'+ pni_ephys_root_data_dir   + raw_rel_path
    dest_ep   = tiger_ep_dir +':'+ tiger_ephys_root_data_dir + raw_rel_path
    transfer_request = request_globus_transfer(source_ep, dest_ep)
    return transfer_request


def globus_transfer_sorted_ephys_tiger_pni(sorted_rel_path):

    source_ep = tiger_ep_dir +':'+ tiger_ephys_sorted_data_dir + sorted_rel_path
    dest_ep   = pni_ep_id    +':'+ pni_ephys_sorted_data_dir   + sorted_rel_path
    transfer_request = request_globus_transfer(source_ep, dest_ep)
    return transfer_request


def update_status_pipeline(session_key_dict, task_field, task_id, status):

    if task_field is not None:
        update_task_id_dict = session_key_dict.copy()
        update_task_id_dict[task_field] = task_id
        acquisition.AcquisitionSessionsTestAutoPipeline.update1(update_task_id_dict)
    
    update_status_dict = session_key_dict.copy()
    update_status_dict['status_pipeline'] = status
    acquisition.AcquisitionSessionsTestAutoPipeline.update1(update_status_dict)


def filter_session_status(df_sessions, status):

    df_sessions_status = df_sessions.loc[df_sessions['status_pipeline'] == status, :]
    df_sessions_status = df_sessions_status.reset_index(drop=True)


def process_new_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        raw_rel_path = df_session.loc[i, 'acquisition_raw_rel_path']
        transfer_request = globus_transfer_raw_ephys_pni_tiger(raw_rel_path)
        if transfer_request['code'] == 'Accepted':
            status_update = True
            key = df_session.loc[i, 'query_key']
            task_id = transfer_request['task_id']
            update_status_pipeline(key, status_dict['RAW_FILE_REQUEST']['Task_Field'], task_id, status_dict['RAW_FILE_REQUEST']['Value'])

    return status_update

def process_raw_file_request_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        id_task = df_session.loc[i, status_dict['RAW_FILE_REQUEST']['Task_Field']]
        transfer_request = request_globus_transfer_status(str(id_task))
        if transfer_request['status'] == 'SUCCEEDED':
            status_update = True
            key = df_session.loc[i, 'query_key']
            task_id = transfer_request['task_id']
            update_status_pipeline(key, status_dict['RAW_FILE_CLUSTER']['Task_Field'], task_id, status_dict['RAW_FILE_CLUSTER']['Value'])

    return status_update

def process_raw_file_cluster_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        raw_rel_path = df_session.loc[i, 'acquisition_raw_rel_path']
        key = df_session.loc[i, 'query_key']
        
        slurm_dict = slurm_dict_default.copy()
        slurm_dict['job-name'] = default_preprocessing_tool + "_" + create_str_from_dict(key)
        slurm_dict['output'] = str(pathlib.Path(tiger_log_files_dir,default_preprocessing_tool + create_str_from_dict(key) + '.log'))

        slurm_text = generate_slurm_kilosort_text(slurm_dict, default_matlab_ver, default_user, raw_rel_path)
        slurm_file_name = 'slurm_' + create_str_from_dict(key) +  '.slurm'
        slurm_file_path = str(pathlib.Path("slurm_files",slurm_file_name))

        write_slurm_file(slurm_file_path, slurm_text)
        
        tiger_slurm_user = default_user+'@'+tiger_gpu_host
        tiger_slurm_location = tiger_slurm_user+':'+tiger_slurm_files_dir+slurm_file_name
        transfer_request = scp_file_transfer(slurm_file_path, tiger_slurm_location)
       
        if transfer_request == system_process['SUCCESS']:
            slurm_queue_status, slurm_jobid = queue_slurm_file(tiger_slurm_user, tiger_slurm_files_dir+slurm_file_name)

            if transfer_request == system_process['SUCCESS']:
                status_update = True
                update_status_pipeline(key, status_dict['JOB_QUEUE']['Task_Field'], slurm_jobid, status_dict['JOB_QUEUE']['Value'])

    return status_update

def process_job_queue_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        slurm_jobid = df_session.loc[i, 'slurm_id_sorting']
        key = df_session.loc[i, 'query_key']

        ssh_user = tiger_slurm_user = default_user+'@'+tiger_gpu_host
        job_status = check_slurm_job(ssh_user, slurm_jobid)
        print(job_status)
        print(slurm_states['SUCCESS'])

        print(job_status.encode('UTF-8'))
        print(slurm_states['SUCCESS'].encode('UTF-8'))

        if job_status == slurm_states['SUCCESS']:
            status_update = True
            update_status_pipeline(key, status_dict['JOB_FINISHED']['Task_Field'], slurm_jobid, status_dict['JOB_FINISHED']['Value'])

    return status_update

def process_job_finished_request_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        raw_rel_path = df_session.loc[i, 'acquisition_post_rel_path']
        transfer_request = globus_transfer_sorted_ephys_tiger_pni(raw_rel_path)
        if transfer_request['code'] == 'Accepted':
            status_update = True
            key = df_session.loc[i, 'query_key']
            task_id = transfer_request['task_id']
            update_status_pipeline(key, status_dict['PROC_FILE_REQUEST']['Task_Field'], task_id, status_dict['PROC_FILE_REQUEST']['Value'])

    return status_update

def process_proc_file_request_session(df_session):

    status_update = False
    for i in range(df_session.shape[0]):

        id_task = df_session.loc[i, status_dict['PROC_FILE_REQUEST']['Task_Field']]
        transfer_request = request_globus_transfer_status(str(id_task))
        if transfer_request['status'] == 'SUCCEEDED':
            status_update = True
            key = df_session.loc[i, 'query_key']
            task_id = transfer_request['task_id']
            update_status_pipeline(key, status_dict['PROC_FILE_HOME']['Task_Field'], task_id, status_dict['PROC_FILE_HOME']['Value'])

    return status_update

def pipeline_handler_main():

    df_sessions = get_active_sessions()
    print(df_sessions['status_pipeline'])

    # Process all sessions in status NEW_SESSION
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['NEW_SESSION']['Value'], :]
    status_update = process_new_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status RAW_FILE_REQUEST
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['RAW_FILE_REQUEST']['Value'], :]
    status_update = process_raw_file_request_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status RAW_FILE_CLUSTER
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['RAW_FILE_CLUSTER']['Value'], :]
    status_update = process_raw_file_cluster_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status JOB_QUEUE
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['JOB_QUEUE']['Value'], :]
    status_update = process_job_queue_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status JOB_FINISHED
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['JOB_FINISHED']['Value'], :]
    status_update = process_job_finished_request_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status PROC_FILE_REQUEST
    filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['PROC_FILE_REQUEST']['Value'], :]
    status_update = process_proc_file_request_session(filt_df_session)
    if status_update:
        df_sessions = get_active_sessions()

    print(df_sessions['status_pipeline'])

    # Process all sessions in status PROC_FILE_HOME
    #filt_df_session = df_sessions.loc[df_sessions['status_pipeline'] == status_dict['PROC_FILE_HOME']['Value'], :]
    #process_proc_file_home_session(filt_df_session)
