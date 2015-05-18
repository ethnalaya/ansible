CREATE DATABASE IF NOT exists tinypm3 CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';
grant all on `database`.* to 'tinypm'@'localhost' identified by 'tinypm';
GRANT SELECT, UPDATE, INSERT, LOCK TABLES, DELETE ON tinypm3.* TO 'tinypm'@'localhost' IDENTIFIED BY 'tinypm';
FLUSH PRIVILEGES;
QUIT