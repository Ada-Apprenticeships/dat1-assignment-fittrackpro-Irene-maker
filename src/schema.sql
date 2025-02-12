-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments ;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS locations;


-- locations table 
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number TEXT NOT NULL CHECK(phone_number LIKE '___-____'),
    email TEXT NOT NULL UNIQUE CHECK(email LIKE '%_@__%.__%'),
    opening_hours TEXT NOT NULL CHECK(opening_hours GLOB '[0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]' OR opening_hours GLOB '[0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]')
);

-- members table 
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE CHECK(email LIKE '%_@__%.__%'),
    phone_number TEXT NOT NULL CHECK(phone_number LIKE '___-____'),
    date_of_birth TEXT NOT NULL CHECK(date_of_birth LIKE '____-__-__'),
    join_date TEXT NOT NULL CHECK(join_date LIKE '____-__-__'),
    emergency_contact_name TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL CHECK(emergency_contact_phone LIKE '___-____')
);

-- staff table 
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE CHECK(email LIKE '%_@__%.__%'),
    phone_number TEXT NOT NULL CHECK(phone_number LIKE '___-____'),
    position TEXT NOT NULL CHECK(position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date TEXT NOT NULL CHECK(hire_date LIKE '____-__-__'),
    location_id INTEGER,
    FOREIGN KEY(location_id) REFERENCES locations(location_id) ON DELETE CASCADE 
);

-- equipment table 
CREATE TABLE equipment(
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('Cardio', 'Strength')),
    purchase_date TEXT NOT NULL CHECK(purchase_date LIKE '____-__-__'),
    last_maintenance_date TEXT NOT NULL CHECK(last_maintenance_date LIKE '____-__-__'),
    next_maintenance_date TEXT NOT NULL CHECK(next_maintenance_date LIKE '____-__-__'),
    location_id INTEGER,
    FOREIGN KEY(location_id) REFERENCES locations(location_id) ON DELETE CASCADE 
);

-- classes table 
CREATE TABLE classes(
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    location_id INTEGER,
    FOREIGN KEY(location_id) REFERENCES locations(location_id) ON DELETE CASCADE 
);

-- class_schedule table
CREATE TABLE class_schedule(
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    class_id INTEGER,
    staff_id INTEGER,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    FOREIGN KEY(class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

-- memberships table 
CREATE TABLE memberships(
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    type TEXT NOT NULL CHECK(type IN ('Premium', 'Basic')),
    start_date TEXT NOT NULL CHECK(start_date LIKE '____-__-__'),
    end_date TEXT NOT NULL CHECK(end_date LIKE '____-__-__'),
    status TEXT NOT NULL CHECK(status IN ('Active', 'Inactive')),
    FOREIGN KEY(member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- attendance table 
CREATE TABLE attendance(
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time TEXT NOT NULL,
    check_out_time TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

-- class attendance table
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- payments table 
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TEXT NOT NULL,
    payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- personal training sessions table 
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date TEXT NOT NULL CHECK(session_date LIKE '____-__-__'),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

-- member health metrics table 
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    measurement_date TEXT NOT NULL CHECK(measurement_date LIKE '____-__-__'),
    weight DECIMAL NOT NULL,
    body_fat_percentage DECIMAL NOT NULL,
    muscle_mass DECIMAL NOT NULL,
    bmi DECIMAL NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- equipment maintenance log table 
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    maintenance_date TEXT NOT NULL CHECK(maintenance_date LIKE '____-__-__'),
    description TEXT NOT NULL,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

-- TODO: Create the following tables:
-- 1. locations
-- 2. members
-- 3. staff
-- 4. equipment
-- 5. classes
-- 6. class_schedule
-- 7. memberships
-- 8. attendance
-- 9. class_attendance
-- 10. payments
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal