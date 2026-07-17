-- ==========================================
-- Retail Analytics SQL Project
-- File: 05_Sales_Trend.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Monthly Revenue Trend

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

-- Step 2: Monthly Number of Transactions

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

-- Step 3: Average Monthly Revenue

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

-- Step 4: Highest Revenue Month

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

-- Step 5: Lowest Revenue Month

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