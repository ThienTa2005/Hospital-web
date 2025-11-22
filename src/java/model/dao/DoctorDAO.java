package model.dao;

import model.entity.Doctor;
import Utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {

    private Connection conn;

    public DoctorDAO() {
        try {
            conn = DBUtils.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách bác sĩ (join Users + Doctor + Department)
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();

        String sql = """
            SELECT 
                u.user_id,
                u.username,
                u.password,
                u.fullname,
                u.dob,
                u.gender,
                u.phonenum,
                u.address,
                u.role,
                d.degree,
                d.department_id,
                dep.name AS department_name
            FROM Users u
            JOIN Doctor d ON u.user_id = d.user_id
            LEFT JOIN Department dep ON d.department_id = dep.department_id
            WHERE u.role = 'doctor'
            ORDER BY u.user_id DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
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

                list.add(doctor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Dùng khi tạo user role=doctor
    public void addDoctorSpecifics(int userId, String degree, int departmentId) throws SQLException {
        String sql = "INSERT INTO Doctor (user_id, degree, department_id) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, degree);

            if (departmentId > 0) {
                ps.setInt(3, departmentId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.executeUpdate();
        }
    }

    // Cập nhật thông tin riêng
    public void updateDoctorSpecifics(int userId, String degree, int departmentId) throws SQLException {
        String sql = "UPDATE Doctor SET degree = ?, department_id = ? WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, degree);
            if (departmentId > 0) {
                ps.setInt(2, departmentId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }

    // Tìm theo tên
    public List<Doctor> searchByName(String keyword) {
        List<Doctor> list = new ArrayList<>();

        String sql = """
            SELECT 
                u.user_id,
                u.username,
                u.password,
                u.fullname,
                u.dob,
                u.gender,
                u.phonenum,
                u.address,
                u.role,
                d.degree,
                d.department_id,
                dep.name AS department_name
            FROM Users u
            JOIN Doctor d ON u.user_id = d.user_id
            LEFT JOIN Department dep ON d.department_id = dep.department_id
            WHERE u.role = 'doctor'
              AND u.fullname LIKE ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
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

                list.add(doctor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public Doctor getDoctorByID(int id) {
    String sql = """
        SELECT 
            u.user_id,
            u.username,
            u.password,
            u.fullname,
            u.dob,
            u.gender,
            u.phonenum,
            u.address,
            u.role,
            d.degree,
            d.department_id,
            dep.name AS department_name
        FROM Users u
        JOIN Doctor d ON u.user_id = d.user_id
        LEFT JOIN Department dep ON d.department_id = dep.department_id
        WHERE u.role = 'doctor' AND u.user_id = ?
    """;

    try (PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
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
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return null; // Không tìm thấy
}

}
