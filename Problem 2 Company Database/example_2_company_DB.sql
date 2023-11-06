--@block: Create database
CREATE DATABASE company_db;

--@block: Using the database created
USE company_db;

--@block: Create required table as normal
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL                                    -- Adding foreign key immediately so that manager_id will be 'connected' with employee_id's value
);

--@block: Adding foreign keys

ALTER TABLE employee ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;        -- Now that branch table exists, employee's branch_id column can be reference with branch table's branch_id
ALTER TABLE employee ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;          -- Employee table's supervisor_id can now be reference with employee_id to establish relationship

--@block: Adding the rest of the tables

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

--@block: Employee and Branch tables

-- Corporate branch

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);            -- David Wallace's branch ID must be set to NULL first since there is no existing branch ID of 1 from the branch table
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');                                           -- Insert branch ID 1 'Corporate'

UPDATE employee                                                                                         -- Now that branch ID 1 exists, update the branch ID for David Wallace
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);                 -- Jan Levinson can be added as normal since branch ID 1 already exists

--@block: Scranton branch

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);              -- Michael Scott's branch ID must be set to NULL as well branch ID 2 does not exists yet
INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');                                            -- Insert branch ID 2 'Scranton'

UPDATE employee                                                                                         -- Update Michael Scott's branch ID now that branch ID 2 has been inserted
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);                 -- Angela Martin, Kelly Kapoor and Stanley Hudson's data can be added as normal since branch ID 2 now exists  
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

--@block: Stamford branch

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);                -- Repeat the same procedure like the previous branches
INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

--@block: Branch Supplier table

INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

--@block: Client table

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

--@block: Works_with table

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


--@block: Find the names of all employees who have sold over 30,000 to a single client 
USE company_db;

SELECT
  employee.emp_id AS 'EID', employee.first_name AS 'First Name', employee.last_name AS 'Last Name'
FROM
  employee
WHERE
  employee.emp_id IN (
    SELECT
      works_with.emp_id
    FROM
      works_with
    WHERE
      total_sales > 30000
  );


--@block: Find all clients who are handled by the branch that Michael Scott manages. Assuming you know Michael's ID (102)
SELECT
  client.client_id AS 'ID', client.client_name AS 'Client'
FROM
  client
WHERE
  client.branch_id IN (
    SELECT
      branch.branch_id
    FROM
      branch
    WHERE
      branch.mgr_id = 102
);


--@block: Find all clients who are handled by the branch that Michael Scott manages. Assuming you don't know Michael Scott's ID

SELECT
  client_id, client.client_name
FROM
  client
WHERE
  client.branch_id = (
  SELECT
    branch.branch_id
  FROM
    branch
  WHERE
    branch.mgr_id = (
      SELECT
        employee.emp_id
      FROM
        employee
      WHERE
        first_name = "Michael" AND last_name = "Scott"
  )
);