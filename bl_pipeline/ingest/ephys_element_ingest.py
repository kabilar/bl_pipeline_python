"""
Insert data into probe_element.Probe and ephys_element.ProbeInsertion tables
"""

import re

import element_data_loader.utils
from element_array_ephys.readers import spikeglx
from bl_pipeline import subject
from bl_pipeline.ephys_element import Session, probe_element, ephys_element, \
                                get_ephys_root_data_dir, get_session_directory


def process_session(session_key):
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


if __name__ == '__main__':
    for session_key in Session.fetch('KEY'):
        process_session(session_key)
