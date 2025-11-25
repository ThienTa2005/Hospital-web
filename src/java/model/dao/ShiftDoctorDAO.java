package model.dao;

import Utils.DBUtils;
import model.entity.ShiftDoctor;
import model.entity.Shift;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

public class ShiftDoctorDAO {

    // Lấy danh sách bác sĩ theo ca trực
    public List<ShiftDoctor> getDoctorsByShift(int shiftId) {
        List<ShiftDoctor> list = new ArrayList<>();
        String sql = "SELECT sd.shift_id, sd.doctor_id, u.fullname, d.degree, dp.name AS department_name "
                + "FROM Shift_Doctor sd "
                + "JOIN Doctor d ON sd.doctor_id = d.user_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "LEFT JOIN Department dp ON d.department_id = dp.department_id "
                + "WHERE sd.shift_id = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, shiftId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new ShiftDoctor(
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

    // Kiểm tra bác sĩ đã có trong ca trực chưa
    public boolean isDoctorInShift(int shiftId, int doctorId) {
        String sql = "SELECT 1 FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // Thêm bác sĩ vào ca trực
    public boolean addDoctorToShift(int shiftId, int doctorId) {
        if (isDoctorInShift(shiftId, doctorId)) {
            return false; // Đã tồn tại
        }

        String sql = "INSERT INTO Shift_Doctor (shift_id, doctor_id) VALUES (?, ?)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa bác sĩ khỏi ca trực
    public boolean removeDoctorFromShift(int shiftId, int doctorId) {
        String sql = "DELETE FROM Shift_Doctor WHERE shift_id = ? AND doctor_id = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách ca trực theo bác sĩ trong khoảng thời gian
    public List<Shift> getShiftsByDoctor(int doctorId, Date fromDate, Date toDate) {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT s.* FROM Shift s "
                + "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id "
                + "WHERE sd.doctor_id = ? "
                + "AND s.shift_date BETWEEN ? AND ? "
                + "ORDER BY s.shift_date ASC, s.start_time ASC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Shift(
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

    // Kiểm tra bác sĩ đang trực ngay bây giờ
    public boolean isDoctorCurrentlyOnShift(int doctorId) {
        String sql = "SELECT 1 FROM Shift s "
                + "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id "
                + "WHERE sd.doctor_id = ? "
                + "AND s.shift_date = CURDATE() "
                + "AND CURTIME() BETWEEN s.start_time AND s.end_time";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        String sql = "SELECT COUNT(*) FROM Shift s "
                + "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id "
                + "WHERE sd.doctor_id = ? "
                + "AND MONTH(s.shift_date) = MONTH(CURDATE()) "
                + "AND YEAR(s.shift_date) = YEAR(CURDATE())";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách ca trực HÔM NAY theo bác sĩ
    public List<Shift> getShiftsToday(int doctorId) {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT s.* FROM Shift s "
                + "JOIN Shift_Doctor sd ON s.shift_id = sd.shift_id "
                + "WHERE sd.doctor_id = ? AND s.shift_date = CURDATE() "
                + "ORDER BY s.start_time ASC";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Shift(
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
    // Thêm import ở đầu file ShiftDoctorDAO.java
// import java.util.Map;
// import java.util.HashMap;
// import java.sql.Time;

    public List<Map<String, Object>> getDoctorOptionsForBooking(Date date, String period) {
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> row;

        Time startTime;
        Time endTime;

        switch (period.toLowerCase()) {
            case "morning":
                startTime = Time.valueOf("07:00:00");
                endTime = Time.valueOf("12:00:00");
                break;
            case "afternoon":
                startTime = Time.valueOf("13:00:00");
                endTime = Time.valueOf("18:00:00");
                break;
            case "night":
                startTime = Time.valueOf("19:00:00");
                endTime = Time.valueOf("23:59:59"); // hoặc 07:00 hôm sau tùy bạn
                break;
            default:
                throw new IllegalArgumentException("Period must be 'morning', 'afternoon', or 'night'");
        }

        String sql = "SELECT sd.shift_doctor_id, u.fullname, d.degree, dp.name AS department_name "
                + "FROM Shift_Doctor sd "
                + "JOIN Shift s ON s.shift_id = sd.shift_id "
                + "JOIN Doctor doc ON sd.doctor_id = doc.user_id "
                + "JOIN Users u ON doc.user_id = u.user_id "
                + "LEFT JOIN Department dp ON doc.department_id = dp.department_id "
                + "WHERE s.shift_date = ? AND s.start_time = ? AND s.end_time = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, date);
            ps.setTime(2, startTime);
            ps.setTime(3, endTime);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    row = new HashMap<>();
                    row.put("shift_doctor_id", rs.getInt("shift_doctor_id"));
                    row.put("doctor_name", rs.getString("fullname"));
                    row.put("degree", rs.getString("degree"));
                    row.put("department_name", rs.getString("department_name"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    // Lịch làm việc của 1 bác sĩ theo ngày (dùng cho đặt lịch)

    public List<Map<String, Object>> getDoctorScheduleByDate(int doctorId, Date date) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql
                = "SELECT sd.shift_doctor_id, s.shift_date, s.start_time, s.end_time, "
                + "       dp.name AS department_name "
                + // KHÔNG dùng dp.address nữa
                "FROM Shift_Doctor sd "
                + "JOIN Shift s        ON sd.shift_id = s.shift_id "
                + "LEFT JOIN Doctor d  ON sd.doctor_id = d.user_id "
                + "LEFT JOIN Department dp ON d.department_id = dp.department_id "
                + "WHERE sd.doctor_id = ? AND s.shift_date = ? "
                + "ORDER BY s.start_time";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, date);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("shiftDoctorId", rs.getInt("shift_doctor_id"));
                    row.put("shiftDate", rs.getDate("shift_date"));
                    row.put("startTime", rs.getTime("start_time"));
                    row.put("endTime", rs.getTime("end_time"));
                    row.put("departmentName", rs.getString("department_name"));
                    // JSP có dùng key "address" nên cho rỗng để khỏi lỗi
                    row.put("address", "");
                    list.add(row);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}
