package Model;

import java.time.LocalDateTime;

public class Appointment {
    private int appointmentId;
    private int patientId;        // Tham chiếu tới Patient.user_id
    private int shiftDoctorId;    // Tham chiếu tới Shift_Doctor.shift_doctor_id
    private LocalDateTime appointmentDate;
    private String status;        // pending / cancelled / completed

    // Constructor rỗng
    public Appointment() {}

    // Constructor đầy đủ
    public Appointment(int appointmentId, int patientId, int shiftDoctorId,
                       LocalDateTime appointmentDate, String status) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.shiftDoctorId = shiftDoctorId;
        this.appointmentDate = appointmentDate;
        this.status = status;
    }

    // Getter & Setter
    public int getAppointmentId() {
        return appointmentId;
    }
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getShiftDoctorId() {
        return shiftDoctorId;
    }
    public void setShiftDoctorId(int shiftDoctorId) {
        this.shiftDoctorId = shiftDoctorId;
    }

    public LocalDateTime getAppointmentDate() {
        return appointmentDate;
    }
    public void setAppointmentDate(LocalDateTime appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId=" + appointmentId +
                ", patientId=" + patientId +
                ", shiftDoctorId=" + shiftDoctorId +
                ", appointmentDate=" + appointmentDate +
                ", status='" + status + '\'' +
                '}';
    }
}
