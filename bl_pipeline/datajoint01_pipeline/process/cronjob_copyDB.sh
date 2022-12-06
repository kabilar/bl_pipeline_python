#!/bin/bash

echo $(pwd)

source /home/u19prod@pu.win.princeton.edu/.bashrc
source /home/u19prod@pu.win.princeton.edu/.bash_profile

conda activate U19-pipeline_python_env
cd "/home/u19prod@pu.win.princeton.edu/Datajoint_projs/bl_pipeline_python/"
git pull

num_days=3

conda activate bl_pipeline_python_env
python scripts/transfer_data_oldDB.py $num_days
python bl_pipeline/process/process.py $num_days
conda deactivate

