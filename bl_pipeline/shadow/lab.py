import datajoint as dj


ratinfo = dj.create_virtual_module('ratinfo', 'bl_ratinfo')

# create shadow schemas
schema = dj.schema('bl_shadow_lab')


# %%
# copy data from source tables to shadow tables
@schema
class Contacts(dj.Computed):
    definition = """
    -> ratinfo.Contacts.proj(contacts_old_id='contactid')
    -----
    user_id             : varchar(32)       # PNI netID or similar
    experimenter        : varchar(32)       # first name (must be unique so may need to add last initial)
    email=null          : varchar(150)      # princeton email address
    initials=null       : varchar(5)        # 2 letter initials
    telephone=null      : bigint(20)        # cell phone digits only
    tag_letter=null     : varchar(1)        # first letter of rat's name
    lab_manager=0       : tinyint(1)        # 1 if you're lab manager
    subscribe_all=0     : tinyint(1)        # 1 is you want to get all automated emails
    tech_morning=0      : tinyint(1)        # 1 if you're a B shift tech
    tech_afternoon=0    : tinyint(1)        # 1 if you're a C shift tech
    tech_computer=0     : tinyint(1)        # 1 if you're the computer tech
    is_alumni=0         : tinyint(1)        # 1 if you're an alumni of the lab
    full_name=null      : varchar(60)       # You're full name however you like it
    tech_overnight=0    : tinyint(1)        # 1 if you're the A shift tech
    tag_rgb=null        : char(12)          # 3 integers 0 to 255 determines the color of your cage cards
    tech_shifts         : varchar(45)       # shifts a tech is scheduled to work, rigs an experimenter is responsible for fixing
    phone_carrier=null  : varchar(15)       # cell phone network provider, necessary to send text messages
    """

    def make(self, key):
        key_shadow = dict(contactid=key['contacts_old_id'])
        data_contactid, data_experimenter,data_email,data_initials,data_telephone,data_tag_letter,data_lab_manager,data_subscribe_all,data_tech_morning,data_tech_afternoon,data_tech_computer,data_is_alumni,data_FullName,data_tech_overnight,data_tag_RGB,data_tech_shifts,data_phone_carrier = (ratinfo.Contacts & key_shadow).fetch1('contactid','experimenter','email', 'initials','telephone','tag_letter','lab_manager','subscribe_all','tech_morning','tech_afternoon','tech_computer','is_alumni','FullName','tech_overnight','tag_RGB','tech_shifts','phone_carrier')

        if key['contacts_old_id'] not in [53, 59, 97]:  # duplicate emails for contactid = 59 and 94; 53 and 71; 12 and 97
            entry = dict(
                user_id             = data_email.split('@')[0],
                contacts_old_id     = data_contactid,
                experimenter        = data_experimenter,
                email               = data_email,
                initials            = data_initials,
                telephone           = data_telephone,
                tag_letter          = data_tag_letter,
                lab_manager         = data_lab_manager,
                subscribe_all       = data_subscribe_all,
                tech_morning        = data_tech_morning,
                tech_afternoon      = data_tech_afternoon,
                tech_computer       = data_tech_computer,
                is_alumni           = data_is_alumni,
                full_name           = data_FullName,
                tech_overnight      = data_tech_overnight,
                tag_rgb             = data_tag_RGB,
                tech_shifts         = data_tech_shifts,
                phone_carrier       = data_phone_carrier
            )
            self.insert1(entry)


@schema
class Riginfo(dj.Computed):
    definition = """
    -> ratinfo.Riginfo
    -----
    rigname               : varchar(32)      # THIS CURRENTLY DOES NOT EXIST
    ip_addr=''            : char(15)         # IP address of the rig
    mac_addr=''           : char(12)         # MAC address of the rig
    rtfsm_ip=null         : char(15)         # The Linux machine this rig connects to
    hostname=null         : varchar(50)      # URL for the rig as registered with OIT, i.e. brodyrigwt06.princeton.edu
    comptype=''           : char(50)         # Processor and Operating System info
    """

    def make(self, key):
        data = (ratinfo.Riginfo & key).fetch1()

        entry = dict(
            rigid     = data['rigid'],
            rigname   = '',
            ip_addr   = data['ip_addr'],
            mac_addr  = data['mac_addr'],
            rtfsm_ip  = data['rtfsm_ip'],
            hostname  = data['hostname'],
            comptype  = data['comptype']
        )
        self.insert1(entry)


