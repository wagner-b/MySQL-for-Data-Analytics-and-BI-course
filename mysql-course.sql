USE employees;

SELECT first_name, last_name FROM employees;

SELECT dept_no FROM departments;
SELECT * FROM departments;

SELECT * FROM employees WHERE first_name = 'Denis';
SELECT * FROM employees WHERE first_name = 'Elvis';
SELECT * FROM employees WHERE first_name = 'Denis' AND gender = 'M';
SELECT * FROM employees WHERE first_name = 'Kellie' AND gender = 'F';
SELECT * FROM employees WHERE first_name = 'Denis' OR first_name = 'Elvis';
SELECT * FROM employees WHERE first_name = 'Kellie' OR first_name = 'Aruna';

/*
Logical operator precedence: In the execution of the query, SQL will
always start reading the conditions around the AND operator, and only
after that, the operator OR is read. Regardless of the order in
which you use these operators in your query. Use parenthesis
around the conditions to get the appropriate result.
*/

-- The query below returns all male employees with last name
-- Denis, as well as all female employees regardless of name 
SELECT * FROM employees
WHERE last_name = 'Denis' AND gender = 'M' OR gender = 'F';

-- But this query below simply returns all employees with
-- the last name Denis, which are assigned M of F gender
SELECT * FROM employees
WHERE last_name = 'Denis' AND (gender = 'M' OR gender = 'F');

SELECT * FROM employees
WHERE gender = 'F' AND (first_name = 'Kellie' OR first_name = 'Aruna');

SELECT * FROM employees
WHERE first_name IN ('Cathie', 'Mark', 'Nathan');

SELECT * FROM employees
WHERE first_name NOT IN ('John', 'Mark', 'Jacob');

-- In pattern seeking, the % sign indicates a sequence of chars
-- as well as no char.
SELECT * FROM employees
WHERE first_name LIKE('Mar%');

-- MySQL is case insensitive, so typing '%ar%' or '%Ar%'
-- or '%AR%' returns the same result
SELECT * FROM employees
WHERE first_name LIKE('%ar%');

-- The underscore (_) matches a single char
SELECT * FROM employees
WHERE first_name LIKE('Mar_');

SELECT * FROM employees
WHERE first_name NOT LIKE('%mar%');

SELECT * FROM employees
WHERE hire_date LIKE('2000%');

-- Includes '1990-01-01' AND '1995-01-01'
SELECT * FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01';

-- Does NOT includes '1990-01-01' AND '1995-01-01'
SELECT * FROM employees
WHERE hire_date NOT BETWEEN '1990-01-01' AND '1995-01-01';

SELECT * FROM salaries
WHERE salary BETWEEN 66000 AND 70000;

SELECT * FROM departments
WHERE dept_no BETWEEN 'd003' AND 'd006';

SELECT * FROM departments
WHERE dept_name IS NOT NULL;

-- In MySQL, the 'not equal to' operator is represented
-- by angle brackets <> or !=
SELECT * FROM employees
WHERE first_name <> 'Mark';

SELECT * FROM employees
WHERE gender = 'F' AND hire_date >= '2000-01-01';

SELECT * FROM salaries
WHERE salary > 150000;

-- Use SELECT DISTINCT to select only values which
-- are different from each other
SELECT DISTINCT gender FROM employees;

-- Aggregate functions: COUNT() SUM() MIN() MAX() AVG()
-- They gather data from many rows of a table, then
-- aggregate it into a single value.
-- They typically ignore null values, but this can be changed.
SELECT COUNT(emp_no) FROM employees;
SELECT COUNT(first_name) FROM employees;
SELECT COUNT(DISTINCT first_name) FROM employees;

-- Count all salaries >= 100,000
SELECT COUNT(*) FROM salaries
WHERE salary >= 100000;

-- Count the number of managers
SELECT COUNT(*) FROM dept_manager;

-- Order by ascending order (ASC optional)
SELECT * FROM employees ORDER BY first_name;
SELECT * FROM employees ORDER BY first_name ASC;

-- Order by descending order (DESC mandatory)
SELECT * FROM employees ORDER BY first_name DESC;
SELECT * FROM employees ORDER BY hire_date DESC;

-- Order by multiple columns
SELECT * FROM employees ORDER BY first_name, last_name;

-- GROUP BY must be placed immediately after the WHERE
-- conditions, if any, and just before the ORDER BY clause.
-- GROUP BY selects only distinct values.
-- It's a good practice to always include the field you have
-- grouped by in your SELECT statement.

-- Get the number of times each first_name appears
SELECT 
    first_name, COUNT(first_name)
FROM
    employees
GROUP BY first_name
ORDER BY first_name;

-- Use alias (AS) to rename a selection from a query
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
ORDER BY first_name;

