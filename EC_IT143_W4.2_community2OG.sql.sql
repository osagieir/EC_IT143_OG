/* =========================
STEP 1: QUESTION
========================= */
-- How many orders does each customer have?

PRINT 'Step 1: Question defined';


/* =========================
STEP 2: PLAN
========================= */
-- Use COUNT and GROUP BY CustomerID

PRINT 'Step 2: Planning answer';


/* =========================
STEP 3: AD HOC QUERY
========================= */
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;

PRINT 'Step 3: Ad hoc query created';


/* =========================
STEP 4: CREATE VIEW
========================= */
GO

CREATE VIEW OrdersPerCustomer_View AS
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;

GO

PRINT 'Step 4: View created';


/* =========================
STEP 5: CREATE TABLE
========================= */
SELECT *
INTO OrdersPerCustomer_Table
FROM OrdersPerCustomer_View;

PRINT 'Step 5: Table created';


/* =========================
STEP 6: LOAD TABLE
========================= */
TRUNCATE TABLE OrdersPerCustomer_Table;

INSERT INTO OrdersPerCustomer_Table
SELECT *
FROM OrdersPerCustomer_View;

PRINT 'Step 6: Table loaded';


/* =========================
STEP 7: STORED PROCEDURE
========================= */
GO

CREATE PROCEDURE sp_LoadOrdersPerCustomer
AS
BEGIN
    TRUNCATE TABLE OrdersPerCustomer_Table;

    INSERT INTO OrdersPerCustomer_Table
    SELECT *
    FROM OrdersPerCustomer_View;
END;

GO

PRINT 'Step 7: Stored procedure created';


/* =========================
STEP 8: EXECUTE
========================= */
EXEC sp_LoadOrdersPerCustomer;

PRINT 'Step 8: Stored procedure executed';