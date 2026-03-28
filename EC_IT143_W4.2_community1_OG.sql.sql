/********************************************************************
STEP 1–8: My Community Analysis (Players Table)
Question: How many players play each position?
********************************************************************/

-- ==========================================
-- Step 1: Question
-- ==========================================
-- How many players play each position?

-- ==========================================
-- Step 2: Plan
-- ==========================================
-- Use GROUP BY Position

-- ==========================================
-- Step 3: Ad hoc query
-- ==========================================
SELECT Position, COUNT(PlayerID) AS PlayerCount
FROM dbo.Players
GROUP BY Position;

-- ==========================================
-- Step 4: Create View
-- ==========================================
GO
CREATE OR ALTER VIEW dbo.PlayersPerPosition_View AS
SELECT Position, COUNT(PlayerID) AS PlayerCount
FROM dbo.Players
GROUP BY Position;
GO

-- Test view
SELECT * FROM dbo.PlayersPerPosition_View;

-- ==========================================
-- Step 5: Create Table
-- ==========================================
SELECT *
INTO dbo.PlayersPerPosition_Table
FROM dbo.PlayersPerPosition_View;

-- Add Primary Key
ALTER TABLE dbo.PlayersPerPosition_Table
ADD ID INT IDENTITY(1,1) PRIMARY KEY;

-- ==========================================
-- Step 6: Load Table
-- ==========================================
TRUNCATE TABLE dbo.PlayersPerPosition_Table;

INSERT INTO dbo.PlayersPerPosition_Table (Position, PlayerCount)
SELECT Position, PlayerCount
FROM dbo.PlayersPerPosition_View;

-- ==========================================
-- Step 7: Stored Procedure
-- ==========================================
GO
CREATE OR ALTER PROCEDURE dbo.sp_LoadPlayersPerPosition
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.PlayersPerPosition_Table;

    INSERT INTO dbo.PlayersPerPosition_Table (Position, PlayerCount)
    SELECT Position, PlayerCount
    FROM dbo.PlayersPerPosition_View;
END
GO

-- ==========================================
-- Step 8: Execute Stored Procedure
-- ==========================================
EXEC dbo.sp_LoadPlayersPerPosition;

-- Check result
SELECT * FROM dbo.PlayersPerPosition_Table;