-- Create table with salaries > 80,000 and count the no of employees
SELECT 
    salary, COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

-- HAVING is frequently used with GROUP BY (after it), it refines the
-- output by adding conditions. It's similar to WHERE, but applied
-- to the GROUP BY block. The difference is, you can have a condition
-- with an aggregate function within HAVING, but the same can't
-- be done with WHERE.
/*
For example, the block of code below would produce an error,
(invalid use of group function), hence it's commented:
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
WHERE
    COUNT(first_name) > 250
GROUP BY first_name
ORDER BY first_name;
*/

-- If we use HAVING after GROUP BY, it works
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;

-- Select all employees with avg salary > 120,000
SELECT 
    emp_no, AVG(salary) AS average_salary
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

-- Extract a list of all names that are encountered less than 200
-- times, but only for people hired after Jan, 1st 1999.
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
WHERE
    hire_date > '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY first_name;

-- Select employee number of all individuals who have
-- signed more than 1 contract after Jan, 1st 2000.
SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

-- The LIMIT statement is always last
-- Show emp_no of 10 highest paid employees
SELECT 
    *
FROM
    salaries
ORDER BY salary DESC
LIMIT 10;

-- The DELETE statement, added here to avoid errors
DELETE FROM employees WHERE emp_no = 999901;
-- The INSERT statement
INSERT INTO employees (
    emp_no, birth_date, first_name, last_name, gender, hire_date
) 
VALUES (
    999901, '1986-04-21', 'Jonh', 'Smith', 'M', '2011-01-01'
);

-- The column names can be ommited in the INSERT statement,
-- as long as you add all values for all columns, and in the
-- same order in which they appear in the table.
DELETE FROM employees WHERE emp_no = 999903;
INSERT INTO employees VALUES (
    999903, '1977-04-14', 'Johnathan', 'Creek', 'M', '1999-01-01'
);

SELECT * FROM employees ORDER BY emp_no DESC LIMIT 10;

-- It's possible to insert data from a table into another table
-- But data types must match, and satisfy the same constraints!
-- First let's create a new table
DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);
-- Then, insert all data from departments to departments_dup
INSERT INTO departments_dup (
	dept_no, dept_name
)
SELECT * FROM departments;
-- Done. Check the contents of the departments_dup table
SELECT * FROM departments_dup ORDER BY dept_no;

-- The UPDATE statement
-- It's crucial to add the WHERE statement, or all rows
-- of the table will be updated.
-- (untick safe updates from edit - preferences - SQL editor)
UPDATE employees 
SET 
    first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE
    emp_no = 999901; -- Keeps the same emp_no

SELECT * FROM employees WHERE emp_no = 999901;

-- COMMIT, DELETE and ROLLBACK statements
-- Again, the WHERE clause is crucial for DELETE,
-- otherwise all data will be deleted.
-- Toggle off autocommit mode in MySQL Workbench before running,
-- otherwise, it may lead to errors. The code below is commented
-- to avoid errors when running all queries of this file
#COMMIT;
#SELECT * FROM employees WHERE emp_no = 999903;
#DELETE FROM employees WHERE emp_no = 999903;
#SELECT * FROM employees WHERE emp_no = 999903;
#ROLLBACK;
SELECT * FROM employees WHERE emp_no = 999903;

-- The DROP statement deletes all records, sctructure,
-- and related objects, and it's not possible to rollback.
-- TRUNCATE works like DELETE without the WHERE clause,
-- all records will be deleted, the structure will not
-- be deleted, but auto-increment values will be reset
-- (unlike with DELETE clause), among other peculiarities.

-- The COUNT(*) statement returns the number of all rows
-- in the table, null values included.
SELECT COUNT(*) FROM salaries;
-- Count how many departments there are in the db
SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

-- Find how much the company spends in salaries
SELECT SUM(salary) FROM salaries;
-- Filter for contracts starting after Jan, 1st 1997
SELECT SUM(salary) FROM salaries WHERE from_date > '1997-01-01';

-- Find the highest and lowest salaries
SELECT MAX(salary), MIN(salary) FROM salaries;
-- Average annual salary
SELECT ROUND(AVG(salary), 2) FROM salaries;
-- AVG salary for contracts starting after Jan, 1st 1997
SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

-- Now, let's change departments_dup to allow NULL
ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

-- Let's insert the 'Public Relations' department name
-- Here, I will always add a DELETE statement before each
--  INSERT, to achieve consistency in the DB when running
-- this entire file more than once with autocommit enabled.
DELETE FROM departments_dup WHERE dept_name = 'Public Relations';
INSERT INTO departments_dup (dept_name) VALUES('Public Relations');
-- Delete dept number 2
DELETE FROM departments_dup WHERE dept_no = 'd002';
-- And add dept 10 and 11
DELETE FROM departments_dup WHERE dept_no = 'd010' OR dept_no = 'd011';
INSERT INTO departments_dup (dept_no) VALUES ('d010'), ('d011');
-- Visualize departments_dup
SELECT * FROM departments_dup ORDER BY dept_no;

