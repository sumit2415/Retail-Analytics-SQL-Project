-- ==========================================================
-- Retail Analytics SQL Project
-- File: 00_Database_Setup.sql
-- Description: Database creation and initial setup
-- ==========================================================

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS Retail_Analytics;

-- Step 2: Select Database
USE Retail_Analytics;

-- Step 3: Verify Current Database
SELECT DATABASE();

-- Step 4: Display Available Tables
SHOW TABLES;

-- Step 5: View Table Structures
DESC customer_profiles;
DESC product_inventory;
DESC sales_transaction;