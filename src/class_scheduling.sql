-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT 
    cl.class_id AS class_id,
    cl.name AS class_name, 
    st.first_name || ' ' || st.last_name AS instructor_name
FROM class_schedule cs
JOIN classes cl ON cs.class_id = cl.class_id
JOIN staff st ON cs.staff_id = st.staff_id;


-- 2. Find available classes for a specific date
SELECT 
    cl.class_id,
    cl.name AS name, 
    cs.start_time, 
    cs.end_time, 
    l.name AS available_spots
FROM class_schedule cs
JOIN classes cl ON cs.class_id = cl.class_id
JOIN locations l ON cl.location_id = l.location_id
WHERE DATE(cs.start_time) = '2025-02-01'; 


-- 3. Register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status) 
VALUES (3, 11, 'Registered');


-- 4. Cancel a class registration

DELETE FROM class_attendance 
WHERE schedule_id = 7 AND member_id = 2;


-- 5. List top 5 most popular classes
SELECT 
    cl.class_id,
    cl.name AS class_name, 
    COUNT(ca.member_id) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes cl ON cs.class_id = cl.class_id
GROUP BY cl.name
ORDER BY registration_count DESC
LIMIT 5;


-- 6. Calculate average number of classes per member
SELECT 
    COUNT(DISTINCT ca.schedule_id) * 1.0 / COUNT(DISTINCT mem.member_id) AS avg_classes_per_member
FROM members mem
LEFT JOIN class_attendance ca ON mem.member_id = ca.member_id;
