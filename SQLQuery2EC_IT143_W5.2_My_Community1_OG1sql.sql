-- ===============================================
-- Database: MyCommunity
-- Description: Tracks members, activities, posts, and comments
-- ===============================================

-- 1. Create the database
CREATE DATABASE MyCommunity;
GO

USE MyCommunity;
GO

-- ===============================================
-- 2. Create Tables
-- ===============================================

-- Members Table
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Age INT,
    City NVARCHAR(50),
    Email NVARCHAR(100),
    JoinDate DATE
);

-- Activities Table
CREATE TABLE Activities (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    ActivityName NVARCHAR(100) NOT NULL,
    ActivityDate DATE
);

-- MemberActivities Table (many-to-many relationship)
CREATE TABLE MemberActivities (
    MemberID INT,
    ActivityID INT,
    PRIMARY KEY (MemberID, ActivityID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID)
);

-- Posts Table
CREATE TABLE Posts (
    PostID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT,
    PostTitle NVARCHAR(200),
    PostContent NVARCHAR(MAX),
    PostDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Comments Table
CREATE TABLE Comments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    PostID INT,
    MemberID INT,
    CommentContent NVARCHAR(MAX),
    CommentDate DATE,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- ===============================================
-- 3. Insert Sample Data
-- ===============================================

-- Members
INSERT INTO Members (Name, Age, City, Email, JoinDate) VALUES
('Alice Johnson', 25, 'Lagos', 'alice@example.com', '2025-01-10'),
('Bob Smith', 30, 'Abuja', 'bob@example.com', '2025-02-15'),
('Clara Evans', 28, 'Lagos', 'clara@example.com', '2025-03-05'),
('David Lee', 35, 'Port Harcourt', 'david@example.com', '2025-01-12'),
('Eva Green', 27, 'Ibadan', 'eva@example.com', '2025-02-10');

-- Activities
INSERT INTO Activities (ActivityName, ActivityDate) VALUES
('Community Cleanup', '2025-03-20'),
('Fundraising Event', '2025-04-01'),
('Tree Planting', '2025-04-15');

-- MemberActivities
INSERT INTO MemberActivities (MemberID, ActivityID) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 2);

-- Posts
INSERT INTO Posts (MemberID, PostTitle, PostContent, PostDate) VALUES
(1, 'Welcome to the Community', 'Excited to be here!', '2025-02-01'),
(2, 'Community Guidelines', 'Please read the rules before posting.', '2025-02-05'),
(3, 'Upcoming Events', 'Don’t miss our upcoming tree planting!', '2025-03-10');

-- Comments
INSERT INTO Comments (PostID, MemberID, CommentContent, CommentDate) VALUES
(1, 2, 'Welcome Alice!', '2025-02-02'),
(1, 3, 'Glad to have you!', '2025-02-03'),
(2, 1, 'Thanks Bob, will do!', '2025-02-06'),
(3, 4, 'Looking forward to it!', '2025-03-11'),
(3, 5, 'Can’t wait!', '2025-03-12');