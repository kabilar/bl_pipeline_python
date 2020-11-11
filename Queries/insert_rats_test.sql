INSERT INTO bl_subject.rats 

(
select

ratname,
'aacarter',
internalID,
free,
'aacarter',
comments,
vendor,
waterperday,
recovering,
deliverydate,
extant,
cagemate,
forceFreeWater,
dateSac,
forceDepWater,
larid,
israt

from bl_ratinfo.rats 

limit 1
)