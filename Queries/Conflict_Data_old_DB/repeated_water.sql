
--Issue:
--Repeated water (all of them have 0 volume)
--Assuming these were "not valid" water administration writting of these data must be prevented because:

--We want to use rat, date, starttime as primarykey
--rat, date, & starttime define uniquely non zero water administration

select

rat,
date,
starttime,
stoptime,
count(rat) as num_water,
sum(volume) as volume_sum,
avg(volume) as volume_mean,
std(volume) as volume_std

from ratinfo.water

where date > '2020-01-01'

group by rat, date, starttime, stoptime
having num_water > 1
order by num_water desc;