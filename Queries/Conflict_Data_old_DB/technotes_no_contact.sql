




--Issue:
--We want contact.experimenter to serve 
--as foreign key to technotes table, so all technotes should be own by experimenter in contact table



select

tech_notes.techinitials,
cont_tech.initials,
cont_tech.experimenter as contact_experimenter,
tech_notes.experimenter as tech_experimenter,
tech_notes.num_notes

from

(select
upper(techinitials) as techinitials,
experimenter,
count(technoteid) as num_notes

from ratinfo.technotes

group by techinitials) tech_notes

left join ratinfo.contacts as cont_tech
on tech_notes.techinitials = cont_tech.initials

where cont_tech.initials is null
order by num_notes desc