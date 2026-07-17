-- ==========================================
-- Retail Analytics SQL Project
-- File: 04_Customer_Analysis.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Top 10 Customers by Revenue

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

-- Step 2: Repeat Customers

SELECT
    CustomerID,
    COUNT(TransactionID) AS Total_Transactions
FROM sales_transaction_clean
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 1
ORDER BY Total_Transactions DESC;

-- Step 3: Average Spending Per Customer

SELECT
    ROUND(AVG(Customer_Spending), 2) AS Average_Spending_Per_Customer
FROM (
    SELECT
        CustomerID,
        SUM(QuantityPurchased * Price) AS Customer_Spending
    FROM sales_transaction_clean
    GROUP BY CustomerID
) AS CustomerTotals;

-- Step 4: Top Customers by Number of Transactions

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

-- Step 5: Customer Distribution by Gender

SELECT
    Gender,
    COUNT(CustomerID) AS Total_Customers
FROM customer_profiles
GROUP BY Gender;

-- Step 6: Customer Distribution by Location

SELECT
    Location,
    COUNT(CustomerID) AS Total_Customers
FROM customer_profiles
GROUP BY Location
ORDER BY Total_Customers DESC;