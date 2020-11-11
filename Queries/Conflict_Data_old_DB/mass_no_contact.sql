

--Issue:
--Check also how many weightings and water missing contact
-- contact needed because is foreign key


select

tech_mass.techinitials,
cont_tech.initials,
cont_tech.experimenter as contact_experimenter,
tech_mass.num_weights

from

(select

upper(tech) as techinitials,
count(weighing) as num_weights

from ratinfo.mass

group by techinitials) tech_mass

left join ratinfo.contacts as cont_tech
on tech_mass.techinitials = cont_tech.initials
where cont_tech.initials is null

order by num_weights desc
;