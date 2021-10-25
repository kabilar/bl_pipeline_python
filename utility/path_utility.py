
import pathlib
import os
import glob
import subprocess


path_not_found_dict = {"no_ephys": "No ephys directory found",  
"mulitple_ephys": "Multiple ephys directory found", 
"no_subject": "No ephys subject directory found",
"no_file_pattern": "No pattern files found in directory"}

file_pattern_ephys_session = {
    "raw_np_files": ['/*ap.bin', '/*ap.meta'],
    "sorted_np_files": ['/*.npy']
}

def combine_str_path(original_path, list_path):
    p1 = pathlib.Path(original_path)
    for i in list_path:
        p1 = p1 / i
    return p1.as_posix()


def check_date_directory(filepath,d1, return_multiple=True):
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

def find_file_pattern_dir(filepath, file_patterns):
    dirs_with_session_files = []
    child_dirs = [x[0] for x in os.walk(filepath)]
    for dir in child_dirs:
        patterns_found = 1
        for pat in file_patterns:
            found_file = glob.glob(dir+pat)
            if len(found_file) == 0:
                patterns_found = 0
                break

        if patterns_found:
            dirs_with_session_files.append(pathlib.Path(dir).as_posix())

    if len(dirs_with_session_files) == 1:
        dirs_with_session_files = dirs_with_session_files[0]
    elif len(dirs_with_session_files) == 0:
        dirs_with_session_files = path_not_found_dict['no_file_pattern']
    return dirs_with_session_files

def check_file_pattern_dir(filepath, file_patterns):
    """
    Check if directory (or its childs) contains some files with specific pattern names
    """
    dirs_with_session_files = []
    child_dirs = [x[0] for x in os.walk(filepath)]
    patterns_found = 0
    for dir in child_dirs:
        for pat in file_patterns:
            found_file = glob.glob(dir+pat)
            if len(found_file) > 0:
                patterns_found = 1
                break

        if patterns_found:
            break

    if patterns_found:
        return 1
    else:
        return 0

def get_size_directory(path):
    command = ["du", path, '-s']
    s = subprocess.run(command, capture_output=True)
    output = s.stdout.decode('UTF-8')
    if len(output) != 0:
        kbytes = int(output.split('\t')[0])
    else:
        kbytes = -1
    return kbytes

def get_size_directory2(FolderPath):
 
    # assign size
    size = 0
    

    # get size
    for path, dirs, files in os.walk(FolderPath):
        for f in files:
            fp = os.path.join(path, f)
            size += os.path.getsize(fp)
    
    return size
