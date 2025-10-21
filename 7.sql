--الخطوة الأولى: تعيين كلمة مرور أساسية جديدة مع الإبقاء على القديمة ككلمة ثانوية
ALTER USER 'Doctor Aram'@'localhost'
IDENTIFIED BY 'Aram_NewPass2025' RETAIN CURRENT PASSWORD;

-- الخطوة الثانية (بعد تحديث جميع التطبيقات المتصلة لاستخدام كلمة المرور الجديدة): تجاهل كلمة المرور القديمة
ALTER USER 'Doctor Aram'@'localhost' DISCARD OLD PASSWORD;
