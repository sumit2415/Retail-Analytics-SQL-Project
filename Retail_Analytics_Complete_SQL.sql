/*
==========================================================
                Retail Analytics SQL Project
==========================================================

Description:
This project demonstrates the use of SQL for retail sales
data analysis. It includes database setup, data cleaning,
exploratory data analysis (EDA), product performance analysis,
customer analysis, sales trend analysis, and business insights.

Tools Used:
- MySQL Workbench
- SQL

==========================================================
*/
-- ==========================================================
-- Complete SQL Script
-- ==========================================================

-- ----------------------------------------------------------
-- Step 1: Database Setup
-- ----------------------------------------------------------

-- Create Database

CREATE DATABASE IF NOT EXISTS Retail_Analytics;

-- Select Database

USE Retail_Analytics;

-- Verify Current Database

SELECT DATABASE();

-- Display Available Tables

SHOW TABLES;

-- View Table Structure

DESC customer_profiles;
DESC product_inventory;
DESC sales_transaction;
-- ----------------------------------------------------------
-- Step 2: Data Cleaning
-- ----------------------------------------------------------

-- Rename Tables

ALTER TABLE `customer_profiles-1-1714027410`
RENAME TO customer_profiles;

ALTER TABLE `product_inventory-1-1714027438`
RENAME TO product_inventory;

ALTER TABLE `sales_transaction-1714027462`
RENAME TO sales_transaction;

-- View Table Structure

DESC customer_profiles;
DESC product_inventory;
DESC sales_transaction;

-- Rename Columns

ALTER TABLE sales_transaction
RENAME COLUMN `ï»¿TransactionID` TO TransactionID;

ALTER TABLE product_inventory
RENAME COLUMN `ï»¿ProductID` TO ProductID;

ALTER TABLE customer_profiles
RENAME COLUMN `ï»¿CustomerID` TO CustomerID;

-- Check for NULL Values

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

-- Check for Duplicate Records

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

-- View Duplicate Transactions

SELECT *
FROM sales_transaction
WHERE TransactionID IN (4999, 5000);

-- Create Backup Table

CREATE TABLE sales_transaction_backup AS
SELECT *
FROM sales_transaction;

-- Identify Duplicate Records

WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
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

-- Remove Duplicate Records

CREATE TABLE sales_transaction_clean AS
SELECT DISTINCT *
FROM sales_transaction;

-- Verify Duplicate Removal

SELECT COUNT(*)
FROM sales_transaction_clean;

-- Validate Quantity Values

SELECT *
FROM sales_transaction_clean
WHERE QuantityPurchased <= 0;

-- Validate Product Price

SELECT *
FROM product_inventory
WHERE Price <= 0;

-- Validate Stock Level

SELECT *
FROM product_inventory
WHERE StockLevel < 0;

-- Check Date Format

SELECT DISTINCT TransactionDate
FROM sales_transaction_clean
LIMIT 10;

SELECT DISTINCT JoinDate
FROM customer_profiles
LIMIT 10;

-- Convert Date Columns

ALTER TABLE sales_transaction_clean
MODIFY COLUMN TransactionDate DATE;

DESC sales_transaction_clean;

ALTER TABLE customer_profiles
MODIFY COLUMN JoinDate DATE;

DESC customer_profiles;

-- Verify Referential Integrity (Customers)

SELECT s.CustomerID
FROM sales_transaction_clean s
LEFT JOIN customer_profiles c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- Verify Referential Integrity (Products)

SELECT s.ProductID
FROM sales_transaction_clean s
LEFT JOIN product_inventory p
ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- ----------------------------------------------------------
-- Step 3: Exploratory Data Analysis (EDA)
-- ----------------------------------------------------------

-- Total Transactions

SELECT COUNT(*) AS Total_Transactions
FROM sales_transaction_clean;

-- Total Unique Customers

SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM sales_transaction_clean;

-- Total Unique Products Sold

SELECT COUNT(DISTINCT ProductID) AS Total_Products_Sold
FROM sales_transaction_clean;

-- Total Revenue

SELECT ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue
FROM sales_transaction_clean;

-- Average Transaction Value

SELECT ROUND(AVG(QuantityPurchased * Price), 2) AS Avg_Transaction_Value
FROM sales_transaction_clean;

-- Total Units Sold

SELECT SUM(QuantityPurchased) AS Total_Units_Sold
FROM sales_transaction_clean;

-- Overall Dataset Summary

SELECT
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    COUNT(DISTINCT ProductID) AS Unique_Products,
    SUM(QuantityPurchased) AS Total_Units_Sold,
    ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue,
    ROUND(AVG(QuantityPurchased * Price), 2) AS Avg_Transaction_Value
FROM sales_transaction_clean;

