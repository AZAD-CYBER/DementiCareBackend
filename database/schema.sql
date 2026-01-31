-- ========================================
-- DEMENTICARE - FINAL DATABASE SCHEMA
-- ========================================
-- Instructions:
-- 1. DROP DATABASE dementicare; (to delete old schema)
-- 2. Run this entire script to create fresh database
-- ========================================
DROP DATABASE IF EXISTS dementicare;
CREATE DATABASE dementicare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dementicare;

SET default_storage_engine=InnoDB;
SET FOREIGN_KEY_CHECKS=0;

-- ========================================
-- TABLE: USERS
-- ========================================
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(50) NOT NULL DEFAULT 'patient',
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_user_type (user_type),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB;

-- ========================================
-- TABLE: PATIENTS
-- ========================================
CREATE TABLE patients (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    name VARCHAR(255) NOT NULL,
    age INT,
    gender VARCHAR(20),
    phone VARCHAR(50),
    address TEXT,
    diagnosis TEXT,
    caregiver_id BIGINT UNSIGNED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_caregiver_id (caregiver_id),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (caregiver_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ========================================
-- TABLE: APPOINTMENTS
-- ========================================
CREATE TABLE appointments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    doctor_id BIGINT UNSIGNED NOT NULL,
    date DATETIME NOT NULL,
    time VARCHAR(50) NOT NULL,
    type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_date (date),
    INDEX idx_status (status),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ========================================
-- TABLE: PRESCRIPTIONS (FIXED)
-- ========================================
CREATE TABLE prescriptions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    doctor_id BIGINT UNSIGNED NULL,
    medication VARCHAR(255) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ========================================
-- TABLE: QUIZ RESULTS
-- ========================================
CREATE TABLE quiz_results (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    score INT NOT NULL,
    max_score INT DEFAULT 100,
    answers JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_patient_id (patient_id),
    INDEX idx_created_at (created_at),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ========================================
-- TABLE: CONTACTS
-- ========================================
CREATE TABLE contacts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB;

-- ========================================
-- TABLE: JOBS
-- ========================================
CREATE TABLE jobs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    location VARCHAR(255),
    type VARCHAR(50) DEFAULT 'full-time',
    description TEXT,
    requirements TEXT,
    salary VARCHAR(100),
    posted_by BIGINT UNSIGNED,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_posted_by (posted_by),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_created_at (created_at),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS=1;

-- ========================================
-- SAMPLE DATA
-- Test users and sample appointments
-- ========================================

-- Sample users (password for all: password123)
INSERT INTO users (email, password, user_type, name, phone) VALUES
('doctor1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'doctor', 'Dr. Sarah Johnson', '+1-555-0101'),
('doctor2@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'doctor', 'Dr. Michael Chen', '+1-555-0102'),
('patient1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'patient', 'John Smith', '+1-555-0201'),
('patient2@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'patient', 'Mary Williams', '+1-555-0202'),
('caregiver1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'caregiver', 'Emma Davis', '+1-555-0301');

-- Sample patients (additional patient data)
INSERT INTO patients (user_id, name, age, gender, phone, address, diagnosis, caregiver_id) VALUES
(3, 'John Smith', 72, 'Male', '+1-555-0201', '123 Oak Street, Springfield', 'Early stage Alzheimer', 5),
(4, 'Mary Williams', 68, 'Female', '+1-555-0202', '456 Elm Avenue, Springfield', 'Mild Cognitive Impairment', 5);

-- Sample appointments (patients booking with doctors)
INSERT INTO appointments (patient_id, doctor_id, date, time, type, status, notes) VALUES
(3, 1, '2026-02-15 10:00:00', '10:00', 'Consultation', 'confirmed', 'Initial consultation - Memory assessment'),
(3, 1, '2026-02-20 14:30:00', '14:30', 'Follow-up', 'pending', 'Follow-up appointment after medication start'),
(4, 2, '2026-02-16 09:00:00', '09:00', 'Checkup', 'confirmed', 'Regular monthly checkup'),
(4, 1, '2026-02-18 11:00:00', '11:00', 'Consultation', 'pending', 'Consultation for treatment plan'),
(3, 2, '2026-02-25 15:00:00', '15:00', 'Follow-up', 'pending', 'Second opinion consultation');

-- Sample prescriptions (using correct patient IDs from patients table)
-- Patient IDs in patients table are auto-generated, so these will be 1 and 2
INSERT INTO prescriptions (patient_id, doctor_id, medication, dosage, frequency, duration, instructions) VALUES
(1, 1, 'Donepezil', '5mg', 'Once daily', '30 days', 'Take in the evening with food'),
(2, 2, 'Memantine', '10mg', 'Twice daily', '30 days', 'Take with meals morning and evening');

-- Sample quiz results (using correct patient IDs from patients table)
INSERT INTO quiz_results (patient_id, score, max_score, answers) VALUES
(1, 22, 30, '{"q1": "answer1", "q2": "answer2"}'),
(2, 26, 30, '{"q1": "answer1", "q2": "answer2"}');

-- Sample jobs
INSERT INTO jobs (title, company, location, type, description, requirements, salary, posted_by, status) VALUES
('Senior Neurologist', 'Springfield Medical Center', 'Springfield, USA', 'full-time', 'Seeking experienced neurologist specializing in dementia care', 'MD, Board certified, 5+ years experience', '$200,000 - $250,000/year', 1, 'active'),
('Caregiver', 'Home Care Plus', 'Springfield, USA', 'part-time', 'Compassionate caregiver needed for elderly patients', 'Experience with dementia care preferred', '$18-22/hour', 1, 'active');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;

-- ========================================
-- VERIFICATION QUERIES
-- ========================================

-- Check all tables created
SHOW TABLES;

-- Verify users
SELECT id, email, user_type, name FROM users;

-- Verify appointments with names
SELECT 
    a.id,
    a.date,
    a.time,
    p.name as patient_name,
    d.name as doctor_name,
    a.type,
    a.status
FROM appointments a
LEFT JOIN users p ON a.patient_id = p.id
LEFT JOIN users d ON a.doctor_id = d.id
ORDER BY a.date;

-- ========================================
-- IMPORTANT NOTES:
-- ========================================
-- 1. All passwords are: password123
-- 2. Appointments.patient_id → users.id (patients)
-- 3. Appointments.doctor_id → users.id (doctors)
-- 4. Only patients can CREATE appointments
-- 5. Doctors view appointments where doctor_id = their id
-- 6. Patients view appointments where patient_id = their id
-- 7. Frontend shows doctor/patient NAMES, not IDs
-- ========================================
