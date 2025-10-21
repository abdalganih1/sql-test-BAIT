-- a. إنشاء مدير النظام ومنحه الصلاحيات الكاملة
DROP USER IF EXISTS 'SysAdmin'@'localhost';
CREATE USER 'SysAdmin'@'localhost' IDENTIFIED BY 'Sys@dmin_12345678';
GRANT ALL PRIVILEGES ON *.* TO 'SysAdmin'@'localhost' WITH GRANT OPTION;

-- b. إنشاء مسؤول المستشفى ومنحه الصلاحيات الكاملة على قاعدة بيانات المستشفى
DROP USER IF EXISTS 'HospitalAdmin Ayla'@'localhost';
CREATE USER 'HospitalAdmin Ayla'@'localhost' IDENTIFIED BY 'Admin_12345';
GRANT ALL PRIVILEGES ON hospital_db.* TO 'HospitalAdmin Ayla'@'localhost';

-- c. إنشاء مسؤول التأمين ومنحه الصلاحيات الكاملة على قاعدة بيانات شركة التأمين
DROP USER IF EXISTS 'InsuranceAdmin Reema'@'localhost';
CREATE USER 'InsuranceAdmin Reema'@'localhost' IDENTIFIED BY 'Insurance_123';
GRANT ALL PRIVILEGES ON insurance_db.* TO 'InsuranceAdmin Reema'@'localhost';

-- d. إنشاء مستخدم الطبيب ومنحه الصلاحيات المحددة
DROP USER IF EXISTS 'Doctor Aram'@'localhost';
CREATE USER 'Doctor Aram'@'localhost' IDENTIFIED BY 'Doctor_12345';
-- i. صلاحيات على جداول الأطباء في القاعدتين
GRANT SELECT, INSERT, UPDATE ON hospital_db.doctor TO 'Doctor Aram'@'localhost';
GRANT SELECT, INSERT, UPDATE ON insurance_db.doctor TO 'Doctor Aram'@'localhost';
-- ii. صلاحيات على جدول الزيارات
GRANT SELECT, INSERT, UPDATE ON hospital_db.appointment TO 'Doctor Aram'@'localhost';
-- iii. صلاحية القراءة من جدول المرضى
GRANT SELECT ON hospital_db.patient TO 'Doctor Aram'@'localhost';
-- iv. صلاحية القراءة من جدول العملاء
GRANT SELECT ON insurance_db.client TO 'Doctor Aram'@'localhost';
-- v. صلاحيات على جدول المطالبة
GRANT SELECT, INSERT ON insurance_db.claim TO 'Doctor Aram'@'localhost';


-- e. إنشاء مستخدم العميل ومنحه الصلاحيات المحددة
DROP USER IF EXISTS 'Client Iliam'@'localhost';
CREATE USER 'Client Iliam'@'localhost' IDENTIFIED BY 'Client_123456';
GRANT SELECT ON insurance_db.client TO 'Client Iliam'@'localhost';
GRANT SELECT, UPDATE ON insurance_db.claim TO 'Client Iliam'@'localhost';

-- f. إنشاء موظف الاستعلامات ومنحه صلاحيات القراءة فقط
DROP USER IF EXISTS 'Viewer Fady'@'localhost';
CREATE USER 'Viewer Fady'@'localhost' IDENTIFIED BY 'Viewer_123456';
GRANT SELECT ON hospital_db.* TO 'Viewer Fady'@'localhost';
GRANT SELECT ON insurance_db.* TO 'Viewer Fady'@'localhost';

-- تطبيق الصلاحيات
FLUSH PRIVILEGES;
