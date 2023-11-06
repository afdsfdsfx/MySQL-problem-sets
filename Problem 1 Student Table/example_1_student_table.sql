--@block: Creating a database
CREATE DATABASE student_db;

--@block: Using the database created
USE student_db;

--@block: Creating a sample table
CREATE TABLE student(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255),
    major VARCHAR(255)
    );

/*
Alternatively

CREATE TABLE student(
    student_id INT,
    student_name VARCHAR(20),
    major VARCHAR(20),
    PRIMARY KEY(student_id)
);

*/

--@block: Adding a new column to an existing table
ALTER TABLE student ADD school_year DATE;

--@block: Deleting a column
ALTER TABLE student DROP COLUMN school_year;

--@block: Add data to the table created
    
INSERT INTO student VALUES(1000, 'Jack', 'Biology');
INSERT INTO student VALUES(1001, 'Kate', 'Sociology');
INSERT INTO student VALUES(1002, 'Claire', 'English');
INSERT INTO student VALUES(1003, 'Jack', 'Biology');
INSERT INTO student VALUES(1004, 'Mike', 'Comp. Sci');

--@block: Show the table created
SELECT * FROM student;

--@block: Updating a table
UPDATE
    student
SET
    major = 'Biology'
WHERE
    student_name = 'Mike';

SELECT * FROM student;

--@block: Additonal sample of updating data in a table
UPDATE
    student
SET
    student_name = 'Michael'
WHERE
    student_name = 'Mike';

--@block: Adding and deleting a row to a table
INSERT INTO student VALUES(1005, 'Thomas', 'Engineering');

DELETE FROM student
WHERE major = 'Engineering';

--@block: Renaming a table
ALTER TABLE
    student
RENAME TO
    freshmen;

SELECT * FROM freshmen;

--@block: Renaming it back
USE student_db;

ALTER TABLE
    freshmen
RENAME TO
    student;

SELECT * FROM student;

--@block: Querying in order
SELECT
    *
FROM
    student
ORDER BY
    student_id DESC;

--@block: Limiting results of a query
SELECT
    *
FROM
    student
ORDER BY
    student_id DESC
LIMIT 2;