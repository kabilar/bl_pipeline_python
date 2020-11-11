use bl_subject;

DROP TRIGGER if exists rathistory_up;

CREATE DEFINER=`alvaros`@`%` trigger rathistory_up after update on bl_subject.rats 
for each row

insert into bl_subject.rat_history ( 
ratname,
logtime,
user_id,
rathistory_old_id,
rats_old_id,
free,
contact,
comments,
vendor,
waterperday,
recovering,
deliverydate,
extant,
cagemate,
force_free_water,
date_sac,
force_dep_water,
larid,
israt) 
values (
NEW.ratname,
CURRENT_TIMESTAMP(),
NEW.user_id,
0,
NEW.rats_old_id,
NEW.free,
NEW.contact,
NEW.comments,
NEW.vendor,
NEW.waterperday,
NEW.recovering,
NEW.deliverydate,
NEW.extant,
NEW.cagemate,
NEW.force_free_water,
NEW.date_sac,
NEW.force_dep_water,
NEW.larid,
NEW.israt
);