-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
SELECT member_id, first_name, last_name, email, join_date
FROM members;

-- 2. Update a member's contact information
UPDATE members
SET email = 'emily.jones.updated@email.com', phone_number = '555-9876'
WHERE member_id = 5;


-- 3. Count total number of members
SELECT COUNT(*) AS total_members 
FROM members;

-- 4. Find member with the most class registrations
SELECT mem.member_id,mem.first_name, mem.last_name, COUNT(cat.member_id) AS registration_count
FROM class_attendance cat
JOIN members mem ON cat.member_id = mem.member_id
GROUP BY cat.member_id
ORDER BY registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
SELECT mem.member_id,mem.first_name, mem.last_name, COUNT(cat.member_id) AS registration_count
FROM class_attendance cat
JOIN members mem ON cat.member_id = mem.member_id
GROUP BY cat.member_id
ORDER BY registration_count ASC
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class

SELECT(COUNT(DISTINCT cat.member_id) * 100.0 / (SELECT COUNT(*) FROM members)) AS attendance_percentage
FROM class_attendance cat;
