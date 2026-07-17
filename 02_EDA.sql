-- ==========================================
-- Retail Analytics SQL Project
-- File: 02_EDA.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Total Transactions

SELECT COUNT(*) AS Total_Transactions
FROM sales_transaction_clean;

-- Step 2: Total Unique Customers

SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM sales_transaction_clean;

-- Step 3: Total Unique Products Sold

SELECT COUNT(DISTINCT ProductID) AS Total_Products_Sold
FROM sales_transaction_clean;

-- Step 4: Total Revenue

SELECT ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue
FROM sales_transaction_clean;

-- Step 5: Average Transaction Value

SELECT ROUND(AVG(QuantityPurchased * Price), 2) AS Avg_Transaction_Value
FROM sales_transaction_clean;

-- Step 6: Total Units Sold

SELECT SUM(QuantityPurchased) AS Total_Units_Sold
FROM sales_transaction_clean;

-- Step 7: Overall Dataset Summary

SELECT
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    COUNT(DISTINCT ProductID) AS Unique_Products,
    SUM(QuantityPurchased) AS Total_Units_Sold,
    ROUND(SUM(QuantityPurchased * Price), 2) AS Total_Revenue,
    ROUND(AVG(QuantityPurchased * Price), 2) AS Avg_Transaction_Value
FROM sales_transaction_clean;