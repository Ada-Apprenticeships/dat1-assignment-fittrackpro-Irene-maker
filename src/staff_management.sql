-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
SELECT 
    st.staff_id, 
    st.first_name,
    st.last_name,
    st.position AS role
FROM staff st;


-- 2. Find trainers with one or more personal training session in the next 30 days
SELECT 
    st.staff_id AS trainer_id,
    st.first_name || ' ' || st.last_name AS trainer_name, 
    COUNT(pts.session_id) AS session_count
FROM personal_training_sessions pts
JOIN staff st ON pts.staff_id = st.staff_id
WHERE pts.session_date >= DATE('now')
AND pts.session_date < DATE('now', '+30 days')
GROUP BY st.staff_id
ORDER BY session_count DESC;





