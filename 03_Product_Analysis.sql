-- ==========================================
-- Retail Analytics SQL Project
-- File: 03_Product_Analysis.sql
-- ==========================================

USE Retail_Analytics;

-- Step 1: Top 10 Best Selling Products

SELECT
    p.ProductID,
    p.ProductName,
    SUM(s.QuantityPurchased) AS Total_Quantity_Sold
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- Step 2: Top 10 Revenue Generating Products

SELECT
    p.ProductID,
    p.ProductName,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Step 3: Category-wise Revenue

SELECT
    p.Category,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS Total_Revenue
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;

-- Step 4: Category-wise Quantity Sold

SELECT
    p.Category,
    SUM(s.QuantityPurchased) AS Total_Quantity_Sold
FROM sales_transaction_clean s
JOIN product_inventory p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Total_Quantity_Sold DESC;

-- Step 5: Low Stock Products

SELECT
    ProductID,
    ProductName,
    Category,
    StockLevel
FROM product_inventory
WHERE StockLevel < 20
ORDER BY StockLevel ASC;

-- Step 6: Out-of-Stock Products

SELECT
    ProductID,
    ProductName,
    Category,
    StockLevel
FROM product_inventory
WHERE StockLevel = 0;