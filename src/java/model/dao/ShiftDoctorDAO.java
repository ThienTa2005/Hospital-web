/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dao;

/**
 *
 * @author tn150
 */
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

    // 3. Thêm bác sĩ vào ca trực
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
    
    public List<model.entity.Shift> getShiftsByDoctor(int doctorId, Date fromDate, Date toDate) {
        List<model.entity.Shift> list = new ArrayList<>();
        String sql = "SELECT s.* FROM Shift s " +
                     "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id " +
                     "WHERE sd.doctor_id = ? " +
                     "AND s.shift_date BETWEEN ? AND ? " +
                     "ORDER BY s.shift_date ASC, s.start_time ASC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new model.entity.Shift(
                    rs.getInt("shift_id"),
                    rs.getDate("shift_date"),
                    rs.getTime("start_time"),
                    rs.getTime("end_time")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Kiểm tra xem bác sĩ có đang trong ca trực ngay bây giờ không??
    public boolean isDoctorCurrentlyOnShift(int doctorId) {
        String sql = "SELECT 1 FROM Shift s " +
                     "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id " +
                     "WHERE sd.doctor_id = ? " +
                     "AND s.shift_date = CURDATE() " +
                     "AND CURTIME() BETWEEN s.start_time AND s.end_time";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm số ca trực trong tháng hiện tại
    public int countShiftsInCurrentMonth(int doctorId) {
        String sql = "SELECT COUNT(*) FROM Shift s " +
                     "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id " +
                     "WHERE sd.doctor_id = ? " +
                     "AND MONTH(s.shift_date) = MONTH(CURDATE()) " +
                     "AND YEAR(s.shift_date) = YEAR(CURDATE())";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách ca trực HÔM NAY để hiển thị Timeline
    public List<model.entity.Shift> getShiftsToday(int doctorId) {
        List<model.entity.Shift> list = new ArrayList<>();
        String sql = "SELECT s.* FROM Shift s " +
                     "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id " +
                     "WHERE sd.doctor_id = ? AND s.shift_date = CURDATE() " +
                     "ORDER BY s.start_time ASC";
         try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new model.entity.Shift(
                    rs.getInt("shift_id"),
                    rs.getDate("shift_date"),
                    rs.getTime("start_time"),
                    rs.getTime("end_time")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}