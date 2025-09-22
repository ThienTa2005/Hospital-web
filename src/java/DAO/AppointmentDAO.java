package DAO;

import Model.Appointment;
import Utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    // Thêm lịch hẹn mới
    public boolean addAppointment(Appointment appt) {
        String sql = "INSERT INTO Appointment (patient_id, shift_doctor_id, appointment_date, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getShiftDoctorId());
            ps.setTimestamp(3, Timestamp.valueOf(appt.getAppointmentDate()));
            ps.setString(4, appt.getStatus());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy tất cả lịch hẹn
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment";
        try (Connection conn = DBUtils.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Appointment appt = new Appointment(
                        rs.getInt("appointment_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("shift_doctor_id"),
                        rs.getTimestamp("appointment_date").toLocalDateTime(),
                        rs.getString("status")
                );
                list.add(appt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm lịch hẹn theo ID
    public Appointment getAppointmentById(int id) {
        String sql = "SELECT * FROM Appointment WHERE appointment_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Appointment(
                            rs.getInt("appointment_id"),
                            rs.getInt("patient_id"),
                            rs.getInt("shift_doctor_id"),
                            rs.getTimestamp("appointment_date").toLocalDateTime(),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật lịch hẹn
    public boolean updateAppointment(Appointment appt) {
        String sql = "UPDATE Appointment SET patient_id=?, shift_doctor_id=?, appointment_date=?, status=? WHERE appointment_id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getShiftDoctorId());
            ps.setTimestamp(3, Timestamp.valueOf(appt.getAppointmentDate()));
            ps.setString(4, appt.getStatus());
            ps.setInt(5, appt.getAppointmentId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa lịch hẹn
    public boolean deleteAppointment(int id) {
        String sql = "DELETE FROM Appointment WHERE appointment_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy lịch hẹn của một bệnh nhân
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE patient_id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = new Appointment(
                            rs.getInt("appointment_id"),
                            rs.getInt("patient_id"),
                            rs.getInt("shift_doctor_id"),
                            rs.getTimestamp("appointment_date").toLocalDateTime(),
                            rs.getString("status")
                    );
                    list.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
