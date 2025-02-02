-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (11, 2, CURRENT_TIMESTAMP); - this query is wrong


-- 2. Retrieve a member's attendance history
SELECT 
    DATE(a.check_in_time) AS visit_date,
    a.check_in_time, 
    a.check_out_time
FROM attendance a
JOIN members m ON a.member_id = m.member_id
JOIN locations l ON a.location_id = l.location_id
WHERE a.member_id = 11
ORDER BY a.check_in_time DESC;


-- 3. Find the busiest day of the week based on gym visits
SELECT 
    strftime('%w', check_in_time) AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;


-- 4. Calculate the average daily attendance for each location
SELECT 
    l.name AS location_name, 
    COUNT(a.attendance_id) * 1.0 / COUNT(DISTINCT date(a.check_in_time)) AS avg_daily_attendance
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.location_id;
