CREATE DEFINER=`brody-dbadmin`@`%` trigger rathistoryins before insert on rats
for each row
BEGIN
set role brody_dataowner;
insert into rat_history (  
free,
alert,
experimenter,
contact ,
ratname ,
training ,
comments ,
waterperday ,
recovering ,
extant ,
cagemate ,
forceFreeWater ,
dateSac ,
forceDepWater ,
bringUpAt ,
bringupday ,
ignoredByWatermeister ) values (
NEW.free,
NEW.alert,
NEW.experimenter,
NEW.contact,
NEW.ratname,
NEW.training,
NEW.comments,
NEW.waterperday,
NEW.recovering,
NEW.extant,
NEW.cagemate,
NEW.forceFreeWater,
NEW.dateSac,
NEW.forceDepWater,
NEW.bringUpAt,
NEW.bringupday,
NEW.ignoredByWatermeister);
END