-- ----------------------------------------------------------
-- Step 4: Product Performance Analysis
-- ----------------------------------------------------------

-- Top 10 Best Selling Products

SELECT
    p.ProductID,
    p.ProductName,
    SUM(s.QuantityPurchased) AS Total_Quantity_Sold
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- Top 10 Revenue Generating Products

SELECT
    p.ProductID,
    p.ProductName,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Category-wise Revenue

SELECT
    p.Category,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;

-- Category-wise Quantity Sold

SELECT
    p.Category,
    SUM(s.QuantityPurchased) AS Total_Quantity_Sold
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Quantity_Sold DESC;

-- Low Stock Products

SELECT
    ProductID,
    ProductName,
    Category,
    StockLevel
FROM product_inventory
WHERE StockLevel < 20
ORDER BY StockLevel ASC;

-- Out-of-Stock Products

SELECT
    ProductID,
    ProductName,
    Category,
    StockLevel
FROM product_inventory
WHERE StockLevel = 0;

-- ----------------------------------------------------------
-- Step 5: Customer Analysis
-- ----------------------------------------------------------

-- Top 10 Customers by Revenue

SELECT
    c.CustomerID,
    c.Age,
    c.Gender,
    c.Location,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Spent
FROM sales_transaction_clean s
JOIN customer_profiles c
ON s.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.Age,
    c.Gender,
    c.Location
ORDER BY Total_Spent DESC
LIMIT 10;

-- Repeat Customers

SELECT
    CustomerID,
    COUNT(TransactionID) AS Total_Transactions
FROM sales_transaction_clean
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 1
ORDER BY Total_Transactions DESC;

-- Average Spending Per Customer

SELECT
    ROUND(AVG(Customer_Spending), 2) AS Average_Spending_Per_Customer
FROM (
    SELECT
        CustomerID,
        SUM(QuantityPurchased * Price) AS Customer_Spending
    FROM sales_transaction_clean
    GROUP BY CustomerID
) AS CustomerTotals;

-- Top Customers by Number of Transactions

SELECT
    c.CustomerID,
    c.Age,
    c.Gender,
    c.Location,
    COUNT(s.TransactionID) AS Total_Transactions
FROM sales_transaction_clean s
JOIN customer_profiles c
ON s.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.Age,
    c.Gender,
    c.Location
ORDER BY Total_Transactions DESC
LIMIT 10;

-- Customer Distribution by Gender

SELECT
    Gender,
    COUNT(CustomerID) AS Total_Customers
FROM customer_profiles
GROUP BY Gender;

-- Customer Distribution by Location

SELECT
    Location,
    COUNT(CustomerID) AS Total_Customers
FROM customer_profiles
GROUP BY Location
ORDER BY Total_Customers DESC;

-- ----------------------------------------------------------
-- Step 6: Sales Trend Analysis
-- ----------------------------------------------------------

-- Monthly Revenue Trend

SELECT
    YEAR(TransactionDate) AS Year,
    MONTH(TransactionDate) AS Month,
    ROUND(SUM(QuantityPurchased * Price), 2) AS Monthly_Revenue
FROM sales_transaction_clean
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Year,
    Month;

-- Monthly Number of Transactions

SELECT
    YEAR(TransactionDate) AS Year,
    MONTH(TransactionDate) AS Month,
    COUNT(TransactionID) AS Total_Transactions
FROM sales_transaction_clean
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Year,
    Month;

-- Average Monthly Revenue

SELECT
    ROUND(AVG(Monthly_Revenue), 2) AS Average_Monthly_Revenue
FROM (
    SELECT
        YEAR(TransactionDate) AS Year,
        MONTH(TransactionDate) AS Month,
        SUM(QuantityPurchased * Price) AS Monthly_Revenue
    FROM sales_transaction_clean
    GROUP BY
        YEAR(TransactionDate),
        MONTH(TransactionDate)
) AS MonthlySales;

-- Highest Revenue Month

SELECT
    YEAR(TransactionDate) AS Year,
    MONTH(TransactionDate) AS Month,
    ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue
FROM sales_transaction_clean
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Total_Revenue DESC
LIMIT 1;

-- Lowest Revenue Month

SELECT
    YEAR(TransactionDate) AS Year,
    MONTH(TransactionDate) AS Month,
    ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue
FROM sales_transaction_clean
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Total_Revenue ASC
LIMIT 1;

-- ----------------------------------------------------------
-- Step 7: Business Insights
-- ----------------------------------------------------------

-- Highest Revenue Category

SELECT
    p.Category,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Category Performance Summary

SELECT
    p.Category,
    SUM(s.QuantityPurchased) AS Total_Units_Sold,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;


-- ==========================================================
-- End of Retail Analytics SQL Project
-- ==========================================================