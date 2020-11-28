import datajoint as dj
from bl_pipeline import lab


schema = dj.schema('bl_new_subject')


@schema
class Rats(dj.Manual):
    definition = """
    ratname                     : varchar(8)      # Unique rat name, 1 letter 3 numbers
    -----
    -> lab.Contacts
    rats_old_id                 : int(10)         # was a unique number assigned to each rat
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
        """


@schema
class RatHistory(dj.Manual):
    definition = """
    -> Rats
    logtime=CURRENT_TIMESTAMP   : timestamp       # IF THIS IS A HISTORICAL RECORD OF THE RATS TABLE THEN IT SHOULD HAVE ALL THE SAME COLUMNS
    -----
    -> lab.Contacts
    rathistory_old_id           : int(10)
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
        """
