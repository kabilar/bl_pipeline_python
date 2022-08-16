
import numpy as np
import datajoint as dj
import pandas as pd


def mymblob_to_dict(np_array, as_int=True):
    '''
    Transform a numpy array to dictionary:
    (numpy array are stored when saving Blobs in  MATLAB Datajoint, normally a dictionary will be the fit)
    '''

    # Transform numpy array to DF
    out_dict = pd.DataFrame(np_array.flatten())

    # Flatten each column and get the "real value of it"
    out_dict = out_dict.applymap(lambda x: x.flatten())

    #Get not empty columns to extract fist value of only those columns
    s = out_dict.applymap(lambda x: x.shape[0])
    not_empty_columns = s.loc[:, ~(s == 0).any()].columns.to_list()
    out_dict = out_dict.apply(lambda x: x[0].flatten() if x.name in not_empty_columns else x)
    
    if not isinstance(out_dict, pd.DataFrame):
        out_dict = out_dict.to_frame()
        #Get columns that are "real" arrays not unique values disguised
        s = out_dict.applymap(lambda x: x.size).T
        real_array_columns = s.loc[:, (s > 1).any()].columns.to_list()
        out_dict = out_dict.T
        out_dict = out_dict.apply(lambda x: x[0] if x.name not in real_array_columns else x, axis=0)
        
    columns = out_dict.columns.copy()
    out_dict = out_dict.squeeze()

    #Transform numeric columns to int (normally for params)
    if as_int:
        for i in columns:
            if (isinstance(out_dict[i],np.float64) and out_dict[i].is_integer()):
                out_dict[i] = out_dict[i].astype('int')

    out_dict = out_dict.to_dict()

    return out_dict


def mymblob_to_dict2(np_array, as_int=True):
    '''
    Transform a numpy array to dictionary:
    (numpy array are stored when saving Blobs in  MATLAB Datajoint, normally a dictionary will be the fit)
    '''

    fields = np_array.dtype.names

    out_dict = dict()
    for idx, field in enumerate(np_array):
        if isinstance(field, dj.blob.MatStruct):
            out_dict[fields[idx]] = blob_to_dict(field)
        else:
            l=len(field) if field.shape else 0
            if l==1:
                field = field[0]
            out_dict[fields[idx]] = field
            

    return out_dict


def transform_blob(peh):

    a = list()
    for i in peh:
        a.append(blob_to_dict(i))

    return a


def blob_to_dict(peh, parent_fields=None):
    '''
    Transform a numpy array to dictionary:
    (numpy array are stored when saving Blobs in  MATLAB Datajoint, normally a dictionary will be the fit)
    '''
    array_test = peh
    if parent_fields is None:
        fields_trial = array_test.dtype.names
    else:
        fields_trial = parent_fields

        
    out_array = list()
    while 1:
        
        new_level = array_test[0]
        new_level_fields_trial = new_level.dtype.names

        if new_level_fields_trial != fields_trial:
            break

        array_test = array_test[0]

    if new_level_fields_trial is not None:
        
        if len(array_test) == 1:
            out_array = blob_to_dict(array_test[0], parent_fields=fields_trial)
        else:
            a = list()
            for i in array_test:
                a.append(blob_to_dict(i, parent_fields=fields_trial))

            int_dict = dict()
            for idx, field in enumerate(fields_trial):
                int_dict[field] = a[idx]
                out_array = int_dict

    else:
        out_array = mymblob_to_dict2(array_test)
    
    return out_array