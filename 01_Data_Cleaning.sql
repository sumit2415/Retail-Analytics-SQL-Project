-- ==========================================
-- Retail Analytics SQL Project
-- File: 01_Data_Cleaning.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Rename Tables

ALTER TABLE `customer_profiles-1-1714027410`
RENAME TO customer_profiles;

ALTER TABLE `product_inventory-1-1714027438`
RENAME TO product_inventory;

ALTER TABLE `sales_transaction-1714027462`
RENAME TO sales_transaction;

-- Check Table Structure

DESC customer_profiles;
DESC product_inventory;
DESC sales_transaction;

-- Step 2: Rename Columns

ALTER TABLE sales_transaction
RENAME COLUMN `ï»¿TransactionID` TO TransactionID;

ALTER TABLE product_inventory
RENAME COLUMN `ï»¿ProductID` TO ProductID;

ALTER TABLE customer_profiles
RENAME COLUMN `ï»¿CustomerID` TO CustomerID;

-- Step 3: Check NULL Values

SELECT *
FROM customer_profiles
WHERE CustomerID IS NULL
   OR Age IS NULL
   OR Gender IS NULL
   OR Location IS NULL
   OR JoinDate IS NULL;

SELECT *
FROM product_inventory
WHERE ProductID IS NULL
   OR ProductName IS NULL
   OR Category IS NULL
   OR StockLevel IS NULL
   OR Price IS NULL;

SELECT *
FROM sales_transaction
WHERE TransactionID IS NULL
   OR CustomerID IS NULL
   OR ProductID IS NULL
   OR QuantityPurchased IS NULL
   OR TransactionDate IS NULL
   OR Price IS NULL;

-- Step 4: Check Duplicate Records

SELECT CustomerID,
       COUNT(*) AS Record_Count
FROM customer_profiles
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT ProductID,
       COUNT(*) AS Record_Count
FROM product_inventory
GROUP BY ProductID
HAVING COUNT(*) > 1;

SELECT TransactionID,
       COUNT(*) AS Record_Count
FROM sales_transaction
GROUP BY TransactionID
HAVING COUNT(*) > 1;

-- View Duplicate Rows

SELECT *
FROM sales_transaction
WHERE TransactionID IN (4999, 5000);

-- Step 5: Create Backup Table

CREATE TABLE sales_transaction_backup AS
SELECT *
FROM sales_transaction;

-- Step 6: Identify Duplicate Records

WITH duplicate_cte AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY TransactionID,
                            CustomerID,
                            ProductID,
                            QuantityPurchased,
                            TransactionDate,
                            Price
               ORDER BY TransactionID
           ) AS rn
    FROM sales_transaction
)

SELECT *
FROM duplicate_cte
WHERE rn > 1;

-- Step 7: Remove Duplicates

CREATE TABLE sales_transaction_clean AS
SELECT DISTINCT *
FROM sales_transaction;

-- Check Total Rows

SELECT COUNT(*) AS Total_Rows
FROM sales_transaction_clean;

-- Step 8: Check Invalid Values

-- Quantity should be greater than 0

SELECT *
FROM sales_transaction_clean
WHERE QuantityPurchased <= 0;

-- Price should be greater than 0

SELECT *
FROM product_inventory
WHERE Price <= 0;

-- Stock should not be negative

SELECT *
FROM product_inventory
WHERE StockLevel < 0;

-- Step 9: Check and Convert Date Format

SELECT DISTINCT TransactionDate
FROM sales_transaction_clean
LIMIT 10;

SELECT DISTINCT JoinDate
FROM customer_profiles
LIMIT 10;

ALTER TABLE sales_transaction_clean
MODIFY COLUMN TransactionDate DATE;

DESC sales_transaction_clean;

ALTER TABLE customer_profiles
MODIFY COLUMN JoinDate DATE;

DESC customer_profiles;

-- Step 10: Check Referential Integrity

SELECT s.CustomerID
FROM sales_transaction_clean s
LEFT JOIN customer_profiles c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT s.ProductID
FROM sales_transaction_clean s
LEFT JOIN product_inventory p
ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;