# BrodyLab Python-based Data Pipeline
+ Create tables with new definitions and copy to new server.

## Ingestion routine
+ `bl_pipeline_python/process/process.py`
+ Copy data from source tables (to shadow tables) to new tables
+ Shadow table allows for renaming of primary key
+ Shadow table has same definition of the new table, except that the primary key is the same as the source table
+ For each shadow table set the keys as a secondary field when not used as primary key

## Data integrity issues
+ `bl_pipeline_python/notebooks/debugging_data_integrity.ipynb`