# Ingestion routine to copy data from source tables to new tables
# source table -> shadow table -> new table
# Shadow table allows for renaming of primary key
# Shadow table has same definition of the new table, except that the primary key is the same as the source table
# For each shadow table set the keys as a secondary field when not used as primary key

import traceback
import datajoint as dj

from bl_pipeline.shadow import lab as lab_shadow
from bl_pipeline.shadow import subject as subject_shadow

from bl_pipeline import lab, subject


# copy data from shadow table (src_schema) to new table (target_schema)
def copy_table(target_schema, src_schema, table_name, **kwargs):
    target_table = getattr(target_schema, table_name)
    src_table = getattr(src_schema, table_name)
    q_insert = src_table - target_table.proj()

    try:
        target_table.insert(q_insert, **kwargs)
    except Exception:
        for t in (q_insert).fetch(as_dict=True):
            try:
                target_table.insert1(t, **kwargs)
            except Exception:
                print("Error when inserting {}".format(t))
                traceback.print_exc()


MODULES = [
    dict(
            module=(lab, lab_shadow),
            tables=[
                'Contacts',
                'Riginfo',
                'Rigflush',
                'Rigfood',
                # 'RigMaintenance',
                # 'TrainingRoom'
            ]
        ),
    # dict(
    #         module=(subject, subject_shadow),
    #         tables=[
    #             'Rats',
    #             'RatHistory'
    #         ]
    #     ),
]


def ingest_shadow():

    kwargs = dict(display_progress=True, suppress_errors=True)
    for m in MODULES:
        for table_name in m['tables']:
            table_shadow = getattr(m['module'][1], table_name)
            print(f'Populating shadow table {table_name}')
            table_shadow.populate(**kwargs)


def ingest_real():

    for m in MODULES:
        for table_name in m['tables']:
            print(f'Copying to real table {table_name}')
            copy_table(m['module'][0], m['module'][1], table_name)


def main():
    ingest_shadow()
    ingest_real()


if __name__ == '__main__':
    main()
