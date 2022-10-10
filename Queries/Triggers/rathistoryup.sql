CREATE DEFINER=`brody-dbadmin`@`%` trigger rathistoryup before update on rats
for each row
BEGIN
set role brody_dataowner;
insert into rat_history (  
free,
alert,
experimenter,
contact ,
ratname ,
training ,
comments ,
waterperday ,
recovering ,
extant ,
cagemate ,
forceFreeWater ,
dateSac ,
forceDepWater ,
bringUpAt ,
bringupday ,
ignoredByWatermeister ) values (
NEW.free,
NEW.alert,
NEW.experimenter,
NEW.contact,
NEW.ratname,
NEW.training,
NEW.comments,
NEW.waterperday,
NEW.recovering,
NEW.extant,
NEW.cagemate,
NEW.forceFreeWater,
NEW.dateSac,
NEW.forceDepWater,
NEW.bringUpAt,
NEW.bringupday,
NEW.ignoredByWatermeister);
END


Traceback (most recent call last):
  File "/home/u19prod@pu.win.princeton.edu/Datajoint_projs/U19-pipeline_python/u19_pipeline/automatic_job/recording_handler.py", line 23, in inner_function
    argout = func(*args, **kwargs)
  File "/home/u19prod@pu.win.princeton.edu/Datajoint_projs/U19-pipeline_python/u19_pipeline/automatic_job/recording_process_handler.py", line 354, in populate_element
    status_update = ep.populate_element_data(rec_series['job_id'])
  File "/home/u19prod@pu.win.princeton.edu/Datajoint_projs/U19-pipeline_python/u19_pipeline/automatic_job/ephys_element_populate.py", line 65, in populate_element_data
    ephys_element.Clustering.populate(cluster_key, **populate_settings)
  File "/home/u19prod@pu.win.princeton.edu/miniconda3/envs/U19-pipeline_python_env/lib/python3.9/site-packages/datajoint/autopopulate.py", line 230, in populate
    error = self._populate1(key, jobs, **populate_kwargs)
  File "/home/u19prod@pu.win.princeton.edu/miniconda3/envs/U19-pipeline_python_env/lib/python3.9/site-packages/datajoint/autopopulate.py", line 281, in _populate1
    make(dict(key), **(make_kwargs or {}))
  File "/home/u19prod@pu.win.princeton.edu/miniconda3/envs/U19-pipeline_python_env/lib/python3.9/site-packages/element_array_ephys/ephys_precluster.py", line 570, in make
    kilosort_dir = find_full_path(get_ephys_root_data_dir(), output_dir)
  File "/home/u19prod@pu.win.princeton.edu/miniconda3/envs/U19-pipeline_python_env/lib/python3.9/site-packages/element_interface/utils.py", line 28, in find_full_path
    raise FileNotFoundError(
FileNotFoundError: No valid full-path found (from ['/mnt/cup/braininit/Data/Raw/electrophysiology', '/mnt/cup/braininit/Data/Processed/electrophysiology']) for ms81/ms81_M019/20220611/TowersTask_g0/TowersTask_g0_imec3/job_id_198/kilosort_output
