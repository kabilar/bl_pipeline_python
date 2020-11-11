
--Issue:
--We want contact.experimenter to serve as foreign key to rats table, 
--so all rats should be own by experimenter in contact table

select

rat_exp.rat_table_experimenter,
cont_exp.experimenter,
rat_exp.rats

from

(select

experimenter as rat_table_experimenter,
count(ratname) as rats

from ratinfo.rats

group by rat_table_experimenter) rat_exp

left join ratinfo.contacts as cont_exp
on rat_exp.rat_table_experimenter = cont_exp.experimenter
where cont_exp.experimenter is null

order by rat_exp.rats desc, rat_exp.rat_table_experimenter