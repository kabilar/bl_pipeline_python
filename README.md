# BrodyLab Python-based Data Pipeline

## User instructions
---
### Instructions to set up a working environment
1. To keep your own version of the pipeline and contribute, fork this repository to your own account.
2. Clone your fork with `git clone {your_fork_url}.git`
3. It is highly recommended to create a virtual environment either with virtualenv or conda.
<br> With conda:
`conda create -n bl_env python==3.7`
<br> After it is created: `conda activate bl_env`
4. Install this repository by moving into this repository and run `pip install -e .` In this way, the modifications on the pipeline will be reflected immediately on the imported modules.
5. Configure the `dj_local_conf.json`. In the root of the clone repository, create a new file `dj_local_conf.json` with the following template:
```json
{
  "database.host": "<hostname>",
  "database.user": "<username>",
  "database.password": "<password>",
  "loglevel": "INFO",
  "safemode": true,
  "display.limit": 7,
  "display.width": 14,
  "display.show_tuple_count": true,
  "custom": {
      "database.prefix": "bl_new_",
      "ephys_root_data_dir": "<directory>" # root directory to the ephys raw data (archive drive), specific to each machine, e.g. On linux, `/mnt/archive/brody/RATTER/PhysData/Raw/`
      "clusterings_root_data_dir": "<directory>" # root directory to ks2 processed data (bucket), specific to each machine, e.g. On linux, `/mnt/bucket/labs/brody/RATTER/PhysData/`
    }
}
```
6. Start a python kernel under the root directory and datajoint will be configured properly.



## Developer Notes
+ Create tables with new definitions and copy to new server.

### Ingestion routine
+ `bl_pipeline_python/process/process.py`
+ Copy data from source tables (to shadow tables) to new tables
+ Shadow table allows for renaming of primary key
+ Shadow table has same definition of the new table, except that the primary key is the same as the source table
+ For each shadow table set the keys as a secondary field when not used as primary key

### Data integrity issues
+ `bl_pipeline_python/notebooks/debugging_data_integrity.ipynb`
