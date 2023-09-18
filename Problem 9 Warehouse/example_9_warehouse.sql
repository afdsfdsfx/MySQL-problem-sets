-- Practice problem creating complex queries by Google Data Analytics on Coursera

CREATE DATABASE warehouse_db;
USE warehouse_db;



--@block: Import the dataset for this problem through MySQL Workbench
USE warehouse_db;

SELECT
    *
FROM
    warehouse_info;

SELECT
    *
FROM
    warehouse_orders;


DESCRIBE warehouse_info;
DESCRIBE warehouse_orders;



--@block: Practice Problem 1: Change the format of `order_date` and `shipper_date` in `warehouse_orders` table to YYYY-MM-DD in DATE data type
UPDATE
    warehouse_orders
SET
    order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%m/%d/%Y'), '%Y-%m-%d');


UPDATE
    warehouse_orders
SET
    shipper_date = DATE_FORMAT(STR_TO_DATE(shipper_date, '%m/%d/%Y'), '%Y-%m-%d');



--@block: Practice Problem 2: Assign `warehouse_id` and `order_id` as the PRIMARY KEY in `warehouse_info` and `warehouse_orders` tables, respectively
ALTER TABLE 
    warehouse_info
ADD
    PRIMARY KEY(warehouse_id);


ALTER TABLE 
    warehouse_orders
ADD
    PRIMARY KEY(order_id);


DESCRIBE warehouse_info;
DESCRIBE warehouse_orders;



--@block: Practice Problem 3: Assign `warehouse_id` from `warehouse_orders` table as a FOREIGN KEY to `warehouse_info` table
ALTER TABLE
    warehouse_orders
ADD
    FOREIGN KEY(warehouse_id)
        REFERENCES warehouse_info(warehouse_id)
            ON DELETE SET NULL;



--@block: Practice Problem 4: Get the total number of employees and average warehouse capacity for each states
USE warehouse_db;

SELECT
    state AS 'State',
    SUM(employee_total) AS 'Total Employees',
    AVG(maximum_capacity) AS 'Average Capacity'
FROM
    warehouse_info
GROUP BY
    state;



--@block: Practice Problem 5: Find the top 5 warehouse that have the most number of customers between January 2019 and June 2019
SELECT
    warehouse_orders.warehouse_id AS 'Warehouse ID',
    warehouse_info.warehouse_alias AS 'Warehouse',
    warehouse_info.state AS 'Location',
    COUNT(DISTINCT customer_id) AS 'No. of Customers'
FROM
    warehouse_orders
JOIN
    warehouse_info
ON
    warehouse_orders.warehouse_id = warehouse_info.warehouse_id
WHERE
    shipper_date BETWEEN '2019-01-01' AND '2019-06-30'
GROUP BY
    warehouse_orders.warehouse_id
ORDER BY
    COUNT(DISTINCT customer_id) DESC
LIMIT
    5;



--@block: Practice Problem 6: Get the total number of orders and identify if it exceeded the maximum capacity for each warehouses along with its percent share status to the total order
SELECT
    warehouse_info.warehouse_id AS 'ID',
	warehouse_info.warehouse_alias AS 'Warehouse',
    COUNT(DISTINCT customer_id) AS 'No. of Customers',
	COUNT(DISTINCT order_id) AS 'No. of Orders',
    warehouse_info.maximum_capacity AS 'Max Cap',
	IF(COUNT(DISTINCT order_id) > maximum_capacity, "Exceeded", "Available") AS 'Availability',
	CASE
		WHEN COUNT(DISTINCT order_id) = 0
			THEN "Under construction"
		WHEN COUNT(DISTINCT order_id) / (SELECT COUNT(*) FROM warehouse_orders) <= 0.2
			THEN "Fulfilled 20%"
		WHEN COUNT(DISTINCT order_id) / (SELECT COUNT(*) FROM warehouse_orders) BETWEEN 0.21 AND 0.60
			THEN "Fulfilled 21%-60%"
		ELSE "Fulfilled more than 60%"
	END AS 'Completion Percentage'
FROM
	warehouse_info
LEFT JOIN
	warehouse_orders
ON
	warehouse_info.warehouse_id = warehouse_orders.warehouse_id
GROUP BY
    warehouse_info.warehouse_id,
    warehouse_info.warehouse_alias;
