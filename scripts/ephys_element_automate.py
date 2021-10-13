from scripts.conf_file_finding import try_find_conf_file
try_find_conf_file()

import re
import datajoint as dj

from bl_pipeline import subject
from bl_pipeline.ephys_element import Session, ephys_element, probe_element \
                                get_ephys_root_data_dir, get_session_directory
from bl_pipeline.ingest import ephys_element_ingest

import element_data_loader.utils
from element_array_ephys.readers import spikeglx

session_query = Session

populate_settings = {'display_progress': False, 
                     'reserve_jobs': False, 
                     'suppress_errors': False}

for session_key in session_query.fetch('KEY'):
    print(session_key)

    # Insert data into probe_element.Probe and ephys_element.ProbeInsertion
    """
    For each entry in `acquisition.AcquisitionSessions` table, 
    search for the SpikeGLX data and create corresponding ProbeInsertion entries

    :param session_key: a `KEY` of `acquisition.AcquisitionSessions`
    """
    subject_key = (subject.Rats & (Session & session_key)).fetch1('KEY')
    
    session_dir = element_data_loader.utils.find_full_path(
        get_ephys_root_data_dir(), get_session_directory(session_key))

    ephys_meta_filepaths = [fp for fp in session_dir.rglob('*.ap.meta')]

    if not len(ephys_meta_filepaths):
        print(f'No SpikeGLX data found for session:\
                    {session_key} - at {session_dir}')
        return

    probe_list, probe_insertion_list = [], []
    for probe_number, meta_filepath in enumerate(ephys_meta_filepaths):

        spikeglx_meta = spikeglx.SpikeGLXMeta(meta_filepath)

        probe_key = {'probe_type': spikeglx_meta.probe_model, 
                     'probe': spikeglx_meta.probe_SN}
        print(session_key, subject_key, 'probe SN', spikeglx_meta.probe_SN)
        print(ephys_meta_filepaths)
        if (probe_key['probe'] not in [p['probe'] for p in probe_list]
                and probe_key not in probe_element.Probe()):
            probe_list.append(probe_key)

        probe_dir = meta_filepath.parent

        # If probe type is higher than version 3A, then overwrite probe number 
        # based on parsing the filename
        # print(probe_number, meta_filepath)
        if spikeglx_meta.probe_model != 'neuropixels 1.0 - 3A':
            probe_number = re.search('(imec)?\d{1}$', probe_dir.name).group()
            probe_number = int(probe_number.replace('imec', ''))
        # print(probe_number, meta_filepath, spikeglx_meta.probe_model)

        probe_insertion_list.append({**subject_key, 
                                     'probe': spikeglx_meta.probe_SN,
                                     'insertion_number': probe_number})

    probe_element.Probe.insert(probe_list)
    ephys_element.ProbeInsertion.insert(probe_insertion_list, 
                                        skip_duplicates=True)

    # Populate EphysRecording --------------------------------------------------
    ephys_element.EphysRecording.populate(session_key, **populate_settings)

    session_info  = (Session & session_key).fetch1()

    clustering_relative_dir = (Session & session_key).fetch1(
                                                'acquisition_post_rel_path')

    insertion_query = ephys_element.ProbeInsertion &  ('ratname="{0}"').format(
                                                        session_info['ratname'])
    for insertion_number in insertion_query.fetch('insertion_number'):

        # Insert parameters used for Clustering
        # TODO load and insert parameters used for each session
        params_ks = {}

        ephys_element.ClusteringParamSet.insert_new_params(
                                processing_method='kilosort2', 
                                paramset_idx=0, 
                                paramset_desc='Spike sorting using Kilosort2', 
                                params=params_ks)

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

