
--Issue:
--Check also how many weightings and water missing contact
-- contact needed because is foreign key

select

tech_water.techinitials,
cont_tech.initials,
cont_tech.experimenter as contact_experimenter,
tech_water.num_water

from

(select

upper(tech) as techinitials,
count(date) as num_water

from ratinfo.water

group by techinitials) tech_water

left join ratinfo.contacts as cont_tech
on tech_water.techinitials = cont_tech.initials
where cont_tech.initials is null

order by num_water desc
;