-- Create and fill the dept_manager_dup table
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
    emp_no INT NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);
INSERT INTO dept_manager_dup
SELECT * FROM dept_manager;
-- Insert some values and delete dept 1 in dept_manager_dup
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES (999904, '2017-01-01'), (999905, '2017-01-01'),
    (999906, '2017-01-01'), (999907, '2017-01-01');
DELETE FROM dept_manager_dup WHERE dept_no = 'd001';
-- Visualize
SELECT * FROM dept_manager_dup ORDER BY dept_no;

-- JOIN
-- Shows a result set, containing fields derived from 2
-- or more tables. There needs to be a related column /
-- field between tables, but it isn't necessary for tables
-- to be logically adjacent (linked).
-- When using JOIN, we can add aliases just after table names
-- without using the AS keyword.

-- INNER JOIN - extracts only the records in which the
-- (non-null) values in the related columns match.
-- The INNER keyword is optional for inner joins, 
-- since MySQL default unqualified JOIN is INNER JOIN.
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;
-- See that we have results for depts 3-9 only.
-- There's no data for depts 1, 2, 10 and 11.
-- This is because there is no depts 1, 10 and 11 on
-- dept_manager_dup, and there is no dept 2 on the
-- departments_dup table.

-- INNER JOIN exercise: Extract a list containing information
-- about all managers employee number, first and last name,
-- department number, and hire date.
SELECT 
    m.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    dept_manager m
        JOIN
    employees e ON m.emp_no = e.emp_no
ORDER BY m.emp_no;

-- When dealing with duplicate values when using JOIN, we
-- can GROUP BY the selected fields to remove duplicates.
-- Lets insert some duplicate data on the '%_dup' tables
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');
INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');
-- Visualize the tables
SELECT * FROM dept_manager_dup ORDER BY emp_no;
SELECT * FROM departments_dup ORDER BY dept_no;
-- Lets do the JOIN again to see the duplicates
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;
-- Now, use GROUP BY to remove duplicates from the JOIN output
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.dept_no, m.emp_no, d.dept_name
ORDER BY m.emp_no;
-- Good. The JOIN output doesn't cointain duplicates anymore

-- Remove the duplicate values from the '%_dup' tables
DELETE FROM dept_manager_dup
WHERE emp_no = '110228';
DELETE FROM departments_dup
WHERE dept_no = 'd009';
-- Add back the original data
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');
INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');
-- Visualize the tables
SELECT * FROM dept_manager_dup ORDER BY emp_no;
SELECT * FROM departments_dup ORDER BY dept_no;

-- LEFT JOIN - extracts all matching values of the 2 tables
-- plus all values from the left table that match no values
-- from the right table. Same output as LEFT OUTER JOIN.
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.emp_no;

-- RIGHT JOIN - Same as LEFT JOIN, but the direction
-- of the operation is inverted. When selecting the
-- related column, remember to select it from the
-- table on the right (table after the JOIN statement).
-- Since it's possible to obtain the same result of
-- the RIGHT JOIN using a LEFT JOIN with an inverted
-- tables order, right joins are seldom used in practice.
SELECT 
    d.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        RIGHT JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.emp_no;

-- The old join syntax - uses the FROM and WHERE
-- keywords to indicate tables and related columns.
-- It performs an inner join. But it is slower.
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m,
    departments_dup d
WHERE
    m.dept_no = d.dept_no
ORDER BY m.emp_no;

-- Use JOIN and WHERE together
-- Example: retrieve employee number, first and last names,
-- and salaries, only for employees that earn > 145,000
SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    salary > 145000
ORDER BY salary;

-- Exercise: Select the first and last name, the hire date,
-- and the job title of all employees whose first name is
-- “Margareta” and have the last name “Markovitch”.
SELECT 
    e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    first_name = 'Margareta'
        AND last_name = 'Markovitch';

-- CROSS JOIN - connects all the values, not only
-- those that match. Particularly useful when the
-- tables are not well connected.
-- The CROSS keyword here is not mandatory, as MySQL
-- will interpret any join without related columns
-- as a cross join. However, it's best practice to
--  always use the CROSS keyword for these cases.
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;
-- Same result with the old join syntax without WHERE
SELECT 
    dm.*, d.*
FROM
    dept_manager dm,
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- cross join exercise - Use a CROSS JOIN to return a
-- list with all possible combinations between managers
-- from the dept_manager table and department number 9.
SELECT 
    d.*, dm.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_no;

