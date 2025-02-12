-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time,check_out_time)
VALUES (7, 1, CURRENT_TIMESTAMP,'');

-- 2. Retrieve a member's attendance history
SELECT 
    DATE(att.check_in_time) AS visit_date,
    att.check_in_time, 
    att.check_out_time
FROM attendance att
JOIN members mem ON att.member_id = mem.member_id
JOIN locations l ON att.location_id = l.location_id
WHERE att.member_id = 5
ORDER BY att.check_in_time DESC;


-- 3. Find the busiest day of the week based on gym visits
-- (0)Sunday to (6)Saturday 
SELECT 
    strftime('%w', check_in_time) AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance 
GROUP BY day_of_week
ORDER BY visit_count DESC;
LIMIT 1;


-- 4. Calculate the average daily attendance for each location
SELECT 
    l.name AS location_name, 
    COUNT(att.attendance_id) * 1.0 / COUNT(DISTINCT SUBSTR(att.check_in_time, 1, 10)) AS avg_daily_attendance
FROM attendance att
JOIN locations l ON att.location_id = l.location_id
WHERE att.check_in_time IS NOT NULL
GROUP BY l.location_id;

