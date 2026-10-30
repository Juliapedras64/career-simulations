create table if not exists data_science_team (
  emp_id VARCHAR(250) primary key references emp_record(emp_id),
  first_name VARCHAR(250),
  last_name VARCHAR(250),
  gender VARCHAR(250),
  role VARCHAR(250),
  dept VARCHAR(250),
  exp integer,
  country VARCHAR(250),
  continent VARCHAR(250)
);

create table if not exists emp_record (
  emp_id VARCHAR(250) primary key,
  first_name VARCHAR(250),
  last_name VARCHAR(250),
  gender VARCHAR(250),
  role VARCHAR(250),
  dept VARCHAR(250),
  exp integer,
  country VARCHAR(250),
  continent VARCHAR(250),
  salary integer,
  emp_rating integer,
  manager_id VARCHAR(250),
  proj_id VARCHAR(250) references project(project_id)
);

create table if not exists project (
  project_id VARCHAR(250) primary key,
  proj_name VARCHAR(250),
  domain VARCHAR(250),
  start_date date,
  closure_date date,
  dev_qtr VARCHAR(250),
  status VARCHAR(250)
);

---Write a query to return EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table

select emp_id, first_name, last_name, gender, dept
from emp_record;

---Write a query to return EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
--less than two, greater than four, and between two and four

select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record
where emp_rating in(1,3,5);

---Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

select concat(first_name, ',', last_name) as NAME, dept
from emp_record
where dept = 'FINANCE';

---Write a SQL query to retrieve the employee ID, first name, role, and department of employees who hold leadership positions (Manager, President, or CEO).

select emp_id, first_name, last_name, dept, role
from emp_record
where role = 'MANAGER' or 
      role = 'PRESIDENT';

---Write a query to list all the employees from the healthcare and finance departments using union or union all. Take data from the employee record table.

select emp_id, first_name, last_name, dept
from data_science_team
where dept = 'HEALTHCARE' OR dept = 'FINANCE'
union
select emp_id, first_name, last_name, dept
from emp_record
where dept = 'HEALTHCARE' OR dept = 'FINANCE';

---Write a query to list employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
--Also include the respective employee rating along with the max emp rating for the department

select emp_id, first_name, last_name, role, dept, emp_rating, 
max(emp_rating) over (partition by dept) as max_emp_rating
from emp_record;

---Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

select role, min(salary) as min_salary, max(salary) as max_salary
from emp_record
group by role;

---Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

select emp_id, concat(first_name, ' ', last_name), role, exp,
rank() over (order by exp desc) as experience_rank
from emp_record;

---Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.

create view high_salary_emp as
select emp_id, first_name, last_name, dept, salary, country
from emp_record
where salary > 6000;

select *
from high_salary_emp;

---Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

select emp_id, first_name, last_name, role, exp
from emp_record
where emp_id IN (
               select emp_id 
               from emp_record
               where exp >10
);

--Write a query in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.The standard being:
--For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
--For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
--For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
--For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
--For an employee with the experience of 12 to 16 years assign 'MANAGER'.

select emp_id, concat(first_name, ' ', last_name), dept, exp,
case when exp <= 2 then 'Junior Data Scientist'
     when exp between 2 and 5 then 'Associate data Scientist'
     when exp between 5 and 10 then 'Senior Data Scientist'
     when exp between 10 and 12 then 'Lead Data Scientist'
     when exp between 12 and 16 then 'Manager'
     else 'President'
end as job_profile
from emp_record
order by exp DESC;

---Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

select emp_id, first_name, last_name, salary, emp_rating,
((0.05 * salary) * emp_rating) as bonus
from emp_record;

---Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

select continent, country, avg(salary)
from emp_record
group by continent, country
order by continent, country;