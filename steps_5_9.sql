-- Step 5: Modify password policy for insurance admin
ALTER USER 'InsuranceAdmin Reema'@'localhost' PASSWORD EXPIRE INTERVAL 60 DAY;

-- Step 6: Disable password expiration for client
ALTER USER 'Client Iliam'@'localhost' PASSWORD EXPIRE NEVER;

-- Step 7: Change doctor password using dual password technique
-- الخطوة الأولى: تعيين كلمة مرور جديدة مع الاحتفاظ بالقديمة
ALTER USER 'Doctor Aram'@'localhost' 
IDENTIFIED BY 'Aram_NewPass2025' RETAIN CURRENT PASSWORD;

-- الخطوة الثانية: تجاهل كلمة المرور القديمة (بعد التأكد من عمل التطبيقات)
ALTER USER 'Doctor Aram'@'localhost' DISCARD OLD PASSWORD;

-- Step 8: Expire client password
ALTER USER 'Client Iliam'@'localhost' PASSWORD EXPIRE;

-- Step 9: Change viewer password
ALTER USER 'Viewer Fady'@'localhost' IDENTIFIED BY 'F@dy_1234';

-- تطبيق التغييرات
FLUSH PRIVILEGES;