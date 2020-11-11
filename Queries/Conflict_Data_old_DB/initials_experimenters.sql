

--Issue:
--Some tables (eg: mass, water) are associated with tech_initials.
--We want to change that to experimenter.
--We need to identify which experimenter did measurement .

select 

initials,
count(*) as num_experimenters,
GROUP_CONCAT(experimenter) as experimenters

from ratinfo.contacts

group by initials

order by num_experimenters desc, initials;