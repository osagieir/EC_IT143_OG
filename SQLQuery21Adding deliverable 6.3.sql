-- =============================================
-- EC_IT143_6.3 - USER DEFINED FUNCTIONS AND TRIGGERS
-- COMPLETE MASTER SCRIPT - FIXED VERSION
-- Author: Osagie George
-- Date: 2024-04-10
-- Description: All scripts for Fun with Functions and Fun with Triggers
-- 
-- =============================================

-- =============================================
-- SETUP: Create Database and Sample Data
-- =============================================

USE master;
GO

-- 
IF DB_ID('EC_IT143_DA') IS NULL
BEGIN
    CREATE DATABASE EC_IT143_DA;
END
GO

USE EC_IT143_DA;
GO

-- =============================================
-- Drop existing objects to start fresh
-- =============================================

IF OBJECT_ID('dbo.trg_UpdateLastModifiedDateAndUser', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_UpdateLastModifiedDateAndUser;
GO

IF OBJECT_ID('dbo.trg_UpdateLastModifiedDate', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_UpdateLastModifiedDate;
GO

IF OBJECT_ID('dbo.udf_GetFirstName', 'FN') IS NOT NULL
    DROP FUNCTION dbo.udf_GetFirstName;
GO

IF OBJECT_ID('dbo.udf_GetLastName', 'FN') IS NOT NULL
    DROP FUNCTION dbo.udf_GetLastName;
GO

IF OBJECT_ID('dbo.t_w3_schools_customers', 'U') IS NOT NULL
    DROP TABLE dbo.t_w3_schools_customers;
GO

IF OBJECT_ID('dbo.v_w3_schools_customers', 'V') IS NOT NULL
    DROP VIEW dbo.v_w3_schools_customers;
GO

-- =============================================
-- Create W3Schools Customers Table with LARGER columns
-- =============================================

CREATE TABLE dbo.t_w3_schools_customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(200),
    ContactName VARCHAR(200),
    Address VARCHAR(200),
    City VARCHAR(100),
    PostalCode VARCHAR(50),
    Country VARCHAR(100),
    LastModifiedDate DATETIME NULL,
    LastModifiedBy VARCHAR(100) NULL
);
GO

-- =============================================
-- Insert Sample Data
-- =============================================

INSERT INTO dbo.t_w3_schools_customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country) VALUES 
(1, 'Alfreds Futterkiste', 'Maria Anders', 'Obere Str. 57', 'Berlin', '12209', 'Germany'),
(2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Avda. de la Constitucion 2222', 'Mexico D.F.', '05021', 'Mexico'),
(3, 'Antonio Moreno Taqueria', 'Antonio Moreno', 'Mataderos 2312', 'Mexico D.F.', '05023', 'Mexico'),
(4, 'Around the Horn', 'Thomas Hardy', '120 Hanover Sq.', 'London', 'WA1 1DP', 'UK'),
(5, 'Berglunds snabbkop', 'Christina Berglund', 'Berguvsvagen 8', 'Lulea', 'S-958 22', 'Sweden'),
(6, 'Blauer See Delikatessen', 'Hanna Moos', 'Forsterstr. 57', 'Mannheim', '68306', 'Germany'),
(7, 'Blondel pere et fils', 'Frederique Citeaux', '24, place Kleber', 'Strasbourg', '67000', 'France'),
(8, 'Bolido Comidas preparadas', 'Martin Sommer', 'C/ Araquil, 67', 'Madrid', '28023', 'Spain'),
(9, 'Bon app', 'Laurence Lebihans', '12, rue des Bouchers', 'Marseille', '13008', 'France'),
(10, 'Bottom-Dollar Marketse', 'Elizabeth Lincoln', '23 Tsawassen Blvd.', 'Tsawassen', 'T2F 8M4', 'Canada');
GO

-- Verify setup
SELECT * FROM dbo.t_w3_schools_customers;
GO

PRINT '========================================';
PRINT 'SETUP COMPLETE - Database and Table Ready';
PRINT 'Author: Osagie George';
PRINT '========================================';
GO

-- =============================================
-- =============================================
-- FUN WITH FUNCTIONS - ALL 8 STEPS
-- =============================================
-- =============================================

-- =============================================
-- EC_IT143_6.3_fwf_s1_og.sql
-- STEP 1: Start with a Question
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 1 - Start with a Question
-- Question: How can I extract the FIRST NAME from the ContactName field?
-- =============================================

QUESTION:
How do I extract just the first name from the ContactName column 
in the W3Schools Customers table?

EXAMPLE:
ContactName: "Maria Anders"
Expected Result: "Maria"

CLARIFICATION:
- The first name is everything BEFORE the first space
- If there's no space, return the entire string
- This needs to work for all customer records consistently
*/
GO

-- =============================================
-- EC_IT143_6.3_fwf_s2_og.sql
-- STEP 2: Begin Creating an Answer
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 2 - Begin Creating an Answer
-- =============================================

CURRENT UNDERSTANDING:
I need to find the position of the first space in the ContactName,
then extract everything to the left of that space.

NEXT LOGICAL STEPS:
1. Find the position of the first space using CHARINDEX()
2. Use LEFT() function to extract characters before the space
3. Handle edge cases where there is no space in the name

SQL FUNCTIONS I WILL NEED:
- CHARINDEX(substring, string) -- finds position of first occurrence
- LEFT(string, length) -- extracts leftmost characters
- CASE statement to handle when CHARINDEX returns 0
*/
GO

-- =============================================
-- EC_IT143_6.3_fwf_s3_og.sql
-- STEP 3: Create an Ad Hoc SQL Query
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 3 - Create an Ad Hoc SQL Query
-- Purpose: Test the logic before creating a function
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Ad hoc query to extract first name
SELECT 
    ContactName,
    CHARINDEX(' ', ContactName) AS SpacePosition,
    CASE 
        WHEN CHARINDEX(' ', ContactName) > 0 
        THEN LEFT(ContactName, CHARINDEX(' ', ContactName) - 1)
        ELSE ContactName
    END AS FirstName
FROM dbo.t_w3_schools_customers;
GO

-- =============================================
-- EC_IT143_6.3_fwf_s4_og.sql
-- STEP 4: Research and Test a Solution
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 4 - Research and Test a Solution
-- Resources Used:
--   1. https://learn.microsoft.com/en-us/sql/t-sql/functions/charindex-transact-sql
--   2. https://learn.microsoft.com/en-us/sql/t-sql/functions/left-transact-sql
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Final tested query with edge cases handled
SELECT 
    ContactName,
    CASE 
        WHEN ContactName IS NULL THEN NULL
        WHEN CHARINDEX(' ', LTRIM(RTRIM(ContactName))) > 0 
        THEN LEFT(LTRIM(RTRIM(ContactName)), CHARINDEX(' ', LTRIM(RTRIM(ContactName))) - 1)
        ELSE LTRIM(RTRIM(ContactName))
    END AS FirstName_Final
FROM dbo.t_w3_schools_customers;
GO

-- =============================================
-- EC_IT143_6.3_fwf_s5_og.sql
-- STEP 5: Create a User-Defined Scalar Function
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 5 - Create User-Defined Scalar Function for First Name
-- Function Name: udf_GetFirstName
-- Purpose: Extracts the first name from a full name string
-- =============================================
*/

USE EC_IT143_DA;
GO

CREATE FUNCTION dbo.udf_GetFirstName
(
    @FullName VARCHAR(100)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @FirstName VARCHAR(50);
    
    SET @FirstName = CASE 
        WHEN @FullName IS NULL THEN NULL
        WHEN CHARINDEX(' ', LTRIM(RTRIM(@FullName))) > 0 
        THEN LEFT(LTRIM(RTRIM(@FullName)), CHARINDEX(' ', LTRIM(RTRIM(@FullName))) - 1)
        ELSE LTRIM(RTRIM(@FullName))
    END;
    
    RETURN @FirstName;
END;
GO

-- Test the function
SELECT dbo.udf_GetFirstName('Maria Anders') AS Test1;
SELECT dbo.udf_GetFirstName('SingleName') AS Test2;
SELECT dbo.udf_GetFirstName(NULL) AS Test3;
GO

PRINT 'Function udf_GetFirstName created successfully by Osagie George!';
GO

-- =============================================
-- EC_IT143_6.3_fwf_s6_og.sql
-- STEP 6: Compare UDF Results to Ad Hoc Query Results
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 6 - Compare UDF Results to Ad Hoc Query Results
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Side-by-side comparison
SELECT 
    ContactName,
    CASE 
        WHEN ContactName IS NULL THEN NULL
        WHEN CHARINDEX(' ', LTRIM(RTRIM(ContactName))) > 0 
        THEN LEFT(LTRIM(RTRIM(ContactName)), CHARINDEX(' ', LTRIM(RTRIM(ContactName))) - 1)
        ELSE LTRIM(RTRIM(ContactName))
    END AS FirstName_AdHoc,
    dbo.udf_GetFirstName(ContactName) AS FirstName_UDF,
    CASE 
        WHEN CASE 
                WHEN ContactName IS NULL THEN NULL
                WHEN CHARINDEX(' ', LTRIM(RTRIM(ContactName))) > 0 
                THEN LEFT(LTRIM(RTRIM(ContactName)), CHARINDEX(' ', LTRIM(RTRIM(ContactName))) - 1)
                ELSE LTRIM(RTRIM(ContactName))
             END = dbo.udf_GetFirstName(ContactName)
        THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS ValidationResult
FROM dbo.t_w3_schools_customers;
GO

-- =============================================
-- EC_IT143_6.3_fwf_s7_og.sql
-- STEP 7: Perform a "0 Results Expected" Test
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 7 - Zero Results Expected Test
-- =============================================
*/

USE EC_IT143_DA;
GO

WITH ComparisonCTE AS
(
    SELECT 
        ContactName,
        CASE 
            WHEN ContactName IS NULL THEN NULL
            WHEN CHARINDEX(' ', LTRIM(RTRIM(ContactName))) > 0 
            THEN LEFT(LTRIM(RTRIM(ContactName)), CHARINDEX(' ', LTRIM(RTRIM(ContactName))) - 1)
            ELSE LTRIM(RTRIM(ContactName))
        END AS FirstName_AdHoc,
        dbo.udf_GetFirstName(ContactName) AS FirstName_UDF
    FROM dbo.t_w3_schools_customers
)
SELECT *
FROM ComparisonCTE
WHERE FirstName_AdHoc <> FirstName_UDF
   OR (FirstName_AdHoc IS NULL AND FirstName_UDF IS NOT NULL)
   OR (FirstName_AdHoc IS NOT NULL AND FirstName_UDF IS NULL);
GO

PRINT 'If you see 0 rows above, the function is working correctly!';
GO

-- =============================================
-- EC_IT143_6.3_fwf_s8_og.sql
-- STEP 8: Ask the Next Question (Extract Last Name)
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Step 8 - Ask the Next Question
-- New Question: How do I extract the LAST NAME from ContactName?
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Test query for last name
SELECT 
    ContactName,
    CASE 
        WHEN CHARINDEX(' ', LTRIM(RTRIM(ContactName))) > 0 
        THEN SUBSTRING(LTRIM(RTRIM(ContactName)), 
                      CHARINDEX(' ', LTRIM(RTRIM(ContactName))) + 1, 
                      LEN(LTRIM(RTRIM(ContactName))))
        ELSE LTRIM(RTRIM(ContactName))
    END AS LastName_Test
FROM dbo.t_w3_schools_customers;
GO

-- Create the Last Name function
CREATE FUNCTION dbo.udf_GetLastName
(
    @FullName VARCHAR(100)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @LastName VARCHAR(50);
    
    SET @LastName = CASE 
        WHEN @FullName IS NULL THEN NULL
        WHEN CHARINDEX(' ', LTRIM(RTRIM(@FullName))) > 0 
        THEN SUBSTRING(LTRIM(RTRIM(@FullName)), 
                      CHARINDEX(' ', LTRIM(RTRIM(@FullName))) + 1, 
                      LEN(LTRIM(RTRIM(@FullName))))
        ELSE LTRIM(RTRIM(@FullName))
    END;
    
    RETURN @LastName;
END;
GO

-- Test both functions together
SELECT 
    ContactName,
    dbo.udf_GetFirstName(ContactName) AS FirstName,
    dbo.udf_GetLastName(ContactName) AS LastName
FROM dbo.t_w3_schools_customers;
GO

PRINT 'Function udf_GetLastName created successfully by Osagie George!';
PRINT 'Both First Name and Last Name functions are ready to use!';
GO

-- =============================================
-- =============================================
-- FUN WITH TRIGGERS - ALL 6 STEPS
-- =============================================
-- =============================================

-- =============================================
-- EC_IT143_6.3_fwt_s1_og.sql
-- TRIGGER STEP 1: Start with a Question
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 1 - Start with a Question
-- Question: How can I automatically track WHEN a record was last modified?
-- =============================================

QUESTION:
How do I automatically update the LastModifiedDate column 
whenever someone updates a customer record?

This should happen automatically without user intervention.
*/
GO

-- =============================================
-- EC_IT143_6.3_fwt_s2_og.sql
-- TRIGGER STEP 2: Begin Creating an Answer
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 2 - Begin Creating an Answer
-- =============================================

CURRENT UNDERSTANDING:
A TRIGGER is a stored procedure that executes automatically 
when INSERT, UPDATE, or DELETE occurs on a table.

NEXT LOGICAL STEPS:
1. Create an AFTER UPDATE trigger
2. Use GETDATE() to set current datetime
3. Use INSERTED table to identify updated rows
*/
GO

-- =============================================
-- EC_IT143_6.3_fwt_s3_og.sql
-- TRIGGER STEP 3: Research and Test a Solution
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 3 - Research and Test a Solution
-- Resources Used:
--   1. https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql
--   2. https://stackoverflow.com/questions/4242488/how-to-use-inserted-and-deleted-tables
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Check current state before trigger
PRINT 'BEFORE TRIGGER: Testing current UPDATE behavior';

SELECT CustomerID, ContactName, City, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;
GO

-- Test update (LastModifiedDate will stay NULL without trigger)
UPDATE dbo.t_w3_schools_customers
SET City = 'Berlin Updated'
WHERE CustomerID = 1;
GO

SELECT CustomerID, ContactName, City, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;
GO

-- =============================================
-- EC_IT143_6.3_fwt_s4_og.sql
-- TRIGGER STEP 4: Create an After-Update Trigger
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 4 - Create After-Update Trigger
-- Trigger Name: trg_UpdateLastModifiedDate
-- Purpose: Automatically set LastModifiedDate when a record is updated
-- =============================================
*/

USE EC_IT143_DA;
GO

CREATE TRIGGER dbo.trg_UpdateLastModifiedDate
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE c
    SET LastModifiedDate = GETDATE()
    FROM dbo.t_w3_schools_customers c
    INNER JOIN inserted i ON c.CustomerID = i.CustomerID;
END;
GO

PRINT 'Trigger trg_UpdateLastModifiedDate created successfully by Osagie George!';
GO

-- =============================================
-- EC_IT143_6.3_fwt_s5_og.sql
-- TRIGGER STEP 5: Test Results to See if They Are As Expected
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 5 - Test the Trigger
-- =============================================
*/

USE EC_IT143_DA;
GO

PRINT '========================================';
PRINT 'TRIGGER TEST: LastModifiedDate';
PRINT 'Tester: Osagie George';
PRINT '========================================';
GO

-- TEST 1: Single Row Update
PRINT 'TEST 1: Single Row Update';
PRINT 'BEFORE Update:';

SELECT CustomerID, ContactName, City, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 2;
GO

PRINT 'Executing UPDATE statement...';
UPDATE dbo.t_w3_schools_customers
SET City = 'Mexico City Updated'
WHERE CustomerID = 2;
GO

PRINT 'AFTER Update:';
SELECT CustomerID, ContactName, City, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 2;
GO

-- TEST 2: Multiple Row Update
PRINT '';
PRINT 'TEST 2: Multiple Row Update';
PRINT 'BEFORE Update:';

SELECT CustomerID, ContactName, Country, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE Country = 'Germany'
ORDER BY CustomerID;
GO

PRINT 'Executing UPDATE for multiple rows...';
UPDATE dbo.t_w3_schools_customers
SET Country = 'Germany Updated'
WHERE Country = 'Germany';
GO

PRINT 'AFTER Update:';
SELECT CustomerID, ContactName, Country, LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE Country = 'Germany Updated'
ORDER BY CustomerID;
GO

PRINT '';
PRINT '========================================';
PRINT 'TRIGGER TEST COMPLETE!';
PRINT 'If you see recent timestamps above, the trigger is working!';
PRINT '========================================';
GO

-- =============================================
-- EC_IT143_6.3_fwt_s6_og.sql
-- TRIGGER STEP 6: Ask the Next Question (Track Who Modified)
-- =============================================

/*
-- =============================================
-- Author: Osagie George
-- Create date: 2024-04-10
-- Description: Trigger Step 6 - Ask the Next Question
-- New Question: How do I track WHO last modified a record?
-- =============================================
*/

USE EC_IT143_DA;
GO

-- Drop the old trigger
DROP TRIGGER dbo.trg_UpdateLastModifiedDate;
GO

-- Create enhanced trigger with BOTH date and user tracking
CREATE TRIGGER dbo.trg_UpdateLastModifiedDateAndUser
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE c
    SET 
        LastModifiedDate = GETDATE(),
        LastModifiedBy = SUSER_NAME()
    FROM dbo.t_w3_schools_customers c
    INNER JOIN inserted i ON c.CustomerID = i.CustomerID;
END;
GO

PRINT 'Enhanced trigger created by Osagie George: trg_UpdateLastModifiedDateAndUser';
GO

-- TEST THE ENHANCED TRIGGER
PRINT '';
PRINT '========================================';
PRINT 'TESTING ENHANCED TRIGGER (Date + User)';
PRINT 'Tester: Osagie George';
PRINT '========================================';
GO

PRINT 'BEFORE Update:';
SELECT CustomerID, ContactName, City, LastModifiedDate, LastModifiedBy
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 3;
GO

PRINT 'Executing UPDATE statement...';
UPDATE dbo.t_w3_schools_customers
SET ContactName = 'Antonio Moreno Updated'
WHERE CustomerID = 3;
GO

PRINT 'AFTER Update:';
SELECT CustomerID, ContactName, City, LastModifiedDate, LastModifiedBy
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 3;
GO

PRINT '';
PRINT '========================================';
PRINT 'ENHANCED TRIGGER TEST COMPLETE!';
PRINT 'Both LastModifiedDate and LastModifiedBy should be populated!';
PRINT '========================================';
GO

-- =============================================
-- FINAL DEMONSTRATION
-- =============================================

PRINT '';
PRINT '========================================';
PRINT 'FINAL DEMONSTRATION';
PRINT 'Functions + Triggers Working Together';
PRINT 'Developed by: Osagie George';
PRINT '========================================';
GO

-- Show all functions working
SELECT 
    CustomerID,
    ContactName,
    dbo.udf_GetFirstName(ContactName) AS FirstName,
    dbo.udf_GetLastName(ContactName) AS LastName,
    City,
    Country,
    LastModifiedDate,
    LastModifiedBy
FROM dbo.t_w3_schools_customers
ORDER BY CustomerID;
GO

-- Final update to show trigger
PRINT 'Performing final update to demonstrate trigger...';
UPDATE dbo.t_w3_schools_customers
SET Country = 'United Kingdom'
WHERE CustomerID = 4;
GO

PRINT 'Final state showing all features:';
SELECT 
    CustomerID,
    ContactName,
    dbo.udf_GetFirstName(ContactName) AS FirstName,
    dbo.udf_GetLastName(ContactName) AS LastName,
    City,
    Country,
    LastModifiedDate,
    LastModifiedBy
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 4;
GO

PRINT '';
PRINT '========================================';
PRINT 'ASSIGNMENT COMPLETE!';
PRINT 'Author: Osagie George';
PRINT '========================================';
PRINT 'Created:';
PRINT '  - dbo.udf_GetFirstName function';
PRINT '  - dbo.udf_GetLastName function';
PRINT '  - dbo.trg_UpdateLastModifiedDateAndUser trigger';
PRINT '';
PRINT 'All objects are working correctly!';
PRINT '========================================';
GO