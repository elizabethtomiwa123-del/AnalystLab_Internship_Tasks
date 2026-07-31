SELECT COUNT(*) AS Total_rows
FROM `chinook`.track;    


SELECT COUNT(*) AS Total_columns
FROM information_schema.columns
WHERE table_name = 'track'
AND  table_schema = 'chinook';

SELECT COUNT(CustomerId) AS Total_records,
COUNT( DISTINCT CustomerId) AS Unique_values
FROM `chinook`.customer;    

-- Top 5 Highest-Generating countries
SELECT
    BillingCountry,
    COUNT(InvoiceId) AS TotalInvoices,
    SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC
LIMIT 5;

-- High Volume Composers
SELECT 
    Composer,
    COUNT(TrackId) AS TrackCount
FROM Track
WHERE Composer IS NOT NULL
GROUP BY Composer
HAVING COUNT(TrackId) > 15
ORDER BY TrackCount DESC;

-- Average Order values
SELECT 
    COUNT(InvoiceId) AS TotalOrders,
    SUM(Total) AS GrossSales,
    ROUND(AVG(Total), 2) AS AverageOrderValue
FROM Invoice;

-- High-value customers
 SELECT 
    CustomerId,
    COUNT(InvoiceId) AS OrderCount,
    SUM(Total) AS TotalSpent
FROM Invoice
GROUP BY CustomerId
HAVING SUM(Total) > 40
ORDER BY TotalSpent DESC;

-- Pricing and Duration Analysis
 SELECT 
    TrackId,
    Name,
    Milliseconds / 60000.0 AS DurationInMinutes,
    UnitPrice
FROM Track
WHERE UnitPrice > 0.99 
  AND Milliseconds > 300000
ORDER BY Milliseconds DESC
LIMIT 5;

-- Genre Distribution
SELECT 
    GenreId,
    COUNT(TrackId) AS TotalTracks
FROM Track
GROUP BY GenreId
HAVING COUNT(TrackId) >= 50
ORDER BY TotalTracks DESC;

-- Annual Revenue Trends
 SELECT 
    YEAR(InvoiceDate) AS SalesYear,
    COUNT(InvoiceId) AS TotalOrders,
    SUM(Total) AS AnnualRevenue
FROM Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY SalesYear ASC;

-- Customer Distribution
SELECT 
    Country,
    COUNT(CustomerId) AS TotalCustomers
FROM Customer
GROUP BY Country
HAVING COUNT(CustomerId) >= 3
ORDER BY TotalCustomers DESC;

-- Identifying media format preferences
 SELECT 
    MediaTypeId,
    COUNT(TrackId) AS TotalTracks,
    ROUND(AVG(UnitPrice), 2) AS AvgPrice
FROM Track
GROUP BY MediaTypeId
ORDER BY TotalTracks DESC;

-- Checking Of Album Length
 SELECT 
    AlbumId,
    COUNT(TrackId) AS TotalTracks,
    SUM(Milliseconds) / 60000.0 AS TotalAlbumMinutes
FROM Track
GROUP BY AlbumId
HAVING COUNT(TrackId) > 15
ORDER BY TotalTracks DESC;

-- High Volume sales Period
SELECT 
    MONTH(InvoiceDate) AS SalesMonth,
    COUNT(InvoiceId) AS TotalOrders,
    SUM(Total) AS MonthlyRevenue
FROM Invoice
WHERE YEAR(InvoiceDate) = 2021
GROUP BY MONTH(InvoiceDate)
ORDER BY MonthlyRevenue DESC;


-- ADVANCED SQL CONCEPTS

-- Inner Join: List track names alongside their corresponding Album, Artist, and Genre
SELECT 
    t.TrackId,
    t.Name AS TrackName,
    a.Title AS AlbumTitle,
    ar.Name AS ArtistName,
    g.Name AS GenreName
FROM Track t
INNER JOIN Album a ON t.AlbumId = a.AlbumId
INNER JOIN Artist ar ON a.ArtistId = ar.ArtistId
INNER JOIN Genre g ON t.GenreId = g.GenreId
ORDER BY ar.Name, a.Title
LIMIT 5;

 -- Left Join: Find all artists and count their albums (including artists with 0 albums)
SELECT 
    ar.ArtistId,
    ar.Name AS ArtistName,
    COUNT(a.AlbumId) AS TotalAlbums
