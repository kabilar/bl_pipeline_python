import pandas as pd

def get_primary_key_fields(t):
    """
    Get network root path depnding on os and path required
    Args:
        t (Dj table): Instance of a table in datajoint 
    Returns:
        primary_field_list: (list): List of all fields that make primary key
    """

    fields_t = pd.DataFrame.from_dict(t.heading.attributes, orient='index')
    primary_field_list = fields_t.loc[fields_t['in_key'] == True].index.to_list()
    
    return primary_field_list