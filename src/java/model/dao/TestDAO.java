package model.dao;

import Utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.Test;

public class TestDAO
{
    // Lay tat ca xet nghiem
    public List<Test> getTestByAppointmentId(int appointmentId) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM Test WHERE appointment_id = ? ORDER BY test_time ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // Them xet nghiem
    public boolean addTest(Test t) throws Exception
    {
        String sql = "INSERT INTO Test(test_name, test_time, parameter, parameter_value, unit, " +
                     "reference_range, appointment_id, shift_doctor_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setString(1, t.getName());
            ps.setTimestamp(2, new Timestamp(t.getTestTime().getTime()));
            ps.setString(3, t.getParameter());
            ps.setString(4, t.getParameterValue());
            ps.setString(5, t.getUnit());
            ps.setString(6, t.getReferenceRange());
            ps.setInt(7, t.getAppointmentId());
            ps.setInt(8, t.getShiftDoctorId());

            return ps.executeUpdate() > 0;
        }
    }
    
    // Cap nhat xet nghiem 
    public boolean updateTest(Test t) throws Exception 
    {
         String sql = "UPDATE Test SET test_name=?, test_time=?, parameter=?, parameter_value=?, " +
        "unit=?, reference_range=?, appointment_id=?, shift_doctor_id=? " +
        "WHERE test_id=?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setString(1, t.getName());
            ps.setTimestamp(2, new Timestamp(t.getTestTime().getTime()));
            ps.setString(3, t.getParameter());
            ps.setString(4, t.getParameterValue());
            ps.setString(5, t.getUnit());
            ps.setString(6, t.getReferenceRange());
            ps.setInt(7, t.getAppointmentId());
            ps.setInt(8, t.getShiftDoctorId());
            ps.setInt(9, t.getTestId());

            return ps.executeUpdate() > 0;
        }
    }
    
    // Xoa xet nghiem 
    public boolean deleteTest(int id) throws Exception 
    {
        String sql = "DELETE FROM Test WHERE test_id = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
    
    private Test map(ResultSet rs) throws Exception {
        return new Test(
            rs.getInt("test_id"),
            rs.getString("test_name"),
            rs.getTimestamp("test_time"),
            rs.getString("parameter"),
            rs.getString("parameter_value"),
            rs.getString("unit"),
            rs.getString("reference_range"),
            rs.getInt("appointment_id"),
            rs.getInt("shift_doctor_id")
        );
    }
}