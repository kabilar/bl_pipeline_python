SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bdata
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bdata
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `alvaros_bdata` DEFAULT CHARACTER SET latin1 ;
-- -----------------------------------------------------
-- Schema protocol
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema protocol
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `alvaros_protocol` DEFAULT CHARACTER SET latin1 ;
-- -----------------------------------------------------
-- Schema ratinfo
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ratinfo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `alvaros_ratinfo` DEFAULT CHARACTER SET latin1 ;
USE `alvaros_bdata` ;

-- -----------------------------------------------------
-- Table `alvaros_bdata`.`biasview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`biasview` (
  `sessiondate` DATE NULL DEFAULT NULL,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `avg_bias` DOUBLE NULL DEFAULT NULL,
  `avg(delta_bias)` DOUBLE NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`calibration_info_tbl`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`calibration_info_tbl` (
  `rig_id` VARCHAR(3) NOT NULL,
  `initials` VARCHAR(5) NOT NULL,
  `dateval` DATETIME NOT NULL,
  `valve` VARCHAR(15) NOT NULL,
  `timeval` DOUBLE UNSIGNED NOT NULL,
  `dispense` DOUBLE UNSIGNED NOT NULL,
  `isvalid` TINYINT(1) NOT NULL,
  `calibrationid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `target` VARCHAR(10) NOT NULL,
  `validity` VARCHAR(5) NOT NULL,
  PRIMARY KEY USING BTREE (`calibrationid`))
