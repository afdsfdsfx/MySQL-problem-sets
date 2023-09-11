-- Practice problem for simple cleaning methods from Google Data Analytics on Coursera

CREATE DATABASE automobile_db;
USE automobile_db;



--@block: Import the dataset for this problem through MySQL Workbench

SELECT
    *
FROM
    automobile;



--@block: Step 1: Inspect the `fuel_type` column

SELECT
    fuel_type, COUNT(fuel_type) AS 'Count'
FROM
    automobile
GROUP BY
    fuel_type;



--@block: Step 2: Inspect the `length` column if the number makes sense

SELECT
    MIN(length) AS min_length,
    MAX(length) AS max_length
FROM
    automobile;



--@block: Step 3: Fill in the missing data

-- For some reason, MySQL cannot locate NULL values for column `num_of_doors`, but Google's BigQuery can. Had to check with BigQuery and the error can be found under the price of 8558 and 10795.

/*
BigQuery's query:

SELECT
    *
FROM
    automobile
WHERE
    num_of_doors IS NULL;
*/

-- MySQL's query:

SELECT
    *
FROM
    automobile
WHERE
    num_of_doors = '';

-- Blank values then must be set to `four`

UPDATE
    automobile
SET
    num_of_doors = 'four'
WHERE
    price IN(8558, 10795);



--@block: Step 4: Idenfity potential errors on `num_of_cylinders` column

SELECT
    DISTINCT num_of_cylinders
FROM
    automobile;

-- It can be seen that a typo can be found having the value of 'tow'. This must be updated to 'two'.

UPDATE
    automobile
SET
    num_of_cylinders = 'two'
WHERE
    num_of_cylinders = 'tow';



--@block: Step 5: Check for values within a certain range

-- Compression ratio should be within 7 to 23. Anything beyond 23 should be deleted.

SELECT
    *
FROM
    automobile
WHERE
    compression_ratio > 23;

-- It can be found that one column has a value of 70. After deleting this, number of records should now be 202.

DELETE FROM
    automobile
WHERE
    compression_ratio = 70;



--@block: Step 6: Trim the whitespaces on `drive_wheels` column for consistency

-- There are whitespaces for some value(s) for `drive_wheels` columns. Make sure to trim then.

SELECT
    drive_wheels,
    LENGTH(drive_wheels) AS 'Old Length'
FROM
    automobile;

-- It appears that there are values having 4 characters when it should be 3.

UPDATE
    automobile
SET
    drive_wheels = TRIM(drive_wheels);


SELECT
    drive_wheels,
    LENGTH(drive_wheels) AS 'New Length'
FROM
    automobile;



--@block: Step 7: Set the price to 20000 for the column `price` who have 0 as value.

SELECT
    *
FROM
    automobile
WHERE
    price = 0;

UPDATE
    automobile
SET
    price = 20000
WHERE
    price = 0;


