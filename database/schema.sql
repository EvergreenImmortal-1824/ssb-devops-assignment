CREATE DATABASE IF NOT EXISTS ssb_ops_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'ssb_app_user'@'localhost' IDENTIFIED BY 'SsbPass@123';
CREATE USER IF NOT EXISTS 'ssb_app_user'@'127.0.0.1' IDENTIFIED BY 'SsbPass@123';

GRANT ALL PRIVILEGES ON ssb_ops_db.* TO 'ssb_app_user'@'localhost';
GRANT ALL PRIVILEGES ON ssb_ops_db.* TO 'ssb_app_user'@'127.0.0.1';
FLUSH PRIVILEGES;

USE ssb_ops_db;

CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    owner VARCHAR(100) NOT NULL,
    status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tasks (title, owner, status) VALUES
('Verify Apache and MySQL services', 'DevOps Team', 'Completed'),
('Configure daily mysqldump backup', 'System Admin', 'Pending'),
('Review Linux file permissions on web root', 'Web Ops', 'Pending');
