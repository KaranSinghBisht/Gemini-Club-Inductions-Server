CREATE USER 'readonly'@'%' IDENTIFIED BY 'readonly_password';
GRANT SELECT ON mydatabase.* TO 'readonly'@'%';
FLUSH PRIVILEGES;
