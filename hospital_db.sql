-- Hospital Management System SQL Project

CREATE DATABASE hospital_db;
USE hospital_db;

-- Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    address VARCHAR(200)
);

-- Doctors Table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(15)
);

-- Appointments Table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    reason VARCHAR(200),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Billing Table
CREATE TABLE billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50),
    bill_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Sample Data
INSERT INTO patients (patient_name, age, gender, phone, address)
VALUES 
('Rahul Kumar', 30, 'Male', '9876543210', 'Hyderabad'),
('Anjali Sharma', 25, 'Female', '9876501234', 'Vijayawada');

INSERT INTO doctors (doctor_name, specialization, phone)
VALUES
('Dr. Ramesh', 'Cardiologist', '9123456780'),
('Dr. Priya', 'Dermatologist', '9876123450');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason)
VALUES
(1, 1, '2025-01-10', 'Chest pain'),
(2, 2, '2025-01-12', 'Skin allergy');

INSERT INTO billing (patient_id, amount, payment_status, bill_date)
VALUES
(1, 2500, 'Paid', '2025-01-10'),
(2, 1800, 'Unpaid', '2025-01-12');

-- View
CREATE VIEW patient_appointment_info AS
SELECT p.patient_name, d.doctor_name, a.appointment_date
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

-- Stored Procedure
DELIMITER //
CREATE PROCEDURE GetPatientBills(IN pid INT)
BEGIN
    SELECT patient_id, amount, payment_status 
    FROM billing 
    WHERE patient_id = pid;
END //
DELIMITER ;

-- Trigger
CREATE TABLE appointment_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER after_appointment_insert
AFTER INSERT ON appointments
FOR EACH ROW
INSERT INTO appointment_logs(appointment_id, action)
VALUES (NEW.appointment_id, 'New appointment created');
