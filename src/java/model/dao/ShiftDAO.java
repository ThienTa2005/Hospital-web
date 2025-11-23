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
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import model.entity.Doctor;

public class ShiftDAO
{
    // Liet ke tat ca ca truc
    public List<Shift> getAllShifts() throws SQLException
    {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shift";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery())
        {
            while(rs.next())
            {
                list.add(new Shift(rs.getInt(1), rs.getDate(2), rs.getTime(3), rs.getTime(4)));
            }
        }
        return list;
    }
    
    public List<Doctor> getAllDoctorsInShift(int shiftId) throws SQLException {
        List<Doctor> list = new ArrayList<>();

        String sql = "SELECT d.user_id, d.department_id, d.degree, dp.name, u.fullname\n"
                   + "FROM Doctor d\n"
                   + "JOIN Shift_Doctor ds ON ds.doctor_id = d.user_id\n"
                   + "JOIN Shift s ON s.shift_id = ds.shift_id\n"
                   + "JOIN Users u ON u.user_id = d.user_id\n"
                   + "JOIN Department AS dp ON dp.department_id = d.department_id\n"
                   + "WHERE s.shift_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, shiftId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setDepartmentId(rs.getInt("department_id"));
                doctor.setDegree(rs.getString("degree"));
                doctor.setFullName(rs.getString("u.fullname"));
                doctor.setDepartmentName(rs.getString("dp.name"));
                list.add(doctor);
            }
        }

        return list;
    }

    
    // Them ca truc
    public boolean addShift(Shift shift) throws SQLException
    {
        String sql = "INSERT INTO Shift (shift_date, start_time, end_time) VALUES (?, ?, ?)";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            LocalDate shiftDate = shift.getShiftDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            ps.setDate(1, Date.valueOf(shiftDate));
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    
    
    // Lay ca truc qua ID
    public Shift getShiftById(int id) throws SQLException
    {
        String sql = "SELECT * FROM Shift WHERE shift_id = ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next())
            {
                return new Shift(rs.getInt(1), rs.getDate(2), rs.getTime(3), rs.getTime(4));
            }
        }
        return null;
    }
    
    // Tim ca truc qua thoi gian
    public List<Shift> searchByTime(Date date, Time time) throws SQLException {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shift WHERE shift_date = ? AND ? BETWEEN start_time AND end_time";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setDate(1, date);
            ps.setTime(2, time);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) 
            {
                list.add(new Shift(
                        rs.getInt("shift_id"),
                        rs.getDate("shift_date"),
                        rs.getTime("start_time"),
                        rs.getTime("end_time")
                ));
            }
        }
        return list;
    }
    
    public boolean addShiftByDateAndPeriod(String shiftDate, String shiftType) throws SQLException 
    {
        Time start = null, end = null;

        switch (shiftType) {
            case "morning": start = Time.valueOf("07:00:00"); end = Time.valueOf("12:00:00"); break;
            case "afternoon": start = Time.valueOf("13:00:00"); end = Time.valueOf("18:00:00"); break;
            case "night": start = Time.valueOf("19:00:00"); end = Time.valueOf("7:00:00"); break;
        }
        
        String sql = "INSERT INTO Shift (shift_date, start_time, end_time) VALUES (?, ?, ?)";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setDate(1, Date.valueOf(shiftDate));
            ps.setTime(2, start);
            ps.setTime(3, end);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Hàm tìm theo ngày và ca (morning/afternoon/night)
    public Shift getShiftsByDateAndPeriod(Date date, String period) throws SQLException {
        List<Shift> list = new ArrayList<>();

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
                endTime = Time.valueOf("07:00:00");
                break;
            default:
                throw new IllegalArgumentException("Period must be 'morning', 'afternoon', or 'night'");
        }

        String sql = "SELECT * FROM Shift WHERE shift_date = ? AND start_time = ? AND end_time = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, date);
            ps.setTime(2, startTime);
            ps.setTime(3, endTime);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Shift(
                    rs.getInt("shift_id"),
                    rs.getDate("shift_date"),
                    rs.getTime("start_time"),
                    rs.getTime("end_time")
                ));
            }
        }

        return list.get(0);
    }


    
    // Cap nhat ca truc
    public void updateShift(Shift shift) throws SQLException {
        String sql = "UPDATE Shift SET shift_date=?, start_time=?, end_time=? WHERE shift_id=?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            LocalDate shiftDate = shift.getShiftDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();   
            ps.setDate(1, Date.valueOf(shiftDate)); 
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            ps.setInt(4, shift.getShiftId());

            ps.executeUpdate();
        }
    }
    
    // Xoa ca truc
    public boolean deleteShift(int id) throws SQLException
    {
        String sql = "DELETE FROM Shift WHERE shift_id = ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Lưu danh sách bác sĩ cho 1 ca trực
    public void saveDoctorsInShift(String shiftDate, String shiftType, List<Doctor> doctors) throws SQLException {
        Shift shift = getShiftsByDateAndPeriod(Date.valueOf(shiftDate), shiftType);
        
        String deleteSQL = "DELETE FROM Shift_Doctor WHERE shift_id = ?";
        String insertSQL = "INSERT INTO Shift_Doctor(shift_id, doctor_id) VALUES (?, ?)";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement deletePS = conn.prepareStatement(deleteSQL);
             PreparedStatement insertPS = conn.prepareStatement(insertSQL)) {

            // 1. Xóa ca trực cũ
            deletePS.setInt(1, shift.getShiftId());
            deletePS.executeUpdate();

            // 2. Thêm bác sĩ mới
            for (Doctor doc : doctors) {
                insertPS.setInt(1, shift.getShiftId());
                insertPS.setInt(2, doc.getUserId());
                insertPS.addBatch();
            }
            insertPS.executeBatch();
        }
    }
    
    // Xóa shift và tất cả bác sĩ liên quan
    public boolean deleteShiftAndDoctors(String shiftDate, String shiftType) throws SQLException {
        Shift shift = getShiftsByDateAndPeriod(Date.valueOf(shiftDate), shiftType);
        
        String deleteDoctorSQL = "DELETE FROM Shift_Doctor WHERE shift_id = ?";
        String deleteShiftSQL = "DELETE FROM Shift WHERE shift_id = ?";

        try(Connection conn = DBUtils.getConnection();
            PreparedStatement psDoctor = conn.prepareStatement(deleteDoctorSQL);
            PreparedStatement psShift = conn.prepareStatement(deleteShiftSQL)) {

            psDoctor.setInt(1, shift.getShiftId());
            psDoctor.executeUpdate();

            psShift.setInt(1, shift.getShiftId());
            return psShift.executeUpdate() > 0;
        }
    }

}
