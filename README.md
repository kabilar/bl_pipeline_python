# Brody Lab Python-based Data Pipeline

The python data pipeline defined for BrodyLab.

# Installation

## Prerequisites

1. Install conda on your system:  https://conda.io/projects/conda/en/latest/user-guide/install/index.html
2. If running in Windows get [git](https://gitforwindows.org/)
3. (Optional for ERDs) [Install graphviz](https://graphviz.org/download/)

## Installation with conda

1. Open a new terminal 
2. Clone this repository: either with https (`https://github.com/Brody-Lab/bl_pipeline_python.git`) or ssh (`git@github.com:Brody-Lab/bl_pipeline_python.git`)
    - If you cannot clone repositories with ssh, [set keys overview](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), [set keys windows](https://github.com/Brody-Lab/jbreda_labnotebook/blob/master/helpful_code.md#ssh)
3. Create a conda environment: `conda create -n bl_pipeline_python_env python==3.7`
    - the name can be changed, just keep it consistent for your kernal below
4. Activate environment: `conda activate bl_pipeline_python_env`.   **(Activate environment each time you use the project)**
5. Change directory to this repository `cd bl_pipeline_python`.
6. Install the primary required libraries `pip install -e .`
    - this will take a few minutes
7. Install jupyter and ipykernal libraries in series
    ```
    conda install -c conda-forge jupyterlab
    conda install -c anaconda ipykernel
    python -m ipykernel install --user --name=bl_pipeline_python_env # allows you to run notebooks on environment kernal
    ```
8. Run the Configuration notebook under `notebooks/00-datajoint-configuration.ipynb`
    - make sure you select the correct kernal from the top right menu
9. If you have install issues, especially on a windows machine, see [here](https://github.com/Brody-Lab/bl_pipeline_python/blob/main/install_debug.md)

## Tutorials

We have created some tutorial notebooks to help you start working with datajoint

1. Querying data (**Strongly recommended**) 
 - `jupyter notebook notebooks/tutorials/Explore_Sessions_Data.ipynb`
 - `jupyter notebook notebooks/tutorials/1-Explore U19 data pipeline with DataJoint.ipynb`


## Array Electrophysiology with Neuropixels Probes

+ This portion of the workflow usings DataJoint's standard python package 
[element-array-ephys](https://github.com/datajoint/element-array-ephys).

+ This workflow uses the `ephys_chronic` module from `element-array-ephys`.

## Developer Notes

### Database transfer
+ `bl_pipeline_python/datajoint01_pipeline/process/process.py`
+ Copy data from source tables (to shadow tables) to new tables
+ Shadow table allows for renaming of primary key
+ Shadow table has same definition of the new table, except that the primary key
 is the same as the source table
+ For each shadow table set the keys as a secondary field when not used as 
primary key

### Data integrity issues
+ `bl_pipeline_python/notebooks/debugging_data_integrity.ipynb`
