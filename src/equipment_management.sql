-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;


-- Equipment Management Queries

-- 1. Find equipment due for maintenance
SELECT equipment_id, name, next_maintenance_date 
FROM equipment 
WHERE next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days');


-- 2. Count equipment types in stock
SELECT type AS equipment_type, COUNT(*) AS count 
FROM equipment 
GROUP BY equipment_type;


-- 3. Calculate average age of equipment by type (in days)
SELECT 
    type AS equipment_type, 
    AVG(julianday('now') - julianday(purchase_date)) AS avg_age_days
FROM equipment 
GROUP BY equipment_type;
