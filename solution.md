💾 ثانياً: ملف الحل الكامل بصيغة Markdown (solution.md)
Markdown

# حل وظيفة إدارة قواعد البيانات (MySQL)

هذا الملف يحتوي على الحل الكامل للوظيفة، بما في ذلك إنشاء قواعد البيانات، المستخدمين، إدارة الصلاحيات، وسياسات كلمات المرور، بالإضافة إلى اقتراحات للنسخ الاحتياطي.

---

## الخطوة 1: بناء قواعد البيانات والجداول

```sql
-- ===================================================================
-- ‫إنشاء قاعدة بيانات المستشفى والجداول الخاصة بها‬
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

-- ===================================================================
-- ‫إنشاء قاعدة بيانات شركة التأمين والجداول الخاصة بها‬
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
الخطوة 2: إنشاء المستخدمين ومنح الصلاحيات
SQL

-- ‫أ. إنشاء مدير النظام‬
DROP USER IF EXISTS 'SysAdmin'@'localhost';
CREATE USER 'SysAdmin'@'localhost' IDENTIFIED BY '12345678_Sys@dmin';
GRANT ALL PRIVILEGES ON *.* TO 'SysAdmin'@'localhost' WITH GRANT OPTION;

-- ‫ب. إنشاء مسؤول المستشفى‬
DROP USER IF EXISTS 'Ayla'@'localhost';
CREATE USER 'Ayla'@'localhost' IDENTIFIED BY '12345_Admin';
GRANT ALL PRIVILEGES ON hospital_db.* TO 'Ayla'@'localhost';

-- ‫ج. إنشاء مسؤول التأمين‬
DROP USER IF EXISTS 'Reema'@'localhost';
CREATE USER 'Reema'@'localhost' IDENTIFIED BY '123_Insurance';
GRANT ALL PRIVILEGES ON insurance_db.* TO 'Reema'@'localhost';

-- ‫د. إنشاء الطبيب‬
DROP USER IF EXISTS 'Aram'@'localhost';
CREATE USER 'Aram'@'localhost' IDENTIFIED BY '12345_Doctor';
GRANT SELECT, INSERT, UPDATE ON hospital_db.doctor TO 'Aram'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hospital_db.appointment TO 'Aram'@'localhost';
GRANT SELECT ON hospital_db.patient TO 'Aram'@'localhost';
GRANT SELECT, INSERT, UPDATE ON insurance_db.doctor TO 'Aram'@'localhost';
GRANT SELECT ON insurance_db.client TO 'Aram'@'localhost';
GRANT SELECT, INSERT ON insurance_db.claim TO 'Aram'@'localhost';

-- ‫هـ. إنشاء العميل‬
DROP USER IF EXISTS 'Iliam'@'localhost';
CREATE USER 'Iliam'@'localhost' IDENTIFIED BY 'Client_123456';
GRANT SELECT ON insurance_db.client TO 'Iliam'@'localhost';
GRANT SELECT, UPDATE ON insurance_db.claim TO 'Iliam'@'localhost';

-- ‫و. إنشاء موظف الاستعلامات‬
DROP USER IF EXISTS 'Fady'@'localhost';
CREATE USER 'Fady'@'localhost' IDENTIFIED BY '123456_Viewer';
GRANT SELECT ON hospital_db.* TO 'Fady'@'localhost';
GRANT SELECT ON insurance_db.* TO 'Fady'@'localhost';

-- ‫تطبيق الصلاحيات‬
FLUSH PRIVILEGES;
الخطوة 3: إدارة الصلاحيات وسياسات كلمات المرور
SQL

-- ‫3. سحب امتياز التحديث من العميل‬
REVOKE UPDATE ON insurance_db.claim FROM 'Iliam'@'localhost';

-- ‫4. تعيين سياسة عامة لتغيير كلمة المرور كل 90 يوماً‬
SET PERSIST default_password_lifetime = 90;

-- ‫5. تعديل سياسة تغيير كلمة المرور لمسؤول التأمين‬
ALTER USER 'Reema'@'localhost' PASSWORD EXPIRE INTERVAL 60 DAY;

-- ‫6. إلغاء تفعيل تغيير كلمة المرور للعميل‬
ALTER USER 'Iliam'@'localhost' PASSWORD EXPIRE NEVER;

-- ‫7. تغيير كلمة مرور الطبيب (محاكاة)‬
-- ملاحظة: هذا منطق تطبيقي. الكود التالي يفترض وجود طبيب اسمه 'Aram' في الجدول
-- UPDATE insurance_db.doctor SET dual_password = password, password = 'a_new_strong_password' WHERE name = 'Aram';

-- ‫8. إنهاء مدة صلاحية كلمة المرور للعميل‬
ALTER USER 'Iliam'@'localhost' PASSWORD EXPIRE;

-- ‫9. تغيير كلمة مرور موظف الاستعلامات‬
ALTER USER 'Fady'@'localhost' IDENTIFIED BY '1234_F@dy';

-- ‫تطبيق التغييرات‬
FLUSH PRIVILEGES;
الخطوة 4: اقتراح سياستي نسخ احتياطي
السياسة الأولى: نسخ احتياطي كامل وتفاضلي (Full & Differential)
الوصف: أخذ نسخة كاملة أسبوعياً (مثلاً السبت ليلاً) ونسخة يومية بالتغييرات التي طرأت منذ النسخة الكاملة الأخيرة.

المزايا: توازن بين سرعة الاستعادة (تحتاج ملفين فقط) ومساحة التخزين.

العيوب: حجم النسخة التفاضلية يزداد خلال الأسبوع.

الأدوات: يمكن جدولتها باستخدام mysqldump مع cron (Linux) أو Task Scheduler (Windows).

السياسة الثانية: نسخ كامل مع سجل المعاملات (Point-in-Time Recovery)
الوصف: أخذ نسخة كاملة يومياً وتفعيل سجل المعاملات الثنائي (binary logging) لأخذ نسخة من التغييرات كل بضع دقائق.

المزايا: تقليل فقدان البيانات إلى الحد الأدنى (دقائق معدودة)، مثالية للأنظمة الحيوية.

العيوب: أكثر تعقيداً في الإعداد والإدارة وتتطلب مساحة تخزين أكبر.

الأدوات: تتطلب تفعيل log_bin في إعدادات MySQL واستخدام أدوات مثل mysqlbinlog للاستعادة.