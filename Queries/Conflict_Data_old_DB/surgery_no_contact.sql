

--Issue:
--We want contact.experimenter to serve as foreign key 
--to surgery table, so all surgeries should be performed by experimenter in contact table

select

surgeon_exp.surgeon_experimenter,
cont_exp.experimenter,
surgeon_exp.surgeries

from

(select

surgeon as surgeon_experimenter,
count(ratname) as surgeries

from ratinfo.surgery

group by surgeon_experimenter) surgeon_exp

left join ratinfo.contacts as cont_exp
on surgeon_exp.surgeon_experimenter = cont_exp.experimenter
where cont_exp.experimenter is null

order by surgeon_exp.surgeries desc, surgeon_exp.surgeon_experimenter