#%%
import traceback
import datajoint as dj

# copy data from shadow table (src_schema) to new table (target_schema)
def copy_table(target_schema, src_schema, table_name, **kwargs):
     target_table    = getattr(target_schema, table_name)
     src_table       = getattr(src_schema, table_name)
     q_insert        = src_table - target_table.proj()

     try:
         target_table.insert(q_insert, **kwargs)
     except Exception:
          for t in (q_insert).fetch(as_dict=True):
               try:
                    target_table.insert1(t, **kwargs)
               except Exception:
                    print("Error when inserting {}".format(t))
                    traceback.print_exc()

#%%
# load shadow table
lab_shadow = dj.create_virtual_module('lab_shadow', 'bl_shadow_lab')
subject_shadow = dj.create_virtual_module('subject_shadow', 'bl_shadow_subject')

# load new table recreated from matlab schema
from new import lab as lab_new
from new import subject as subject_new

#%%
copy_table(lab_new, lab_shadow, 'Contacts')
copy_table(lab_new, lab_shadow, 'Riginfo')
copy_table(lab_new, lab_shadow, 'Rigflush')
copy_table(lab_new, lab_shadow, 'Rigfood')
copy_table(lab_new, lab_shadow, 'RigMaintenance')
copy_table(lab_new, lab_shadow, 'TrainingRoom')

copy_table(subject_new, subject_shadow, 'Rats')
copy_table(subject_new, subject_shadow, 'RatHistory')
# %%
