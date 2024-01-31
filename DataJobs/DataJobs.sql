use datascience_jobs;
show tables;

describe data_jobs;
/* work_year  job_title  job_category  salary_currency  salary
salary_in_usd  employee_residence  experience_level  employement_type  
work_setting  company_location  company_size*/

select * from data_jobs;

-- What are the various Job Categories and their count
select job_category, count(job_category) as JobCount
from data_jobs
group by job_category
order by JobCount desc;

-- Average salary by job Categories in desc order
select job_category, concat(round(avg(salary)/1000,2), " K") as avg_salary_in_thousands
from data_jobs
group by job_category
order by avg_salary_in_thousands;

-- Prepare salary histogram to show ranges and respective counts
with salary_ranges as (
	select *, case when salary_in_usd<50000 then '0-50000'
		when salary_in_usd>50000 and salary_in_usd<=100000 then '50001-100000'
		when salary_in_usd>100000 and salary_in_usd<=200000 then '100001-200000'
		when salary_in_usd>200000 and salary_in_usd<=300000 then '200001-300000'
        else '300000+' end as SalaryRange
	from data_jobs)

select SalaryRange, count(SalaryRange) as HeadCount
from salary_ranges
group by SalaryRange
order by SalaryRange;

-- Distribution of salary ranges among different company sizes
with salary_ranges as (
	select *, case when salary_in_usd<50000 then '0-50000'
		when salary_in_usd>50000 and salary_in_usd<=100000 then '50001-100000'
		when salary_in_usd>100000 and salary_in_usd<=200000 then '100001-200000'
		when salary_in_usd>200000 and salary_in_usd<=300000 then '200001-300000'
        else '300000+' end as SalaryRange
	from data_jobs)
select company_size, 
		sum(case when SalaryRange = '0-50000' then 1 else 0 end) as '0-50000',
        sum(case when SalaryRange = '50001-100000' then 1 else 0 end) as '50001-100000',
        sum(case when SalaryRange = '100001-200000' then 1 else 0 end) as '100001-200000',
        sum(case when SalaryRange = '200001-300000' then 1 else 0 end) as '200001-300000',
        sum(case when SalaryRange = '300000+' then 1 else 0 end) as '300000+'
from salary_ranges
group by company_size;

-- in wahat work setting employees are paid the most
select work_setting, round(avg(salary_in_usd),2) as AvgSalary
from data_jobs
group by work_setting
order by AvgSalary desc;

-- avg salary for each experience level for the - work setting with max avg salary i.e. In-person
select experience_level, round(avg(salary_in_usd),2) as AvgSalary
from data_jobs
where work_setting = 'In-person'
group by experience_level
order by AvgSalary desc;

-- Companies situated in which country provide higher than avg salary
select company_location, min(salary_in_usd) as MinSalary,
		round(avg(salary_in_usd),2) AvgSalary,
		max(salary_in_usd) as MaxSalary
from data_jobs
where salary_in_usd > (select avg(salary_in_usd) from data_jobs)
group by company_location
order by AvgSalary;

-- Find distinct years
select distinct work_year
from data_jobs
order by work_year asc;

-- Find if avg salary has gone up over the years
select work_year, round(avg(salary_in_usd),2) as AvgSalary
from data_jobs
group by work_year
order by AvgSalary;

-- Find the avg salary for each job category over the years
select job_category, 
		round(avg(case when work_year = '2020' then salary_in_usd else 0 end),2) as 'AvgSalary_2020',
		round(avg(case when work_year = '2021' then salary_in_usd else 0 end),2) as 'AvgSalary_2021',
		round(avg(case when work_year = '2022' then salary_in_usd else 0 end),2) as 'AvgSalary_2022',
		round(avg(case when work_year = '2023' then salary_in_usd else 0 end),2) as 'AvgSalary_2023',
        round(avg(salary_in_usd),2) as Overall_AvgSalary
from data_jobs
group by job_category
order by Overall_AvgSalary desc;

-- Calculate what percent of the total avg salary for each job title
select job_title, 
		round(avg(salary_in_usd),2) as AvgSalary,
        concat(round(avg(salary_in_usd) / (select avg(salary_in_usd)
										from data_jobs) * 100, 2), " %") as pct_salary
from data_jobs
group by job_title
order by AvgSalary desc;