SELECT * 
FROM sales_dataset.sales_data_sample;


SELECT COUNT(*) AS Total_rows
FROM `sales_dataset`.sales_data_sample;

SELECT COUNT(*) AS Total_columns
FROM  information_schema.columns
WHERE table_name = 'sales_data_sample'
AND table_schema =  'sales_dataset';

SELECT COUNT(ORDERNUMBER) AS Total_records,
COUNT(DISTINCT ORDERNUMBER) AS Unique_records
FROM `sales_dataset`.sales_data_sample;


-- ===================================================================
-- TASK 2: CORE SQL QUERIES & AGGREGATIONS
-- Dataset: sales_dataset.sales_data_sample
-- ===================================================================


-- Retrieving line items for US customers sorted by highest sales value.
SELECT 
    ORDERNUMBER, 
    CUSTOMERNAME, 
    COUNTRY, 
    SALES, 
    ORDERDATE
FROM sales_dataset.sales_data_sample
WHERE COUNTRY = 'USA'
ORDER BY SALES DESC;

-- 2. Calculates total orders, units sold, total revenue, and average line sales.
SELECT 
    PRODUCTLINE,
    COUNT(DISTINCT ORDERNUMBER) AS TotalOrders,
    SUM(QUANTITYORDERED) AS TotalUnitsSold,
    ROUND(SUM(SALES), 2) AS TotalRevenue,
    ROUND(AVG(SALES), 2) AS AverageLineSales
FROM sales_dataset.sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY TotalRevenue DESC;


-- 3. Identifies products generating over $1,000,000 in total revenue.
SELECT 
    PRODUCTLINE,
    ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_dataset.sales_data_sample
GROUP BY PRODUCTLINE
HAVING SUM(SALES) > 1000000
ORDER BY TotalRevenue DESC;


-- 4. Summarizes order counts and revenue chronologically by Year and Quarter.
SELECT 
    YEAR_ID,
    QTR_ID,
    COUNT(DISTINCT ORDERNUMBER) AS TotalOrders,
    ROUND(SUM(SALES), 2) AS QuarterlyRevenue
FROM sales_dataset.sales_data_sample
GROUP BY YEAR_ID, QTR_ID
ORDER BY YEAR_ID ASC, QTR_ID ASC;

-- 5. Sales Performance by Order Status
SELECT 
    STATUS,
    COUNT(DISTINCT ORDERNUMBER) AS TotalOrders,
    SUM(QUANTITYORDERED) AS TotalUnits,
    ROUND(SUM(SALES), 2) AS TotalRevenue,
    ROUND((SUM(SALES) / (SELECT SUM(SALES) FROM sales_dataset.sales_data_sample)) * 100, 2) AS SalesPercentage
FROM sales_dataset.sales_data_sample
GROUP BY STATUS
ORDER BY TotalRevenue DESC;


-- 6. Peak Revenue Year (Year with Most Sales)
SELECT 
    YEAR_ID,
    COUNT(DISTINCT ORDERNUMBER) AS TotalOrders,
    SUM(QUANTITYORDERED) AS TotalUnitsSold,
    ROUND(SUM(SALES), 2) AS AnnualRevenue,
    ROUND(AVG(SALES), 2) AS AverageLineSales
FROM sales_dataset.sales_data_sample
GROUP BY YEAR_ID
ORDER BY AnnualRevenue DESC;


-- TASK 3: ADVANCED SQL CONCEPTS
-- Self-Joins, Subqueries, and Window Functions

-- 1. SELF-JOIN: Identify Customers Placing Multiple Orders
SELECT DISTINCT
    a.CUSTOMERNAME,
    a.ORDERNUMBER AS First_Order_Number,
    a.ORDERDATE AS First_Order_Date,
    b.ORDERNUMBER AS Subsequent_Order_Number,
    b.ORDERDATE AS Subsequent_Order_Date
FROM sales_dataset.sales_data_sample a
INNER JOIN sales_dataset.sales_data_sample b 
    ON a.CUSTOMERNAME = b.CUSTOMERNAME 
    AND a.ORDERNUMBER < b.ORDERNUMBER
ORDER BY a.CUSTOMERNAME, First_Order_Date;


-- 2. SCALAR SUBQUERY: Line Items Above Global Average Sale Amount
-- Calculates the overall company sales average in a subquery and returns 
-- only those individual line transactions that exceed that average benchmark.
SELECT 
    ORDERNUMBER,
    CUSTOMERNAME,
    PRODUCTLINE,
    SALES
FROM sales_dataset.sales_data_sample
WHERE SALES > (
    SELECT AVG(SALES) 
    FROM sales_dataset.sales_data_sample
)
ORDER BY SALES DESC;

-- 3. CORRELATED SUBQUERY: Top Record per Product Line
-- Evaluates row-by-row to isolate the exact order line that recorded 
-- the maximum sales value within its specific product line category.
SELECT 
    s.ORDERNUMBER,
    s.PRODUCTLINE,
    s.CUSTOMERNAME,
    s.SALES
FROM sales_dataset.sales_data_sample s
WHERE s.SALES = (
    -- Subquery: Finds the maximum sale value specific to matching product line
    SELECT MAX(sub.SALES)
    FROM sales_dataset.sales_data_sample sub
    WHERE sub.PRODUCTLINE = s.PRODUCTLINE
)
ORDER BY s.PRODUCTLINE;


