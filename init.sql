CREATE DATABASE IF NOT EXISTS mydatabase;

USE mydatabase;

-- Table for users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    role ENUM('core', 'mentor', 'mentee') NOT NULL,
    domain ENUM('web', 'app', 'sysad') DEFAULT NULL,
    mentee_capacity INT DEFAULT NULL
);

-- Table for tasks
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    task_number INT,
    domain ENUM('web', 'app', 'sysad'),
    status ENUM('completed', 'submitted') NOT NULL,
    details TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Sample data for users
INSERT INTO users (username, role, domain, mentee_capacity) VALUES
('DAdmin', 'core', NULL, NULL),
('john_mentor', 'mentor', 'web', 5),
('jane_mentee', 'mentee', NULL, NULL);

-- Sample data for tasks
INSERT INTO tasks (user_id, task_number, domain, status, details) VALUES
(1, 1, 'sysad', 'completed', 'Task 1 details for Sysad'),
(2, 1, 'web', 'completed', 'Task 1 details for Web'),
(3, 1, 'sysad', 'submitted', 'Task 1 submitted for Sysad');