-- Find the average salaries of men and women
SELECT 
    e.gender, AVG(s.salary) AS average_salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

-- Join more than 2 tables
-- Retrieve information about all managers: first and
-- last names, hire_date, from_date and dept_name
-- The employees and dept_manager tables can be linked
-- by the emp_no field, while the dept_manager and 
-- departments tables can be linked by the dept_no field.
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no;

-- Select all managers first and last name, hire date,
-- job title, start date, and department name.
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager';

-- Obtain the department names and their average salary
-- but only for average salary > 60,000
SELECT 
    d.dept_name, AVG(s.salary) AS avg_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING avg_salary > 60000
ORDER BY avg_salary DESC;

-- Find the number of male and female managers
SELECT 
    e.gender, COUNT(m.emp_no)
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
GROUP BY gender;

-- Create the employees_dup table
DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup (
    emp_no INT,
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M', 'F'),
    hire_date DATE
);
-- Insert into only 20 first records from employees
INSERT INTO employees_dup
SELECT * FROM employees LIMIT 20;
-- Create a duplicate of the first row
INSERT INTO employees_dup VALUES
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');
-- Verify
SELECT * FROM employees_dup;

-- UNION - allows us to unify tables, combining
-- a few SELECT statements into a single output.
-- But it requires the same number of columns, with
-- same names, same order, and with related data types.
-- While UNION displays only distinct values in the
-- output, UNION ALL retrieves duplicates as well.
-- We will use it on employee_dup and dept_manager
-- and we will need to create columns with null

-- UNION - removes duplicates
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
UNION ALL SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
    dept_manager m;
-- UNION ALL - Prioritizes performance
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e 
UNION ALL SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
    dept_manager m
ORDER BY - emp_no DESC;
-- Use the minus sign, field and DESC keyword to sort
-- in ascending order with null values in the end.

-- Subqueries = inner queries = nested queries = inner select
-- They should always placed within parentheses
-- They are queries embedded in a query,
-- the outer query (outer select).
-- e.g. select first and last name of managers
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm);
-- The SQL engine starts by running the inner query, then
-- it uses the returned output to execute the outer query

-- Exercise - Extract the information about all department
-- managers who were hired between the 1st of January 1990
-- and the 1st of January 1995.
-- selecting information from the employees table
SELECT 
    *
FROM
    employees
WHERE
    hire_date BETWEEN '1990-01-01' AND '1995-01-01'
        AND emp_no IN (SELECT 
            emp_no
        FROM
            dept_manager);
-- selecting information from dept_manager table
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

-- While IN searches among values, EXISTS tests row values
-- for existence, which is quicker in retrieving large amounts
-- of data. Example with EXISTS:
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no)
ORDER BY emp_no;

-- Subqueries exercise with EXISTS: Select the information
-- from employees table for all employees whose job title
-- is “Assistant Engineer”. 
SELECT 
    e.*
FROM
    employees e
WHERE
    EXISTS( SELECT 
            t.*
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND t.title = 'Assistant Engineer');

-- Subqueries nested in SELECT statement
-- Assign employee number 110022 as a manager to all employees
-- from 10001 to 10020, and employee 110039 as a manager to all
-- employees from 10021 to 10040.
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;

-- Create the emp_manager table
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
    emp_no INT NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT NOT NULL
);
-- Fill the emp_manager table
INSERT INTO emp_manager SELECT 
    U.*
FROM
    (SELECT 
        A.*
    FROM
        (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no) AS A UNION SELECT 
        B.*
    FROM
        (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    LIMIT 20) AS B UNION SELECT 
        C.*
    FROM
        (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022) AS C UNION SELECT 
        D.*
    FROM
        (SELECT 
        e.emp_no AS employeeID,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS managerID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039) AS D) AS U
ORDER BY employeeID;
-- Visualize the emp_managers table
SELECT * FROM emp_manager;

-- self join - Combines rows of a table with other rows
-- of the same table. All rows come from the same table.
-- Using aliases is obligatory. The filtering the data
-- can be done both in the join, or one in the
-- WHERE clause, and the other in the join.
-- E.g. from emp_manager, extract only the managers.
SELECT DISTINCT
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;
-- Instead of select distinct, we can filter on WHERE clause
SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);

-- SQL view is a virtual table whose contents are
-- obtained from an existing table(s), called base
-- table(s). The view object doesn't contain real
-- data, it simply shows data from the base table.
-- E.g. visualize last contract of each employee
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
-- To visualize it, click the last icon on SCHEMAS-employees-
-- Views-v_dept_emp_lastest_date or type:
SELECT * FROM employees.v_dept_emp_latest_date;

