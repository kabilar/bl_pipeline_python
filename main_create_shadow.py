# Ingestion routine to copy data from source tables to new tables
# source table -> shadow table -> new table
# Shadow table allows for renaming of primary key
# Shadow table has same definition of the new table, except that the primary key is the same as the source table
# For each shadow table set the keys as a secondary field when not used as primary key

# %%
import datajoint as dj
import datetime

# connect to princeton server
print(dj.conn())

# list schemas on princeton server
print(dj.list_schemas())

# load source schema
ratinfo = dj.create_virtual_module('ratinfo', 'bl_ratinfo')

# create shadow schemas
lab_shadow = dj.schema('bl_shadow_lab')
subject_shadow = dj.schema('bl_shadow_subject')

# %%
# copy data from source tables to shadow tables
@lab_shadow
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

@lab_shadow
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

@lab_shadow
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

@lab_shadow
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

@lab_shadow
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

@lab_shadow
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

@subject_shadow
class Rats(dj.Computed):
     definition = """
     -> ratinfo.Rats.proj(rats_old_id='internalID')
     -----
     ratname                     : varchar(8)      # Unique rat name, 1 letter 3 numbers
     user_id                     : varchar(32)     # PNI netID or similar
     free=0                      : tinyint(1)      # whether or not the rat is available for use by any other experimenter
     comments=null               : varchar(500)    # any notes about the animal, surgery info, transgenic strain...
     vendor='Taconic'            : varchar(40)     # e.g. Taconic, Charles River, etc.
     waterperday=30              : decimal(3,1)    # WHERE IT IS THE PERCENT BODY MASS THE RAT WILL BE OFFERED IN THE PUB, VALUES < 3.0 ARE NOT ALLOWED BY PROTOCOL, 100 INTERPRETED AS TO BE EXCLUDED FROM THE PUB AND RECEIVE WATER IN HOME CAGE
     recovering=0                : tinyint(1)      # whether or not the rat is currently in recovery from surgery or illness
     deliverydate=null           : date            # date rat arrived at lab
     extant=0                    : tinyint(4)      # 1 if the rat is still alive
     cagemate=null               : varchar(4)      # the name of the rat this rat lives with SHOULD BE ENLARGED TO ALLOW FOR MICE THAT HAVE MORE THAN 1 CAGEMATE
     force_free_water=0          : tinyint(3)      # not used
     date_sac=null               : date            # date the rat was euthanized or died
     force_dep_water=0           : tinyint(3)      # training session during which a rat should receive water, for restricting rats not on the training schedule
     larid=null                  : int(10)         # the ID assigned to the rat by LAR (I don't think we use this)
     israt=1                     : tinyint(1)      # 1 if rat, 0 if mouse
     """

     class Contact(dj.Part):
          definition = """
          -> master
          contact                : varchar(40)     # PUIDs of the lab member(s) responsible for the rat
          ----
          ratname                : varchar(8)      # Unique rat name, 1 letter 3 numbers
          """

     def make(self, key):
          key_shadow = dict(internalID=key['rats_old_id'])
          data = (ratinfo.Rats & key_shadow).fetch1()

          entry = dict(
               ratname             = data['ratname'],
               user_id             = data['experimenter'],#change to emailid
               rats_old_id         = data['internalID'],
               free                = data['free'],
               comments            = data['comments'],
               vendor              = data['vendor'],
               waterperday         = data['waterperday'],
               recovering          = data['recovering'],
               extant              = data['extant'],
               cagemate            = data['cagemate'],
               force_free_water    = data['forceFreeWater'],
               force_dep_water     = data['forceDepWater'],
               larid               = data['larid'],
               israt               = data['israt']
          )
          if data['dateSac'] != '0000-00-00':
               entry.update(date_sac=data['dateSac'])
          if data['deliverydate'] != '0000-00-00':
               entry.update(deliverydate=data['deliverydate'])

          self.insert1(entry)

          if data['contact'] is not None:
               if (not data['contact'].isspace()) and (data['contact'] != ''):
                    contacts = data['contact'].split(',')
                    for contact in contacts:
                         self.Contact.insert1(dict(key,ratname = data['ratname'],contact = contact.strip()))

@subject_shadow
class RatHistory(dj.Computed):
     definition = """
     -> ratinfo.RatHistory.proj(rathistory_old_id='internalID')
     -----
     ratname                     : varchar(8)      # Unique rat name, 1 letter 3 numbers
     logtime=CURRENT_TIMESTAMP   : timestamp       # IF THIS IS A HISTORICAL RECORD OF THE RATS TABLE THEN IT SHOULD HAVE ALL THE SAME COLUMNS
     user_id                     : varchar(32)     # PNI netID or similar
     free=0                      : tinyint(1)      # 'whether or not the rat is available for use by any other experimenter',
     alert=0                     : tinyint(1)      # 'whether or not there is an alert for special attention for the rat (e.g. sick, recent surgery, etc.)',
     training=0                  : tinyint(1)   
     comments=null               : varchar(500)   
     waterperday=30              : int(11)         # '0 for free water, otherwise the number of minutes the rat has access to water each day (may vary over time)',
     recovering=0                : tinyint(1)      # 'whether or not the rat is currently in recovery from surgery',
     extant=0                    : tinyint(4)   
     cagemate=null               : varchar(4)   
     force_free_water=0          : tinyint(3) 
     date_sac=null               : date   
     force_dep_water=0           : tinyint(3) 
     bring_up_at=0               : tinyint(1)      # 'set with which rat should be brought upstairs',
     bringupday=null             : varchar(7)   
     ignored_by_watermeister=0   : tinyint(1)
     """

     class Contact(dj.Part):
          definition = """
          -> master
          contact                : varchar(40)     # PUIDs of the lab member(s) responsible for the rat
          ----
          ratname                : varchar(8)      # Unique rat name, 1 letter 3 numbers
          """

     def make(self, key):
          key_shadow = dict(internalID=key['rathistory_old_id'])
          data = (ratinfo.RatHistory & key_shadow).fetch1()

          entry = dict(
               ratname                  = data['ratname'],
               logtime                  = data['logtime'],
               user_id                  = data['experimenter'],
               rathistory_old_id        = data['internalID'],
               free                     = data['free'],
               alert                    = data['alert'], 
               training                 = data['training'], 
               comments                 = data['comments'],
               waterperday              = data['waterperday'],
               recovering               = data['recovering'],
               extant                   = data['extant'],
               cagemate                 = data['cagemate'],
               force_free_water         = data['forceFreeWater'], 
               force_dep_water          = data['forceDepWater'],
               bring_up_at              = data['bringUpAt'],
               bringupday               = data['bringupday'],
               ignored_by_watermeister  = data['ignoredByWatermeister'] 
          )
          if data['dateSac'] != '0000-00-00':
               entry.update(date_sac=data['dateSac'])

          self.insert1(entry)

          if data['contact'] is not None:
               if (not data['contact'].isspace()) and (data['contact'] != ''):
                    contacts = data['contact'].split(',')
                    for contact in contacts:
                         self.Contact.insert1(dict(key,ratname = data['ratname'],contact = contact.strip()))

#%%
# populate shadow tables

if __name__ == "__main__":
     # bl_shadow_lab schema
     Contacts.populate(display_progress=True)
     Riginfo.populate(display_progress=True)
     Rigflush.populate(display_progress=True)
     Rigfood.populate(display_progress=True)
     RigMaintenance.populate(display_progress=True)
     TrainingRoom.populate(display_progress=True)

     # bl_shadow_subject schema
     Rats.populate(display_progress=True)
     RatHistory.populate(display_progress=True)
# %%
