import datajoint as dj


schema = dj.schema('bl_new_lab')


@schema
class Contacts(dj.Manual):
    definition = """
    user_id                    : varchar(32)      # PNI netID or similar
    -----
    contacts_old_id            : int(11)
    experimenter               : varchar(32)      # first name (must be unique so may need to add last initial)
    email=null                 : varchar(150)     # princeton email address
    initials=null              : varchar(5)       # 2 letter initials
    telephone=null             : bigint(20)       # cell phone digits only
    tag_letter=null            : varchar(1)       # first letter of rat's name
    lab_manager=0              : tinyint(1)       # 1 if you're lab manager
    subscribe_all=0            : tinyint(1)       # 1 is you want to get all automated emails
    tech_morning=0             : tinyint(1)       # 1 if you're a B shift tech
    tech_afternoon=0           : tinyint(1)       # 1 if you're a C shift tech
    tech_computer=0            : tinyint(1)       # 1 if you're the computer tech
    is_alumni=0                : tinyint(1)       # 1 if you're an alumni of the lab
    full_name=null             : varchar(60)      # You're full name however you like it
    tech_overnight=0           : tinyint(1)       # 1 if you're the A shift tech
    tag_rgb=null               : char(12)         # 3 integers 0 to 255 determines the color of your cage cards
    tech_shifts                : varchar(45)      # shifts a tech is scheduled to work, rigs an experimenter is responsible for fixing
    phone_carrier=null         : varchar(15)      # cell phone network provider, necessary to send text messages
    """


@schema
class Riginfo(dj.Manual):
    definition = """
    rigid                      : int(3)           # Unique rig integer number
    -----
    rigname                    : varchar(32)      # THIS CURRENTLY DOES NOT EXIST
    ip_addr=''                 : char(15)         # IP address of the rig
    mac_addr=''                : char(12)         # MAC address of the rig
    rtfsm_ip=null              : char(15)         # The Linux machine this rig connects to
    hostname=null              : varchar(50)      # URL for the rig as registered with OIT, i.e. brodyrigwt06.princeton.edu
    comptype=''                : char(50)         # Processor and Operating System info
    """


@schema
class Rigflush(dj.Manual):
    definition = """
    -> Riginfo
    rigflush_date              : datetime
    -----
    rigflush_old_id            : int(10)
    wasflushed                 : tinyint(3)
    """


@schema
class Rigfood(dj.Manual):
    definition = """
    rigfood_id                 : int(10)
    -----
    -> Riginfo
    rigfood_datetime           : datetime
    """


@schema
class RigMaintenance(dj.Manual):
    definition = """
    rig_maintenance_id         : int(10)
    -----
    -> Riginfo
    rig_fix_date               : datetime         # date and time the rig was fixed
    rig_maintenance_note       : varchar(500)     # description of what is wrong with a rig
    isbroken                   : tinyint(3)       # 1 if the rig is still broken
    broke_person               : varchar(45)      # lab member that flagged the rig as broken
    fix_person                 : varchar(45)      # lab member that fixed the rig
    broke_date                 : datetime         # date and time when the rig was flagged as broken
    rig_maintenance_fix_note   : varchar(500)     # description of what was done to fix the rig
    """


@schema
class TrainingRoom(dj.Manual):
    definition = """
    tower                      : int(10)          # unique ID, the tower the rig belongs to
    -----
    top=null                   : char(50)         # top    rig in tower: ratname, trial count, percent correct, training duration
    middle=null                : char(50)         # middle rig in tower: ratname, trial count, percent correct, training duration
    bottom=null                : char(50)         # bottom rig in tower: ratname, trial count, percent correct, training duration
    """
