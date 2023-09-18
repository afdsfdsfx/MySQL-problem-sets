-- Practice problem in joining multiple tables in a single database from Google Data Analytics on Coursera

CREATE DATABASE department_db;
USE department_db;



--@block: Import the dataset for this problem through MySQL Workbench

USE department_db;

SELECT
    *
FROM
    department_table;


SELECT
    *
FROM
    employee_table;



--@block: Practice Problem 1: Convert `department_id` from TEXT to INT for both tables

ALTER TABLE
    department_table
MODIFY COLUMN
    department_id INT;


ALTER TABLE
    employee_table
MODIFY COLUMN
    department_id INT;


DESCRIBE department_table;
DESCRIBE employee_table;



--@block: Practice Problem 2: Get all the employees' name, position whose department is officially listed

SELECT
    employee_table.name AS 'Employee',
    employee_table.role AS 'Position',
    department_table.name AS 'Department'
FROM
    employee_table
INNER JOIN
    department_table
ON
    employee_table.department_id = department_table.department_id
ORDER BY
    department_table.department_id;



--@block: Practice Problem 3: Get all the employees' name, position and whose department is NULL

SELECT
    employee_table.name AS 'Employee',
    employee_table.role AS 'Position',
    department_table.name AS 'Department'
FROM
    employee_table
LEFT JOIN
    department_table
ON
    employee_table.department_id = department_table.department_id
WHERE
    department_table.name IS NULL;



--@block: Practice Problem 4: Get all the employees' name, position from each department

SELECT
    employee_table.name AS 'Employee',
    employee_table.role AS 'Position',
    department_table.name AS 'Department'
FROM
    employee_table
RIGHT JOIN
    department_table
ON
    employee_table.department_id = department_table.department_id
ORDER BY
    department_table.name;



--@block: Practice Problem 5: Perform an OUTER JOIN despite MySQL not supporting this functionality

-- Step 1: Query the needed information from a LEFT JOIN
-- Step 2: Query the needed information from a RIGHT JOIN
-- Step 3: Use UNION to combine the LEFT and RIGHT joined tables


SELECT
    employee_table.name AS 'Employee',
    employee_table.role AS 'Position',
    department_table.name AS 'Department'
FROM
    employee_table
LEFT JOIN
    department_table
ON
    employee_table.department_id = department_table.department_id

UNION

SELECT
    employee_table.name AS 'Employee',
    employee_table.role AS 'Position',
    department_table.name AS 'Department'
FROM
    employee_table
LEFT JOIN
    department_table
ON
    employee_table.department_id = department_table.department_id;