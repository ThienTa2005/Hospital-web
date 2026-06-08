CREATE DATABASE IF NOT EXISTS clinic_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- DA THAY DOI O DONG 57,70,83

USE clinic_db;

-- Bảng người dùng chung
CREATE TABLE IF NOT EXISTS Users
(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
	phonenum VARCHAR(15),
    address VARCHAR(255),
    role ENUM('patient', 'doctor', 'nurse', 'admin') NOT NULL
);

-- Phòng ban
CREATE TABLE IF NOT EXISTS Department
(
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Bệnh nhân
CREATE TABLE IF NOT EXISTS Patient
(
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bác sĩ
CREATE TABLE IF NOT EXISTS Doctor
(
    user_id INT PRIMARY KEY,
    degree VARCHAR(255) NOT NULL,
    department_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE SET NULL
);

-- Ca trực
CREATE TABLE IF NOT EXISTS Shift
(
    shift_id INT PRIMARY KEY AUTO_INCREMENT,
    shift_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- Quan hệ bác sĩ - ca trực
CREATE TABLE IF NOT EXISTS Shift_Doctor
(
-- 	DAT KHOA CHINH DON DE TRUY XUAT TU BANG KHAC DE DANG

	shift_doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    shift_id INT,
    doctor_id INT,
    FOREIGN KEY (shift_id) REFERENCES Shift(shift_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(user_id) ON DELETE CASCADE
);

-- Cuộc hẹn
CREATE TABLE IF NOT EXISTS Appointment
(
-- TRUY XUAT DEN SHIFT-DOCTOR DE BIET LICH HEN GAN BS NAO THAY VI SHIFT 
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    shift_doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('pending', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (patient_id) REFERENCES Patient(user_id) ON DELETE CASCADE,
    FOREIGN KEY (shift_doctor_id) REFERENCES Shift_Doctor(shift_doctor_id) ON DELETE CASCADE  
);

-- Xét nghiệm
CREATE TABLE IF NOT EXISTS Test
(
-- THAM CHIEU DEN BANG SHIFT_DOCTOR VI CHI BAC SI TRONG CA TRUC MOI LAM VIEC

    test_id INT PRIMARY KEY AUTO_INCREMENT,
    test_name VARCHAR(255) NOT NULL,
    test_time DATETIME NOT NULL,
    parameter VARCHAR(100) NOT NULL,
    parameter_value VARCHAR(100) NOT NULL, 
    unit VARCHAR(100) NOT NULL, 
    reference_range VARCHAR(100) NOT NULL, 
    appointment_id INT NOT NULL,
	shift_doctor_id INT NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (shift_doctor_id) REFERENCES Shift_Doctor(shift_doctor_id) ON DELETE CASCADE
);

-- Hồ sơ khám bệnh
CREATE TABLE IF NOT EXISTS MedicalRecord
(
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    diagnosis VARCHAR(255) NOT NULL,
    notes VARCHAR(255),
    prescription VARCHAR(255),
    appointment_id INT NOT NULL, 
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id) ON DELETE CASCADE
);


-- INSERT DL MAU

USE clinic_db;

-- 1. Users
INSERT INTO Users (username, password, fullname, dob, gender, phonenum, address, role) VALUES
('admin01', '123456', 'Nguyen Van Admin', '1990-01-01', 'M', '0909000001', 'Hanoi', 'admin'),
('bs01', '123456', 'Tran Thi Bac Si', '1985-05-12', 'F', '0909000002', 'Hanoi', 'doctor'),
('bs02', '123456', 'Le Van Doctor', '1980-08-20', 'M', '0909000003', 'HCM', 'doctor'),
('bn01', '123456', 'Nguyen Van Benh', '2000-03-15', 'M', '0909000004', 'Hanoi', 'patient'),
('bn02', '123456', 'Tran Thi Nhan', '1998-07-10', 'F', '0909000005', 'HCM', 'patient');

-- 2. Department
INSERT INTO Department (name) VALUES
('Khoa Nội'),
('Khoa Ngoại');

-- 3. Doctor (tham chiếu tới Users)
INSERT INTO Doctor (user_id, degree, department_id) VALUES
(2, 'Thạc sĩ Nội khoa', 1), -- bs01
(3, 'Tiến sĩ Ngoại khoa', 2); -- bs02

-- 4. Patient (tham chiếu tới Users)
INSERT INTO Patient (user_id) VALUES
(4), -- bn01
(5); -- bn02

-- 5. Shift
INSERT INTO Shift (shift_date, start_time, end_time) VALUES
(CURDATE(), '08:00:00', '12:00:00'), -- sáng hôm nay
(CURDATE(), '13:00:00', '17:00:00'); -- chiều hôm nay

-- 6. Shift_Doctor
INSERT INTO Shift_Doctor (shift_id, doctor_id) VALUES
(1, 2), -- bs01 trực ca sáng
(2, 3); -- bs02 trực ca chiều

-- 7. Appointment
INSERT INTO Appointment (patient_id, shift_doctor_id, appointment_date, status) VALUES
(4, 1, NOW(), 'pending'), -- bn01 hẹn với bs01 sáng nay
(5, 2, NOW(), 'pending'); -- bn02 hẹn với bs02 chiều nay

-- 8. Test (ví dụ xét nghiệm máu với 2 chỉ số Hb và WBC)
INSERT INTO Test (test_name, test_time, appointment_id, shift_doctor_id, parameter, parameter_value, unit, reference_range) VALUES
('Xét nghiệm máu', NOW(), 1, 1, 'Hb', '13.5', 'g/dL', '12-16'),
('Xét nghiệm máu', NOW(), 1, 1, 'WBC', '7.2', '10^9/L', '4-10');

-- 9. MedicalRecord
INSERT INTO MedicalRecord (diagnosis, notes, prescription, appointment_id) VALUES
('Viêm họng cấp', 'Nghỉ ngơi, uống nhiều nước', 'Paracetamol 500mg, ngày 3 lần sau ăn', 1),
('Đau dạ dày', 'Tránh đồ cay nóng', 'Omeprazole 20mg, ngày 2 lần trước bữa ăn', 2);
