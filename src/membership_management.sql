-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name,
    ms.membership_type, 
    m.join_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.expiry_date >= CURRENT_DATE;


-- 2. Calculate the average duration of gym visits for each membership type
SELECT 
    ms.membership_type, 
    AVG(julianday(v.exit_time) - julianday(v.entry_time)) * 24 AS avg_visit_duration_minutes (dont forget to change to min)
FROM visits v
JOIN memberships ms ON v.member_id = ms.member_id
WHERE v.exit_time IS NOT NULL
GROUP BY ms.membership_type;


-- 3. Identify members with expiring memberships this year
SELECT 
    m.member_id, 
    m.first_name,
    m.last_name, 
    m.email,
    ms.end_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE strftime('%Y', ms.expiry_date) = strftime('%Y', 'now');
