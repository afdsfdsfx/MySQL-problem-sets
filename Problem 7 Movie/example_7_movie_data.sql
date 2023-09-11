-- Practice problem for data cleaning and transformation in MySQL from Google Data Analytics on Coursera

CREATE DATABASE movie_db;
USE movie_db;



--@block: Import the dataset for this problem through MySQL Workbench
USE movie_db;
SELECT
    *
FROM
    movie_table;



--@block: Practice Problem 1: Remove any whitespaces for each record on `movie_title` column

UPDATE
    movie_table
SET
    movie_title = TRIM(movie_title);



--@block: Practice Problem 2: Set the `release_date` data type to DATE
USE movie_db;

-- Note that by default, MySQL reads datetime in YYYY-MM-DD hh:mm:ss format

-- Step 1: Set the `release_date` format to YYYY-MM-DD. Note that this does not change the data type to DATE
UPDATE 
    movie_table
SET
    release_date = DATE_FORMAT(STR_TO_DATE(release_date, '%m/%d/%Y'), '%Y-%m-%d');


-- Step 2: Once successfully changed, the data type can be updated as normal
ALTER TABLE
    movie_table
MODIFY COLUMN
    release_date DATE;

DESCRIBE movie_table;



--@block: Practice Problem 3: Set blank values to NULL for the following columns: 
-- `director_1`
-- `director_2`
-- `cast_1`
-- `cast_2`
-- `cast_3`
-- `cast_4`
-- `cast_5`

-- For `director_1`, no blank values found
SELECT
    director_1
FROM
    movie_table
WHERE
    director_1 = '';


-- For `director_2`:
UPDATE
    movie_table
SET
    director_2 = NULL
WHERE
    director_2 = '';


-- For `cast_1`:
UPDATE
    movie_table
SET
    cast_1 = NULL
WHERE
    cast_1 = '';


-- For `cast_2`:
UPDATE
    movie_table
SET
    cast_2 = NULL
WHERE
    cast_2 = '';


-- For `cast_3`:
UPDATE
    movie_table
SET
    cast_3 = NULL
WHERE
    cast_3 = '';


-- For `cast_4`:
UPDATE
    movie_table
SET
    cast_4 = NULL
WHERE
    cast_4 = '';


-- For `cast_5`:
UPDATE
    movie_table
SET
    cast_5 = NULL
WHERE
    cast_5 = '';



--@block: Practice Problem 4: Change `budget` and `revenue` columns data type to DOUBLE
USE movie_db;


-- Step 1: Remove first the currency sign
UPDATE
    movie_table
SET
    budget = SUBSTRING(budget, 2);

UPDATE
    movie_table
SET
    revenue = SUBSTRING(revenue, 2);

--@block

-- Step 2: Remove the comma delimeter separating the numbers
UPDATE
    movie_table
SET
    budget = REPLACE(budget, ',', '');

UPDATE
    movie_table
SET
    revenue = REPLACE(revenue, ',', '');


--@block
-- Step 3: Change the data type to DOUBLE

ALTER TABLE
    movie_table
MODIFY COLUMN
    budget DOUBLE;

USE movie_db;

ALTER TABLE
    movie_table
MODIFY COLUMN
    revenue DOUBLE;

DESCRIBE movie_table;