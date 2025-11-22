package model.dao;

import Utils.DBUtils;
import model.entity.ShiftDoctor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShiftDoctorDAO {

    // Lấy danh sách bác sĩ được phân công trong 1 ca trực
    public List<ShiftDoctor> getDoctorsByShift(int shiftId) {
        List<ShiftDoctor> list = new ArrayList<>();

        String sql = """
            SELECT 
                sd.shift_doctor_id,
                sd.shift_id,
                sd.doctor_id,
                u.fullname,
                d.degree,
                dep.name AS department_name
            FROM Shift_Doctor sd
            JOIN Doctor d ON sd.doctor_id = d.user_id
            JOIN Users u ON d.user_id = u.user_id
            LEFT JOIN Department dep ON d.department_id = dep.department_id
            WHERE sd.shift_id = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, shiftId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShiftDoctor sd = new ShiftDoctor();
                    sd.setShiftDoctorId(rs.getInt("shift_doctor_id"));
                    sd.setShiftId(rs.getInt("shift_id"));
                    sd.setDoctorId(rs.getInt("doctor_id"));
                    sd.setDoctorName(rs.getString("fullname"));
                    sd.setDegree(rs.getString("degree"));
                    sd.setDepartmentName(rs.getString("department_name"));

                    list.add(sd);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Thêm 1 bác sĩ vào ca trực
    // Trả về false nếu đã tồn tại (tránh phân công trùng)
    public boolean addDoctorToShift(int shiftId, int doctorId) {
        String checkSql = "SELECT 1 FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";
        String insertSql = "INSERT INTO Shift_Doctor (shift_id, doctor_id) VALUES (?, ?)";

        try (Connection conn = DBUtils.getConnection()) {

            // Kiểm tra trùng
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, shiftId);
                checkPs.setInt(2, doctorId);

                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        // đã tồn tại
                        return false;
                    }
                }
            }

            // Nếu chưa có thì insert
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setInt(1, shiftId);
                insertPs.setInt(2, doctorId);
                int rows = insertPs.executeUpdate();
                return rows > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa 1 bác sĩ khỏi ca trực
    public boolean removeDoctorFromShift(int shiftId, int doctorId) {
        String sql = "DELETE FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
