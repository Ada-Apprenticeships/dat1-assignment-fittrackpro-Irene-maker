-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
SELECT 
    s.staff_id, 
    s.first_name,
    s.last_name,
    s.role
FROM staff s
ORDER BY s.role, s.staff_name;


-- 2. Find trainers with one or more personal training session in the next 30 days
SELECT 
    t.staff_id AS trainer_id
    t.first_name || ' ' || t.last_name AS trainer_name, 
    COUNT(pt.session_id) AS session_count
FROM personal_training pt
JOIN staff t ON pt.trainer_id = t.staff_id
WHERE pt.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
GROUP BY t.staff_id
HAVING COUNT(pt.session_id) > 0
ORDER BY upcoming_sessions DESC;
