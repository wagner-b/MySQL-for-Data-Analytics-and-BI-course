-- MySQL course - combining SQL and Tableau
-- Copyright (C) 2023, Wagner Bertholdo Burghausen
--
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.

USE employees_mod;

-- Create a visualization that provides a breakdown between male and
-- female employee working in the company each year, starting from 1990.
SELECT 
    YEAR(d.from_date) AS calendar_year,
    e.gender,
    COUNT(d.emp_no) AS num_of_employees
FROM
    t_dept_emp d
        JOIN
    t_employees e ON d.emp_no = e.emp_no
GROUP BY calendar_year , e.gender
HAVING calendar_year >= 1990
ORDER BY calendar_year;

-- Compare the number of male managers to the number of female managers
-- from different departments for each year, starting from 1990.
SELECT 
    d.dept_name,
    e2.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(dm.from_date) <= e.calendar_year
                AND YEAR(dm.to_date) >= e.calendar_year
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees e2 ON dm.emp_no = e2.emp_no
ORDER BY dm.emp_no , e.calendar_year;
