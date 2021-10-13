from scripts.conf_file_finding import try_find_conf_file
try_find_conf_file()

import datajoint as dj

from bl_pipeline.ephys_element import Session, ephys_element, probe_element
from bl_pipeline.ingest import ephys_element_ingest

# Required for ClusteringTask
params_ks = {}
# TODO insert parameters used for each session

ephys_element.ClusteringParamSet.insert_new_params(
    'kilosort2', 0, 'Spike sorting using Kilosort2', params_ks)

session_query = Session

populate_settings = {'display_progress': False, 
                     'reserve_jobs': False, 
                     'suppress_errors': False}

for session_key in session_query.fetch('KEY'):
    print(session_key)

    ephys_element_ingest.process_session(session_key)

    ephys_element.EphysRecording.populate(session_key, **populate_settings)

    session_info  = (Session & session_key).fetch1()

    clustering_relative_dir = (Session & session_key).fetch1(
                                                'acquisition_post_rel_path')

    insertion_query = ephys_element.ProbeInsertion &  ('ratname="{0}"').format(
                                                        session_info['ratname'])
    for insertion_number in insertion_query.fetch('insertion_number'):

        # Insert new ClusteringTask for each ProbeInsertion
        session_key_clustering_task = dict(session_key, 
                                           ratname=session_info['ratname'],
                                           insertion_number=insertion_number, 
                                           paramset_idx=0)
        # TODO update paramset_idx for the parameters used for each session 

        ephys_element.ClusteringTask.insert1(
            dict(session_key_clustering_task, 
                 clustering_output_dir=clustering_relative_dir,
                 task_mode='load'), 
                 skip_duplicates=True)

        ephys_element.Clustering.populate(session_key, **populate_settings)

        # Create a new curation entry.  In this case, since this script is 
        # automated, no curation was assumed to be performed on the dataset
        ephys_element.Curation().create1_from_clustering_task(
                                                    session_key_clustering_task)
        # TODO determine if any datasets were curated and update accordingly

        ephys_element.CuratedClustering.populate(session_key, **populate_settings)
        ephys_element.LFP.populate(session_key, **populate_settings)
        ephys_element.WaveformSet.populate(session_key, **populate_settings)

