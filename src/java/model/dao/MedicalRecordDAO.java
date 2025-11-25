package model.dao;

import Utils.DBUtils;
import java.sql.*;
import java.util.*;
import model.entity.MedicalRecord;

public class MedicalRecordDAO
{
    // Lay ho so theo lich hen
    public List<MedicalRecord> getMedicalRecordByAppointmentId(int appointmentId) throws SQLException
    {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM MedicalRecord WHERE appointment_id=?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if(rs.next())
            {
                list.add(new MedicalRecord(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getInt(5)));
            }
        }
        return list;
    }
    
    // Them ho so
    public boolean addRecord(MedicalRecord m) throws SQLException
    {
        String sql = "INSERT INTO MedicalRecord(diagnosis, notes, prescription, appointment_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setString(1, m.getDiagnosis());
            ps.setString(2, m.getNotes());
            ps.setString(3, m.getPrescription());
            ps.setInt(4, m.getAppointmentId());

            return ps.executeUpdate() > 0;
        }
    }
    
    // Cap nhat ho so
    public boolean updateRecord(MedicalRecord m) throws SQLException
    {
        String sql = "UPDATE MedicalRecord SET diagnosis=?, notes=?, prescription=? WHERE record_id=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setString(1, m.getDiagnosis());
            ps.setString(2, m.getNotes());
            ps.setString(3, m.getPrescription());
            ps.setInt(4, m.getRecordId());

            return ps.executeUpdate() > 0;
        }  
    }
    
    // Xoa ho so
    public boolean delete(int id) throws SQLException
    {
        String sql = "DELETE FROM MedicalRecord WHERE record_id=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) 
        {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } 
    }
}
