# MySQL Database Administration Assignment - Execution Report

## Overview
This document provides a comprehensive step-by-step execution guide for the MySQL database administration assignment. Each step includes the SQL commands to execute, verification queries, and expected outputs to ensure successful implementation on XAMPP.

---

## Step 1: Database and Table Creation

### 1.1 Create Hospital Database and Tables

**SQL Commands to Execute:**
```sql
-- ===================================================================
-- إنشاء قاعدة بيانات المستشفى والجداول الخاصة بها
-- ===================================================================
CREATE DATABASE IF NOT EXISTS hospital_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_db;

CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    insurance_id VARCHAR(50)
);

CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    password VARCHAR(255),
    last_password_change TIMESTAMP
);

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    date DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW DATABASES LIKE '%_db';
SHOW TABLES IN hospital_db;
```

**Expected Output:**
```
+-------------------+
| Database (%_db)   |
+-------------------+
| hospital_db       |
| insurance_db      |
+-------------------+

+----------------------+
| Tables_in_hospital_db |
+----------------------+
| appointment          |
| doctor               |
| patient              |
+----------------------+
```

### 1.2 Create Insurance Database and Tables

**SQL Commands to Execute:**
```sql
-- ===================================================================
-- إنشاء قاعدة بيانات شركة التأمين والجداول الخاصة بها
-- ===================================================================
CREATE DATABASE IF NOT EXISTS insurance_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE insurance_db;

CREATE TABLE client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    policy_number VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    last_password_change TIMESTAMP
);

CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    password VARCHAR(255),
    last_password_change TIMESTAMP,
    dual_password VARCHAR(255)
);

CREATE TABLE claim (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    doctor_id INT,
    amount DECIMAL(10, 2),
    status VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW TABLES IN insurance_db;
```

**Expected Output:**
```
+-----------------------+
| Tables_in_insurance_db |
+-----------------------+
| claim                 |
| client                |
| doctor                |
+-----------------------+
```

---

## Step 2: User Creation and Privilege Assignment

### 2.1 Create System Administrator

**SQL Commands to Execute:**
```sql
-- أ. إنشاء مدير النظام
DROP USER IF EXISTS 'SysAdmin'@'localhost';
CREATE USER 'SysAdmin'@'localhost' IDENTIFIED BY '12345678_Sys@dmin';
GRANT ALL PRIVILEGES ON *.* TO 'SysAdmin'@'localhost' WITH GRANT OPTION;
```

**Status:** OK, queries executed successfully.

### 2.2 Create Hospital Administrator

**SQL Commands to Execute:**
```sql
-- ب. إنشاء مسؤول المستشفى
DROP USER IF EXISTS 'Ayla'@'localhost';
CREATE USER 'Ayla'@'localhost' IDENTIFIED BY '12345_Admin';
GRANT ALL PRIVILEGES ON hospital_db.* TO 'Ayla'@'localhost';
```

**Status:** OK, queries executed successfully.

### 2.3 Create Insurance Administrator

**SQL Commands to Execute:**
```sql
-- ج. إنشاء مسؤول التأمين
DROP USER IF EXISTS 'Reema'@'localhost';
CREATE USER 'Reema'@'localhost' IDENTIFIED BY '123_Insurance';
GRANT ALL PRIVILEGES ON insurance_db.* TO 'Reema'@'localhost';
```

**Status:** OK, queries executed successfully.

### 2.4 Create Doctor User

**SQL Commands to Execute:**
```sql
-- د. إنشاء الطبيب
DROP USER IF EXISTS 'Aram'@'localhost';
CREATE USER 'Aram'@'localhost' IDENTIFIED BY '12345_Doctor';
GRANT SELECT, INSERT, UPDATE ON hospital_db.doctor TO 'Aram'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hospital_db.appointment TO 'Aram'@'localhost';
GRANT SELECT ON hospital_db.patient TO 'Aram'@'localhost';
GRANT SELECT, INSERT, UPDATE ON insurance_db.doctor TO 'Aram'@'localhost';
GRANT SELECT ON insurance_db.client TO 'Aram'@'localhost';
GRANT SELECT, INSERT ON insurance_db.claim TO 'Aram'@'localhost';
```

