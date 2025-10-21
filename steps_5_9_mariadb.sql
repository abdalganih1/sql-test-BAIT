-- Step 5: Modify password policy for insurance admin
ALTER USER 'InsuranceAdmin Reema'@'localhost' PASSWORD EXPIRE INTERVAL 60 DAY;

-- Step 6: Disable password expiration for client
ALTER USER 'Client Iliam'@'localhost' PASSWORD EXPIRE NEVER;

-- Step 7: Change doctor password (MariaDB doesn't support dual password, so we'll just change it)
ALTER USER 'Doctor Aram'@'localhost' IDENTIFIED BY 'Aram_NewPass2025';

-- Step 8: Expire client password
ALTER USER 'Client Iliam'@'localhost' PASSWORD EXPIRE;

-- Step 9: Change viewer password
ALTER USER 'Viewer Fady'@'localhost' IDENTIFIED BY 'F@dy_1234';

-- تطبيق التغييرات
FLUSH PRIVILEGES;