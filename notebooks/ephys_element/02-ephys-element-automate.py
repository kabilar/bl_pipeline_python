from scripts.conf_file_finding import try_find_conf_file
try_find_conf_file()

import datajoint as dj

from bl_pipeline.datajoint01_pipeline import lab, subject, acquisition
from bl_pipeline.datajoint01_pipeline.ephys_element import ephys_element, probe_element
from bl_pipeline.datajoint01_pipeline.ingest import ephys_element_ingest
from bl_pipeline.datajoint01_pipeline.acquisition import AcquisitionSessions as Session

params_ks = {
    "fs": 30000,
    "fshigh": 150,
    "minfr_goodchannels": 0.1,
    "Th": [10, 4],
    "lam": 10,
    "AUCsplit": 0.9,
    "minFR": 0.02,
    "momentum": [20, 400],
    "sigmaMask": 30,
    "ThPr": 8,
    "spkTh": -6,
    "reorder": 1,
    "nskip": 25,
    "GPU": 1,
    "Nfilt": 1024,
    "nfilt_factor": 4,
    "ntbuff": 64,
    "whiteningRange": 32,
    "nSkipCov": 25,
    "scaleproc": 200,
    "nPCs": 3,
    "useRAM": 0
}

ephys_element.ClusteringParamSet.insert_new_params(
    'kilosort2', 0, 'Spike sorting using Kilosort2', params_ks)

# TODO determine parameters used for each session

for session_key in (Session & 'session_rat="A249"').fetch('KEY'):#session_rat, sessid

    session_info  = (Session & session_key).fetch1()
    print(session_info)
    ephys_element_ingest.process_session(session_key)

    ephys_element.EphysRecording.populate(session_key, display_progress=True)

    clustering_relative_dir = (Session & session_key).fetch1('acquisition_post_rel_path')

    insertion_number = (ephys_element.ProbeInsertion & ('ratname="{0}"').format(session_info['session_rat'])).fetch1('insertion_number')

    ephys_element.ClusteringTask.insert1(
        dict(session_key, 
            ratname=session_info['session_rat'], #TODO ratname
            insertion_number=insertion_number, 
            paramset_idx=0, 
            clustering_output_dir=clustering_relative_dir
            ), skip_duplicates=True)
            #TODO paramset_idx and insertion number

    ephys_element.Clustering.populate(session_key, display_progress=True)

    session_key_clustering_task = (ephys_element.ClusteringTask & session_key).fetch1('KEY')

    ephys_element.Curation().create1_from_clustering_task(session_key_clustering_task)
    # Assumes curation was not performed on dataset

    ephys_element.CuratedClustering.populate(session_key, display_progress=True)
    ephys_element.LFP.populate(session_key, display_progress=True)
    ephys_element.WaveformSet.populate(session_key, display_progress=True)

