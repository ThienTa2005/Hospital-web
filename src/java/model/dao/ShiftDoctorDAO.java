package model.dao;

import Utils.DBUtils;
import model.entity.ShiftDoctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import Utils.DBUtils;
import model.entity.ShiftDoctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShiftDoctorDAO {

    public List<ShiftDoctor> getDoctorsByShift(int shiftId) {
        List<ShiftDoctor> list = new ArrayList<>();
        String sql = "SELECT sd.shift_doctor_id, sd.shift_id, sd.doctor_id, " +
                     "u.fullname, d.degree, dp.name as department_name " +
                     "FROM Shift_Doctor sd " +
                     "JOIN Doctor d ON sd.doctor_id = d.user_id " +
                     "JOIN Users u ON d.user_id = u.user_id " +
                     "LEFT JOIN Department dp ON d.department_id = dp.department_id " +
                     "WHERE sd.shift_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shiftId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(new ShiftDoctor(
                    rs.getInt("shift_doctor_id"),
                    rs.getInt("shift_id"),
                    rs.getInt("doctor_id"),
                    rs.getString("fullname"),
                    rs.getString("degree"),
                    rs.getString("department_name")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isDoctorInShift(int shiftId, int doctorId) {
        String sql = "SELECT 1 FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addDoctorToShift(int shiftId, int doctorId) {
        if (isDoctorInShift(shiftId, doctorId)) {
            return false; // Đã tồn tại, không thêm nữa
        }
        
        String sql = "INSERT INTO Shift_Doctor (shift_id, doctor_id) VALUES (?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean removeDoctorFromShift(int shiftId, int doctorId) {
        String sql = "DELETE FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}