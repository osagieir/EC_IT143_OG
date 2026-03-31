-- ===============================================
-- Script: EC_IT143_W5.2_MyCommunity_BG.sql
-- Description: MyCommunity dataset - 4 questions and answers
-- Author: Busari Gbotemi
-- Original Questions:
-- Q1, Q2: Created by Busari Gbotemi
-- Q3: Inspired by another student (fictional: N. Herman)
-- Q4: Inspired by another student (fictional: K. Kwaku)
-- ===============================================

USE MyCommunity;
GO

-- ===============================================
-- QUESTION 1
-- Q1 (Busari Gbotemi): List all members and their emails who joined after Feb 1, 2025
-- ===============================================
SELECT Name, Email, JoinDate
FROM Members
WHERE JoinDate > '2025-02-01';
GO

-- ===============================================
-- QUESTION 2
-- Q2 (Busari Gbotemi): Find all activities and the number of members participating in each
-- ===============================================
SELECT a.ActivityName, COUNT(ma.MemberID) AS NumParticipants
FROM Activities a
LEFT JOIN MemberActivities ma
    ON a.ActivityID = ma.ActivityID
GROUP BY a.ActivityName;
GO

-- ===============================================
-- QUESTION 3
-- Q3 (N. Herman - student-inspired): List all posts along with the member name who posted them
-- ===============================================
SELECT p.PostTitle, p.PostContent, m.Name AS MemberName, p.PostDate
FROM Posts p
INNER JOIN Members m
    ON p.MemberID = m.MemberID;
GO

-- ===============================================
-- QUESTION 4
-- Q4 (K. Kwaku - student-inspired): List all comments on the post titled 'Upcoming Events' with member names
-- ===============================================
SELECT c.CommentContent, c.CommentDate, m.Name AS Commenter
FROM Comments c
INNER JOIN Posts p
    ON c.PostID = p.PostID
INNER JOIN Members m
    ON c.MemberID = m.MemberID
WHERE p.PostTitle = 'Upcoming Events';
GO