
import pathlib
import os
import glob


path_not_found_dict = {"no_ephys": "No ephys directory found",  
"mulitple_ephys": "Multiple ephys directory found", 
"no_subject": "No ephys subject directory found"}

def combine_str_path(original_path, list_path):
    p1 = pathlib.Path(original_path)
    for i in list_path:
        p1 = p1 / i
    return p1.as_posix()


def check_date_directory(filepath,d1, return_multiple=False):
    if os.path.isdir(filepath):
        d2 = d1.replace('-','_')
        all_files = glob.glob(filepath+'/*')
        ld1 = [i for i in all_files if d1 in i]
        ld2 = [i for i in all_files if d2 in i]
        ld1 = ld1 + ld2
        if len(ld1) == 0:
            return path_not_found_dict['no_ephys']
        elif len(ld1) > 1:
            if return_multiple:
                posix_ld1 = [pathlib.Path(filepath, i).as_posix() for i in ld1]
                return posix_ld1
            else:
                return path_not_found_dict['mulitple_ephys']
        else:
            return pathlib.Path(filepath, ld1[0]).as_posix()
    else:
        return path_not_found_dict['no_subject']