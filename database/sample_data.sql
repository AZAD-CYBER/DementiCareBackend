-- Sample Data for Dementicare Database
-- This file contains sample data for testing

USE dementicare;

-- Clear existing data (be careful in production!)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE quiz_results;
TRUNCATE TABLE prescriptions;
TRUNCATE TABLE appointments;
TRUNCATE TABLE jobs;
TRUNCATE TABLE contacts;
TRUNCATE TABLE patients;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- Sample Users
-- Note: Password is 'password123' hashed with bcrypt (you should change this)
-- To generate bcrypt hash: use an online tool or the backend API

INSERT INTO users (email, password, user_type, name, phone) VALUES
('doctor1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'doctor', 'Dr. Sarah Johnson', '+1-555-0101'),
('doctor2@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'doctor', 'Dr. Michael Chen', '+1-555-0102'),
('caregiver1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'caregiver', 'Emily Rodriguez', '+1-555-0201'),
('caregiver2@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'caregiver', 'David Kim', '+1-555-0202'),
('patient1@dementicare.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'patient', 'Robert Wilson', '+1-555-0301');

-- Sample Patients
INSERT INTO patients (name, age, gender, phone, address, diagnosis, caregiver_id) VALUES
('Margaret Thompson', 78, 'Female', '+1-555-1001', '123 Oak Street, Springfield, IL 62701', 'Alzheimer\'s Disease - Early Stage', 3),
('James Anderson', 82, 'Male', '+1-555-1002', '456 Maple Avenue, Springfield, IL 62702', 'Vascular Dementia', 3),
('Patricia Martinez', 75, 'Female', '+1-555-1003', '789 Pine Road, Springfield, IL 62703', 'Alzheimer\'s Disease - Moderate Stage', 4),
('William Brown', 80, 'Male', '+1-555-1004', '321 Elm Street, Springfield, IL 62704', 'Lewy Body Dementia', 4),
('Barbara Davis', 73, 'Female', '+1-555-1005', '654 Cedar Lane, Springfield, IL 62705', 'Mild Cognitive Impairment', NULL);

-- Sample Appointments
INSERT INTO appointments (patient_id, doctor_id, date, time, type, status, notes) VALUES
(1, 1, '2026-02-05 10:00:00', '10:00 AM', 'consultation', 'confirmed', 'Initial cognitive assessment and family consultation'),
(1, 1, '2026-02-19 14:00:00', '2:00 PM', 'follow-up', 'pending', 'Follow-up on medication adjustment'),
(2, 2, '2026-02-07 09:00:00', '9:00 AM', 'consultation', 'confirmed', 'Blood pressure monitoring and medication review'),
(3, 1, '2026-02-10 11:00:00', '11:00 AM', 'follow-up', 'confirmed', 'Memory test and family support discussion'),
(4, 2, '2026-02-12 15:00:00', '3:00 PM', 'consultation', 'pending', 'New patient consultation - Lewy Body symptoms'),
(5, 1, '2026-02-15 13:00:00', '1:00 PM', 'consultation', 'confirmed', 'Cognitive screening and lifestyle recommendations'),
(1, 1, '2026-01-28 10:00:00', '10:00 AM', 'consultation', 'completed', 'Completed initial assessment');

-- Sample Prescriptions
INSERT INTO prescriptions (patient_id, doctor_id, medication, dosage, frequency, duration, instructions) VALUES
(1, 1, 'Donepezil (Aricept)', '5mg', 'Once daily', '30 days', 'Take in the evening before bedtime. May increase to 10mg after 4-6 weeks.'),
(1, 1, 'Memantine (Namenda)', '5mg', 'Once daily', '30 days', 'Start with 5mg, gradually increase. Take with or without food.'),
(2, 2, 'Rivastigmine (Exelon)', '4.6mg patch', 'Once daily', '30 days', 'Apply patch to clean, dry skin. Rotate application sites.'),
(2, 2, 'Aspirin', '81mg', 'Once daily', '90 days', 'Take with food to prevent stomach upset.'),
(3, 1, 'Galantamine (Razadyne)', '8mg', 'Twice daily', '30 days', 'Take with morning and evening meals.'),
(4, 2, 'Carbidopa-Levodopa', '25-100mg', 'Three times daily', '30 days', 'Take 30 minutes before meals. Do not crush tablets.');

-- Sample Quiz Results
INSERT INTO quiz_results (patient_id, score, max_score, answers) VALUES
(1, 22, 30, '{"q1": "correct", "q2": "incorrect", "q3": "correct", "q4": "correct", "q5": "incorrect", "total_time": "15:30"}'),
(2, 18, 30, '{"q1": "correct", "q2": "incorrect", "q3": "incorrect", "q4": "correct", "q5": "incorrect", "total_time": "18:45"}'),
(3, 15, 30, '{"q1": "incorrect", "q2": "incorrect", "q3": "correct", "q4": "incorrect", "q5": "correct", "total_time": "20:10"}'),
(5, 26, 30, '{"q1": "correct", "q2": "correct", "q3": "correct", "q4": "correct", "q5": "incorrect", "total_time": "12:20"}'),
(1, 24, 30, '{"q1": "correct", "q2": "correct", "q3": "correct", "q4": "correct", "q5": "incorrect", "total_time": "14:15"}');

-- Sample Contact Messages
INSERT INTO contacts (name, email, message, status) VALUES
('John Smith', 'john.smith@example.com', 'I would like to schedule a consultation for my mother who is showing signs of memory loss.', 'new'),
('Lisa Johnson', 'lisa.j@example.com', 'Can you provide information about your caregiver training programs?', 'read'),
('Mark Wilson', 'mark.wilson@example.com', 'Thank you for the excellent care provided to my father. Your team has been wonderful.', 'replied'),
('Jennifer Brown', 'jen.brown@example.com', 'What are the costs associated with your cognitive assessment services?', 'new');

-- Sample Jobs
INSERT INTO jobs (title, company, location, type, description, requirements, salary, posted_by, status) VALUES
('Certified Nursing Assistant (CNA)', 'Springfield Care Center', 'Springfield, IL', 'full-time', 
'Seeking compassionate CNA to provide care for patients with dementia. Responsibilities include assisting with daily activities, monitoring vital signs, and providing emotional support.',
'Valid CNA certification, 1+ years experience with dementia patients preferred, excellent communication skills, patience and empathy',
'$32,000 - $38,000/year', 1, 'active'),

('Home Health Aide', 'Caring Hands Home Care', 'Springfield, IL', 'part-time',
'Looking for a dedicated home health aide to assist elderly clients with dementia in their homes. Flexible scheduling available.',
'High school diploma or equivalent, reliable transportation, background check required, experience with Alzheimer\'s patients a plus',
'$15-$18/hour', 1, 'active'),

('Dementia Care Specialist', 'Memory Care Solutions', 'Springfield, IL', 'full-time',
'Join our team as a Dementia Care Specialist. Develop and implement individualized care plans for residents with various forms of dementia.',
'Bachelor\'s degree in nursing or related field, 3+ years experience in dementia care, strong assessment and communication skills',
'$45,000 - $55,000/year', 2, 'active'),

('Activities Coordinator', 'Sunrise Senior Living', 'Springfield, IL', 'full-time',
'Plan and implement engaging activities for residents in our memory care unit. Create programs that stimulate cognitive function and social interaction.',
'Experience in recreational therapy or activities coordination, creativity, patience, and enthusiasm for working with seniors',
'$30,000 - $36,000/year', 2, 'active');

-- Verify data insertion
SELECT 'Users:' as 'Table', COUNT(*) as 'Count' FROM users
UNION ALL
SELECT 'Patients:', COUNT(*) FROM patients
UNION ALL
SELECT 'Appointments:', COUNT(*) FROM appointments
UNION ALL
SELECT 'Prescriptions:', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'Quiz Results:', COUNT(*) FROM quiz_results
UNION ALL
SELECT 'Contacts:', COUNT(*) FROM contacts
UNION ALL
SELECT 'Jobs:', COUNT(*) FROM jobs;

-- Show sample data
SELECT '=== Sample Users ===' as Info;
SELECT id, email, user_type, name FROM users LIMIT 5;

SELECT '=== Sample Patients ===' as Info;
SELECT id, name, age, gender, diagnosis FROM patients LIMIT 5;

SELECT '=== Sample Appointments ===' as Info;
SELECT id, patient_id, doctor_id, date, type, status FROM appointments LIMIT 5;

SELECT 'Data insertion completed successfully!' as Status;
