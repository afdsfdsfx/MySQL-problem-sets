-- Practice problem for simple data transformation in MySQL from Google Data Analytics on Coursera

CREATE DATABASE furniture_db;
USE furniture_db;



--@block: Import the dataset for this problem through MySQL Workbench

SELECT
    *
FROM
    furniture_table;



--@block: Rename `date` column to `transaction_date`

ALTER TABLE
    furniture_table
RENAME COLUMN
    date to transaction_date;



--@block: Change `transaction_date` data type to DATE

-- Originally, `date` column was set to TEXT and you might encounter when changing it on MySQL Workbench to DATE

-- Old schema
DESCRIBE furniture_table;

ALTER TABLE
    furniture_table
MODIFY COLUMN
    transaction_date DATE;

-- New schema after updating `transaction_date`
DESCRIBE furniture_table;



-- Another way to to change data type is through the use of CAST() function

SELECT
    CAST(transaction_date AS DATE) AS 'New Transaction Date'
FROM
    furniture_table;



--@block: Transform `product_price` and `revenue` from TEXT to DOUBLE to accomodate the decimal values.

-- Step 1: Remove the currency symbol.
-- For `product_price`:
UPDATE
    furniture_table
SET
    product_price = SUBSTRING(product_price, 2);


-- For `revenue`:
UPDATE
    furniture_table
SET
    revenue = SUBSTRING(revenue, 2);



-- Step 2: Remove the comma separator.
-- For `product_price`:
UPDATE
    furniture_table
SET
    product_price = 1000.00
WHERE
    product_price = '1,000.00';


-- For `revenue`:
UPDATE
    furniture_table
SET
    revenue = 1000.00
WHERE
    revenue = '1,000.00';

SELECT * FROM furniture_table;



-- Step 3: Change the data type to DOUBLE once consistency is ensured.
-- For `product_price`:
ALTER TABLE
    furniture_table
MODIFY COLUMN
    product_price DOUBLE;


-- For `revenue`:
ALTER TABLE
    furniture_table
MODIFY COLUMN
    revenue DOUBLE;

DESCRIBE furniture_table;



--@block: Practice Problem 1: Assuming `revenue` column does not exist, add a new column with the revenue for each row using the only the existing information

-- Create a new blank column that will hold the computed revenue
ALTER TABLE
    furniture_table
ADD 
    computed_revenue DOUBLE;


-- Compute the revenue for each row and add it to the new blank column created
UPDATE
    furniture_table
SET
    computed_revenue = (product_price * purchase_size);

SELECT
    revenue AS 'Given',
    computed_revenue AS 'Calculated'
FROM
    furniture_table;



--@block: Practice Problem 2: Create a more detailed product information by combining `product_code` and `product_color`, then get the number of items per new product information.

SELECT
	@x := CONCAT(product_code, '_', product_color) AS product_info,
	@y := COUNT(@x) AS count
FROM
	furniture_table
GROUP BY
	product_info
ORDER BY
	count DESC;



--@block: Practice Problem 3: Return the non-null values on `product` column using COALESCE(), if any, and their count

SELECT
	@a := COALESCE(product, product_code) AS product_info,
	@b := COUNT(@a) AS count
FROM
	furniture_table
GROUP BY
	product_info
ORDER BY
	count DESC;

-- It appears '' is not NULL on MySQL as also observed on Problem 5



--@block: Practice Problem 4: Example on how to use CASE statement when verifying and reporting data stored in a database

SELECT
	transaction_id,
	product_price,
		CASE
			WHEN product_price < 50 THEN 'Budget-friendly'
			WHEN product_price BETWEEN 51 AND 100 THEN 'Quality of life'
			WHEN product_price BETWEEN 101 AND 500 THEN 'Pricey'
			WHEN product_price > 501 THEN 'Luxury'
		END AS 'price_description'
FROM
    furniture_table;