-- A view acts like a shorcut for writing the same SELECT
-- statement every time. Saves a lot of coding time,
-- occupies no extra memory, and acts like a dynamic table,
-- since it instantly reflect the changes in the base table.

-- Views exercise: Create a view that will extract the
-- average salary of all managers registered in the database.
-- Round this value to the nearest cent.
CREATE OR REPLACE VIEW v_manager_avg_salary AS
    SELECT 
        ROUND(AVG(salary), 2) AS average_salary
    FROM
        salaries s
            JOIN
        dept_manager dm ON s.emp_no = dm.emp_no;
-- Visualize the result
SELECT * FROM v_manager_avg_salary;

-- Stored routines
-- Routine is a usual, fixed action, or series of action,
-- repeated periodically. Stored routines are SQL statement(s)
-- that can be stored in a DB server, and invoked by users.
-- Stored routines can be stored procedures or functions.

-- It is important to define a delimiter for the routine
-- other than the semi-colon, otherwise only the first query
-- of the routine will be executed when called.

-- Exercise: create a stored procedure to see the average
-- salary of all employees. The call the procedure.
USE employees;
DROP PROCEDURE IF EXISTS avg_salary_all_emp;
DELIMITER $$
USE employees$$
CREATE PROCEDURE avg_salary_all_emp()
BEGIN
	SELECT AVG(salary) AS avg_salary FROM salaries;
END$$
DELIMITER ;
-- Call the procedure
CALL employees.avg_salary_all_emp();

-- Procedures with input and output parameters:
-- Requires the SELECT - INTO structure.
-- Create a procedure to store the average salary
-- of an employee, based on a given employee number
USE employees;
DROP PROCEDURE IF EXISTS emp_avg_salary_out;
DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out(IN p_emp_no INT, OUT p_avg_salary DECIMAL(10,2))
BEGIN
SELECT
    ROUND(AVG(s.salary), 2)
INTO p_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
END$$
DELIMITER ;

-- Exercise: Create a procedure called ‘emp_info’ that
-- uses as parameters the first and the last name of an
-- individual, and returns their employee number.
USE employees;
DROP PROCEDURE IF EXISTS emp_info;
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(14), IN p_last_name VARCHAR(16), OUT p_emp_no INT)
BEGIN
SELECT 
    MAX(emp_no)
INTO p_emp_no FROM
    employees
WHERE
    first_name = p_first_name
        AND last_name = p_last_name;
END$$
DELIMITER ;

-- Variable names are preceded by the @ symbol.
-- Use the syntax 'SET' to initialize a variable
SET @v_avg_salary = 0;
-- Call the procedure
CALL employees.emp_avg_salary_out(11300, @v_avg_salary);
-- Display the output value in the variable
SELECT @v_avg_salary;

-- Exercise: Create a variable, called ‘v_emp_no’, where
-- you will store the output of the procedure you created
-- in the last exercise. Call the same procedure, inserting
-- the values ‘Aruna’ and ‘Journel’ as a first and last name
-- respectively. Finally, select the obtained output. 
SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

-- User-defined functions
-- There are no OUT parameters, all parameters are inputs,
-- so there is no need to type the keyword IN. But it must
-- always return one value, using the RETURN statement.
-- Use the DECLARE statement to define a varible 
-- inside the scope of the function.
USE employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;
DELIMITER $$
CREATE FUNCTION f_emp_avg_salary(p_emp_no INT) RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
DECLARE v_avg_salary DECIMAL(10, 2);

SELECT
    AVG(s.salary)
INTO v_avg_salary FROM
	employees e
        JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;

RETURN v_avg_salary;
END$$
DELIMITER ;
/*
Because binary logs may be enabled by default, it may be
necessary to add the keywords DETERMINISTIC or NO SQL or
READS SQL DATA to avoid error code 1418. This is because
When binary logs are enabled, it will always check
whether a function is changing the data in the
database and what is the result to be produced.

Meanings of these keywords: 
DETERMINISTIC – it states that the function will
always return identical result given the same input.
NO SQL – means that the code in our function
does not contain SQL (rarely the case).
READS SQL DATA – this is usually when a simple SELECT
statement is present.

When none of those are present in our code, MySQL
assumes that our function is non-deterministic
and that it changes data. This is why error code
1418 is raised in the absence of these keywords.
*/
-- Use the SELECT statement to see the function return value
SELECT f_emp_avg_salary(11300);

-- Functions exercise: Create a function called ‘f_emp_info’
-- that takes for parameters the first and last name of an
-- employee, and returns the salary from the newest
-- contract of that employee.
USE employees;
DROP FUNCTION IF EXISTS f_emp_info;
DELIMITER $$
CREATE FUNCTION f_emp_info(p_first_name VARCHAR(14), p_last_name VARCHAR(16)) RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
DECLARE v_salary DECIMAL(10, 2);
DECLARE v_max_from_date DATE;

