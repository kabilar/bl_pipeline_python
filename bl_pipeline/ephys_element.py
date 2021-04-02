import datajoint as dj
import pathlib

from bl_pipeline import lab, subject, acquisition

from element_array_ephys import probe as probe_element
from element_array_ephys import ephys as ephys_element

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
from bl_pipeline.acquisition import Sessions as Session
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
    experimenter, ratname, session_date = \
        (lab.Contacts *
         (subject.Rats *
          (acquisition.Sessions.proj('session_date', ratname='session_rat') & session_key))).fetch1(
                'experimenter', 'ratname', 'session_date')
    sess_dir = root_dir / experimenter / ratname / f'{ratname}_{session_date.strftime("%Y_%m_%d")}'
    return sess_dir.as_posix()


# ------------- Activate "ephys" schema -------------
ephys_element.activate(ephys_schema_name, probe_schema_name, linking_module=__name__)


# ------------- Create Neuropixels probe entries -------------
for probe_type in ('neuropixels 1.0 - 3A', 'neuropixels 1.0 - 3B',
                   'neuropixels 2.0 - SS', 'neuropixels 2.0 - MS'):
    probe_element.ProbeType.create_neuropixels_probe(probe_type)
