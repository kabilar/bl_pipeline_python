from scripts.conf_file_finding import try_find_conf_file
try_find_conf_file()

import re
import datajoint as dj

from bl_pipeline.ephys_element import subject, Session, \
                                      probe_element, ephys_element, \
                                      get_ephys_root_data_dir, \
                                      get_session_directory

acquisition = dj.create_virtual_module('bl_new_acquisition', 'bl_new_acquisition')

from element_data_loader.utils import find_full_path
from element_array_ephys.readers import spikeglx

#FileNotFoundError: No SpikeGLX data found for probe insertion - serial number
# subject has multiple probes, even though chronic element?
# & 'sessid=751888'
# & 'sessid=752191'
# & 'sessid=752787'
# & 'sessid=753704'
# & 'sessid=754891'
# & 'sessid=755179'
# & 'sessid=755811'
# & 'sessid=757148'
# & 'sessid=757184'
# & 'sessid=757200'
# & 'sessid=757218'
# & 'sessid=757242'
# & 'sessid=757262'
# & 'sessid=758100'
# & 'sessid=743260'
# from element_array_ephys.readers import spikeglx
# spikeglx.SpikeGLXMeta('/home/pu.win.princeton.edu/kg7524/mnt_archive/brody/RATTER/PhysData/Raw/Adrian/A241/2019-10-28/bank 2/bank 2 anaesthetized_g0/bank 2 anaesthetized_g0_t0.imec0.ap.meta').probe_SN

populate_settings = dict(display_progress=False, 
                         reserve_jobs=False, 
                         suppress_errors=False)

# Assume don’t remove probe
# Insertion datetime=assuming that it is the time of the first recording
# Ephys file stores the correct file
# Ensure that the same probe serial number is not on the same subject - reinsertion
#        Only one insertion can be current for probe insertion 

# Increment probes by the insertion number not per session, but overall
# Check the serial number for each session, and only if unique then increment

for subject_key in (subject.Rats & Session).fetch('KEY'):
    insertion_number=0
    for session_key in (acquisition.Acquisitions & subject_key).fetch('KEY'):#Session
        session_dir = find_full_path(get_ephys_root_data_dir(), 
                                     get_session_directory(session_key))

        ephys_meta_filepaths = [fp for fp in session_dir.rglob('*.ap.meta')]

        if not ephys_meta_filepaths:
            raise FileNotFoundError(f'No SpikeGLX data found for session (\
                                    {session_key}) in {session_dir}')

        # inserted_probe_serial_number = (ephys_element.ProbeInsertion & \
        #                                             subject_key).fetch1('probe')

        # for meta_filepath in ephys_meta_filepaths:
        #     spikeglx_meta = spikeglx.SpikeGLXMeta(meta_filepath)

        #     if str(spikeglx_meta.probe_SN) == inserted_probe_serial_number:
        #         break
        # else:
        #     raise FileNotFoundError(
        #         'No SpikeGLX data found for probe insertion: {}'.format(key))

        for file_number, meta_filepath in enumerate(ephys_meta_filepaths):

            # Insert data into Probe and ProbeInsertion ------------------------
            spikeglx_meta = spikeglx.SpikeGLXMeta(meta_filepath)
            # if spikeglx_meta.probe_SN == inserted_probe_serial_number:
            print(file_number, session_key, subject_key, insertion_number, 
                  meta_filepath, spikeglx_meta.probe_SN, spikeglx_meta.probe_model)

            probe_element.Probe.insert1(dict(probe_type=spikeglx_meta.probe_model, 
                                            probe=spikeglx_meta.probe_SN),
                                        skip_duplicates=True)

            # If probe type is higher than version 3A, then overwrite probe number 
            # based on parsing the filename
            if spikeglx_meta.probe_model != 'neuropixels 1.0 - 3A':
                insertion_number = re.search('(imec)?\d{1}$', 
                                        meta_filepath.parent.name).group()
                insertion_number = int(insertion_number.replace('imec', ''))

            ephys_element.ProbeInsertion.insert1(dict(**subject_key, 
                                                    insertion_number=insertion_number,
                                                    probe=spikeglx_meta.probe_SN,
                                                    insertion_datetime=spikeglx_meta.recording_time),
                                                skip_duplicates=True)

            # Populate EphysRecording ------------------------------------------
            recording_key = dict(session_key,
                                 insertion_number=insertion_number)
            print(recording_key)
            ephys_element.EphysRecording.populate(recording_key, 
                                                **populate_settings)

            # # Populate Clustering tables ---------------------------------------
            # # TODO store each directory as a separate curation
            # # Insert parameters used for Clustering
            # params_ks = {} # TODO load rez.mat
            # paramset_idx = 1
            # ephys_element.ClusteringParamSet.insert_new_params(
            #                         processing_method='kilosort2', 
            #                         paramset_idx=paramset_idx, 
            #                         paramset_desc='Spike sorting using Kilosort2', 
            #                         params=params_ks)

            # # Insert new ClusteringTask for each ProbeInsertion
            # session_key_clustering_task = dict(**recording_key, 
            #                                 **subject_key,
            #                                 paramset_idx=paramset_idx)

        # for sorting_id, clustering_relative_dir in (acquisition.Sortings & session_key).fetch1('sorting_id', 'acquisition_post_rel_path'):
        #     ephys_element.ClusteringTask.insert1(
        #         dict(session_key_clustering_task, 
        #             clustering_output_dir=clustering_relative_dir,
        #             task_mode='load'), 
        #             skip_duplicates=True)

        #     ephys_element.Clustering.populate(recording_key, **populate_settings)

        #     # Create a new curation entry.  In this case, since this script is 
        #     # automated, no curation was assumed to be performed on the dataset
            
        #     ephys_element.Curation().create1_from_clustering_task(
        #                                                 session_key_clustering_task)

        #     ephys_element.CuratedClustering.populate(session_key, 
        #                                             **populate_settings)

        #     ephys_element.LFP.populate(session_key, 
        #                             **populate_settings)

        #     ephys_element.WaveformSet.populate(session_key, 
        #                                     **populate_settings)

