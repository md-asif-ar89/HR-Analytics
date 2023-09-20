
-- What is the gender breakdown of employees in the company?
select gender, count(*) as total_employees from hr_data  
where age >= 18 and term_date is null
group by gender;


-- What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as total_employees from hr_data  
where age >= 18 and term_date is null
group by race
order by total_employees desc;


-- What is the age distribution of employees in the company?
select case 
	when age between 18 and 24 then '18-24'
	when age between 25 and 34 then '25-34'
    when age between 35 and 44 then '35-44'
    when age between 45 and 54 then '45-54'
    when age between 55 and 64 then '55-64'
    else 'NA'
end as age_group,
count(*) as total_employees
from hr_data
where age >= 18 and term_date is null
group by age_group
order by age_group;


-- What is the age distribution of employees by gender in the company?
select case 
	when age between 18 and 24 then '18-24'
	when age between 25 and 34 then '25-34'
    when age between 35 and 44 then '35-44'
    when age between 45 and 54 then '45-54'
    when age between 55 and 64 then '55-64'
    else 'NA'
end as age_group, gender,
count(*) as total_employees
from hr_data
where age >= 18 and term_date is null
group by gender, age_group
order by age_group;


-- How many employees work at headquarters versus remote locations?
select location, count(*) as total_employees
from hr_data
where age >= 18 and term_date is null
group by location;


-- What is the average length of employment for employees who have been terminated?
select round(avg(datediff(term_date, hire_date)/365),2) as avg_job_length_for_terminated
from hr_data
where age >= 18 and term_date is not null and term_date <= current_date();


-- How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as total_employees
from hr_data
where age >= 18 and term_date is null
group by 1, 2
order by 1, 2;


-- What is the distribution of job titles across the company?
select jobtitle, count(*) as total_employees
from hr_data
where age >= 18 and term_date is null
group by jobtitle
order by jobtitle desc;


-- Which department has the highest turnover rate?
with cte1 as
(select department, count(*) as total_employees,
sum(case when term_date <= curdate() and term_date is not null then 1 else 0 end) as terminated_employees
from hr_data
where age >= 18
group by department)
select department, total_employees, terminated_employees, (terminated_employees/total_employees) as termination_rate
from cte1
order by termination_rate desc;


-- How has the company's employee count changed over time based on hire and term dates?
with cte2 as
(select year(hire_date) as year, count(*) as total_hires,
sum(case when term_date is not null and term_date <= current_date() then 1 else 0 end) as total_terminations
from hr_data
where age >= 18
group by year)
select *, (total_hires - total_terminations) as net_change, round(((total_hires - total_terminations) / total_hires) * 100, 2) as net_change_percent
from cte2
order by year;

-- What is the average tenure distribution for each department?
select department, round(avg(datediff(term_date, hire_date)/365),1) as avg_tenure_in_years
from hr_data
where age >= 18 and term_date is not null and term_date <= current_date()
group by department;




