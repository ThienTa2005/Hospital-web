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
}