SELECT 
    MAX(s.from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;

SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;

RETURN v_salary;
END$$
DELIMITER ;
-- View the output for 'Georgi Facello' 
SELECT f_emp_info('Georgi', 'Facello');
-- View the output for 'Aruna Journel'
SELECT f_emp_info('Aruna', 'Journel');

-- To update, insert or delete values in a table,
-- it is advised to use stored procedures and not
-- functions, as functions need to return a value.

-- While including a procedure in a SELECT statement
-- is impossible, a function can be easily included
-- as a column of a SELECT statement. For example:
SET @v_emp_no = 11300;
SELECT 
    emp_no,
    first_name,
    last_name,
    F_EMP_AVG_SALARY(@v_emp_no) AS avg_salary
FROM
    employees
WHERE
    emp_no = @v_emp_no;

-- The variables created previously where either session
-- variables (created with SET @) or local variables
-- (created with DECLARE). Global variables are specific,
-- pre-defined system variables, like '.max_connections()'
-- or '.max_join_size()'. Use 'SET GLOBAL' or 'SET @@global.'
-- to set these types of variables. E.g.
SET GLOBAL max_connections = 1000;
SET @@global.max_connections = 800;
SELECT @@global.max_connections;

-- Triggers: a trigger is a MySQL object that can “trigger” a
-- specific action or calculation ‘before’ or ‘after’ an INSERT, 
-- UPDATE, or DELETE statement has been executed. A trigger can
-- be activated before a new record is inserted into a table,
-- or after a record has been updated.
USE employees;
DROP TRIGGER IF EXISTS before_salaries_insert;
DELIMITER $$
CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SET NEW.salary = 0;
    END IF;
END$$
DELIMITER ;

SELECT * FROM salaries WHERE emp_no = 10001;
-- Insert a new record with negative salary
DELETE FROM salaries WHERE salary = 0;
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');
-- See that the new record has a salary of 0, not -92891
SELECT * FROM salaries WHERE emp_no = 10001;

-- Before update trigger
USE employees;
DROP TRIGGER IF EXISTS before_salaries_update;
DELIMITER $$
CREATE TRIGGER before_salaries_update
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
	    SET NEW.salary = OLD.salary;
	END IF;
END$$
DELIMITER ;

-- Update the salary of emp_no 10001 on 2010-06-22
UPDATE salaries 
SET 
    salary = - 50000
WHERE
    emp_no = 10001
        AND from_date = '2010-06-22';
-- See that the salary on that row wasn't updated
SELECT * FROM salaries WHERE emp_no = 10001 AND from_date = '2010-06-22';
-- Delete the value we inserted earlier
DELETE FROM salaries WHERE salary = 0;

-- Some system built-in functions
-- sysdate() returns datetime when it's invoked
SELECT SYSDATE();
SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') AS today;

-- MySQL Indexes are used to increase the search speed
-- related to a table. Need to specify the column name(s).
-- The syntax is:
# CREATE INDEX i_index_name ON table_name(column1, column2, ...);


-- Creating and dropping indexes isn't supported with
-- 'IF EXISTS' statements, therefore we need procedures.
-- Procedure to create an index only if it doesn't exist:
DELIMITER $$
DROP PROCEDURE IF EXISTS csi_add_index $$
CREATE PROCEDURE csi_add_index(in theTable varchar(128), in theIndexName varchar(128), in theIndexColumns varchar(128)  )
BEGIN
 IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics WHERE TABLE_SCHEMA = DATABASE() and table_name =
theTable AND index_name = theIndexName)  = 0) THEN
   SET @s = CONCAT('CREATE INDEX ' , theIndexName , ' ON ' , theTable, '(', theIndexColumns, ')');
   PREPARE stmt FROM @s;
   EXECUTE stmt;
 END IF;
END $$
DELIMITER ;

-- Procedure to drop an index only if exists:
DELIMITER $$
DROP PROCEDURE IF EXISTS drop_index_if_exists $$
CREATE PROCEDURE drop_index_if_exists(in theTable varchar(128), in theIndexName varchar(128) )
BEGIN
 IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics WHERE TABLE_SCHEMA = DATABASE() and table_name =
theTable AND index_name = theIndexName) > 0) THEN
   SET @s = CONCAT('DROP INDEX ' , theIndexName , ' ON ' , theTable);
   PREPARE stmt FROM @s;
   EXECUTE stmt;
 END IF;
END $$
DELIMITER ;

