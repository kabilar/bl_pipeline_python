


from scripts.conf_file_finding import try_find_conf_file
try_find_conf_file()


import datajoint as dj
import json

dj.blob.use_32bit_dims = True

db_params_file = open('brodylab_db_conf.json','r')
db_params = db_params_file.read()
db_params = json.loads(db_params)

con = dj.conn(host=db_params['host'],user=db_params['user'],password=db_params['password'], reset=True)


from bl_pipeline import bdata
bdata.BehaviorEvent.populate()
