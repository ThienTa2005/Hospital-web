package model.dao;

import Utils.DBUtils;
import java.util.ArrayList;
import java.util.List;
import model.entity.Shift;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ShiftDAO {

    // Liệt kê tất cả ca trực
    public List<Shift> getAllShifts() throws SQLException {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shift";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Shift(
                        rs.getInt(1),
                        rs.getDate(2),
                        rs.getTime(3),
                        rs.getTime(4)
                ));
            }
        }
        return list;
    }

    // Thêm ca trực
    public boolean addShift(Shift shift) throws SQLException {
        String sql = "INSERT INTO Shift (shift_date, start_time, end_time) VALUES (?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 👉 Chuyển từ java.util.Date sang java.sql.Date một cách an toàn
            java.sql.Date sqlDate;
            if (shift.getShiftDate() instanceof java.sql.Date) {
                sqlDate = (java.sql.Date) shift.getShiftDate();
            } else {
                sqlDate = new java.sql.Date(shift.getShiftDate().getTime());
            }

            ps.setDate(1, sqlDate);
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());

            return ps.executeUpdate() > 0;
        }
    }

    // Lấy ca trực qua ID
    public Shift getShiftById(int id) throws SQLException {
        String sql = "SELECT * FROM Shift WHERE shift_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Shift(
                        rs.getInt(1),
                        rs.getDate(2),
                        rs.getTime(3),
                        rs.getTime(4)
                );
            }
        }
        return null;
    }

    // Tìm ca trực qua thời gian (ngày + giờ nằm trong khoảng start–end)
    public List<Shift> searchByTime(Date date, Time time) throws SQLException {
        List<Shift> list = new ArrayList<>();

        String sql = "SELECT shift_id, shift_date, start_time, end_time "
                   + "FROM Shift "
                   + "WHERE shift_date = ? "
                   + "AND start_time <= ? "
                   + "AND end_time >= ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, date);
            ps.setTime(2, time);
            ps.setTime(3, time);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Shift(
                            rs.getInt("shift_id"),
                            rs.getDate("shift_date"),
                            rs.getTime("start_time"),
                            rs.getTime("end_time")
                    ));
                }
            }
        }
        return list;
    }

    // Cập nhật ca trực
    public void updateShift(Shift shift) throws SQLException {
        String sql = "UPDATE Shift SET shift_date = ?, start_time = ?, end_time = ? WHERE shift_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 👉 Cũng dùng cách convert an toàn như trên
            java.sql.Date sqlDate;
            if (shift.getShiftDate() instanceof java.sql.Date) {
                sqlDate = (java.sql.Date) shift.getShiftDate();
            } else {
                sqlDate = new java.sql.Date(shift.getShiftDate().getTime());
            }

            ps.setDate(1, sqlDate);
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            ps.setInt(4, shift.getShiftId());

            ps.executeUpdate();
        }
    }

    // Xóa ca trực
    public boolean deleteShift(int id) throws SQLException {
        String sql = "DELETE FROM Shift WHERE shift_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Tìm tất cả ca trực theo ngày
    public List<Shift> searchByDate(Date date) throws SQLException {
        List<Shift> list = new ArrayList<>();

        String sql = "SELECT shift_id, shift_date, start_time, end_time "
                   + "FROM Shift "
                   + "WHERE shift_date = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, date);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Shift(
                            rs.getInt("shift_id"),
                            rs.getDate("shift_date"),
                            rs.getTime("start_time"),
                            rs.getTime("end_time")
                    ));
                }
            }
        }

        return list;
    }
}