-- Searching becomes a lot faster after the index is created
CALL drop_index_if_exists('employees', 'i_hire_date');
SELECT * FROM employees WHERE hire_date > '2000-01-01';
CALL csi_add_index('employees', 'i_hire_date', 'hire_date');
SELECT * FROM employees WHERE hire_date > '2000-01-01';

-- Indexes can also be applied for multiple columns, called
-- composite indexes. The csi_add_index also supports it
CALL drop_index_if_exists('employees', 'i_composite');
SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';
CALL csi_add_index('employees', 'i_composite', 'first_name, last_name');
SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';

-- Primary and unique keys are also indexes. Indexes
-- can be seen via the GUI in MySQL Workbench, or:
SHOW INDEX FROM employees FROM employees;

-- Index exercise 1 - Drop i_hire_date index
CALL drop_index_if_exists('employees', 'i_hire_date');
-- Index exercise 2 - Create/test index for salary in salaries
CALL drop_index_if_exists('salaries', 'i_salary');
SELECT * FROM salaries WHERE salary > 89000;
CALL csi_add_index('salaries', 'i_salary', 'salary');
SELECT * FROM salaries WHERE salary > 89000;
CALL drop_index_if_exists('salaries', 'i_salary');

-- The CASE statement - used in a SELECT statement
SELECT 
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM
    employees;
-- Alternatively:
SELECT 
    emp_no,
    first_name,
    last_name,
    CASE gender
        WHEN 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM
    employees;

-- The above alternative is not always possible, though.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;
-- In this case, putting dm.emp_no right after CASE instead of 
-- WHEN (and erasing IS), will generate an incorrect output
-- with all rows 'Employee' on the is_manager column.

-- IF(expression_to_evaluate, value_if_true, value_if_false)
SELECT 
    emp_no,
    first_name,
    last_name,
    IF(gender = 'M', 'Male', 'Female') AS gender
FROM
    employees;

-- CASE statement exercise: Extract a dataset containing the
-- following information about the managers: employee number,
-- first name, and last name. Add two columns at the end, one
-- showing the difference between the maximum and minimum
-- salary of that employee, and another one saying whether
-- this salary raise was higher than $30,000 or NOT.
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_increase,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Yes'
        ELSE 'No'
    END AS s_increase_over_30000
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY dm.emp_no , e.first_name , e.last_name
ORDER BY dm.emp_no;
-- Using IF() instead of CASE
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_increase,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Yes',
        'No') AS s_increase_over_30000
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY dm.emp_no , e.first_name , e.last_name
ORDER BY dm.emp_no;

-- CASE statement exercise 2: Extract the employee number,
-- first name, and last name of the first 100 employees,
-- and add a fourth column, called “current_employee”
-- saying “Is still employed” if the employee is still
-- working in the company, or “Not an employee anymore”
-- if they aren’t.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no , e.first_name , e.last_name
ORDER BY e.emp_no
LIMIT 100;

-- MySQL Window functions - performs calculations for
-- every record in the dataset (current row). There
-- are aggregate window functions and nonaggregate
-- window function (divided in ranking and value
-- window functions).

-- The ROW_NUMBER() ranking window function
-- Empty OVER clause = all query rows will be evaluated
-- That means all rows are like a single partition
SELECT 
    ROW_NUMBER() OVER () AS row_num,
    emp_no,
    salary
FROM
    salaries
LIMIT 1100;

-- 'PARTITION BY' will divide the data in partitions,
-- and the evaluation will be done separately for each
-- partition. In the example below, the row_num increases
-- for each row with same emp_no, but will reset to 1 when
-- a new emp_no appears in the table (a new partition).
SELECT 
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary) AS row_num,
    emp_no,
    salary
FROM
    salaries
LIMIT 1100;

-- PARTITION BY is not mandatory, we can use only ORDER BY
SELECT 
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    emp_no,
    salary
FROM
    salaries
LIMIT 1100;

-- Window functions alternative syntax - involves
-- naming the window specification - useful when it's
-- necessary to refer to it multiple times
SELECT 
    ROW_NUMBER() OVER w AS row_num,
    emp_no,
    salary
FROM
    salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC)
LIMIT 1100;

-- RANK() and DENSE_RANK() window functions
-- They assign the same rank to records that hold
-- identical values. RANK() focuses on the number
-- of values in the output, incrementing to the next
-- rank the number of identical values. DENSE_RANK()
-- focuses on the ranking itself and only increments
-- the next rank by 1, regardless of identical values.
SELECT
    emp_no, salary, RANK() OVER w AS rank_num
FROM
    salaries
WHERE emp_no = 11839
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT
    emp_no, salary, DENSE_RANK() OVER w AS rank_num
FROM
    salaries
WHERE emp_no = 11839
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

