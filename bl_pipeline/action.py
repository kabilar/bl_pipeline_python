import datajoint as dj
from bl_pipeline import lab, subject


# create new schema
schema = dj.schema('bl_new_action')


# %%
@schema
class CalibrationInfoTbl(dj.Manual):
     definition = """
     calibration_info_tbl_id:            INT(10) AUTO_INCREMENT  
     -----
     ->lab.Riginfo
     calibration_datetime:               DATETIME
     open_valve_time:                    DOUBLE
     calibration_person:                 VARCHAR(32)
     valve:                              VARCHAR(15)
     dispense:                           DOUBLE                  # amount dispensed
     isvalid:                            TINYINT(1)
     target:                             VARCHAR(10)
     """

@schema
class Mass(dj.Manual):
     definition = """
     mass_id:                           INT(10) AUTO_INCREMENT   # original id 
     -----
     ->subject.Rats
     weigh_person:                      VARCHAR(32)
     weighing_datetime:                 DATETIME
     mass=null:                         SMALLINT(5)
     """

@schema
class Rigwater(dj.Manual):
     definition = """
     rigwater_id:                       INT(10) AUTO_INCREMENT
     -----
     ->subject.Rats
     earnedwater_datetime:              DATETIME                     
     totalvol:                          DECIMAL(10,5) 
     trialvol:                          DECIMAL(10,5) 
     complete:                          TINYINT(3) 
     n_rewarded_trials:                 INT(5) 
     target_percent=null:               DECIMAL(5,2) 
     """

@schema
class Schedule(dj.Manual):
     definition = """
     schedule_id:                       INT(10) AUTO_INCREMENT        
     -----
     ratname=null:                      VARCHAR(30)
     experimenter=null:                 VARCHAR(30)
     schedule_date:                     DATE
     schedule_timeslot:                 TINYINT
     rig:                               INT(11)
     instructions=null:                 VARCHAR(250)             # 'Special instructions for the technicians'
     schedule_comments=null:            VARCHAR(250)             # Comments seen by experimenters, i.e. slot reserved for..., this is a special rig 6-poke, opto, phys...
     """

@schema
class Surgery(dj.Manual):
     definition = """
     ->subject.Rats
     surgery_date:                      DATE
     surgery_starttime:                 TIME
     -----
     surgery_stoptime=null:             TIME
     surgeon:                           VARCHAR(32)
     surgery_old_id:                    INT(11) 
     ratgrams=null:                     INT(11) 
     surgery_type=null:                 VARCHAR(100)             # Electrode, cannula, lesion
     eib_num=null:                      VARCHAR(20) 
     coordinates=null:                  VARCHAR(40) 
     brainregions:                      VARCHAR(40) 
     ketamine=null:                     FLOAT                    # how many CC's of ketamine used
     buprenex=null:                     FLOAT                    # how many CC's of buprenex used
     surgery_notes=null:                VARCHAR(600) 
     bregma=null:                       TINYBLOB                 # AP, ML, DV  tinyblob for storage as vector (should we store it as three separate fields? ) 
     ia_zero=null:                      TINYBLOB                 # AP, ML, DV  tinyblob for storage as vector (should we store it as three separate fields? )
     angle=0:                           FLOAT
     tilt_axis=null:                    ENUM('AP', 'ML')
     """

@schema
class TechSchedule(dj.Manual):
     definition = """
     scheduleid:                        INT(10) AUTO_INCREMENT
     -----
     techschedule_date:                 DATE
     day:                               VARCHAR(45)
     overnight:                         VARCHAR(200)
     morning:                           VARCHAR(200)
     evening:                           VARCHAR(200)
     """

@schema
class Technotes(dj.Manual):
     definition = """
     technote_id:                       INT(11) AUTO_INCREMENT
     -----
     technote_datetime:                 DATETIME
     technician=null:                   VARCHAR(32)
     technote_rat=null:                 VARCHAR(8)               # definition only in python
     technote_rig=null:                 INT(3)                   # definition only in python
     technote_experimenter=null:        VARCHAR(32)              # definition only in python, individual in the lab to receive the technote
     timeslot=null:                     TINYINT(1)
     technotes_note:                    VARCHAR(800)
     flag=null:                         INT(3)
     """

@schema
class Water(dj.Manual):
     definition = """
     water_id:                          INT(11)                  # original id
     -----
     ->subject.Rats
     administration_date:               DATE
     administration_starttime:          TIME
     administration_stoptime=null:      TIME 
     administration_person:             VARCHAR(32)
     volume:                            DECIMAL(6,3) 
     percent_bodymass:                  DECIMAL(6,3) 
     percent_target:                    DECIMAL(6,3)      
     """