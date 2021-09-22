import datajoint as dj
from bl_pipeline import lab, subject


# create new schema
schema = dj.schema('bl_new_acquisition')


@schema
class SessStarted(dj.Manual):
     definition = """
     sessid:                            INT(11)        # Unique number assigned to each training session
     -----
     session_started_rat:               VARCHAR(8)     # rats name inherited from rats table
     session_started_rigid:             INT(3)         # rig id number inherited from riginfo table
     session_date='1000-01-01':         DATE           # date the session started on in yyyy-mm-dd format
     session_starttime='00:00:00':      TIME           # time session started at
     was_ended=0:                       TINYINT(1)     # 0 if the session has not ended yet, 1 if it has
     crashed:                           TINYINT(3)     # 0 if did not crash, 1 if runrats caught a crash, 2 for all other crashes
     """


@schema
class Sessions(dj.Manual):
     definition = """
     ->SessStarted
     -----
     session_rat:                       VARCHAR(8)      # ratname inherited from rats table
     session_userid:                    VARCHAR(32)     # rat owner inherited from contacts table
     session_rigid:                     INT(3)          # rig id number inherited from riginfo table
     session_date='1000-01-01':         DATE            # date session started on
     session_starttime='00:00:00':      TIME            # time session started
     session_endtime='00:00:00':        TIME            # time session ended
     protocol='':                       VARCHAR(30)     # protocol name
     peh=null:                          MEDIUMBLOB      # parsed events history state, poke, and wave times on each trial
     n_done_trials=0:                   INT(11)         # number of trials completed
     session_comments=null:             VARCHAR(1000)   # general comments
     settings_file='':                  VARCHAR(200)    # file containing settings saved at end of session
     settings_path='':                  VARCHAR(200)    # path to settings file
     data_file='':                      VARCHAR(200)    # file containing data saved at end of session
     data_path='':                      VARCHAR(200)    # path to data file
     video_file='':                     VARCHAR(200)    # file containing video saved at end of session
     video_path='':                     VARCHAR(200)    # path to video file
     total_correct=null:                FLOAT(2,2)      # percent trials correct
     right_correct=null:                FLOAT(2,2)      # percent right trials correct
     left_correct=null:                 FLOAT(2,2)      # percent left trials correct
     percent_violations=null:           FLOAT(2,2)      # percent violation trials
     protocol_data=null:                MEDIUMBLOB      # data structure containing selection of data from data and settings files
     left_pokes=null:                   INT(10)         # number of left pokes performed
     center_pokes=null:                 INT(10)         # number of center pokes performed
     right_pokes=null:                  INT(10)         # number of right pokes performed
     ip_addr=null:                      VARCHAR(15)     # IP address of rig session ran on
     foodpuck=0:                        TINYINT(1)      # 1 if food was in the rig during the sessions, 0 if not
     """

@schema
class AcquisitionSessionsOld(dj.Manual):
     definition = """
     ->Sessions
     -----
     session_rat:                       VARCHAR(8)      # ratname inherited from rats table
     session_userid:                    VARCHAR(32)     # rat owner inherited from contacts table
     session_rigid:                     INT(3)          # rig id number inherited from riginfo table
     acquisition_type:                  VARCHAR(32)     # ephys or imaging
     acquisition_raw_abs_path=null:     VARCHAR(200)    # absoulte path of raw files 
     acquisition_raw_rel_path=null:     VARCHAR(200)    # relative path (from ephys or imaging root dir)
     acquisition_post_abs_path=null:    VARCHAR(200)    # absoulte path of post processing file (clustered/segmented)
     acquisition_post_rel_path=null:    VARCHAR(200)    # relative path (from ephys or imaging  clustering/segmentation root dir)
     """


@schema
class PreAcquisitionSessions(dj.Manual):
     definition = """
     ->Sessions
     directory_num:                     INT(11)      # Counts the number of possible directory mathces for the session
     -----
     session_rat:                       VARCHAR(8)      # ratname inherited from rats table
     session_userid:                    VARCHAR(32)     # rat owner inherited from contacts table
     session_rigid:                     INT(3)          # rig id number inherited from riginfo table
     acquisition_type:                  VARCHAR(32)     # ephys or imaging
     acquisition_raw_rel_path=null:     VARCHAR(200)    # relative path (from ephys or imaging root dir)
     acquisition_post_rel_path=null:    VARCHAR(200)    # relative path (from ephys or imaging  clustering/segmentation root dir)
     correct_dirs:                      TINYINT(1)      # flag to indicate correct directory combination
     """

@schema
class AcquisitionSessions(dj.Manual):
     definition = """
     ->Sessions
     -----
     session_rat:                       VARCHAR(8)      # ratname inherited from rats table
     session_userid:                    VARCHAR(32)     # rat owner inherited from contacts table
     session_rigid:                     INT(3)          # rig id number inherited from riginfo table
     acquisition_type:                  VARCHAR(32)     # ephys or imaging
     acquisition_raw_rel_path=null:     VARCHAR(200)    # relative path (from ephys or imaging root dir)
     acquisition_post_rel_path=null:    VARCHAR(200)    # relative path (from ephys or imaging  clustering/segmentation root dir)
     """
