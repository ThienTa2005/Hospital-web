package model.dao;

import Utils.DBUtils;
import model.entity.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    //lấy tên bs, khoa, giờ trực,tên bệnh nhân
    private static final String SELECT_FULL_INFO = 
        "SELECT a.appointment_id, a.patient_id, a.shift_doctor_id, a.appointment_date, a.status, " +
        "       u_doc.fullname AS doctor_name, " +
        "       u_pat.fullname AS patient_name, " +
        "       dep.name AS department_name, " +
        "       s.shift_date, s.start_time, s.end_time " +
        "FROM Appointment a " +
        "JOIN Shift_Doctor sd ON a.shift_doctor_id = sd.shift_doctor_id " +
        "JOIN Doctor d ON sd.doctor_id = d.user_id " +
        "JOIN Users u_doc ON d.user_id = u_doc.user_id " +       
        "JOIN Department dep ON d.department_id = dep.department_id " + 
        "JOIN Shift s ON sd.shift_id = s.shift_id " +            
        "JOIN Users u_pat ON a.patient_id = u_pat.user_id ";    

    //lấy danh sách lịch hẹn của một Bệnh nhân 
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "WHERE a.patient_id = ? ORDER BY a.appointment_date DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    //cho danh sách lịch hẹn của một Bác sĩ (để bác sĩ xem hôm nay khám ai)
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "WHERE sd.doctor_id = ? ORDER BY s.shift_date DESC, s.start_time ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    //tạo lịch hẹn mới
    public boolean createBooking(Appointment app) {
        String sql = "INSERT INTO Appointment(patient_id, shift_doctor_id, appointment_date, status) VALUES (?, ?, NOW(), ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, app.getPatientId());
            ps.setInt(2, app.getShiftDoctorId());
            ps.setString(3, "pending"); //mặc định là pending
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    //hủy lịch hẹn
    public boolean cancelAppointment(int id) {
        String sql = "UPDATE Appointment SET status = 'cancelled' WHERE appointment_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        return new Appointment(
            rs.getInt("appointment_id"),
            rs.getInt("patient_id"),
            rs.getInt("shift_doctor_id"),
            rs.getTimestamp("appointment_date"),
            rs.getString("status"),
            rs.getString("doctor_name"),     //tên bs
            rs.getString("department_name"), //tên khoa
            rs.getString("patient_name"),    //tên bệnh nhân
            rs.getDate("shift_date"),        //ngày trực
            rs.getTime("start_time"),        //giờ bắt đầu
            rs.getTime("end_time")           //giờ kết thúc
        );
    }
}