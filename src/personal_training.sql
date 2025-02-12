-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
SELECT 
    pts.session_id, 
    mem.first_name || ' ' || mem.last_name AS member_name, 
    pts.session_date,
    pts.start_time, 
    pts.end_time
FROM personal_training_sessions pts
JOIN members mem ON pts.member_id = mem.member_id
JOIN staff st ON pts.staff_id = st.staff_id
WHERE st.first_name = 'Ivy' AND st.last_name = 'Irwin';

