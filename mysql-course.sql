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
INSERT INTO employees VALUES (
    999903, '1977-04-14', 'Johnathan', 'Creek', 'M', '1999-01-01'
);

SELECT * FROM employees ORDER BY emp_no DESC LIMIT 10;

-- It's possible to insert data from a table into another table
-- But data types must match, and satisfy the same constraints!
-- First let's create a new table
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
-- Toggle off autocommit mode in MySQL Workbench before running
COMMIT;
SELECT * FROM employees WHERE emp_no = 999903;
DELETE FROM employees WHERE emp_no = 999903;
SELECT * FROM employees WHERE emp_no = 999903;
ROLLBACK;
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
-- Then, insert 'Public Relations' dept
INSERT INTO departments_dup (dept_name) VALUES('Public Relations');
-- Delete dept number 2
DELETE FROM departments_dup WHERE dept_no = 'd002';
-- And add dept 10 and 11
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

