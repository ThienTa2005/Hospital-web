CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;

-- Bảng users (tài khoản hệ thống)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DOCTOR', 'NURSE', 'STAFF') DEFAULT 'STAFF'
);

-- Bảng patients (bệnh nhân)
CREATE TABLE IF NOT EXISTS patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    address VARCHAR(255),
    phone VARCHAR(20)
);

-- Insert dữ liệu mẫu
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'ADMIN'),
('doctor1', 'docpass', 'DOCTOR'),
('nurse1', 'nursepass', 'NURSE');

INSERT INTO patients (name, dob, gender, address, phone) VALUES
('Nguyen Van A', '1990-05-20', 'MALE', 'Hanoi', '0901234567'),
('Tran Thi B', '1985-10-10', 'FEMALE', 'HCM City', '0912345678'),
('Le Van C', '2000-03-15', 'MALE', 'Da Nang', '0987654321');
