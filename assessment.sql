CREATE DATABASE bank_db;
USE bank_db;

CREATE TABLE Bank (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(100) NOT NULL
);

CREATE TABLE Account_Holder (
    account_holder_id INT PRIMARY KEY,
    account_no VARCHAR(20) UNIQUE NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    contact VARCHAR(15),
    date_of_account_created DATE,
    account_status VARCHAR(20) CHECK (account_status IN ('Active', 'Terminated')),
    account_type VARCHAR(50),
    balance DECIMAL(12,2)
);

CREATE TABLE Loan (
    loan_no INT PRIMARY KEY,
    branch_id INT,
    account_holder_id INT,
    loan_amount DECIMAL(12,2),
    loan_type VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES Bank(branch_id),
    FOREIGN KEY (account_holder_id) REFERENCES Account_Holder(account_holder_id)
);

INSERT INTO Bank
(branch_id, branch_name, branch_city) 
VALUES
(1, 'Main Branch', 'Ahemdabad'),
(2, 'City Branch', 'Mehsana'),
(3, 'Town Branch', 'Ahemdabad');

SELECT * FROM bank;

INSERT INTO Account_Holder 
(account_holder_id, account_no, account_holder_name, city, contact, date_of_account_created, account_status, account_type, balance)
VALUES
(101, 'A', 'Priyal Solanki', 'Ahemdabad', '9876543210', '2023-07-10', 'Active', 'Savings', 5000.00),
(102, 'B', 'Riya Mehta', 'Ahemdabad', '9876500000', '2023-07-20', 'Active', 'Current', 3000.00),
(103, 'C', 'Karan Joshi', 'Mehsana', '9876511111', '2023-08-05', 'Active', 'Savings', 8000.00);

SELECT * FROM account_holder;

INSERT INTO Loan
(loan_no, branch_id, account_holder_id, loan_amount, loan_type) 
VALUES
(201, 1, 101, 20000.00, 'Home Loan'),
(202, 2, 103, 15000.00, 'Car Loan');

SELECT * FROM loan;

START TRANSACTION;

UPDATE Account_Holder
SET balance = balance - 100
WHERE account_no = 'A';

UPDATE Account_Holder
SET balance = balance + 100
WHERE account_no = 'B';

COMMIT;

SELECT *
FROM Account_Holder ah1
WHERE EXISTS (
    SELECT 1
    FROM Account_Holder ah2
    WHERE ah1.city = ah2.city
      AND ah1.account_holder_id <> ah2.account_holder_id
);

SELECT account_no, account_holder_name
FROM Account_Holder
WHERE DAY(date_of_account_created) > 15;

SELECT branch_city, COUNT(branch_id) AS Count_Branch
FROM Bank
GROUP BY branch_city;

SELECT ah.account_holder_id,
       ah.account_holder_name,
       l.branch_id,
       l.loan_amount
FROM Account_Holder ah
JOIN Loan l ON ah.account_holder_id = l.account_holder_id;

drop database bank_db;