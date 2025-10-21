-- إنشاء قاعدة بيانات المستشفى
CREATE DATABASE IF NOT EXISTS hospital_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- استخدام قاعدة البيانات
USE hospital_db;

-- إنشاء جدول المرضى
CREATE TABLE IF NOT EXISTS patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    insurance_id VARCHAR(100)
);

-- إنشاء جدول الأطباء في المستشفى
CREATE TABLE IF NOT EXISTS doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    last_password_change TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- إنشاء جدول الزيارات
CREATE TABLE IF NOT EXISTS appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    `date` DATETIME NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);
