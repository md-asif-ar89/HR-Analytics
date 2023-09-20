
-- creating a new database as hr_project
create database hr_project;

use hr_project;

/*
now we have to import human resources csv file data in the form of a table with name as "hr_data"
we can import a dataset with limited number of records directly with in MySQL Workbench by using "Table data import wizard" 
but for large dataset with thousands or millions of records we have to use Command line for data import
*/

select * from hr_data limit 10;

update hr_data set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;

alter table hr_data
modify column birthdate date;
describe hr_data;


update hr_data set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;

alter table hr_data
modify column hire_date date;
describe hr_data;


alter table hr_data
add column term_date text after termdate;

update hr_data set term_date = substring(termdate, 1, instr(termdate, ' ')-1)
where termdate is not null and termdate != '';

alter table hr_data
modify column term_date date;

alter table hr_data
drop column termdate;

-- if age will come a lot of time in analysis then its good practice to add a seperate column for age for fast querying
alter table hr_data
add column age int after birthdate;

update hr_data set age = (datediff(current_date(), birthdate)/365);

select birthdate, age from hr_data;
select count(age) from hr_data where age < 0;
select count(term_date) from hr_data where term_date > current_date();



