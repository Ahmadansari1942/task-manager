-- Create database
CREATE DATABASE IF NOT EXISTS taskmanager;

USE taskmanager;

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status ENUM('pending', 'in-progress', 'completed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample data
INSERT INTO tasks (title, description, status) VALUES
('Deploy Application', 'Deploy React frontend and Node.js backend to EC2', 'in-progress'),
('Setup RDS Database', 'Configure MySQL RDS instance and connect to application', 'in-progress'),
('Configure Security Groups', 'Set up proper security rules for EC2 and RDS', 'pending');