@schema
class Rigflush(dj.Computed):
    definition = """
    -> ratinfo.Rigflush.proj(rigflush_old_id='id')
    -----
    rigid                      : int(3)           # Unique rig integer number
    rigflush_date              : datetime
    wasflushed                 : tinyint(3)
    """

    def make(self, key):
        key_shadow = dict(id=key['rigflush_old_id'])
        data = (ratinfo.Rigflush & key_shadow).fetch1()

        entry = dict(
            rigid               = data['rig'],
            rigflush_date       = data['dateval'],
            rigflush_old_id     = data['id'],
            wasflushed          = data['wasflushed']
        )
        self.insert1(entry)


@schema
class Rigfood(dj.Computed):
    definition = """
    -> ratinfo.Rigfood.proj(rigfood_id='rigfoodid')
    -----
    rigid                      : int(3)
    rigfood_datetime           : datetime
    """

    def make(self, key):
        key_shadow = dict(rigfoodid=key['rigfood_id'])
        data = (ratinfo.Rigfood & key_shadow).fetch1()

        entry = dict(
            rigfood_id          = data['rigfoodid'],
            rigid               = data['rigid'],
            rigfood_datetime    = data['datetime']
        )
        self.insert1(entry)


@schema
class RigMaintenance(dj.Computed):
    definition = """
    -> ratinfo.RigMaintenance.proj(rig_maintenance_id='maintenance_id')
    -----
    rigid                      : int(3)
    rig_fix_date=null          : datetime         # date and time the rig was fixed
    rig_maintenance_note       : varchar(500)     # description of what is wrong with a rig
    isbroken                   : tinyint(3)       # 1 if the rig is still broken
    broke_person               : varchar(45)      # lab member that flagged the rig as broken
    fix_person                 : varchar(45)      # lab member that fixed the rig
    broke_date=null            : datetime         # date and time when the rig was flagged as broken
    rig_maintenance_fix_note   : varchar(500)     # description of what was done to fix the rig
    """

    def make(self, key):
        key_shadow = dict(maintenance_id=key['rig_maintenance_id'])
        data = (ratinfo.RigMaintenance & key_shadow).fetch1()

        entry = dict(
            rig_maintenance_id       = data['maintenance_id'],
            rigid                    = data['rigid'],
            rig_maintenance_note     = data['note'],
            isbroken                 = data['isbroken'],
            broke_person             = data['broke_person'],
            fix_person               = data['fix_person'],
            rig_maintenance_fix_note = data['fix_note']
        )

        if data['fix_date'] != '0000-00-00 00:00:00':
            entry.update(rig_fix_date=data['fix_date'])
        if data['broke_date'] != '0000-00-00 00:00:00':
            entry.update(broke_date=data['broke_date'])

        self.insert1(entry)


@schema
class TrainingRoom(dj.Computed):
    definition = """
    -> ratinfo.TrainingRoom
    -----
    top=null                   : char(50)         # top    rig in tower: ratname, trial count, percent correct, training duration
    middle=null                : char(50)         # middle rig in tower: ratname, trial count, percent correct, training duration
    bottom=null                : char(50)         # bottom rig in tower: ratname, trial count, percent correct, training duration
    """

    def make(self, key):
        data = (ratinfo.TrainingRoom & key).fetch1()

        entry = dict(
            tower     = data['tower'],
            top       = data['top'],
            middle    = data['middle'],
            bottom    = data['bottom']
        )
        self.insert1(entry)