FROM Artist ar
LEFT JOIN Album a ON ar.ArtistId = a.ArtistId
GROUP BY ar.ArtistId, ar.Name
HAVING COUNT(a.AlbumId) = 0
ORDER BY ar.Name
LIMIT 5;

-- Right Join: List support agents and any customers assigned to them
SELECT 
    e.EmployeeId,
    e.FirstName  ' ', e.LastName AS SupportRepName,
    c.CustomerId,
    c.FirstName  ' ' , c.LastName AS CustomerName
FROM Customer c
RIGHT JOIN Employee e ON c.SupportRepId = e.EmployeeId
WHERE e.Title LIKE '%Sales%'
ORDER BY e.EmployeeId;

-- Subquery: Retrieve tracks with duration greater than the average track duration
SELECT 
    TrackId,
    Name AS TrackName,
    Milliseconds / 1000 AS DurationSeconds
FROM Track
WHERE Milliseconds > (
    SELECT AVG(Milliseconds) 
    FROM Track
)
ORDER BY Milliseconds DESC
LIMIT 5;

-- Subquery: Find customers with cumulative spending greater than $40
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Country
FROM Customer c
WHERE (
    -- Correlated subquery calculating total spent per customer
    SELECT SUM(i.Total) 
    FROM Invoice i 
    WHERE i.CustomerId = c.CustomerId
) > 40
ORDER BY c.CustomerId
LIMIT 5;


-- Window Function: Number tracks within each genre by duration using ROW_NUMBER()
WITH RankedTracks AS (
    SELECT 
        g.Name AS GenreName,
        t.Name AS TrackName,
        t.Milliseconds / 1000 AS Seconds,
        ROW_NUMBER() OVER (
            PARTITION BY g.GenreId 
            ORDER BY t.Milliseconds DESC
        ) AS RowNum
    FROM Track t
    JOIN Genre g ON t.GenreId = g.GenreId
)
SELECT 
    GenreName,
    TrackName,
    Seconds,
    RowNum
FROM RankedTracks
WHERE RowNum <= 3
ORDER BY GenreName, RowNum;

-- Window Function: Rank spending per customer partitioned by Country
WITH CustomerSpending AS (
    SELECT 
        c.Country,
        c.CustomerId,
        c.FirstName  ' ' , c.LastName AS CustomerName,
        ROUND(SUM(i.Total), 2) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.Country, c.CustomerId, CustomerName
)
SELECT 
    Country,
    CustomerName,
    TotalSpent,
    -- ROW_NUMBER gives strict sequential numbers (1, 2, 3...)
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS RowNum,
    -- RANK gives equal rank to ties and skips the next sequence number
    RANK() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS RankNum
FROM CustomerSpending
WHERE Country IN ('USA', 'Canada', 'Brazil')
ORDER BY Country, TotalSpent DESC;

-- Business Problem Solving

-- Top 5 tracks by total sales revenue
SELECT 
    t.TrackId,
    t.Name AS TrackName,
    ar.Name AS ArtistName,
    COUNT(il.InvoiceLineId) AS TotalUnitsSold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
GROUP BY t.TrackId, t.Name, ar.Name
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Top 5 customers by total spending
SELECT 
    c.CustomerId,
    c.FirstName  ' ' , c.LastName AS CustomerName,
    c.Country,
    COUNT(i.InvoiceId) AS TotalOrders,
    ROUND(SUM(i.Total), 2) AS LifetimeValue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, CustomerName, c.Country
ORDER BY LifetimeValue DESC
LIMIT 5;

 -- Monthly sales performance and cumulative track count
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS SalesMonth, -- Use TO_CHAR(InvoiceDate, 'YYYY-MM') in PostgreSQL
    COUNT(DISTINCT InvoiceId) AS TotalOrders,
    SUM(Total) AS MonthlyRevenue
FROM Invoice
GROUP BY SalesMonth
ORDER BY SalesMonth ASC
LIMIT 6;

 -- Customer purchasing habits by country
SELECT 
    c.Country,
    COUNT(DISTINCT c.CustomerId) AS TotalCustomers,
    COUNT(DISTINCT i.InvoiceId) AS TotalInvoices,
    ROUND(AVG(i.Total), 2) AS AvgOrderValue,
    ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2) AS RevenuePerCustomer
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
HAVING COUNT(DISTINCT c.CustomerId) >= 2
ORDER BY RevenuePerCustomer DESC;

