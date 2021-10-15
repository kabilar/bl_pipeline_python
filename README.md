# bl_pipeline_python

The python data pipeline defined for BrodyLab.

# Installation

## Prerequisites

1. Install conda on your system:  https://conda.io/projects/conda/en/latest/user-guide/install/index.html
2. If running in Windows get [git](https://gitforwindows.org/)
3. (Optional for ERDs) [Install graphviz](https://graphviz.org/download/)

## Installation with conda

1. Open a new terminal 
2. Clone this repository: `git@github.com:BrainCOGS/bl_pipeline_python.git`
    - If you cannot clone repositories with ssh, [set keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
3. Create a conda environment: `conda create -n u19_datajoint_env python==3.7`.
4. Activate environment: `conda activate u19_datajoint_env`.   **(Activate environment each time you use the project)**
5. Change directory to this repository `cd U19_pipeline_python`.
6. Install all required libraries `pip install -e .`
7. Datajoint Configuration: `jupyter notebook notebooks/00-datajoint-configuration.ipynb` 


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
