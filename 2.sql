-- ===================================================================
-- إنشاء المستخدمين ومنح الصلاحيات حسب متطلبات السؤال
-- ===================================================================

-- أ. إنشاء مدير النظام SysAdmin بكلمة مرور 12345678_Sys@dmin
-- ومنحه كامل الصلاحيات على جميع قواعد البيانات
DROP USER IF EXISTS 'SysAdmin'@'localhost';
CREATE USER 'SysAdmin'@'localhost' IDENTIFIED BY '12345678_Sys@dmin';
GRANT ALL PRIVILEGES ON *.* TO 'SysAdmin'@'localhost' WITH GRANT OPTION;

-- ب. إنشاء مسؤول المستشفى Ayla بكلمة مرور 12345_Admin
-- ومنحه كامل الصلاحيات على قاعدة بيانات المستشفى
DROP USER IF EXISTS 'Ayla'@'localhost';
CREATE USER 'Ayla'@'localhost' IDENTIFIED BY '12345_Admin';
GRANT ALL PRIVILEGES ON hospital_db.* TO 'Ayla'@'localhost';

-- ج. إنشاء مسؤول التأمين Reema بكلمة مرور 123_Insurance
-- ومنحه كامل الصلاحيات على قاعدة بيانات شركة التأمين
DROP USER IF EXISTS 'Reema'@'localhost';
CREATE USER 'Reema'@'localhost' IDENTIFIED BY '123_Insurance';
GRANT ALL PRIVILEGES ON insurance_db.* TO 'Reema'@'localhost';

-- د. إنشاء الطبيب Aram بكلمة مرور 12345_Doctor
-- ومنحه الصلاحيات المطلوبة:
DROP USER IF EXISTS 'Aram'@'localhost';
CREATE USER 'Aram'@'localhost' IDENTIFIED BY '12345_Doctor';

-- القراءة والإدخال والتحديث على جدول الطبيب في قاعدة بيانات المستشفى
GRANT SELECT, INSERT, UPDATE ON hospital_db.doctor TO 'Aram'@'localhost';

-- القراءة والإدخال والتحديث على جدول الطبيب في قاعدة بيانات شركة التأمين
GRANT SELECT, INSERT, UPDATE ON insurance_db.doctor TO 'Aram'@'localhost';

-- القراءة والإدخال والتحديث على جدول الزيارة في قاعدة بيانات المستشفى
GRANT SELECT, INSERT, UPDATE ON hospital_db.appointment TO 'Aram'@'localhost';

-- القراءة على جدول المريض
GRANT SELECT ON hospital_db.patient TO 'Aram'@'localhost';

-- القراءة على جدول العميل
GRANT SELECT ON insurance_db.client TO 'Aram'@'localhost';

-- القراءة والإدخال على جدول المطالبة
GRANT SELECT, INSERT ON insurance_db.claim TO 'Aram'@'localhost';

-- هـ. إنشاء العميل Iliam بكلمة مرور Client_123456
-- ومنحه صلاحيات القراءة على جدول العميل والقراءة مع التحديث على جدول المطالبة
DROP USER IF EXISTS 'Iliam'@'localhost';
CREATE USER 'Iliam'@'localhost' IDENTIFIED BY 'Client_123456';
GRANT SELECT ON insurance_db.client TO 'Iliam'@'localhost';
GRANT SELECT, UPDATE ON insurance_db.claim TO 'Iliam'@'localhost';

-- و. إنشاء موظف الاستعلامات Fady بكلمة مرور 123456_Viewer
-- ومنحه صلاحيات القراءة على كل جداول قاعدتي البيانات
DROP USER IF EXISTS 'Fady'@'localhost';
CREATE USER 'Fady'@'localhost' IDENTIFIED BY '123456_Viewer';
GRANT SELECT ON hospital_db.* TO 'Fady'@'localhost';
GRANT SELECT ON insurance_db.* TO 'Fady'@'localhost';

-- تطبيق الصلاحيات
FLUSH PRIVILEGES;