-- LAG() and LEAD() value window functions
-- They return a value that can be found in the database
-- LAG() returns the previous value from a column
-- LEAD() returns the next value from a column
SELECT 
    emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_curr_prev,
    LEAD(salary) OVER w - salary AS diff_salary_next_curr
FROM salaries
WHERE emp_no = 10001
WINDOW w AS (ORDER BY salary);

-- The MySQL LAG() and LEAD() value window functions can have
-- a second argument, designating how many rows/steps back
-- (for LAG()) or forth (for LEAD()) we'd like to refer to
-- with respect to a given record.
SELECT 
    emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LAG(salary, 2) OVER w AS previous_previous_salary,
    LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS next_next_salary
FROM
    salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

-- Aggregate window functions
-- They are aggregate functions like MAX() MIN() AVG() SUM()
-- but applied to the context of window functions. Must use
-- PARTITION BY, and must be careful to obtain meaningful
-- results. It doesn't reduce the number of records returned.
-- E.g. select emp salary and average salary per department
-- for employees which are still working on the company.
SELECT 
    s.emp_no, d.dept_name, s.salary,
    ROUND(AVG(s.salary) OVER w) AS avg_salary_per_dept
FROM
    salaries s
        JOIN
    dept_emp de ON s.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    s.to_date > SYSDATE() AND de.to_date > SYSDATE()
GROUP BY s.emp_no , d.dept_name , s.salary
WINDOW w AS (PARTITION BY d.dept_name)
ORDER BY s.emp_no
LIMIT 1000;

-- Common Table Expressions (CTEs)
-- Used to obtain temporary result dataset that are
-- produced within the execution of a query / subquery.
-- Sometimes referred as 'named subqueries'.
-- Starts with 'WITH' clause, then the name of the CTE.
-- e.g. how many female salaries are above all-time
-- average salary?
WITH cte AS (SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
    SUM(CASE WHEN s.salary > c.avg_salary THEN 1 ELSE 0 END)
    AS no_of_fem_salaries_above_avg,
    COUNT(s.salary) AS total_no_of_fem_salary_contracts
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'F' 
        CROSS JOIN
    cte c;

-- CTEs can have multiple subclauses
-- In MySQL we can't use 2 or more WITH clauses on the
-- same level (same query). But we can use a comma to add
-- other CTEs after the first one (CTE subclauses).
-- e.g. how many female highest salaries are above all-time
-- average salary across all genders?
WITH cte_avg_salary AS (
    SELECT AVG(salary) AS avg_salary FROM salaries
),
cte_f_highest_salary AS (
    SELECT s.emp_no, MAX(s.salary) AS f_highest_salary
    FROM salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
    GROUP BY s.emp_no
)
SELECT 
    SUM(CASE WHEN cte2.f_highest_salary > cte1.avg_salary
        THEN 1 ELSE 0 END) AS f_highest_salaries_above_avg,
    COUNT(e.emp_no) AS total_no_of_female_contracts,
    (SUM(CASE WHEN cte2.f_highest_salary > cte1.avg_salary
        THEN 1 ELSE 0 END) / COUNT(e.emp_no)) * 100
        AS percentage
FROM
    employees e
        JOIN
    cte_f_highest_salary cte2 ON cte2.emp_no = e.emp_no
        CROSS JOIN
    cte_avg_salary cte1;

-- Temporary tables
-- They only exist during the current session.
-- But they can be very useful, since they can
-- be used like any other table from the default
-- database during the session it was created.
CREATE TEMPORARY TABLE f_highest_salaries
SELECT 
    s.emp_no, MAX(s.salary) AS f_highest_salary
FROM
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
GROUP BY s.emp_no;
-- Select new temporary table
SELECT * FROM f_highest_salaries;
-- They can also be dropped like any other table
# DROP TABLE IF EXISTS f_highest_salaries;
-- Adding the TEMPORARY keyword also works
DROP TEMPORARY TABLE IF EXISTS f_highest_salaries;

-- After a temporary table is used once, it's locked-for-use,
-- meaning it can't be used on self-joins, or with UNION or
-- UNION ALL. But there is a workaround this, we can create
-- a CTE and copy the code of the temp table inside the CTE.
CREATE TEMPORARY TABLE f_highest_salaries
SELECT 
    s.emp_no, MAX(s.salary) AS f_highest_salary
FROM
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
GROUP BY s.emp_no
LIMIT 10;

WITH cte AS (
    SELECT
        s.emp_no, MAX(s.salary) AS f_highest_salary
    FROM
        salaries s
            JOIN
        employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
    GROUP BY s.emp_no
    LIMIT 10
)
SELECT * FROM f_highest_salaries UNION ALL SELECT * FROM cte;

DROP TEMPORARY TABLE IF EXISTS f_highest_salaries;