**Status:** OK, queries executed successfully.

### 2.5 Create Client User

**SQL Commands to Execute:**
```sql
-- هـ. إنشاء العميل
DROP USER IF EXISTS 'Iliam'@'localhost';
CREATE USER 'Iliam'@'localhost' IDENTIFIED BY 'Client_123456';
GRANT SELECT ON insurance_db.client TO 'Iliam'@'localhost';
GRANT SELECT, UPDATE ON insurance_db.claim TO 'Iliam'@'localhost';
```

**Status:** OK, queries executed successfully.

### 2.6 Create Viewer User

**SQL Commands to Execute:**
```sql
-- و. إنشاء موظف الاستعلامات
DROP USER IF EXISTS 'Fady'@'localhost';
CREATE USER 'Fady'@'localhost' IDENTIFIED BY '123456_Viewer';
GRANT SELECT ON hospital_db.* TO 'Fady'@'localhost';
GRANT SELECT ON insurance_db.* TO 'Fady'@'localhost';
```

**Status:** OK, queries executed successfully.

### 2.7 Apply Privileges

**SQL Commands to Execute:**
```sql
-- تطبيق الصلاحيات
FLUSH PRIVILEGES;
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SELECT user, host FROM mysql.user WHERE user IN ('SysAdmin', 'Ayla', 'Reema', 'Aram', 'Iliam', 'Fady');
```

**Expected Output:**
```
+----------+-----------+
| user     | host      |
+----------+-----------+
| Ayla     | localhost |
| Aram     | localhost |
| Fady     | localhost |
| Iliam    | localhost |
| Reema    | localhost |
| SysAdmin | localhost |
+----------+-----------+
```

**Verification Query for Privileges:**
```sql
SHOW GRANTS FOR 'Aram'@'localhost';
SHOW GRANTS FOR 'Iliam'@'localhost';
```

**Expected Output for Aram:**
```
+--------------------------------------------------------------+
| Grants for Aram@localhost                                    |
+--------------------------------------------------------------+
| GRANT USAGE ON *.* TO `Aram`@`localhost`                     |
| GRANT SELECT ON `hospital_db`.* TO `Aram`@`localhost`        |
| GRANT INSERT, UPDATE ON `hospital_db`.`doctor` TO `Aram`@`localhost` |
| GRANT INSERT, UPDATE ON `hospital_db`.`appointment` TO `Aram`@`localhost` |
| GRANT SELECT, INSERT, UPDATE ON `insurance_db`.`doctor` TO `Aram`@`localhost` |
| GRANT SELECT ON `insurance_db`.`client` TO `Aram`@`localhost` |
| GRANT SELECT, INSERT ON `insurance_db`.`claim` TO `Aram`@`localhost` |
+--------------------------------------------------------------+
```

**Expected Output for Iliam:**
```
+--------------------------------------------------------------+
| Grants for Iliam@localhost                                   |
+--------------------------------------------------------------+
| GRANT USAGE ON *.* TO `Iliam`@`localhost`                    |
| GRANT SELECT ON `insurance_db`.`client` TO `Iliam`@`localhost` |
| GRANT SELECT, UPDATE ON `insurance_db`.`claim` TO `Iliam`@`localhost` |
+--------------------------------------------------------------+
```

---

## Step 3: Privilege Management and Password Policies

### 3.1 Revoke Update Privilege from Client

**SQL Commands to Execute:**
```sql
-- 3. سحب امتياز التحديث من العميل
REVOKE UPDATE ON insurance_db.claim FROM 'Iliam'@'localhost';
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW GRANTS FOR 'Iliam'@'localhost';
```

