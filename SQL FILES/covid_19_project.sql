create  database covid_19
use Covid_19

select * from district_tablet
select * from State_table
select * from time_series

select state,total_tested,(total_vaccinated1+total_vaccinated2) as total_vaccinated from State_table

--Weekly evolution of number of confirmed cases, recovered cases, deaths, tests.
--For instance, your dashboard should be able to compare Week 3 of May with Week 2 of August 

select 
state,Year,Month_name,Month_number,Week_number,
sum(total_confirmed) as confirmed,SUM(total_deceased) as deceased,Sum(total_recovered) as recovered,
Sum(total_tested) as tested,SUM(total_vaccinated)  as vaccinated
from 
(
select 
state, total_confirmed, total_recovered, total_deceased, total_tested, 
(total_vaccinated1+total_vaccinated2) as total_vaccinated,
Month(Date) as Month_number,date,
DATENAME(Month,date) as Month_name,Year(date) as year,
(datediff(day, dateadd(month, datediff(month, 0, date), 0), date) / 7 + 1) as Week_number
from time_series
) as table1

group by Week_number,state,Month_number,Month_name,year
order by Month_number,Week_number

--- Let’s call `testing ratio(tr) = (number of tests done) / (population)`, 
--now categorise every district in one of the following categories:
--- Category A: 0.05 ≤ tr ≤ 0.1
--- Category B: 0.1 < tr ≤ 0.3
--- Category C: 0.3 < tr ≤ 0.5
--- Category D: 0.5 < tr ≤ 0.75
--- Category E: 0.75 < tr ≤ 1.0
--Now perform an analysis of number of deaths across all category.
--Example, what was the number / % of deaths in Category A district as compared for Category E districts



with cte as 
(
select state, District,total_confirmed, total_deceased, total_recovered,total_tested,
(total_vaccinated1+total_vaccinated2) as total_vaccinated,meta_population
from district_tablet
where meta_population != 0 and total_tested != 0
),
cte1 as
(
select *, (cast(total_tested as decimal(10,2))/ cast(meta_population as decimal(10,2))) as Testing_ratio 
from cte
) 
select *, case when Testing_ratio Between 0.05 and 0.1 Then 'Category A'
			   when Testing_ratio Between 0.1 and 0.3 then 'category B'
			   when Testing_ratio Between 0.3 and 0.5 then 'category C'
			   when Testing_ratio Between 0.5 and 0.75 then 'category D'
			   when Testing_ratio Between 0.75 and 1.0 then 'category E' END as Category
from cte1



--------------------------------------------------------------------------------------------------------

--Compare delta7 confirmed cases with respect to vaccination


select
state,sum(delta7_confirmed) as delta7_confirmed,
sum( (cast(delta7_vaccinated1 as bigint) + delta7_vaccinated2) ) as  delta7_vaccinated
from time_series
group by state




--INSIGHT 1
select state,DATENAME(month,date) as Date,YEAR(date) as year,SUM(total_recovered) as '1st_vaccination',SUM(total_vaccinated2) as '2nd_vaccination' 
from time_series
group by state,DATENAME(month,date),YEAR(date) ;


--INSIGHT 2
select state,DATENAME(month,date) as Date,YEAR(date) as year,SUM(total_recovered) as 'Recovery_rate' 
from time_series
group by state,DATENAME(month,date),YEAR(date) ;


select state,SUM(total_recovered) as 'total_recovered',sum(total_confirmed) as 'total_confirmed'
from district_tablet
group by state

select * from district_tablet

select state,DateName(month, date) as month_name,DATEPART(month,date) as month_num,SUM(total_confirmed) as no_of_cases
from time_series
group by DATEName(month, date),state,DATEPART(month,date)
order by month_num,no_of_cases desc;




























































































































