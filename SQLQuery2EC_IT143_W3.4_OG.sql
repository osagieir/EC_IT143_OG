/******************************************************************************
File:        EC_IT143_W3.4_OS.sql
Author:      osagie george
Class:       IT 143
Assignment:  W3.4 Adventure Works—Create Answers
Database:    AdventureWorks2022
Created:     2026-03-19

Description:
This script answers 8 user questions using the AdventureWorks sample database.
The questions were selected from classmates' discussion posts and include:
- 2 Business User questions — Marginal complexity
- 2 Business User questions — Moderate complexity
- 2 Business User questions — Increased complexity
- 2 Metadata questions using INFORMATION_SCHEMA views

Runtime estimate:
Approximately 10–20 seconds depending on system performance.

******************************************************************************/

USE AdventureWorks2022;
GO

SET NOCOUNT ON;
GO

/*===========================================================
Q1 - Business User Question — Marginal Complexity
Original Author: Blessing Elileojo Omage
Question: Which product sold the most?
===========================================================*/
SELECT TOP (1)
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY
    TotalQuantitySold DESC,
    p.Name;
GO

/*===========================================================
Q2 - Business User Question — Marginal Complexity
Original Author: Victor Chinyere Iwuoha
Question: What are the top five most expensive products by list price?
===========================================================*/
SELECT TOP (5)
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice
FROM Production.Product AS p
ORDER BY
    p.ListPrice DESC,
    p.Name;
GO

/*===========================================================
Q3 - Business User Question — Moderate Complexity
Original Author: Christopher Jerome
Question: Which product categories generated the highest total sales revenue?
===========================================================*/
SELECT
    pc.Name AS ProductCategory,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18, 2)) AS TotalSalesRevenue
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name
ORDER BY
    TotalSalesRevenue DESC,
    pc.Name;
GO

/*===========================================================
Q4 - Business User Question — Moderate Complexity
Original Author: Shadi Maria jamjam
Question: What is the average order quantity for each product subcategory in 2014?
===========================================================*/
SELECT
    ps.Name AS ProductSubcategory,
    CAST(AVG(CAST(sod.OrderQty AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS AverageOrderQuantity
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE YEAR(soh.OrderDate) = 2014
GROUP BY
    ps.Name
ORDER BY
    AverageOrderQuantity DESC,
    ps.Name;
GO

/*===========================================================
Q5 - Business User Question — Increased Complexity
Original Author: Victor Chinyere Iwuoha
Question: I need insight into seasonal sales trends for road bikes.
Can you show monthly sales totals for road bikes in 2013, including
quantity sold, total revenue, and average unit price?
===========================================================*/
SELECT
    YEAR(soh.OrderDate) AS SalesYear,
    MONTH(soh.OrderDate) AS SalesMonthNumber,
    DATENAME(MONTH, soh.OrderDate) AS SalesMonth,
    SUM(sod.OrderQty) AS QuantitySold,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18, 2)) AS TotalRevenue,
    CAST(AVG(sod.UnitPrice) AS DECIMAL(18, 2)) AS AverageUnitPrice
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE YEAR(soh.OrderDate) = 2013
  AND ps.Name = 'Road Bikes'
GROUP BY
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate)
ORDER BY
    SalesYear,
    SalesMonthNumber;
GO

/*===========================================================
Q6 - Business User Question — Increased Complexity
Original Author: Davidson Charles
Question: I need to understand our sales performance by territory.
Can you show me the top 10 regions ranked by total purchase amount,
including the number of orders and total revenue for each region?
===========================================================*/
SELECT TOP (10)
    st.Name AS Region,
    COUNT(soh.SalesOrderID) AS NumberOfOrders,
    CAST(SUM(soh.TotalDue) AS DECIMAL(18, 2)) AS TotalRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name
ORDER BY
    TotalRevenue DESC,
    st.Name;
GO

/*===========================================================
Q7 - Metadata Question
Original Author: Edgar Estrada
Question: Which tables in AdventureWorks contain a column named CustomerID
using INFORMATION_SCHEMA?
===========================================================*/
SELECT
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.COLUMN_NAME = 'CustomerID'
ORDER BY
    c.TABLE_SCHEMA,
    c.TABLE_NAME;
GO

/*===========================================================
Q8 - Metadata Question
Original Author: Blessing Elileojo Omage
Question: How many tables are in AdventureWorks?
===========================================================*/
SELECT
    COUNT(*) AS TotalTables
FROM INFORMATION_SCHEMA.TABLES AS t
WHERE t.TABLE_TYPE = 'BASE TABLE';
GO