create database tech_layoffs;
use tech_layoffs;

select * from layoffs;

describe layoffs;
/* ID, Company, Location_HQ, Country, Continent, Laid_Off, Date_layoffs, Percentage, 
Company_Size_before_Layoffs, Company_Size_after_layoffs, Industry, 
Stage, Money_Raised_in_$_mil, Year, lat, lng*/

-- FEW MODIFICATIONS BEFORE DATA QUERIES
alter table layoffs
modify Date_layoffs date;

update layoffs
set Date_layoffs = date_format(Date_layoffs, '%Y-%m-%d');

alter table layoffs
add primary key (ID);

alter table layoffs
rename column `Index` to ID;

-- Find the companies with least layoffs
select Company, Percentage, Location_HQ
from layoffs
where Percentage < 100
order by Percentage asc;

-- companies which shut down i.e. 100% layoff
select Company
from layoffs
where Percentage = 100
order by 1;

-- Layoffs by year
select `Year`, sum(Laid_Off) total_layoffs
from layoffs
group by `Year`
order by `Year` desc;

-- find layoffs total for each industry each year (from 2020 - 2023)
select `Year`, Industry, sum(Laid_Off) as total_layoffs
from layoffs
where `Year` <> 2024 and Industry <> "Other"
group by `Year`, Industry
order by `Year` desc, total_layoffs desc;

-- display industries with highest number of layoffs for each year before 2024
with layoff_cte as 
	(select `Year`, Industry, sum(Laid_Off) total_layoffs, 
    row_number() over(partition by `Year`order by sum(Laid_Off) desc) as RowNum
	from layoffs
	where Industry <> "Other" and `Year` <> 2024
	group by  `Year`, Industry
	)
select `Year`, Industry, total_layoffs
from layoff_cte
where RowNum = 1
order by `Year` desc , total_layoffs desc;

-- add a new column where if company's whole staff is laid off - "Company_WindUp"
alter table layoffs
add column Company_WindUp varchar(5);

update layoffs
set Company_WindUp = "Yes"
where Percentage = 100;
/* 48 companies laif off 100% staff*/

-- what is the total number of layoffs in each country and location
select Country, Location_HQ, sum(Laid_Off) Total_LaidOff
from layoffs
group by Country, Location_HQ
order by Total_LaidOff desc;

-- layoffs based on the stage of companies
select Stage, count(*) as Total_Layoffs, Avg(Percentage)
from layoffs
group by Stage
order by Total_Layoffs desc;

-- Companies data which has less than 5% layoffs and employees before layoff was over 1000
select *
from layoffs
where Percentage < 5 and Company_Size_after_layoffs > 1000
order by Percentage, Company;