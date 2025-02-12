-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
SELECT 
    mem.member_id, 
    mem.first_name, 
    mem.last_name,
    ms.type AS membership_type, 
    mem.join_date
FROM memberships ms
JOIN members mem ON ms.member_id = mem.member_id
WHERE ms.end_date >= CURRENT_DATE;


-- 2. Calculate the average duration of gym visits for each membership type

SELECT 
    ms.type AS membership_type, 
    AVG((strftime('%s', att.check_out_time) - strftime('%s', att.check_in_time)) / 60) AS avg_visit_duration_minutes 
FROM attendance att
JOIN memberships ms ON att.member_id = ms.member_id
WHERE att.check_out_time IS NOT NULL 
GROUP BY membership_type;


-- 3. Identify members with expiring memberships this year
SELECT 
    mem.member_id, 
    mem.first_name,
    mem.last_name, 
    mem.email,
    ms.end_date
FROM memberships ms
JOIN members mem ON ms.member_id = mem.member_id
WHERE strftime('%Y', ms.end_date) = strftime('%Y', 'now');