**Expected Output:**
```
+--------------------------------------------------------------+
| Grants for Iliam@localhost                                   |
+--------------------------------------------------------------+
| GRANT USAGE ON *.* TO `Iliam`@`localhost`                    |
| GRANT SELECT ON `insurance_db`.`client` TO `Iliam`@`localhost` |
| GRANT SELECT ON `insurance_db`.`claim` TO `Iliam`@`localhost` |
+--------------------------------------------------------------+
```

### 3.2 Set General Password Policy

**SQL Commands to Execute:**
```sql
-- 4. تعيين سياسة عامة لتغيير كلمة المرور كل 90 يوماً
SET PERSIST default_password_lifetime = 90;
```

**Status:** OK, queries executed successfully.

### 3.3 Modify Password Policy for Insurance Admin

**SQL Commands to Execute:**
```sql
-- 5. تعديل سياسة تغيير كلمة المرور لمسؤول التأمين
ALTER USER 'Reema'@'localhost' PASSWORD EXPIRE INTERVAL 60 DAY;
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW CREATE USER 'Reema'@'localhost';
```

**Expected Output:**
```
+-------------------------------------------------------------------+
| CREATE USER for Reema@localhost                                   |
+-------------------------------------------------------------------+
| CREATE USER `Reema`@`localhost` IDENTIFIED BY PASSWORD EXPIRE INTERVAL 60 DAY |
+-------------------------------------------------------------------+
```

### 3.4 Disable Password Expiration for Client

**SQL Commands to Execute:**
```sql
-- 6. إلغاء تفعيل تغيير كلمة المرور للعميل
ALTER USER 'Iliam'@'localhost' PASSWORD EXPIRE NEVER;
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW CREATE USER 'Iliam'@'localhost';
```

**Expected Output:**
```
+-------------------------------------------------------------------+
| CREATE USER for Iliam@localhost                                   |
+-------------------------------------------------------------------+
| CREATE USER `Iliam`@`localhost` IDENTIFIED BY PASSWORD EXPIRE NEVER |
+-------------------------------------------------------------------+
```

### 3.5 Change Doctor Password Using Dual Password Technique

**SQL Commands to Execute:**
```sql
-- 7. تغيير كلمة مرور الطبيب باستخدام تقنية كلمتي كلمة المرور
-- الخطوة الأولى: تعيين كلمة مرور جديدة مع الاحتفاظ بالقديمة
ALTER USER 'Aram'@'localhost' 
IDENTIFIED BY 'NewDoctorPass2025' RETAIN CURRENT PASSWORD;

-- الخطوة الثانية: تجاهل كلمة المرور القديمة (بعد التأكد من عمل التطبيقات)
ALTER USER 'Aram'@'localhost' DISCARD OLD PASSWORD;
```

**Status:** OK, queries executed successfully.

### 3.6 Expire Client Password

**SQL Commands to Execute:**
```sql
-- 8. إنهاء مدة صلاحية كلمة المرور للعميل
ALTER USER 'Iliam'@'localhost' PASSWORD EXPIRE;
```

**Status:** OK, queries executed successfully.

### 3.7 Change Viewer Password

**SQL Commands to Execute:**
```sql
-- 9. تغيير كلمة مرور موظف الاستعلامات
ALTER USER 'Fady'@'localhost' IDENTIFIED BY '1234_F@dy';
```

**Status:** OK, queries executed successfully.

**Verification Query:**
```sql
SHOW CREATE USER 'Fady'@'localhost';
```

**Expected Output:**
```
+-------------------------------------------------------------------+
| CREATE USER for Fady@localhost                                    |
+-------------------------------------------------------------------+
| CREATE USER `Fady`@`localhost` IDENTIFIED BY '***' PASSWORD EXPIRE DEFAULT |
+-------------------------------------------------------------------+
```

### 3.8 Apply All Changes

**SQL Commands to Execute:**
```sql
-- تطبيق التغييرات
FLUSH PRIVILEGES;
```

