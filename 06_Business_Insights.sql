-- ==========================================
-- Retail Analytics SQL Project
-- File: 06_Business_Insights.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Highest Revenue Category

SELECT
    p.Category,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Step 2: Category Performance Summary

SELECT
    p.Category,
    SUM(s.QuantityPurchased) AS Total_Units_Sold,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;