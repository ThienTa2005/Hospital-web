package model.dao;

import model.entity.Doctor;
import Utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    private static final String SELECT_ALL_DOCTORS = "SELECT u.*, d.degree, d.department_id, dp.name as department_name " +
                                                    "FROM Users u " +
                                                    "JOIN Doctor d ON u.user_id = d.user_id " +
                                                    "LEFT JOIN Department dp ON d.department_id = dp.department_id " +
                                                    "WHERE u.role = 'doctor'";
    
    private static final String SELECT_DOCTOR_BY_ID = "SELECT u.*, d.degree, d.department_id, dp.name as department_name " +
                                                     "FROM Users u " +
                                                     "JOIN Doctor d ON u.user_id = d.user_id " +
                                                     "LEFT JOIN Department dp ON d.department_id = dp.department_id " +
                                                     "WHERE u.user_id = ?";

    // Thêm vào bảng Users (với role 'doctor')
    private static final String INSERT_USER_SQL = "INSERT INTO Users (username, password, fullname, dob, gender, phonenum, address, role) VALUES (?, ?, ?, ?, ?, ?, ?, 'doctor')";
    
    // (KHÁC) Thêm vào bảng Doctor
    private static final String INSERT_DOCTOR_SQL = "INSERT INTO Doctor (user_id, degree, department_id) VALUES (?, ?, ?)";
    

    private static final String UPDATE_USER_SQL = "UPDATE Users SET fullname = ?, dob = ?, gender = ?, phonenum = ?, address = ? WHERE user_id = ?";
    
    private static final String UPDATE_DOCTOR_SQL = "UPDATE Doctor SET degree = ?, department_id = ? WHERE user_id = ?";

 
    private static final String DELETE_USER_SQL = "DELETE FROM Users WHERE user_id = ? AND role = 'doctor'";

    
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.user_id, d.department_id, d.degree, dp.name, u.fullname\n"
                   + "FROM Doctor AS d\n"
                   + "JOIN Users AS u ON u.user_id = d.user_id\n"
                   + "JOIN Department AS dp ON dp.department_id = d.department_id";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setDepartmentId(rs.getInt("department_id"));
                doctor.setDegree(rs.getString("degree"));
                doctor.setFullName(rs.getString("u.fullname"));
                doctor.setDepartmentName(rs.getString("dp.name"));
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }


    public Doctor getDoctorById(int userId) {
        Doctor doctor = null;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_DOCTOR_BY_ID)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doctor = mapResultSetToDoctor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctor;
    }

    public boolean addDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psDoctor = null; // (SỬA)
        ResultSet generatedKeys = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // Bước 1: Thêm vào bảng Users
            psUser = conn.prepareStatement(INSERT_USER_SQL, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, doctor.getUsername());
            psUser.setString(2, doctor.getPassword()); // Cần mã hóa
            psUser.setString(3, doctor.getFullname());
            psUser.setDate(4, doctor.getDob());
            psUser.setString(5, doctor.getGender());
            psUser.setString(6, doctor.getPhonenum());
            psUser.setString(7, doctor.getAddress());
            
            int affectedRows = psUser.executeUpdate();

            if (affectedRows > 0) {
                // Lấy user_id vừa tạo
                generatedKeys = psUser.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);
                    
                    // (SỬA) Bước 2: Thêm vào bảng Doctor
                    psDoctor = conn.prepareStatement(INSERT_DOCTOR_SQL);
                    psDoctor.setInt(1, userId);
                    psDoctor.setString(2, doctor.getDegree());
                    psDoctor.setInt(3, doctor.getDepartmentId());
                    
                    if (psDoctor.executeUpdate() > 0) {
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
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            // Đóng tất cả
            try { if (generatedKeys != null) generatedKeys.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psDoctor != null) psDoctor.close(); } catch (SQLException e) { /* ignored */ } // (SỬA)
            try { if (psUser != null) psUser.close(); } catch (SQLException e) { /* ignored */ }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { /* ignored */ }
        }
        return success;
    }

    public boolean updateDoctor(Doctor doctor) {
         Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psDoctor = null;
        boolean success = false;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

       
            psUser = conn.prepareStatement(UPDATE_USER_SQL);
            psUser.setString(1, doctor.getFullname());
            psUser.setDate(2, doctor.getDob());
            psUser.setString(3, doctor.getGender());
            psUser.setString(4, doctor.getPhonenum());
            psUser.setString(5, doctor.getAddress());
            psUser.setInt(6, doctor.getUserId()); 
            
            int userRows = psUser.executeUpdate();
            
            psDoctor = conn.prepareStatement(UPDATE_DOCTOR_SQL);
            psDoctor.setString(1, doctor.getDegree());
            psDoctor.setInt(2, doctor.getDepartmentId());
            psDoctor.setInt(3, doctor.getUserId());
            
            int doctorRows = psDoctor.executeUpdate();

            if (userRows > 0 || doctorRows > 0) { 
                conn.commit();
                success = true;
            } else {
                conn.rollback();  //TIEN HANH ROLL BACK
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            try { if (psDoctor != null) psDoctor.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psUser != null) psUser.close(); } catch (SQLException e) { /* ignored */ }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { /* ignored */ }
        }
        return success;
    }

  
    public boolean deleteDoctor(int userId) {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_USER_SQL)) { // (SỬA)
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public void addDoctorSpecifics(int userId, String degree, int departmentId) throws SQLException {
        String sql = "INSERT INTO Doctor (user_id, degree, department_id) VALUES (?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, degree);
            ps.setInt(3, departmentId);
            ps.executeUpdate();
        }
    }
    
    
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
    Doctor doctor = new Doctor();
    doctor.setUserId(rs.getInt("user_id"));
    doctor.setUsername(rs.getString("username"));
    doctor.setPassword(rs.getString("password")); 
    doctor.setFullname(rs.getString("fullname"));
    doctor.setDob(rs.getDate("dob"));
    doctor.setGender(rs.getString("gender"));
    doctor.setPhonenum(rs.getString("phonenum"));
    doctor.setAddress(rs.getString("address"));
    doctor.setRole(rs.getString("role"));
    doctor.setDegree(rs.getString("degree"));
    doctor.setDepartmentId(rs.getInt("department_id"));
    doctor.setDepartmentName(rs.getString("department_name"));
    return doctor;
}
    
    public List<Doctor> searchDoctorsByName(String keyword) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT u.*, d.degree, d.department_id, dp.name as department_name " +
                 "FROM Users u " +
                 "JOIN Doctor d ON u.user_id = d.user_id " +
                 "LEFT JOIN Department dp ON d.department_id = dp.department_id " +
                 "WHERE u.role = 'doctor' AND (" +
                 "   u.fullname LIKE ? OR " +    
                 "   u.username LIKE ? OR " +   
                 "   u.phonenum LIKE ? OR " +    
                 "   u.address LIKE ? OR " + 
                 "   d.degree LIKE ? OR " +    
                 "   dp.name LIKE ? " +       
                 ")";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword + "%"; 
            ps.setString(1, searchKeyword);
            ps.setString(2, searchKeyword);
            ps.setString(3, searchKeyword);
            ps.setString(4, searchKeyword);
            ps.setString(5, searchKeyword);     
            ps.setString(6, searchKeyword);   
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    doctors.add(mapResultSetToDoctor(rs)); 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }   
}