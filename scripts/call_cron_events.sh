

echo $(pwd)

source /home/u19prod@pu.win.princeton.edu/.bashrc
source /home/u19prod@pu.win.princeton.edu/.bash_profile

cd "/home/u19prod@pu.win.princeton.edu/Datajoint_projs/bl_pipeline_python/"
git pull

conda activate bl_pipeline_python_env
python scripts/cron_events.py 
conda deactivate

