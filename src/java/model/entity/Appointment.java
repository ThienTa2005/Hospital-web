package model.entity;

import java.sql.Timestamp; // Appointment dùng Datetime hoặc Timestamp
import java.sql.Time;
import java.sql.Date;

public class Appointment {
    private int appointmentId;
    private int patientId;
    private int shiftDoctorId;
    private Timestamp appointmentDate; //ngày giờ đặt hẹn created_at
    private String status; // pending, completed, cancelled

    //cho frontend thông tin thêm
    private String doctorName;
    private String departmentName;
    private String patientName; //dành cho bác sĩ xem danh sách bệnh nhân
    private Date shiftDate;
    private Time startTime;
    private Time endTime;

    public Appointment() {}

    //constructor đầy đủ 
    public Appointment(int appointmentId, int patientId, int shiftDoctorId, Timestamp appointmentDate, String status, 
                       String doctorName, String departmentName, String patientName, Date shiftDate, Time startTime, Time endTime) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.shiftDoctorId = shiftDoctorId;
        this.appointmentDate = appointmentDate;
        this.status = status;
        this.doctorName = doctorName;
        this.departmentName = departmentName;
        this.patientName = patientName;
        this.shiftDate = shiftDate;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public Appointment(int patientId, int shiftDoctorId, Timestamp appointmentDate, String status) {
        this.patientId = patientId;
        this.shiftDoctorId = shiftDoctorId;
        this.appointmentDate = appointmentDate;
        this.status = status;
    }


    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getShiftDoctorId() { return shiftDoctorId; }
    public void setShiftDoctorId(int shiftDoctorId) { this.shiftDoctorId = shiftDoctorId; }

    public Timestamp getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Timestamp appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    //getters cho thông tin hiển thị
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public Date getShiftDate() { return shiftDate; }
    public void setShiftDate(Date shiftDate) { this.shiftDate = shiftDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
}