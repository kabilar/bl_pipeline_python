from os import PathLike
import datajoint as dj
import pathlib

from element_array_ephys import probe as probe_element
from element_array_ephys import ephys_chronic as ephys_element

"""
------ Gathering requirements to activate the ephys elements ------
To activate the ephys elements, we need to provide:

1. Schema names
    + schema name for the probe module
    + schema name for the ephys module

2. Upstream tables
    + Subject table
    + Session table
    + SkullReference table - Reference table for InsertionLocation, specifying the skull reference
                 used for probe insertion location (e.g. Bregma, Lambda)

3. Utility functions
    + get_ephys_root_data_dir()
    + get_session_directory()

For more detail, check the docstring of the imaging element:
    help(probe_element.activate)
    help(ephys_element.activate)
"""

# 1. Schema names
probe_schema_name = dj.config['custom']['database.prefix'] + 'probe_element'
ephys_schema_name = dj.config['custom']['database.prefix'] + 'ephys_element'

# 2. Upstream tables
from bl_pipeline import lab, subject, acquisition
from bl_pipeline.acquisition import AcquisitionSessions as Session
from bl_pipeline.subject import Rats as Subject

schema = dj.schema(dj.config['custom']['database.prefix'] + 'lab')


@schema
class SkullReference(dj.Lookup):
    definition = """
    skull_reference   : varchar(60)
    """
    contents = zip(['Bregma', 'Lambda'])


# 3. Utility functions

def get_ephys_root_data_dir():
    data_dir = dj.config.get('custom', {}).get('ephys_root_data_dir', None)
    return pathlib.Path(data_dir) if data_dir else None


def get_clustering_root_data_dir():
    data_dir = dj.config.get('custom', {}).get('clustering_root_data_dir', None)
    return pathlib.Path(data_dir) if data_dir else None


def get_session_directory(session_key):
    root_dir = get_ephys_root_data_dir()
    sess_dir = (AcquisitionSession & session_key).fetch('acquisition_raw_rel_path')

    if len(sess_dir) == 1:
        return pathlib.Path(root_dir, sess_dir[0]).as_posix()
    else:
        return ''

    '''
    experimenter, ratname, session_date = \
        (lab.Contacts *
         (subject.Rats *
          (acquisition.Sessions.proj('session_date', ratname='session_rat') & session_key))).fetch1(
                'experimenter', 'ratname', 'session_date')
    sess_dir = root_dir / experimenter / ratname / f'{ratname}_{session_date.strftime("%Y_%m_%d")}'
    return sess_dir.as_posix()
    '''

def get_session_cluster_directory(session_key):
    root_dir = get_clustering_root_data_dir()
    sess_dir = (AcquisitionSession & session_key).fetch('acquisition_post_rel_path')

    if len(sess_dir) == 1:
        return pathlib.Path(root_dir, sess_dir[0]).as_posix()
    else:
        return ''

def get_session_cluster_rel_directory(session_key):
    root_dir = get_clustering_root_data_dir()
    sess_dir = (AcquisitionSession & session_key).fetch('acquisition_post_rel_path')

    if len(sess_dir) == 1:
        return pathlib.Path(sess_dir[0]).as_posix()
    else:
        return ''


# ------------- Activate "ephys" schema -------------
ephys_element.activate(ephys_schema_name, probe_schema_name, linking_module=__name__)

ephys_element.EphysRecording.key_source = Session.proj(...,ratname='session_rat') * ephys_element.ProbeInsertion

