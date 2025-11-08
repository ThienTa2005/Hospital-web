package model.dao;

import model.entity.Patient;
import Utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    // Lấy thông tin từ bảng Users VÀ bảng Patient
    private static final String SELECT_ALL_PATIENTS = "SELECT u.* FROM Users u JOIN Patient p ON u.user_id = p.user_id WHERE u.role = 'patient'";
    private static final String SELECT_PATIENT_BY_ID = "SELECT u.* FROM Users u JOIN Patient p ON u.user_id = p.user_id WHERE u.user_id = ?";
    
    // Thêm vào bảng Users
    private static final String INSERT_USER_SQL = "INSERT INTO Users (username, password, fullname, dob, gender, phonenum, address, role) VALUES (?, ?, ?, ?, ?, ?, ?, 'patient')";
    // Thêm vào bảng Patient
    private static final String INSERT_PATIENT_SQL = "INSERT INTO Patient (user_id) VALUES (?)";
    
    // Cập nhật bảng Users
    private static final String UPDATE_USER_SQL = "UPDATE Users SET fullname = ?, dob = ?, gender = ?, phonenum = ?, address = ? WHERE user_id = ?";
    
    // Xóa khỏi bảng Users (bảng Patient sẽ tự động xóa theo ON DELETE CASCADE)
    private static final String DELETE_USER_SQL = "DELETE FROM Users WHERE user_id = ? AND role = 'patient'";

    // Lấy tất cả bệnh nhân
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_PATIENTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    // Lấy bệnh nhân theo ID (user_id)
    public Patient getPatientById(int userId) {
        Patient patient = null;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_PATIENT_BY_ID)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    patient = mapResultSetToPatient(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patient;
    }

    // Thêm bệnh nhân mới (2 bước)
    public boolean addPatient(Patient patient) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psPatient = null;
        ResultSet generatedKeys = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // Bước 1: Thêm vào bảng Users
            psUser = conn.prepareStatement(INSERT_USER_SQL, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, patient.getUsername());
            psUser.setString(2, patient.getPassword()); // Cần mã hóa mật khẩu ở đây
            psUser.setString(3, patient.getFullname());
            psUser.setDate(4, patient.getDob());
            psUser.setString(5, patient.getGender());
            psUser.setString(6, patient.getPhonenum());
            psUser.setString(7, patient.getAddress());
            
            int affectedRows = psUser.executeUpdate();

            if (affectedRows > 0) {
                // Lấy user_id vừa tạo
                generatedKeys = psUser.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);
                    
                    // Bước 2: Thêm vào bảng Patient
                    psPatient = conn.prepareStatement(INSERT_PATIENT_SQL);
                    psPatient.setInt(1, userId);
                    
                    if (psPatient.executeUpdate() > 0) {
                        conn.commit(); // Hoàn tất transaction
                        success = true;
                    } else {
                        conn.rollback(); // Hủy bỏ nếu bước 2 lỗi
                    }
                }
            } else {
                conn.rollback(); // Hủy bỏ nếu bước 1 lỗi
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            // Đóng tất cả kết nối
            try { if (generatedKeys != null) generatedKeys.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psPatient != null) psPatient.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psUser != null) psUser.close(); } catch (SQLException e) { /* ignored */ }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { /* ignored */ }
        }
        return success;
    }

    // Cập nhật thông tin bệnh nhân (chỉ cập nhật bảng Users)
    public boolean updatePatient(Patient patient) {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_USER_SQL)) {
            
            ps.setString(1, patient.getFullname());
            ps.setDate(2, patient.getDob());
            ps.setString(3, patient.getGender());
            ps.setString(4, patient.getPhonenum());
            ps.setString(5, patient.getAddress());
            ps.setInt(6, patient.getUserId()); // Where clause
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa bệnh nhân (chỉ cần xóa ở bảng Users)
    public boolean deletePatient(int userId) {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_USER_SQL)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm helper để map ResultSet từ bảng Users sang Patient
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setUserId(rs.getInt("user_id"));
        patient.setUsername(rs.getString("username"));
        patient.setFullname(rs.getString("fullname"));
        patient.setDob(rs.getDate("dob"));
        patient.setGender(rs.getString("gender"));
        patient.setPhonenum(rs.getString("phonenum"));
        patient.setAddress(rs.getString("address"));
        patient.setRole(rs.getString("role"));
        return patient;
    }
}