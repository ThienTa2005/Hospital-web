package model.dao;

import Utils.DBUtils;
import static Utils.DBUtils.getConnection;
import model.entity.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class AppointmentDAO {
    private static final String SELECT_FULL_INFO
            = "SELECT a.appointment_id, a.patient_id, a.shift_doctor_id, a.appointment_date, a.status, "
            + "       u_doc.fullname AS doctor_name, "
            + "       u_pat.fullname AS patient_name, "
            + "       dep.name AS department_name, "
            + "       s.shift_date, s.start_time, s.end_time "
            + "FROM Appointment a "
            + "JOIN Shift_Doctor sd ON a.shift_doctor_id = sd.shift_doctor_id "
            + "JOIN Doctor d ON sd.doctor_id = d.user_id "
            + "JOIN Users u_doc ON d.user_id = u_doc.user_id "
            + "JOIN Department dep ON d.department_id = dep.department_id "
            + "JOIN Shift s ON sd.shift_id = s.shift_id "
            + "JOIN Users u_pat ON a.patient_id = u_pat.user_id ";

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "ORDER BY a.appointment_date DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public Appointment getAppointmentById(int appointmentId) {
        String sql = SELECT_FULL_INFO + "WHERE a.appointment_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    //lấy danh sách lịch hẹn của một Bệnh nhân 
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "WHERE a.patient_id = ? ORDER BY a.appointment_date DESC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //cho danh sách lịch hẹn của một Bác sĩ (để bác sĩ xem hôm nay khám ai)
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "WHERE sd.doctor_id = ? ORDER BY s.shift_date DESC, s.start_time ASC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDate(LocalDate date) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.shift_doctor_id, a.appointment_date, a.status, "
                + "u_doc.fullname AS doctor_name, "
                + "u_pat.fullname AS patient_name, "
                + "dep.name AS department_name, "
                + "s.shift_date, s.start_time, s.end_time "
                + "FROM Appointment a "
                + "JOIN Shift_Doctor sd ON a.shift_doctor_id = sd.shift_doctor_id "
                + "JOIN Doctor d ON sd.doctor_id = d.user_id "
                + "JOIN Users u_doc ON d.user_id = u_doc.user_id "
                + "LEFT JOIN Department dep ON d.department_id = dep.department_id "
                + "JOIN Shift s ON sd.shift_id = s.shift_id "
                + "JOIN Users u_pat ON a.patient_id = u_pat.user_id "
                + "WHERE s.shift_date = ? "
                + "ORDER BY s.start_time ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(date));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Appointment(
                        rs.getInt("appointment_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("shift_doctor_id"), // đúng theo DB
                        rs.getTimestamp("appointment_date"),
                        rs.getString("status"),
                        rs.getString("doctor_name"),
                        rs.getString("department_name"),
                        rs.getString("patient_name"),
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

    //tạo lịch hẹn mới
    public boolean createBooking(Appointment app) {
           String sql = "INSERT INTO Appointment (patient_id, shift_doctor_id, appointment_date, status) VALUES (?, ?, ?, ?)";

           try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

               ps.setInt(1, app.getPatientId());
               ps.setInt(2, app.getShiftDoctorId());

               ps.setTimestamp(3, app.getAppointmentDate()); 

               ps.setString(4, app.getStatus()); // pending

               return ps.executeUpdate() > 0;
           } catch (Exception e) {
               e.printStackTrace();
               return false;
           }
       }

    //hủy lịch hẹn
    public boolean cancelAppointment(int id) {
        String sql = "UPDATE Appointment SET status = 'cancelled' WHERE appointment_id = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        return new Appointment(
                rs.getInt("appointment_id"),
                rs.getInt("patient_id"),
                rs.getInt("shift_doctor_id"),
                rs.getTimestamp("appointment_date"),
                rs.getString("status"),
                rs.getString("doctor_name"), //tên bs
                rs.getString("department_name"), //tên khoa
                rs.getString("patient_name"), //tên bệnh nhân
                rs.getDate("shift_date"), //ngày trực
                rs.getTime("start_time"), //giờ bắt đầu
                rs.getTime("end_time") //giờ kết thúc
        );
    }

    public List<Appointment> getAppointmentsByPatientFilter(int patientId, Integer departmentId, LocalDate appointmentDate, String shift) {
        List<Appointment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(SELECT_FULL_INFO);
        sql.append("WHERE a.patient_id = ? ");

        if (departmentId != null) {
            sql.append("AND dep.department_id = ? ");
        }

        if (appointmentDate != null) {
            sql.append("AND DATE(a.appointment_date) = ? ");
        }

        Time shiftStart = null;
        Time shiftEnd = null;
        if (shift != null && !shift.isEmpty()) {
            switch (shift.toLowerCase()) {
                case "morning":
                    shiftStart = Time.valueOf("07:00:00");
                    shiftEnd = Time.valueOf("12:00:00");
                    break;
                case "afternoon":
                    shiftStart = Time.valueOf("13:00:00");
                    shiftEnd = Time.valueOf("18:00:00");
                    break;
            }
            if (shiftStart != null && shiftEnd != null) {
                sql.append("AND TIME(a.appointment_date) BETWEEN ? AND ? ");
            }
        }

        sql.append("ORDER BY a.appointment_date DESC, a.appointment_id ASC");

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, patientId);

            if (departmentId != null) {
                ps.setInt(index++, departmentId);
            }

            if (appointmentDate != null) {
                ps.setDate(index++, Date.valueOf(appointmentDate));
            }

            if (shiftStart != null && shiftEnd != null) {
                ps.setTime(index++, shiftStart);
                ps.setTime(index++, shiftEnd);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Appointment> getAppointmentsByPatientInCurrentMonth(int patientId) {
        List<Appointment> list = new ArrayList<>();

        String sql = SELECT_FULL_INFO
                + "WHERE a.patient_id = ? "
                + "  AND MONTH(a.appointment_date) = MONTH(CURRENT_DATE()) "
                + "  AND YEAR(a.appointment_date) = YEAR(CURRENT_DATE()) "
                + "ORDER BY a.appointment_date DESC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> getPatientHistoryMap(int patientId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT a.appointment_id, a.appointment_date, a.status, "
                + "       u.fullname AS doctor_name, d.name AS dept_name, "
                + "       mr.record_id "
                +
                "FROM Appointment a "
                + "JOIN Shift_Doctor sd ON a.shift_doctor_id = sd.shift_doctor_id "
                + "JOIN Doctor doc ON sd.doctor_id = doc.user_id "
                + "JOIN Users u ON doc.user_id = u.user_id "
                + "LEFT JOIN Department d ON doc.department_id = d.department_id "
                + "LEFT JOIN MedicalRecord mr ON a.appointment_id = mr.appointment_id "
                + "WHERE a.patient_id = ? "
                + "ORDER BY a.appointment_date DESC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("appointment_id", rs.getInt("appointment_id"));
                row.put("appointment_date", rs.getTimestamp("appointment_date")); // Lấy cả ngày giờ
                row.put("status", rs.getString("status"));
                row.put("doctor_name", rs.getString("doctor_name"));
                row.put("dept_name", rs.getString("dept_name"));

                int recordId = rs.getInt("record_id");
                row.put("record_id", recordId > 0 ? recordId : null);

                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDoctorIdAndDate(int doctorId, LocalDate date) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO
                   + "WHERE sd.doctor_id = ? AND s.shift_date = ? "
                   + "ORDER BY s.start_time ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, java.sql.Date.valueOf(date));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Appointment> getCompletedAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL_INFO + "WHERE a.patient_id = ? AND a.status = 'completed' ORDER BY a.appointment_date DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
        try (java.sql.Connection conn = getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}