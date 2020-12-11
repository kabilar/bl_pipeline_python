import datajoint as dj
from bl_pipeline.shadow import lab

ratinfo = dj.create_virtual_module('ratinfo', 'bl_ratinfo')

schema = dj.schema('bl_shadow_subject')


@schema
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
        contact                 : varchar(40)     # PUIDs of the lab member(s) responsible for the rat
        ratname                 : varchar(8)      # Unique rat name, 1 letter 3 numbers
        """

    def make(self, key):
        key_shadow = dict(internalID=key['rats_old_id'])
        data = (ratinfo.Rats & key_shadow).fetch1()
        data_email = (ratinfo.Contacts & {'experimenter': data['experimenter']}).fetch1('email')
        entry = dict(
            ratname             = data['ratname'],
            user_id             = data_email.split('@')[0],
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
                    self.Contact.insert1(dict(ratname=data['ratname'],
                                              contact=contact.strip()))

    
@schema
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
        contact                 : varchar(40)     # PUIDs of the lab member(s) responsible for the rat
        ratname                 : varchar(8)      # Unique rat name, 1 letter 3 numbers
        """

    def make(self, key):
        key_shadow = dict(internalID=key['rathistory_old_id'])
        data = (ratinfo.RatHistory & key_shadow).fetch1()
        data_email = (ratinfo.Contacts & {'experimenter': data['experimenter']}).fetch1('email')

        entry = dict(
            ratname                  = data['ratname'],
            logtime                  = data['logtime'],
            user_id                  = data_email.split('@')[0],
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
                        self.Contact.insert1(dict(ratname = data['ratname'],
                                                  contact = contact.strip()))