-
-- 4. WINDOW FUNCTIONS: Ranking Sales within Product Categories
-- Demonstrates ROW_NUMBER(), RANK(), and DENSE_RANK() using PARTITION BY.
SELECT 
    PRODUCTLINE,
    ORDERNUMBER,
    CUSTOMERNAME,
    SALES,
    -- Unique sequential number per product category
    ROW_NUMBER() OVER (
        PARTITION BY PRODUCTLINE 
        ORDER BY SALES DESC
    ) AS Row_Num,
    
    -- Rank with gaps when identical sales values occur
    RANK() OVER (
        PARTITION BY PRODUCTLINE 
        ORDER BY SALES DESC
    ) AS Sales_Rank,
    
    -- Consecutive rank without skipping numbers on ties
    DENSE_RANK() OVER (
        PARTITION BY PRODUCTLINE 
        ORDER BY SALES DESC
    ) AS Sales_Dense_Rank
FROM sales_dataset.sales_data_sample
ORDER BY PRODUCTLINE, Sales_Rank;


-- 5. WINDOW FUNCTION + CTE: Top 3 Highest Sales per Product Line
-- Uses a Common Table Expression (CTE) to filter window function output 
-- and retrieve only the top 3 highest revenue lines per product category.
WITH RankedSales AS (
    SELECT 
	 PRODUCTLINE,
     ORDERNUMBER,
        CUSTOMERNAME,
        SALES,
        ROW_NUMBER() OVER (
            PARTITION BY PRODUCTLINE 
            ORDER BY SALES DESC
        ) AS CategoryRank
    FROM sales_dataset.sales_data_sample
)
SELECT 
    PRODUCTLINE,
    CategoryRank,
    ORDERNUMBER,
    CUSTOMERNAME,
    SALES
FROM RankedSales
WHERE CategoryRank <= 3
ORDER BY PRODUCTLINE, CategoryRank;


-- TASK 4: BUSINESS PROBLEM SOLVING
-- Goal: Answer key business questions regarding performance & behavior

-- QUESTION 1A: TOP-PERFORMING PRODUCTS (by Revenue & Units Sold)
-- Identifies the highest grossing product lines and individual products.
-- -------------------------------------------------------------------
SELECT 
    PRODUCTLINE,
    COUNT(DISTINCT ORDERNUMBER) AS Total_Orders,
    SUM(QUANTITYORDERED) AS Total_Units_Sold,
    ROUND(SUM(SALES), 2) AS Total_Revenue,
    ROUND(AVG(SALES), 2) AS Avg_Line_Sales
FROM sales_dataset.sales_data_sample
WHERE STATUS = 'Shipped'
GROUP BY PRODUCTLINE
ORDER BY Total_Revenue DESC;


-- QUESTION 1B: TOP-PERFORMING CUSTOMERS (Customer Lifetime Value - LTV)
-- Ranks top 10 customers by total realized revenue and order frequency.
SELECT 
    CUSTOMERNAME,
    COUNTRY,
    COUNT(DISTINCT ORDERNUMBER) AS Lifetime_Orders,
    SUM(QUANTITYORDERED) AS Total_Units_Purchased,
    ROUND(SUM(SALES), 2) AS Lifetime_Revenue
FROM sales_dataset.sales_data_sample
WHERE STATUS = 'Shipped'
GROUP BY CUSTOMERNAME, COUNTRY
ORDER BY Lifetime_Revenue DESC
LIMIT 10;


-- QUESTION 2: REVENUE TRENDS OVER TIME (Yearly & Monthly Growth)
SELECT 
    YEAR_ID,
    MONTH_ID,
    COUNT(DISTINCT ORDERNUMBER) AS Monthly_Orders,
    SUM(QUANTITYORDERED) AS Units_Sold,
    ROUND(SUM(SALES), 2) AS Monthly_Revenue
FROM sales_dataset.sales_data_sample
WHERE STATUS = 'Shipped'
GROUP BY YEAR_ID, MONTH_ID
ORDER BY Monthly_Revenue DESC;

-- QUESTION 3A: CUSTOMER PURCHASING BEHAVIOR (Recency, Frequency, Value)
SELECT 
    CUSTOMERNAME,
    DEALSIZE,
    COUNT(DISTINCT ORDERNUMBER) AS Orders_Count,
    ROUND(AVG(QUANTITYORDERED), 0) AS Avg_Units_Per_Order,
    ROUND(AVG(SALES), 2) AS Avg_Order_Line_Value,
    ROUND(SUM(SALES), 2) AS Total_Spend
FROM sales_dataset.sales_data_sample
GROUP BY CUSTOMERNAME, DEALSIZE
ORDER BY Total_Spend DESC;


-- QUESTION 3B: REVENUE LEAKAGE & ORDER STATUS BEHAVIOR
SELECT 
    STATUS,
    COUNT(DISTINCT ORDERNUMBER) AS Total_Orders,
    ROUND(SUM(SALES), 2) AS Status_Revenue,
    ROUND(
        (SUM(SALES) / (SELECT SUM(SALES) FROM sales_dataset.sales_data_sample)) * 100, 
        2
    ) AS Pct_Of_Total_Revenue
FROM sales_dataset.sales_data_sample
GROUP BY STATUS
ORDER BY Status_Revenue DESC;