-- ================================================================
-- NAME: W6.4_PerformanceAnalysis_Indexes.sql
-- AUTHOR: Osagie George
-- DATE: 2024
-- DESCRIPTION: Performance analysis scripts demonstrating execution
--               plans and missing index recommendations
-- ================================================================

-- =================================================================
-- SCENARIO 1: Person.Person Table - Query by LastName
-- =================================================================

-- Step 1 & 2: Query with WHERE clause on unindexed character field
-- (Turn on "Include Actual Execution Plan" before running)
SELECT 
    BusinessEntityID, 
    FirstName, 
    LastName
FROM Person.Person
WHERE LastName = 'Smith';
GO

-- Step 7: Create the missing index based on recommendation
-- (Named uniquely so it does not conflict with previous attempts)
CREATE NONCLUSTERED INDEX IX_Person_LastName_Assignment 
ON Person.Person (LastName)
INCLUDE (FirstName);
GO

-- Step 8: Re-run query to verify improved performance
SELECT 
    BusinessEntityID, 
    FirstName, 
    LastName
FROM Person.Person
WHERE LastName = 'Smith';
GO

-- =================================================================
-- SCENARIO 2: Production.Product Table - Query by Color
-- =================================================================

-- Step 1 & 2: Query with WHERE clause on unindexed character field
-- (Turn on "Include Actual Execution Plan" before running)
SELECT 
    ProductID, 
    Name, 
    Color,
    ListPrice
FROM Production.Product
WHERE Color = 'Red';
GO

-- Step 7: Create the missing index based on recommendation
-- (Named uniquely so it does not conflict with previous attempts)
CREATE NONCLUSTERED INDEX IX_Product_Color_Assignment 
ON Production.Product (Color)
INCLUDE (Name, ListPrice);
GO

-- Step 8: Re-run query to verify improved performance
SELECT 
    ProductID, 
    Name, 
    Color,
    ListPrice
FROM Production.Product
WHERE Color = 'Red';
GO