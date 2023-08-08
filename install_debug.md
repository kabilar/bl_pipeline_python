## Install Debug Notes

Written by Jess Breda February 2023. Primarily targeting windows computers.

If you are having install issues- things to try:

1. Run from the anaconda powershell 
    - if you want to enable conda commands you need to ['ini'](https://stackoverflow.com/questions/64149680/how-to-activate-conda-environment-from-powershell) the windows powershell or use ubuntu
3. Restart the terminal and try the command again
4. Don't pip install jupyter lab/ipython, instead use `conda` commands
5. Update conda
   - `conda update conda`
   - 23.1.0 is working well for me
6. If you have openSSL issues with installs follow [this](https://www.youtube.com/watch?v=hfKAV6OYaKw) video.
7. If getting python extension issues, try to update spyder
    - `conda install spyder=5.0`
