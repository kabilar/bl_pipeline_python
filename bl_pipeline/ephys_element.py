"""
Requirements to activate the ephys elements.

1. Schema names
    + Schema name for the probe module
    + Schema name for the ephys module

2. Upstream tables
    + Subject table
    + Session table
    + SkullReference table - Reference table for InsertionLocation, 
                             specifying the skull reference used for probe 
                             insertion location (e.g. Bregma, Lambda)

3. Path functions
    + get_ephys_root_data_dir()
    + get_session_directory()

4. Activate element

For more detail, check the docstring of the element:
    help(probe_element.activate)
    help(ephys_element.activate)
"""

# 1. Schema names --------------------------------------------------------------
import datajoint as dj

from element_array_ephys import probe as probe_element
from element_array_ephys import ephys_chronic as ephys_element

probe_schema_name = dj.config['custom']['database.prefix'] + 'probe_element'
ephys_schema_name = dj.config['custom']['database.prefix'] + 'ephys_element'


# 2. Upstream tables -----------------------------------------------------------
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


# 3. Path functions ------------------------------------------------------------
def get_ephys_root_data_dir():
    root_data_dirs = dj.config.get('custom', {}).get('ephys_root_data_dir', 
                                                     None)

    return root_data_dirs

def get_session_directory(session_key): 
    session_dir = (Session & session_key).fetch1('acquisition_raw_rel_path')

    return session_dir


# 4. Activate ephys schema -----------------------------------------------------
ephys_element.activate(ephys_schema_name, 
                       probe_schema_name, 
                       linking_module=__name__)

ephys_element.EphysRecording.key_source = \
    Session.proj(ratname='session_rat') * ephys_element.ProbeInsertion

Session = Session.proj(..., ratname='session_rat')