ENGINE = InnoDB
AUTO_INCREMENT = 76718
DEFAULT CHARACTER SET = latin1
COMMENT = 'Table that stores all the calibration data for every rig';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`carlosexperiment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`carlosexperiment` (
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `randomblob` BLOB NULL DEFAULT NULL,
  `anumber` TINYINT(3) UNSIGNED ZEROFILL NOT NULL DEFAULT '000',
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`carlosview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`carlosview` (
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `sessiondate` DATE NULL DEFAULT NULL,
  `sess_length` TIME NULL DEFAULT NULL,
  `n_done_trials` INT(11) NULL DEFAULT NULL,
  `total_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `bias` DOUBLE NULL DEFAULT NULL,
  `comments` VARCHAR(1000) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`cells`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`cells` (
  `cellid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sessid` INT(10) UNSIGNED NOT NULL,
  `ratname` VARCHAR(6) NULL DEFAULT NULL,
  `channelid` INT(10) UNSIGNED NOT NULL,
  `sc_num` TINYINT(3) UNSIGNED NOT NULL,
  `cluster` TINYINT(3) UNSIGNED NOT NULL,
  `single` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `nSpikes` MEDIUMINT(8) UNSIGNED NOT NULL,
  `quality` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
  `overlap` FLOAT UNSIGNED NULL DEFAULT NULL,
  `iti_mn` FLOAT UNSIGNED NULL DEFAULT NULL,
  `iti_sd` FLOAT UNSIGNED NULL DEFAULT NULL,
  `trial_mn` FLOAT UNSIGNED NULL DEFAULT NULL,
  `trial_sd` FLOAT UNSIGNED NULL DEFAULT NULL,
  `task_sig` FLOAT UNSIGNED NULL DEFAULT NULL,
  `filename` VARCHAR(30) NOT NULL,
  `cluster_in_file` TINYINT(4) NULL DEFAULT NULL,
  `frac_bad_isi` FLOAT NULL DEFAULT NULL,
  `cutting_comment` VARCHAR(200) NULL DEFAULT NULL,
  `eibid` INT(7) NULL DEFAULT NULL,
  `ttid` INT(7) NULL DEFAULT NULL,
  `comment` VARCHAR(200) NULL DEFAULT NULL,
  `recorded_on_right` TINYINT(1) NULL DEFAULT NULL,
  `rate` FLOAT NULL DEFAULT NULL,
  `width` FLOAT NULL DEFAULT NULL,
  `height` FLOAT NULL DEFAULT NULL,
  `halfwidth` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`cellid`),
  UNIQUE INDEX `unqCellIdx` USING BTREE (`sessid` ASC, `sc_num` ASC, `cluster` ASC),
  INDEX `sessidx` (`sessid` ASC),
  INDEX `eibidx` (`eibid` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 18932
DEFAULT CHARACTER SET = utf8
COMMENT = 'Cell information';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`channels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`channels` (
  `channelid` INT(11) NOT NULL AUTO_INCREMENT,
  `sessid` INT(11) NOT NULL,
  `ad_channels` VARCHAR(20) NOT NULL,
  `header` TEXT NULL DEFAULT NULL,
  `file_name` VARCHAR(30) NOT NULL,
  `path_name` VARCHAR(100) NULL DEFAULT NULL,
  `AP` FLOAT NULL DEFAULT NULL,
  `DV` FLOAT NULL DEFAULT NULL,
  `ML` FLOAT NULL DEFAULT NULL,
  `target` VARCHAR(30) NULL DEFAULT NULL,
  `ttid` INT(7) NULL DEFAULT NULL,
  PRIMARY KEY (`channelid`),
  INDEX `sessidx` (`sessid` ASC),
  FULLTEXT INDEX `targetidx` (`target` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 9771
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`events` (
  `sessid` INT(10) UNSIGNED NOT NULL,
  `evnt_strt` MEDIUMBLOB NOT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Storage of parsed_events';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`gcs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`gcs` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `computer_name` VARCHAR(99) NOT NULL,
  `dateval` DATETIME NOT NULL,
  `job` VARCHAR(20) NOT NULL,
  `completed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `initials` VARCHAR(4) NOT NULL,
  `message` MEDIUMTEXT NOT NULL,
  `received` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `rectime` DATETIME NOT NULL,
  `failed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `code` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 54321
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`gcs_old`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`gcs_old` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `computer_name` VARCHAR(99) NOT NULL,
  `dateval` DATETIME NOT NULL,
  `job` VARCHAR(20) NOT NULL,
  `completed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `initials` VARCHAR(4) NOT NULL,
  `message` MEDIUMTEXT NOT NULL,
  `received` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `rectime` DATETIME NOT NULL,
  `failed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `code` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 22917
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`jeffsview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`jeffsview` (
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `sessiondate` DATE NULL DEFAULT NULL,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `sess_length` TIME NULL DEFAULT NULL,
  `n_done_trials` INT(11) NULL DEFAULT NULL,
  `perf` VARCHAR(24) NULL DEFAULT NULL,
  `delta_perf` VARCHAR(24) NULL DEFAULT NULL,
  `bias` VARCHAR(19) NULL DEFAULT NULL,
  `delta_bias` VARCHAR(19) NULL DEFAULT NULL,
  `comments` VARCHAR(1000) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`labmember`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`labmember` (
  `memberid` SMALLINT(6) NOT NULL,
  `name` VARCHAR(30) NOT NULL DEFAULT '',
  `contact_info` VARCHAR(230) NOT NULL DEFAULT '',
  `password` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`memberid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`new_calibration_info_tbl`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`new_calibration_info_tbl` (
  `rig_id` VARCHAR(3) NOT NULL,
  `initials` VARCHAR(5) NOT NULL,
  `dateval` DATETIME NOT NULL,
  `valve` VARCHAR(15) NOT NULL,
  `timeval` DOUBLE UNSIGNED NOT NULL,
  `dispense` DOUBLE UNSIGNED NOT NULL,
  `isvalid` TINYINT(1) NOT NULL,
  `calibrationid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `target` VARCHAR(10) NOT NULL,
  `validity` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`calibrationid`))
ENGINE = InnoDB
AUTO_INCREMENT = 30
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`orphaned_sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`orphaned_sessions` (
  `sessid` INT(11) UNSIGNED NOT NULL,
  `experimenter` VARCHAR(30) NOT NULL DEFAULT '',
  `sessiondate` DATE NOT NULL,
  `ratname` CHAR(4) NOT NULL DEFAULT '',
  `rigid` TINYINT(3) UNSIGNED NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`pa_sess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`pa_sess` (
  `sessid` INT(11) NOT NULL DEFAULT '0',
  `num_trials` INT(11) NOT NULL,
  `hits` INT(11) NOT NULL,
  `misses` INT(11) NOT NULL,
  `violations` INT(11) NOT NULL,
  `pro_hit_frac` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_hit_frac` FLOAT UNSIGNED NULL DEFAULT NULL,
  `pro_hit_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `pro_miss_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_hit_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_miss_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
AUTO_INCREMENT = 115
DEFAULT CHARACTER SET = utf8
COMMENT = 'Summary Data for each ProAnti Session';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`parsed_events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`parsed_events` (
  `sessid` INT(11) NOT NULL,
  `peh` MEDIUMBLOB NOT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'a table just for parsed events history';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`parsed_events_2020`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`parsed_events_2020` (
  `sessid` INT(11) NOT NULL,
  `peh` MEDIUMBLOB NOT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'a table just for parsed events history';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`paview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`paview` (
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `sessiondate` DATE NULL DEFAULT NULL,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `sess_length` TIME NULL DEFAULT NULL,
  `n_done_trials` INT(11) NULL DEFAULT NULL,
  `perf` VARCHAR(24) NULL DEFAULT NULL,
  `delta_perf` VARCHAR(24) NULL DEFAULT NULL,
  `bias` VARCHAR(19) NULL DEFAULT NULL,
  `delta_bias` VARCHAR(19) NULL DEFAULT NULL,
  `comments` VARCHAR(1000) NULL DEFAULT NULL,
  `pro_hit_frac` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_hit_frac` FLOAT UNSIGNED NULL DEFAULT NULL,
  `pro_hit_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `pro_miss_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_hit_rt` FLOAT UNSIGNED NULL DEFAULT NULL,
  `anti_miss_rt` FLOAT UNSIGNED NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`phys_sess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`phys_sess` (
  `sessid` INT(11) NOT NULL,
  `cutting_notes` TEXT NULL DEFAULT NULL,
  `notes` VARCHAR(500) NULL DEFAULT NULL,
  `sync_fit_m` FLOAT NULL DEFAULT NULL,
  `sync_fit_b` FLOAT NULL DEFAULT NULL,
  `ratname` VARCHAR(6) NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`protocol_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`protocol_info` (
  `protocol` VARCHAR(30) NOT NULL,
  `start_state` VARCHAR(40) NULL DEFAULT NULL,
  `end_state` VARCHAR(40) NULL DEFAULT NULL,
  `wait_for_center_poke_state` VARCHAR(40) NULL DEFAULT NULL,
  `foo` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`protocol`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Repository of protocol standards';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`raw_tracking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`raw_tracking` (
  `sessid` INT(11) NOT NULL,
  `data` LONGBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Video Tracking data';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`rig_error_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`rig_error_log` (
  `id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `rig_id` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Rig ID',
  `identifier` VARCHAR(30) NOT NULL,
  `message` VARCHAR(300) NOT NULL,
  `datetimeval` DATETIME NOT NULL COMMENT 'Timestamp',
  `file_path` VARCHAR(45) NOT NULL,
  `function_name` VARCHAR(45) NOT NULL,
  `line_number` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`sess_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`sess_list` (
  `sessid` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
AUTO_INCREMENT = 786113
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`sess_started`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`sess_started` (
  `sessid` INT(11) NOT NULL,
  `sessiondate` DATE NULL DEFAULT '1000-01-01',
  `starttime` TIME NULL DEFAULT '00:00:00',
  `was_ended` TINYINT(1) NULL DEFAULT '0',
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `technotes` VARCHAR(200) NULL DEFAULT NULL COMMENT 'Sundeep Tuteja - 2010-04-01: Tech notes should be available in this table, since this table stores databout the start of a session',
  `crashed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `rigid` INT(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`sessid`),
  INDEX `dateidx` (`sessiondate` ASC),
  INDEX `rigidx` (`rigid` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'sessions at the time \"Run\" was clicked';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`sessions` (
  `sessid` INT(11) NOT NULL,
  `ratname` VARCHAR(30) NOT NULL DEFAULT '',
  `hostname` VARCHAR(30) NOT NULL DEFAULT '',
  `experimenter` VARCHAR(30) NOT NULL DEFAULT '',
  `starttime` TIME NOT NULL DEFAULT '00:00:00',
  `endtime` TIME NOT NULL DEFAULT '00:00:00',
  `sessiondate` DATE NOT NULL DEFAULT '1000-01-01',
  `n_done_trials` INT(11) NOT NULL DEFAULT '0',
  `comments` VARCHAR(1000) NULL DEFAULT NULL,
  `settings_file` VARCHAR(200) NOT NULL DEFAULT '',
  `settings_path` VARCHAR(200) NOT NULL DEFAULT '',
  `data_file` VARCHAR(200) NOT NULL DEFAULT '',
  `data_path` VARCHAR(200) NOT NULL DEFAULT '',
  `video_file` VARCHAR(200) NOT NULL DEFAULT '',
  `video_path` VARCHAR(200) NOT NULL DEFAULT '',
  `protocol` VARCHAR(30) NOT NULL DEFAULT '',
  `total_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `right_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `left_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `percent_violations` FLOAT(2,2) NULL DEFAULT NULL,
  `brokenbits` INT(11) NULL DEFAULT '0',
  `protocol_data` MEDIUMBLOB NULL DEFAULT NULL,
  `left_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `center_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `right_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `technotes` VARCHAR(200) NULL DEFAULT NULL,
  `IP_addr` VARCHAR(15) NULL DEFAULT NULL,
  `crashed` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  `foodpuck` TINYINT(1) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY USING BTREE (`sessid`),
  INDEX `rat_index` (`ratname` ASC),
  INDEX `experimenter_index` (`experimenter` ASC),
  INDEX `date_index` (`sessiondate` ASC),
  INDEX `protocol_index` (`protocol` ASC),
  INDEX `data_file_idx` USING HASH (`data_file` ASC),
  INDEX `hostidx` (`hostname` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'data from all rat sessions';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`sessions_2020`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`sessions_2020` (
  `sessid` INT(11) NOT NULL,
  `ratname` VARCHAR(30) NOT NULL DEFAULT '',
  `hostname` VARCHAR(30) NOT NULL DEFAULT '',
  `experimenter` VARCHAR(30) NOT NULL DEFAULT '',
  `starttime` TIME NOT NULL DEFAULT '00:00:00',
  `endtime` TIME NOT NULL DEFAULT '00:00:00',
  `sessiondate` DATE NOT NULL DEFAULT '1000-01-01',
  `n_done_trials` INT(11) NOT NULL DEFAULT '0',
  `comments` VARCHAR(1000) NULL DEFAULT NULL,
  `settings_file` VARCHAR(200) NOT NULL DEFAULT '',
  `settings_path` VARCHAR(200) NOT NULL DEFAULT '',
  `data_file` VARCHAR(200) NOT NULL DEFAULT '',
  `data_path` VARCHAR(200) NOT NULL DEFAULT '',
  `video_file` VARCHAR(200) NOT NULL DEFAULT '',
  `video_path` VARCHAR(200) NOT NULL DEFAULT '',
  `protocol` VARCHAR(30) NOT NULL DEFAULT '',
  `total_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `right_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `left_correct` FLOAT(2,2) NULL DEFAULT NULL,
  `percent_violations` FLOAT(2,2) NULL DEFAULT NULL,
  `brokenbits` INT(11) NULL DEFAULT '0',
  `protocol_data` MEDIUMBLOB NULL DEFAULT NULL,
  `left_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `center_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `right_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `technotes` VARCHAR(200) NULL DEFAULT NULL,
  `IP_addr` VARCHAR(15) NULL DEFAULT NULL,
  `crashed` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  `foodpuck` TINYINT(1) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY USING BTREE (`sessid`),
  INDEX `rat_index` (`ratname` ASC),
  INDEX `experimenter_index` (`experimenter` ASC),
  INDEX `date_index` (`sessiondate` ASC),
  INDEX `protocol_index` (`protocol` ASC),
  INDEX `data_file_idx` USING HASH (`data_file` ASC),
  INDEX `hostidx` (`hostname` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'data from all rat sessions';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`sessview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`sessview` (
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `sessiondate` DATE NULL DEFAULT NULL,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `sess_length` TIME NULL DEFAULT NULL,
  `n_done_trials` INT(11) NULL DEFAULT NULL,
  `perf` VARCHAR(24) NULL DEFAULT NULL,
  `delta_perf` VARCHAR(24) NULL DEFAULT NULL,
  `bias` VARCHAR(19) NULL DEFAULT NULL,
  `delta_bias` VARCHAR(19) NULL DEFAULT NULL,
  `comments` VARCHAR(1000) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`spktimes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`spktimes` (
  `cellid` INT(10) UNSIGNED NOT NULL,
  `sessid` INT(10) UNSIGNED NOT NULL,
  `ts` MEDIUMBLOB NOT NULL,
  `wave` BLOB NOT NULL,
  PRIMARY KEY (`cellid`),
  INDEX `sessidx` (`sessid` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table of spike times and waveform';

-- -----------------------------------------------------
-- Table `alvaros_bdata`.`spktimes_2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`spktimes_2019` (
  `cellid` INT(10) UNSIGNED NOT NULL,
  `sessid` INT(10) UNSIGNED NOT NULL,
  `ts` MEDIUMBLOB NOT NULL,
  `wave` BLOB NOT NULL,
  PRIMARY KEY (`cellid`),
  INDEX `sessidx` (`sessid` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table of spike times and waveform';


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`technician_notes_tbl`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`technician_notes_tbl` (
  `id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `tech_initials` VARCHAR(4) NOT NULL,
  `rig_id` INT(10) UNSIGNED NOT NULL,
  `ratname` VARCHAR(5) NULL DEFAULT NULL,
  `timestamp` DATETIME NOT NULL,
  `sessid` INT(10) UNSIGNED NULL DEFAULT NULL,
  `technotes` VARCHAR(300) NOT NULL,
  `sessiondate` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`tetrodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`tetrodes` (
  `ratname` VARCHAR(6) NULL DEFAULT NULL,
  `ttid` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `eibid` INT(11) NULL DEFAULT NULL,
  `region` VARCHAR(25) NULL DEFAULT NULL,
  `side` CHAR(1) NULL DEFAULT NULL,
  `ch0_imp` FLOAT NULL DEFAULT NULL,
  `ch1_imp` FLOAT NULL DEFAULT NULL,
  `ch2_imp` FLOAT NULL DEFAULT NULL,
  `ch3_imp` FLOAT NULL DEFAULT NULL,
  `notes` VARCHAR(100) NULL DEFAULT NULL,
  `tt_num` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ttid`),
  INDEX `eibidx` (`eibid` ASC),
  INDEX `ratidx` (`ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 34
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_bdata`.`tracking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_bdata`.`tracking` (
  `sessid` INT(11) NOT NULL,
  `ts` LONGBLOB NULL DEFAULT NULL,
  `x` LONGBLOB NULL DEFAULT NULL,
  `y` LONGBLOB NULL DEFAULT NULL,
  `theta` LONGBLOB NULL DEFAULT NULL,
  `header` BLOB NULL DEFAULT NULL,
  `error_code` INT(11) NULL DEFAULT NULL COMMENT 'specify a bit code here of what each bit signifies.  0 means all good.',
  `comments` VARCHAR(200) NULL DEFAULT NULL,
  `proc_theta` LONGBLOB NULL DEFAULT NULL,
  `proc_ts` LONGBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Video Tracking data';

USE `alvaros_protocol` ;

-- -----------------------------------------------------
-- Table `alvaros_protocol`.`ExtendedStimulus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`ExtendedStimulus` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxWithout` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxSame` FLOAT NULL DEFAULT NULL,
  `SidesSection_ThisPair` TINYINT(3) NULL DEFAULT NULL,
  `SidesSection_ntrials` FLOAT NULL DEFAULT NULL,
  `SidesSection_SortBySides` FLOAT NULL DEFAULT NULL,
  `SidesSection_LeftRightOnly` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFracTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_LtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_RtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_BiasTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_Beta` FLOAT NULL DEFAULT NULL,
  `RewardsSection_hit_streak` FLOAT NULL DEFAULT NULL,
  `RewardsSection_no_violation_trials` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last30_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last15_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_mean_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nTrials` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nRewards` FLOAT NULL DEFAULT NULL,
  `StimulusSection_n_center_pokes` FLOAT NULL DEFAULT NULL,
  `StimulusSection_InterCycleGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_f1f2Gap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_Center2CenterGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_Center2SideGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_Center2SideGap2` FLOAT NULL DEFAULT NULL,
  `StimulusSection_n_stimulus_cycles` FLOAT NULL DEFAULT NULL,
  `StimulusSection_StimulusDuration` FLOAT NULL DEFAULT NULL,
  `StimulusSection_StimTimeStart` FLOAT NULL DEFAULT NULL,
  `StimulusSection_FromAnswerPoke` FLOAT NULL DEFAULT NULL,
  `StimulusSection_WaterMultiplier` FLOAT NULL DEFAULT NULL,
  `StimulusSection_PriProb` FLOAT NULL DEFAULT NULL,
  `StimulusSection_PostProb` FLOAT NULL DEFAULT NULL,
  `StimulusSection_CurrentPair` FLOAT NULL DEFAULT NULL,
  `StimulusSection_SoundsOn` FLOAT NULL DEFAULT NULL,
  `StimulusSection_sounds_button` FLOAT NULL DEFAULT NULL,
  `StimulusSection_snd_amp` FLOAT NULL DEFAULT NULL,
  `StimulusSection_pprob` FLOAT NULL DEFAULT NULL,
  `StimulusSection_f1_frq` FLOAT NULL DEFAULT NULL,
  `StimulusSection_f1_dur` FLOAT NULL DEFAULT NULL,
  `StimulusSection_f2_frq` FLOAT NULL DEFAULT NULL,
  `StimulusSection_f2_dur` FLOAT NULL DEFAULT NULL,
  `StimulusSection_wtr_ml` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blocks_button` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk2_min_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk2_max_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk2_antibias` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk2_thrshld` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk1_min_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk1_max_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk1_antibias` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk1_thrshld` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk0_min_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk0_max_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk0_antibias` FLOAT NULL DEFAULT NULL,
  `StimulusSection_blk0_thrshld` FLOAT NULL DEFAULT NULL,
  `StimulusSection_temperror_len` FLOAT NULL DEFAULT NULL,
  `StimulusSection_error_timeout` FLOAT NULL DEFAULT NULL,
  `StimulusSection_goto_trial_terminates_at` FLOAT NULL DEFAULT NULL,
  `StimulusSection_random_max_same` FLOAT NULL DEFAULT NULL,
  `StimulusSection_random_antibias` FLOAT NULL DEFAULT NULL,
  `StimulusSection_goto_blocks_at` FLOAT NULL DEFAULT NULL,
  `StimulusSection_goto_random_at` FLOAT NULL DEFAULT NULL,
  `StimulusSection_counter` FLOAT NULL DEFAULT NULL,
  `StimulusSection_n_block` FLOAT NULL DEFAULT NULL,
  `StimulusSection_last_session_n_probe_trials` FLOAT NULL DEFAULT NULL,
  `StimulusSection_last_session_probe_hitfrac` FLOAT NULL DEFAULT NULL,
  `TimesSection_water_wait` FLOAT NULL DEFAULT NULL,
  `TimesSection_water_wait_lights` FLOAT NULL DEFAULT NULL,
  `TimesSection_mu_ITI` FLOAT NULL DEFAULT NULL,
  `TimesSection_sd_ITI` FLOAT NULL DEFAULT NULL,
  `TimesSection_miss_ITI` FLOAT NULL DEFAULT NULL,
  `TimesSection_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_penalty_button` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterLightPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishCL1BadPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_C2SPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SSidePokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SCenterPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITIPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishITIPokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WD_in_sdt` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkGrace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkCap` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarningSoundPanel` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarnDur` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DangerDur` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_WarningSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_DangerSoundBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PostDrinkPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ErrorPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_TimeOutPun_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SideChoicePunishmentType` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishSideChoice` FLOAT NULL DEFAULT NULL,
  `SessionDefinition_active_stage` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`),
  INDEX `thispairidx` (`SidesSection_ThisPair` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`ProAnti2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`ProAnti2` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` TINYINT(4) NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT UNSIGNED NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SessionDefinition_eod_jumper` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_StartTrialSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_ProSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ProSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_AntiSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_AntiSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_RightSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_RightSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_CenterSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_CenterSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_LeftSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_LeftSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_HitSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_HitSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_MissSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_MissSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ViolationSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_BadBoySoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_ITISoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_ITISoundBal` FLOAT NULL DEFAULT NULL,
  `SettingsSection_nPokes` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_pro_prob` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_trial_type` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_prior_override` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_MaxSame` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_delay2startTO` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke1TO_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke1TO_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_show_poke1leds` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_poke1snd_delay_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke1snd_delay_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke1poke2gap_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke1poke2gap_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2TO_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2TO_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_show_poke2leds` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_pk2_stop_cntxt_snd` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_poke2snd_delay_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2snd_delay_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2ledTime` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2poke3gap_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke2poke3gap_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke3TO_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_poke3TO_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_AL_badboy` FLOAT NULL DEFAULT NULL,
  `SettingsSection_AR_badboy` FLOAT NULL DEFAULT NULL,
  `SettingsSection_PL_badboy` FLOAT NULL DEFAULT NULL,
  `SettingsSection_PR_badboy` FLOAT NULL DEFAULT NULL,
  `SettingsSection_wrs_override` FLOAT NULL DEFAULT NULL,
  `SettingsSection_delay2reward_max` FLOAT NULL DEFAULT NULL,
  `SettingsSection_delay2reward_min` FLOAT NULL DEFAULT NULL,
  `SettingsSection_reward_prob` FLOAT NULL DEFAULT NULL,
  `SettingsSection_FlashCorrectResp` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_scale_reward` FLOAT NULL DEFAULT NULL,
  `SettingsSection_scale_temperror_rew` FLOAT NULL DEFAULT NULL,
  `SettingsSection_KeepSoundOn` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_poke2sound_t_after_wtr` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_hitITIdurUI` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_violationITIdurUI` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_missITIdurUI` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PApunish_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_PApunish_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PApunish_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PApunish_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PApunish_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PApunish_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `SoftPokeStayInterface_soft_drink_time_Duration` FLOAT NULL DEFAULT NULL,
  `SoftPokeStayInterface_soft_drink_time_Grace` FLOAT NULL DEFAULT NULL,
  `SettingsSection_reward_type` TINYINT(4) NULL DEFAULT NULL,
  `SettingsSection_hit_iti_or_wd` TINYINT(4) NULL DEFAULT NULL,
  `WarnDangerInterface_wd_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_WarningSoundBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_wd_DangerSoundBal` FLOAT NULL DEFAULT NULL,
  `WarnDangerInterface_wd_WarnDur` FLOAT NULL DEFAULT NULL,
  `WarnDangerInterface_wd_DangerDur` FLOAT NULL DEFAULT NULL,
  `PunishInterface_iti_punishment_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_InitSndBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndLoop` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_iti_punishment_OngoingSndBal` FLOAT NULL DEFAULT NULL,
  `PunishInterface_iti_punishment_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_iti_punishment_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_iti_punishment_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_iti_punishment_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `SettingsSection_locsnd_anti_hz` FLOAT NULL DEFAULT NULL,
  `SettingsSection_locsnd_pro_hz` FLOAT NULL DEFAULT NULL,
  `SettingsSection_cntx_loc_overlap` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFracTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_LtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_RtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_BiasTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_Beta` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_LtProb` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_RtProb` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_carlos_block_type` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_carlos_block_counter` SMALLINT(6) NULL DEFAULT NULL,
  `PerformanceSection_PRewarded` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_PCorrect` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_PProCorrect` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_PAntCorrect` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_PLeftCorr` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_PRightCorr` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_NLeftPokes` SMALLINT(6) NULL DEFAULT NULL,
  `PerformanceSection_NRightPokes` SMALLINT(6) NULL DEFAULT NULL,
  `PerformanceSection_NCenterPokes` SMALLINT(6) NULL DEFAULT NULL,
  `PerformanceSection_streak` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_numtrials` SMALLINT(6) NULL DEFAULT NULL,
  `PerformanceSection_reward_baited` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_goodPoke3` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_poke2_snd_loc` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_pro_trial` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_poke3TO` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_poke2poke3gap` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_poke2snd_delay` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_goodPoke2` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_poke2TO` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_poke1poke2gap` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_poke1snd_delay` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_goodPoke1` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_poke1TO` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_reward_time` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_delay2reward` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_missITIdur` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_hitITIdur` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_violationITIdur` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_block_counter` FLOAT NULL DEFAULT NULL,
  `PerformanceSection_current_block` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_n_good_trials` TINYINT(4) NULL DEFAULT NULL,
  `PerformanceSection_ntrials` SMALLINT(6) NULL DEFAULT NULL,
  `SessionDefinition_active_stage` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`helper_vars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`helper_vars` (
  `sessid` INT(11) NOT NULL,
  `trial_n` SMALLINT(5) UNSIGNED NOT NULL,
  `sph_fullname` VARCHAR(100) NOT NULL,
  `sph_value` BLOB NULL DEFAULT NULL,
  UNIQUE INDEX `uniqueidx` (`sph_fullname` ASC, `trial_n` ASC, `sessid` ASC),
  INDEX `sessidx` (`sessid` ASC),
  INDEX `nameidx` (`sph_fullname` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`helper_vars2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`helper_vars2` (
  `sessid` INT(11) NOT NULL,
  `trial_n` SMALLINT(6) NOT NULL,
  `sph_fullname` VARCHAR(100) NOT NULL,
  `sph_value` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`, `sph_fullname`),
  INDEX `sessidx` (`sessid` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`lightchasing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`lightchasing` (
  `sessid` INT(11) NOT NULL,
  `trial_n` SMALLINT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`trial_n`, `sessid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`pbups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`pbups` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SidesSection_LR_BiasTau` FLOAT NULL DEFAULT NULL,
  `SidesSection_LR_Beta` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxSame` FLOAT NULL DEFAULT NULL,
  `SidesSection_ThisSound` FLOAT NULL DEFAULT NULL,
  `RewardsSection_error_delay` FLOAT NULL DEFAULT NULL,
  `RewardsSection_locked_in_sound` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundVol` FLOAT NULL DEFAULT NULL,
  `RewardsSection_reward_delay` FLOAT NULL DEFAULT NULL,
  `RewardsSection_left_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_right_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_right_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_left_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_center_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_hit_streak` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last60_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last30_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last15_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_mean_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_cpoke_violations` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nTrials` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nRewarded` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nCorrect` FLOAT NULL DEFAULT NULL,
  `StimulusSection_nose_in_center` FLOAT NULL DEFAULT NULL,
  `StimulusSection_legal_cbreak` FLOAT NULL DEFAULT NULL,
  `StimulusSection_nic_end_sound` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundVol` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap_2` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_LEDRewardTime` FLOAT NULL DEFAULT NULL,
  `StimulusSection_fixed_stim_dur` FLOAT NULL DEFAULT NULL,
  `StimulusSection_memory_gap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_stim_start_delay` FLOAT NULL DEFAULT NULL,
  `PBupsSection_HitFracTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_RtHitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_LtHitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_HitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_BiasTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_Beta` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationBeta` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationBias` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_probe` FLOAT NULL DEFAULT NULL,
  `PBupsSection_p_probe` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_min` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_max` FLOAT NULL DEFAULT NULL,
  `PBupsSection_gamma_style` FLOAT NULL DEFAULT NULL,
  `PBupsSection_easiest` FLOAT NULL DEFAULT NULL,
  `PBupsSection_hardest` FLOAT NULL DEFAULT NULL,
  `PBupsSection_N` FLOAT NULL DEFAULT NULL,
  `PBupsSection_total_rate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_first_bup_stereo` FLOAT NULL DEFAULT NULL,
  `PBupsSection_crosstalk` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisGamma` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisLeftRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisRightRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_vol` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_miss_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishCL1BadPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SSidePokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SCenterPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishITIPokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WD_in_sdt` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkGrace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkCap` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarnDur` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DangerDur` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_LEDtemp_pun` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SideChoicePunishmentType` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishSideChoice` TINYINT(1) NULL DEFAULT NULL,
  `PenaltySection_PunishSidePokesinWFCO` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WaitForCenterNoseOut` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



-- -----------------------------------------------------
-- Table `alvaros_protocol`.`pbups_2020`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`pbups_2020` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SidesSection_LR_BiasTau` FLOAT NULL DEFAULT NULL,
  `SidesSection_LR_Beta` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxSame` FLOAT NULL DEFAULT NULL,
  `SidesSection_ThisSound` FLOAT NULL DEFAULT NULL,
  `RewardsSection_error_delay` FLOAT NULL DEFAULT NULL,
  `RewardsSection_locked_in_sound` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_locked_in_soundVol` FLOAT NULL DEFAULT NULL,
  `RewardsSection_reward_delay` FLOAT NULL DEFAULT NULL,
  `RewardsSection_left_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_right_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_right_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_left_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_center_pokes` FLOAT NULL DEFAULT NULL,
  `RewardsSection_hit_streak` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last60_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last30_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last15_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_mean_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_cpoke_violations` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nTrials` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nRewarded` FLOAT NULL DEFAULT NULL,
  `RewardsSection_nCorrect` FLOAT NULL DEFAULT NULL,
  `StimulusSection_nose_in_center` FLOAT NULL DEFAULT NULL,
  `StimulusSection_legal_cbreak` FLOAT NULL DEFAULT NULL,
  `StimulusSection_nic_end_sound` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_nic_end_soundVol` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap_2` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_LEDRewardTime` FLOAT NULL DEFAULT NULL,
  `StimulusSection_fixed_stim_dur` FLOAT NULL DEFAULT NULL,
  `StimulusSection_memory_gap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_stim_start_delay` FLOAT NULL DEFAULT NULL,
  `PBupsSection_HitFracTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_RtHitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_LtHitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_HitFrac` FLOAT NULL DEFAULT NULL,
  `PBupsSection_BiasTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_Beta` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationBeta` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationTau` FLOAT NULL DEFAULT NULL,
  `PBupsSection_DurationBias` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_probe` FLOAT NULL DEFAULT NULL,
  `PBupsSection_p_probe` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_min` FLOAT NULL DEFAULT NULL,
  `PBupsSection_T_max` FLOAT NULL DEFAULT NULL,
  `PBupsSection_gamma_style` FLOAT NULL DEFAULT NULL,
  `PBupsSection_easiest` FLOAT NULL DEFAULT NULL,
  `PBupsSection_hardest` FLOAT NULL DEFAULT NULL,
  `PBupsSection_N` FLOAT NULL DEFAULT NULL,
  `PBupsSection_total_rate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_first_bup_stereo` FLOAT NULL DEFAULT NULL,
  `PBupsSection_crosstalk` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisGamma` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisLeftRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisRightRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_vol` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_miss_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishCL1BadPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SSidePokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SCenterPokes` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishITIPokes` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WD_in_sdt` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkGrace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkCap` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarnDur` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DangerDur` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Duration` FLOAT NULL DEFAULT NULL,
  `PenaltySection_LEDtemp_pun` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SideChoicePunishmentType` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishSideChoice` TINYINT(1) NULL DEFAULT NULL,
  `PenaltySection_PunishSidePokesinWFCO` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WaitForCenterNoseOut` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`samedifferent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`samedifferent` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxWithout` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxSame` FLOAT NULL DEFAULT NULL,
  `SidesSection_ThisSound` SMALLINT(5) NULL DEFAULT NULL,
  `SidesSection_SortBySides` TINYINT(1) NULL DEFAULT NULL,
  `SidesSection_LeftRightOnly` TINYINT(1) NULL DEFAULT NULL,
  `RewardsSection_reward_delay` FLOAT NULL DEFAULT NULL,
  `RewardsSection_left_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_right_wtr_mult` FLOAT NULL DEFAULT NULL,
  `RewardsSection_n_right_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_n_left_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_n_center_pokes` INT(10) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_hit_streak` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_last30_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_last15_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_mean_hitfrac` FLOAT NULL DEFAULT NULL,
  `RewardsSection_cpoke_violations` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_spoke_violations` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_nTrials` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_nRewarded` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `RewardsSection_nCorrect` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `StimulusSection_count_cpokes` TINYINT(1) NULL DEFAULT NULL,
  `StimulusSection_cpoke_schedule` TINYINT(4) NULL DEFAULT NULL,
  `StimulusSection_n_center_pokes` TINYINT(4) NULL DEFAULT NULL,
  `StimulusSection_nose_in_center` FLOAT NULL DEFAULT NULL,
  `StimulusSection_legal_cbreak` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap` FLOAT NULL DEFAULT NULL,
  `StimulusSection_C2SGap_2` FLOAT NULL DEFAULT NULL,
  `StimulusSection_stim_start_delay` FLOAT NULL DEFAULT NULL,
  `StimulusSection_n_stimulus_cycles` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
  `StimulusSection_fixed_stim_dur` FLOAT NULL DEFAULT NULL,
  `StimulusSection_from_answer_poke` TINYINT(1) NULL DEFAULT NULL,
  `StimulusSection_StimTimeStart` TINYINT(1) NULL DEFAULT NULL,
  `StimulusSection_SoundsOn` TINYINT(1) NULL DEFAULT NULL,
  `SoundTableSection_T1soundtable_show` TINYINT(1) NULL DEFAULT NULL,
  `SoundTableSection_T1loop` TINYINT(1) NULL DEFAULT NULL,
  `SoundTableSection_T1two_sounds` TINYINT(1) NULL DEFAULT NULL,
  `SoundTableSection_T1Gap1` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1Gap2` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1HitFracTau` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1LtHitFrac` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1RtHitFrac` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1HitFrac` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1BiasTau` FLOAT NULL DEFAULT NULL,
  `SoundTableSection_T1Beta` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_miss_ITI` FLOAT NULL DEFAULT NULL,
  `PenaltySection_penalty_button` TINYINT(1) NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_CenterLightPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishCL1BadPokes` TINYINT(1) NULL DEFAULT NULL,
  `PunishInterface_C2SPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_C2SPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishC2SSidePokes` TINYINT(1) NULL DEFAULT NULL,
  `PenaltySection_PunishC2SCenterPokes` TINYINT(1) NULL DEFAULT NULL,
  `PunishInterface_ITIPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ITIPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_PunishITIPokes` TINYINT(1) NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WD_in_sdt` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkGrace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SoftDrinkCap` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DrinkTime` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarningSoundPanel` FLOAT NULL DEFAULT NULL,
  `PenaltySection_WarnDur` FLOAT NULL DEFAULT NULL,
  `PenaltySection_DangerDur` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_PostDrinkPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_wait_for_cpoke_grace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_wait_for_spoke_grace` FLOAT NULL DEFAULT NULL,
  `PenaltySection_violation_punishment` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_ErrorPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Duration` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_Reinit` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_ReinitGrace` FLOAT NULL DEFAULT NULL,
  `PunishInterface_TimeOutPun_ReinitPenalty` FLOAT NULL DEFAULT NULL,
  `PenaltySection_SideChoicePunishmentType` TINYINT(1) NULL DEFAULT NULL,
  `PenaltySection_PunishSideChoice` TINYINT(1) NULL DEFAULT NULL,
  `PokesPlotSection_PokesPlotShow` TINYINT(1) NULL DEFAULT NULL,
  `PokesPlotSection_t0` FLOAT NULL DEFAULT NULL,
  `PokesPlotSection_t1` FLOAT NULL DEFAULT NULL,
  `PokesPlotSection_ntrials` FLOAT NULL DEFAULT NULL,
  `PokesPlotSection_start_trial` FLOAT NULL DEFAULT NULL,
  `PokesPlotSection_end_trial` FLOAT NULL DEFAULT NULL,
  `CommentsSection_CommentsShow` TINYINT(1) NULL DEFAULT NULL,
  `SessionDefinition_session_show` TINYINT(1) NULL DEFAULT NULL,
  `SessionDefinition_active_stage` TINYINT(4) NULL DEFAULT NULL,
  `SessionDefinition_eod_jumper` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisGamma` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisLeftRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_ThisRightRate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_total_rate` FLOAT NULL DEFAULT NULL,
  `PBupsSection_sduration` FLOAT NULL DEFAULT NULL,
  `PBupsSection_L_pprob` FLOAT NULL DEFAULT NULL,
  `PBupsSection_vol` FLOAT NULL DEFAULT NULL,
  `PBupsSection_first_bup_stereo` TINYINT(4) NULL DEFAULT NULL,
  `PBupsSection_crosstalk` FLOAT NULL DEFAULT NULL,
  `StimulusSection_SoundSource` TINYINT(4) NULL DEFAULT NULL,
  `SoundInterface_TempPunDur1` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`sounddiscrimination`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`sounddiscrimination` (
  `sessid` INT(11) NOT NULL,
  `trial_n` INT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL,
  `WaterValvesSection_Streak_base` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Streak_max` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Right_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_RightWValveTime` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_Left_volume` FLOAT NULL DEFAULT NULL,
  `WaterValvesSection_LeftWValveTime` FLOAT NULL DEFAULT NULL,
  `SessionDefinition_active_stage` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_n_center_pokes` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusWNP` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_left_stimulusBal` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusTau` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusGap` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusWNP` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusLoop` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusDur1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusDur2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusFMAmp` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusFreq1` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusVol2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusFreq2` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusFMFreq` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusVol` FLOAT NULL DEFAULT NULL,
  `SoundInterface_right_stimulusBal` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2_Min` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2_Max` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2_Tau` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2_Mu` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2_Sd` FLOAT NULL DEFAULT NULL,
  `DistribInterface_var_gap2` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_Lock_Gap_Sound` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_Temperror` FLOAT NULL DEFAULT NULL,
  `SoftPokeStayInterface2_soft_drink_time_Duration` FLOAT NULL DEFAULT NULL,
  `SoftPokeStayInterface2_soft_drink_time_Grace` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_SoundRewardOverlap` FLOAT NULL DEFAULT NULL,
  `WarnDangerInterface_warndanger_SoundsPanel` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_Psych10_Count` FLOAT NULL DEFAULT NULL,
  `SoundDiscrimination_Total_Trial_Count` FLOAT NULL DEFAULT NULL,
  `PhantomSection_PhantomParam` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFracTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_LtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_RtHitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_HitFrac` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_BiasTau` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_Beta` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_LtProb` FLOAT NULL DEFAULT NULL,
  `AntibiasSection_RtProb` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxSame` FLOAT NULL DEFAULT NULL,
  `SidesSection_MaxWithout` FLOAT NULL DEFAULT NULL,
  `SidesSection_LeftProb` FLOAT NULL DEFAULT NULL,
  `SidesSection_ViewState` FLOAT NULL DEFAULT NULL,
  `PsychSection_T1_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T1_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T2_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T2_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T3_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T3_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T4_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T4_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T5_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T5_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T6_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T6_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T7_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T7_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T8_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T8_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T9_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T9_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_T10_HitFrac` FLOAT NULL DEFAULT NULL,
  `PsychSection_T10_TriNum` FLOAT NULL DEFAULT NULL,
  `PsychSection_TrialType` FLOAT NULL DEFAULT NULL,
  `PsychSection_LeftEndPsych` FLOAT NULL DEFAULT NULL,
  `PsychSection_Spread` FLOAT NULL DEFAULT NULL,
  `PsychSection_RightEndPsych` FLOAT NULL DEFAULT NULL,
  `PsychSection_Mid` FLOAT NULL DEFAULT NULL,
  `PsychSection_NumPsych` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`, `trial_n`),
  INDEX `sessidx` (`sessid` ASC),
  INDEX `trialidx` (`trial_n` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_protocol`.`tempSD`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_protocol`.`tempSD` (
  `sessid` INT(11) NOT NULL,
  `trial_n` SMALLINT(6) NOT NULL,
  `ProtocolsSection_parsed_events` BLOB NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `alvaros_ratinfo` ;

-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`cerebro_sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`cerebro_sessions` (
  `ratname` CHAR(4) NOT NULL,
  `sessid` INT(10) UNSIGNED NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  `exclude` TINYINT(1) UNSIGNED NOT NULL,
  `exclude_reason` VARCHAR(1000) NULL DEFAULT NULL,
  `comments` VARCHAR(1000) NULL DEFAULT NULL,
  `cerebro_session_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`cerebro_session_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'table for storing info about cerebro sessions';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`contacts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`contacts` (
  `experimenter` VARCHAR(30) NOT NULL DEFAULT 'unnamed',
  `email` VARCHAR(150) NULL DEFAULT NULL,
  `initials` VARCHAR(5) NULL DEFAULT NULL,
  `telephone` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
  `tag_letter` VARCHAR(1) NULL DEFAULT NULL,
  `tag_RGB_old` TINYBLOB NULL DEFAULT NULL,
  `lab_manager` TINYINT(1) NULL DEFAULT '0',
  `subscribe_all` TINYINT(1) NULL DEFAULT '0',
  `tech_morning` TINYINT(1) NULL DEFAULT '0',
  `tech_afternoon` TINYINT(1) NULL DEFAULT '0',
  `tech_computer` TINYINT(1) UNSIGNED NULL DEFAULT '0',
  `is_alumni` TINYINT(1) NOT NULL,
  `custom_rig_order` VARCHAR(128) NULL DEFAULT NULL,
  `FullName` VARCHAR(60) NULL DEFAULT NULL,
  `tech_overnight` TINYINT(1) UNSIGNED ZEROFILL NULL DEFAULT '0',
  `tag_RGB` CHAR(12) NULL DEFAULT NULL,
  `tech_shifts` VARCHAR(45) NOT NULL,
  `phone_carrier` VARCHAR(15) NULL DEFAULT NULL,
  `contactid` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`contactid`))
ENGINE = InnoDB
AUTO_INCREMENT = 117
DEFAULT CHARACTER SET = utf8
COMMENT = 'Experimenter Contact Information';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`eibs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`eibs` (
  `eibid` INT(5) UNSIGNED NOT NULL DEFAULT '0',
  `ratname` VARCHAR(6) NOT NULL,
  `eib_num` VARCHAR(7) NOT NULL,
  `made_by` VARCHAR(40) NULL DEFAULT NULL,
  `made_on` DATE NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  `region` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`eibid`))
ENGINE = InnoDB
AUTO_INCREMENT = 680
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`experiment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`experiment` (
  `expid` CHAR(8) NOT NULL DEFAULT '',
  `project` VARCHAR(30) NULL DEFAULT NULL COMMENT 'which umbrella project does this belong to.',
  `description` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Description of the experiment',
  `start_date` DATE NULL DEFAULT NULL COMMENT 'when did this start',
  `end_date` DATE NULL DEFAULT NULL COMMENT 'when did this end',
  `experimenters` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Comma separated list of the people working on this experiment',
  `keywords` VARCHAR(500) NULL DEFAULT NULL COMMENT 'some keywords (eg. halo, muscimol, water restriction)',
  PRIMARY KEY (`expid`),
  INDEX `projidx` (`project` ASC),
  FULLTEXT INDEX `keyidx` (`keywords` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`infusions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`infusions` (
  `sessid` INT(11) NOT NULL,
  `ratname` VARCHAR(4) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `sessiondate` DATE NULL DEFAULT NULL,
  `start_time` TIME NULL DEFAULT NULL,
  `end_time` TIME NULL DEFAULT NULL,
  `region` VARCHAR(40) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `volume` DECIMAL(5,2) NULL DEFAULT NULL COMMENT 'in µL',
  `dose` DECIMAL(5,3) NULL DEFAULT NULL,
  `infusion_duration` SMALLINT(6) NULL DEFAULT NULL COMMENT 'in seconds',
  `drug` VARCHAR(40) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `notes` VARCHAR(300) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `performed_by` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `ignore_sess` TINYINT(4) NULL DEFAULT '0',
  `ignore_reason` VARCHAR(300) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `cntrl_sessid` INT(11) NULL DEFAULT NULL,
  `old_dose` DECIMAL(5,2) NULL DEFAULT NULL COMMENT 'in mg/mL',
  PRIMARY KEY (`sessid`),
  INDEX `ratidx` (`ratname` ASC),
  INDEX `regidx` (`region` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`mass`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`mass` (
 `alvaros_ratinfo`.`mass` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `weighing` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL DEFAULT '1000-01-01',
  `ratname` VARCHAR(4) NOT NULL,
  `tech` VARCHAR(4) NULL DEFAULT NULL,
  `timeval` TIME NOT NULL,
  PRIMARY KEY USING BTREE (`weighing`),
  UNIQUE INDEX `ratday` (`date` ASC, `ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 932590
DEFAULT CHARACTER SET = utf8
COMMENT = 'rat masses';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`pa_opto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`pa_opto` (
  `sessiondate` DATE NULL DEFAULT NULL,
  `ratname` VARCHAR(4) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `sessid` INT(11) NOT NULL,
  `region` VARCHAR(40) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `plug_in` TINYINT(4) NULL DEFAULT '0',
  `laser` TINYINT(4) NULL DEFAULT '0',
  `stim_epoch` VARCHAR(40) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `performed_by` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `ignore_sess` TINYINT(4) NULL DEFAULT '0',
  `ignore_reason` VARCHAR(300) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `notes` VARCHAR(300) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`),
  INDEX `ratidx` (`ratname` ASC),
  INDEX `regidx` (`region` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`phys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`phys` (
  `sessid` INT(11) NOT NULL,
  `notes` VARCHAR(500) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `session_notes` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `plugged_in` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1',
  `tetrodes_with_cells` VARCHAR(255) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `good_tracking` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  `MUAs` VARCHAR(255) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `LFPs` VARCHAR(255) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `ratname` VARCHAR(6) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `eibids` VARCHAR(50) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`),
  INDEX `ratidx` (`ratname` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rat_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rat_history` (
  `internalID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `free` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not the rat is available for use by any other experimenter',
  `alert` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not there is an alert for special attention for the rat (e.g. sick, recent surgery, etc.)',
  `experimenter` VARCHAR(20) NULL DEFAULT NULL COMMENT 'name of the experimenter',
  `contact` VARCHAR(40) NULL DEFAULT NULL,
  `ratname` VARCHAR(4) NULL DEFAULT NULL COMMENT 'name of the rat',
  `training` TINYINT(1) NOT NULL DEFAULT '0',
  `comments` VARCHAR(500) NULL DEFAULT NULL,
  `waterperday` INT(11) NOT NULL DEFAULT '30' COMMENT '0 for free water, otherwise the number of minutes the rat has access to water each day (may vary over time)',
  `recovering` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not the rat is currently in recovery from surgery',
  `extant` TINYINT(4) NOT NULL DEFAULT '0',
  `cagemate` VARCHAR(4) NULL DEFAULT NULL,
  `forceFreeWater` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `dateSac` DATE NULL DEFAULT NULL,
  `forceDepWater` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `bringUpAt` TINYINT(1) NULL DEFAULT '0' COMMENT 'set with which rat should be brought upstairs',
  `bringupday` VARCHAR(7) NULL DEFAULT NULL,
  `ignoredByWatermeister` TINYINT(1) NULL DEFAULT '0',
  `logtime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY USING BTREE (`internalID`),
  INDEX `ratidx` (`ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 14867
DEFAULT CHARACTER SET = utf8
COMMENT = 'Brody Lab Rats';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rats` (
  `internalID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `free` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not the rat is available for use by any other experimenter',
  `alert` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not there is an alert for special attention for the rat (e.g. sick, recent surgery, etc.)',
  `experimenter` VARCHAR(20) NULL DEFAULT NULL COMMENT 'name of the experimenter',
  `contact` VARCHAR(40) NULL DEFAULT NULL,
  `ratname` VARCHAR(4) NULL DEFAULT NULL COMMENT 'name of the rat',
  `training` TINYINT(1) NOT NULL DEFAULT '0',
  `comments` VARCHAR(500) NULL DEFAULT NULL,
  `vendor` VARCHAR(40) NOT NULL DEFAULT 'Taconic' COMMENT 'e.g. Taconic, Charles River, etc.',
  `waterperday` INT(11) NOT NULL DEFAULT '30' COMMENT '0 for free water, otherwise the number of minutes the rat has access to water each day (may vary over time)',
  `recovering` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'whether or not the rat is currently in recovery from surgery',
  `deliverydate` DATE NULL DEFAULT NULL COMMENT 'date rat arrived at lab',
  `massArrival` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'mass of the rat upon arrival',
  `po` VARCHAR(8) NULL DEFAULT NULL,
  `extant` TINYINT(4) NOT NULL DEFAULT '0',
  `cagemate` VARCHAR(4) NULL DEFAULT NULL,
  `forceFreeWater` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `dateSac` DATE NULL DEFAULT NULL,
  `forceDepWater` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `bringUpAt` TINYINT(1) NULL DEFAULT '0' COMMENT 'set with which rat should be brought upstairs',
  `bringupday` VARCHAR(7) NULL DEFAULT NULL,
  `ignoredByWatermeister` TINYINT(1) NULL DEFAULT '0',
  `larid` INT(10) NULL DEFAULT NULL,
  `israt` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1 if rat, 0 if mouse',
  PRIMARY KEY USING BTREE (`internalID`),
  UNIQUE INDEX `ratname` (`ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 3320
DEFAULT CHARACTER SET = utf8
COMMENT = 'Brody Lab Rats';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rig_maintenance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rig_maintenance` (
  `maintenance_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `rigid` INT(10) UNSIGNED NOT NULL,
  `note` TEXT NOT NULL,
  `isbroken` TINYINT(3) UNSIGNED NOT NULL,
  `broke_person` VARCHAR(45) NOT NULL,
  `fix_person` VARCHAR(45) NOT NULL,
  `broke_date` DATETIME NOT NULL,
  `fix_date` DATETIME NOT NULL,
  `fix_note` TEXT NOT NULL,
  PRIMARY KEY (`maintenance_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2165
DEFAULT CHARACTER SET = latin1
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigflush`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigflush` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `rig` INT(10) UNSIGNED NOT NULL,
  `wasflushed` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `dateval` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 36674
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigfood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigfood` (
  `rigfoodid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `rigid` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `datetime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  PRIMARY KEY (`rigfoodid`))
ENGINE = InnoDB
AUTO_INCREMENT = 9669
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`riginfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`riginfo` (
  `rigid` INT(3) UNSIGNED NOT NULL,
  `ip_addr` CHAR(15) NOT NULL DEFAULT '',
  `mac_addr` CHAR(12) NULL DEFAULT '',
  `rtfsm_ip` CHAR(15) NULL DEFAULT NULL,
  `hostname` VARCHAR(50) NULL DEFAULT NULL,
  `is_linux` INT(1) NULL DEFAULT NULL,
  `video_server` CHAR(15) NULL DEFAULT NULL,
  `comptype` CHAR(50) NULL DEFAULT '',
  PRIMARY KEY (`rigid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `hostname` VARCHAR(30) NULL DEFAULT NULL,
  `Rig_ID` INT(11) NOT NULL DEFAULT '0',
  `type` ENUM('Matlab', 'RT') NULL DEFAULT NULL,
  `IP` VARCHAR(16) NULL DEFAULT NULL,
  `MAC` CHAR(12) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8
COMMENT = 'Rig info';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigtrials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigtrials` (
  `rigid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `n_done_trials` INT(10) UNSIGNED NOT NULL,
  `peh` BLOB NOT NULL,
  `performance` DOUBLE NOT NULL,
  `foodpuck` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`rigid`))
ENGINE = InnoDB
AUTO_INCREMENT = 501
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigvideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigvideo` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `initials` VARCHAR(4) NOT NULL,
  `dateval` DATETIME NOT NULL,
  `rig_id` INT(3) UNSIGNED NOT NULL,
  `comments` VARCHAR(1000) NOT NULL,
  `video` TINYINT(3) UNSIGNED NOT NULL,
  `aimed` TINYINT(3) UNSIGNED NOT NULL,
  `focused` TINYINT(3) UNSIGNED NOT NULL,
  `lid` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1016
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`rigwater`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`rigwater` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ratname` VARCHAR(4) NOT NULL,
  `dateval` DATE NOT NULL,
  `totalvol` DECIMAL(10,5) NOT NULL,
  `trialvol` DECIMAL(10,5) NOT NULL,
  `complete` TINYINT(3) UNSIGNED NOT NULL,
  `n_rewarded_trials` INT(5) UNSIGNED NOT NULL,
  `target_percent` DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 217241
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`sched_rescue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`sched_rescue` (
  `timeslot` INT(11) NOT NULL DEFAULT '0',
  `rig` INT(11) NOT NULL DEFAULT '0',
  `start_time` TIME NULL DEFAULT NULL,
  `ratname` VARCHAR(30) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `experimenter` VARCHAR(30) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `protocol` VARCHAR(50) CHARACTER SET 'utf8' NULL DEFAULT ' ' COMMENT 'The name of the protocol the rat will run on, e.g. Multipokes3, duration_disc, ProAnti2, ...',
  `system` INT(11) NULL DEFAULT '1' COMMENT 'The base ExperPort system that the protocol runs on - 1 for RPBox, 2 for Dispatcher/RunRats.',
  `instructions` VARCHAR(250) CHARACTER SET 'utf8' NULL DEFAULT NULL COMMENT 'Special instructions for the technicians',
  `comments` VARCHAR(250) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `technician` VARCHAR(30) CHARACTER SET 'utf8' NULL DEFAULT ' ',
  `schedentryid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `date` DATE NOT NULL,
  `wascompleted` TINYINT(1) NOT NULL DEFAULT '0',
  `wasqueried` TINYINT(1) NOT NULL DEFAULT '0',
  `wasstarted` TINYINT(1) NOT NULL DEFAULT '0',
  `wasvideosaved` TINYINT(1) NOT NULL DEFAULT '0',
  `Trials_Issue` VARCHAR(2) CHARACTER SET 'utf8' NOT NULL,
  `Bias_Issue` VARCHAR(2) CHARACTER SET 'utf8' NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`schedule` (
  `timeslot` INT(11) NOT NULL DEFAULT '0',
  `rig` INT(11) NOT NULL DEFAULT '0',
  `start_time` TIME NULL DEFAULT NULL,
  `ratname` VARCHAR(30) NULL DEFAULT NULL,
  `experimenter` VARCHAR(30) NULL DEFAULT NULL,
  `protocol` VARCHAR(50) NULL DEFAULT ' ' COMMENT 'The name of the protocol the rat will run on, e.g. Multipokes3, duration_disc, ProAnti2, ...',
  `system` INT(11) NULL DEFAULT '1' COMMENT 'The base ExperPort system that the protocol runs on - 1 for RPBox, 2 for Dispatcher/RunRats.',
  `instructions` VARCHAR(250) NULL DEFAULT NULL COMMENT 'Special instructions for the technicians',
  `comments` VARCHAR(250) NULL DEFAULT NULL,
  `technician` VARCHAR(30) NULL DEFAULT ' ',
  `schedentryid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `wascompleted` TINYINT(1) NOT NULL DEFAULT '0',
  `wasqueried` TINYINT(1) NOT NULL DEFAULT '0',
  `wasstarted` TINYINT(1) NOT NULL DEFAULT '0',
  `wasvideosaved` TINYINT(1) NOT NULL DEFAULT '0',
  `Trials_Issue` VARCHAR(2) NOT NULL,
  `Bias_Issue` VARCHAR(2) NOT NULL,
  PRIMARY KEY USING BTREE (`schedentryid`),
  UNIQUE INDEX `slot` (`rig` ASC, `timeslot` ASC, `date` ASC),
  INDEX `dateidx` (`date` ASC),
  INDEX `ratidx` (`ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1088994
DEFAULT CHARACTER SET = utf8
COMMENT = 'Rat Training Schedule';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`stim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`stim` (
  `ratname` CHAR(4) NOT NULL DEFAULT '',
  `stim_line` TINYINT(2) UNSIGNED NOT NULL,
  `stim_label` VARCHAR(30) NOT NULL DEFAULT '',
  `stimid` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`stimid`),
  UNIQUE INDEX `rat_line` (`stim_line` ASC, `ratname` ASC),
  INDEX `ratidx` (`ratname` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`surgery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`surgery` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ratname` CHAR(4) NOT NULL,
  `surgeon` VARCHAR(40) NULL DEFAULT NULL,
  `ratgrams` INT(11) NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  `starttime` TIME NOT NULL,
  `endtime` TIME NOT NULL,
  `type` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Electrode, cannula, lesion',
  `eib_num` VARCHAR(20) NULL DEFAULT NULL,
  `coordinates` VARCHAR(40) NULL DEFAULT NULL,
  `brainregions` VARCHAR(40) NOT NULL,
  `ketamine` FLOAT NULL DEFAULT NULL COMMENT 'how many CC\'s of ketamine used',
  `buprenex` FLOAT NULL DEFAULT NULL COMMENT 'how many CC\'s of buprenex used',
  `notes` TEXT NULL DEFAULT NULL,
  `Bregma` VARCHAR(20) NULL DEFAULT NULL COMMENT 'AP, ML, DV',
  `IA0` VARCHAR(20) NULL DEFAULT NULL COMMENT 'AP, ML, DV',
  `angle` FLOAT NULL DEFAULT '0',
  `tilt_axis` ENUM('AP', 'ML') NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 273
DEFAULT CHARACTER SET = utf8
COMMENT = 'Surgery Logs';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`tech_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`tech_schedule` (
  `date` DATE NOT NULL,
  `day` VARCHAR(45) NOT NULL,
  `overnight` VARCHAR(200) NOT NULL,
  `scheduleid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `morning` VARCHAR(200) NOT NULL,
  `evening` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`scheduleid`))
ENGINE = InnoDB
AUTO_INCREMENT = 1731315
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`technotes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`technotes` (
  `technoteid` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `datestr` DATE NULL DEFAULT NULL,
  `timestr` TIME NULL DEFAULT NULL,
  `ratname` CHAR(6) NULL DEFAULT NULL,
  `rigid` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `timeslot` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  `experimenter` VARCHAR(30) NULL DEFAULT NULL,
  `techinitials` CHAR(4) NULL DEFAULT NULL,
  `note` TEXT NOT NULL,
  `flag` INT(3) NULL DEFAULT NULL,
  PRIMARY KEY (`technoteid`),
  INDEX `ratidx` (`ratname` ASC),
  INDEX `dateidx` (`datestr` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 36754
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`training_room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`training_room` (
  `tower` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `top` CHAR(50) NULL DEFAULT NULL,
  `middle` CHAR(50) NULL DEFAULT NULL,
  `bottom` CHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`tower`))
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`turn_down_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`turn_down_log` (
  `sessid` INT(11) NULL DEFAULT '0',
  `ratname` VARCHAR(5) NULL DEFAULT NULL,
  `eibid` INT(11) NULL DEFAULT NULL,
  `turn_date` DATE NULL DEFAULT NULL,
  `turn_time` TIME NULL DEFAULT NULL,
  `turn` FLOAT NULL DEFAULT NULL,
  `turned_to` FLOAT NULL DEFAULT NULL COMMENT 'this should be a number on a clock.  like 12.5 is 12:30',
  `experimenter` VARCHAR(50) NULL DEFAULT NULL,
  `turned_by` VARCHAR(50) NULL DEFAULT NULL,
  `notes` VARCHAR(300) NULL DEFAULT NULL,
  `depth` FLOAT NULL DEFAULT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY USING BTREE (`id`),
  INDEX `sessidx` (`sessid` ASC),
  INDEX `ratidx` (`ratname` ASC),
  INDEX `dateidx` (`turn_date` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 2018
DEFAULT CHARACTER SET = utf8
COMMENT = 'A log of when we turn down the electrodes';


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`video_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`video_log` (
  `sessid` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vid_server` CHAR(15) NULL DEFAULT '',
  `problem` CHAR(30) NOT NULL DEFAULT '',
  `rigid` TINYINT(3) UNSIGNED NOT NULL,
  `ratname` CHAR(4) NOT NULL DEFAULT '',
  `sessiondate` DATE NOT NULL,
  `comment` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`sessid`))
ENGINE = InnoDB
AUTO_INCREMENT = 381706
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`videoinfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`videoinfo` (
  `rigid` INT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `video_server` CHAR(7) NOT NULL DEFAULT '',
  `video_server_id` TINYINT(3) UNSIGNED NOT NULL,
  `video_server_port` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`rigid`))
ENGINE = InnoDB
AUTO_INCREMENT = 35
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `alvaros_ratinfo`.`water`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `alvaros_ratinfo`.`water` (
  `date` DATE NOT NULL,
  `rat` VARCHAR(4) NOT NULL,
  `tech` VARCHAR(4) NULL DEFAULT NULL,
  `starttime` TIME NULL DEFAULT NULL,
  `stoptime` TIME NULL DEFAULT NULL,
  `watering` INT(11) NOT NULL AUTO_INCREMENT,
  `volume` DECIMAL(6,3) NOT NULL,
  `percent_bodymass` DECIMAL(6,3) NOT NULL,
  `percent_target` DECIMAL(6,3) NOT NULL,
  PRIMARY KEY (`watering`))
ENGINE = InnoDB
AUTO_INCREMENT = 1073006
DEFAULT CHARACTER SET = utf8
COMMENT = 'Watering Records';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