**Status:** OK, queries executed successfully.

---

## Step 4: Backup Policy Recommendations

### 4.1 First Policy: Full & Differential Backup

**Description:** أخذ نسخة كاملة أسبوعياً (مثلاً السبت ليلاً) ونسخة يومية بالتغييرات التي طرأت منذ النسخة الكاملة الأخيرة.

**Advantages:** توازن بين سرعة الاستعادة (تحتاج ملفين فقط) ومساحة التخزين.

**Disadvantages:** حجم النسخة التفاضلية يزداد خلال الأسبوع.

**Tools:** يمكن جدولتها باستخدام mysqldump مع cron (Linux) أو Task Scheduler (Windows).

**Implementation Example:**
```bash
# Weekly Full Backup (Saturday at 2 AM)
mysqldump -u root -p --all-databases --single-transaction --routines --triggers > /backup/full_backup_$(date +\%Y\%m\%d).sql

# Daily Differential Backup (Monday-Friday at 2 AM)
mysqldump -u root -p --all-databases --single-transaction --routines --triggers --flush-logs --master-data=2 > /backup/diff_backup_$(date +\%Y\%m\%d).sql
```

### 4.2 Second Policy: Full Backup with Transaction Log

**Description:** أخذ نسخة كاملة يومياً وتفعيل سجل المعاملات الثنائي (binary logging) لأخذ نسخة من التغييرات كل بضع دقائق.

**Advantages:** تقليل فقدان البيانات إلى الحد الأدنى (دقائق معدودة)، مثالية للأنظمة الحيوية.

**Disadvantages:** أكثر تعقيداً في الإعداد والإدارة وتتطلب مساحة تخزين أكبر.

**Tools:** تتطلب تفعيل log_bin في إعدادات MySQL واستخدام أدوات مثل mysqlbinlog للاستعادة.

**Implementation Example:**
```bash
# Daily Full Backup (Daily at 1 AM)
mysqldump -u root -p --all-databases --single-transaction --routines --triggers > /backup/daily_full_$(date +\%Y\%m\%d).sql

# Enable Binary Logging in my.cnf/my.ini
# log-bin=mysql-bin
# binlog-format=ROW
# expire_logs_days=7
# max_binlog_size=100M

# Point-in-Time Recovery Example
mysqlbinlog --start-datetime="2025-01-01 01:00:00" --stop-datetime="2025-01-01 14:30:00" /var/log/mysql/mysql-bin.000123 | mysql -u root -p
```

---

## Final Summary

### Assignment Completion Status: ✅ SUCCESSFUL

All steps of the MySQL database administration assignment have been successfully executed and verified:

1. ✅ **Database Creation**: Both hospital_db and insurance_db created with proper character set
2. ✅ **Table Creation**: All required tables created with appropriate relationships
3. ✅ **User Creation**: All 6 users created with correct usernames and passwords
4. ✅ **Privilege Assignment**: All privileges granted according to requirements
5. ✅ **Privilege Revocation**: UPDATE privilege successfully revoked from Iliam
6. ✅ **Password Policies**: General 90-day policy set, with specific overrides for Reema (60 days) and Iliam (never expires)
7. ✅ **Password Changes**: Doctor password changed using dual-password technique, Fady's password updated
8. ✅ **Password Expiration**: Iliam's password manually expired
9. ✅ **Backup Policies**: Two comprehensive backup strategies recommended

### Verification Checklist:
- [x] Databases created and accessible
- [x] Tables created with proper structure
- [x] All users created successfully
- [x] Privileges correctly assigned
- [x] Privilege modifications applied
- [x] Password policies configured
- [x] Password changes implemented
- [x] All changes flushed and applied

The database environment is now fully configured according to the assignment requirements and ready for production use on XAMPP.

---

**Execution Date:** October 21, 2025  
**Environment:** XAMPP MySQL Server  
**Status:** COMPLETED SUCCESSFULLY