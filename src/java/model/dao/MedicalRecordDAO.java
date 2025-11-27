package model.dao;

import Utils.DBUtils;
import static Utils.DBUtils.getConnection;
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
    
    public boolean saveExamination(MedicalRecord record, List<model.entity.Test> tests, int appointmentId) {
        Connection conn = null;
        PreparedStatement psRecord = null;
        PreparedStatement psTest = null;
        PreparedStatement psApp = null;

        // SQL Lưu hồ sơ
        String sqlRecord = "INSERT INTO MedicalRecord (diagnosis, notes, prescription, appointment_id) VALUES (?, ?, ?, ?)";
        
        // SQL Lưu xét nghiệm (Chỉ insert các trường cần thiết, shift_doctor_id để null)
        String sqlTest = "INSERT INTO Test (test_name, test_time, appointment_id, parameter, parameter_value, unit, reference_range) VALUES (?, NOW(), ?, ?, ?, ?, ?)";
        
        // SQL Cập nhật trạng thái
        String sqlUpdateApp = "UPDATE Appointment SET status = 'completed' WHERE appointment_id = ?";

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // --- BẮT ĐẦU TRANSACTION ---

            // 1. Lưu MedicalRecord
            psRecord = conn.prepareStatement(sqlRecord);
            psRecord.setString(1, record.getDiagnosis());
            psRecord.setString(2, record.getNotes());
            psRecord.setString(3, record.getPrescription());
            psRecord.setInt(4, appointmentId);
            int recResult = psRecord.executeUpdate();
            System.out.println("DEBUG: Saved Record -> Rows: " + recResult);

            // 2. Lưu Tests (Nếu có)
            if (tests != null && !tests.isEmpty()) {
                psTest = conn.prepareStatement(sqlTest);
                for (model.entity.Test t : tests) {
                    psTest.setString(1, t.getName());
                    psTest.setInt(2, appointmentId);
                    psTest.setString(3, t.getParameter());
                    psTest.setString(4, t.getParameterValue());
                    psTest.setString(5, t.getUnit());
                    psTest.setString(6, t.getReferenceRange());
                    psTest.addBatch();
                }
                int[] testResults = psTest.executeBatch();
                System.out.println("DEBUG: Saved Tests -> Count: " + testResults.length);
            }

            psApp = conn.prepareStatement(sqlUpdateApp);
            psApp.setInt(1, appointmentId);
            int appResult = psApp.executeUpdate();
            System.out.println("DEBUG: Updated Status -> Rows: " + appResult);

            conn.commit(); 
            return true;

        } catch (Exception e) {
            System.out.println("!!! LỖI TRANSACTION !!! Đang Rollback...");
            e.printStackTrace(); 
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (psRecord != null) psRecord.close();
                if (psTest != null) psTest.close();
                if (psApp != null) psApp.close();
                if (conn != null) conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
