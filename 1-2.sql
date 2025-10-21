-- إنشاء قاعدة بيانات شركة التأمين
CREATE DATABASE IF NOT EXISTS insurance_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- استخدام قاعدة البيانات
USE insurance_db;

-- إنشاء جدول العملاء
CREATE TABLE IF NOT EXISTS client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    policy_number VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    last_password_change TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- إنشاء جدول الأطباء في شركة التأمين
CREATE TABLE IF NOT EXISTS doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    last_password_change TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dual_password VARCHAR(255)
);

-- إنشاء جدول المطالبات
CREATE TABLE IF NOT EXISTS claim (
    claim_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    doctor_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);
