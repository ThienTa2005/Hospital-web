package model.entity;

public class ShiftDoctor {
    private int shiftDoctorId;
    private int shiftId;
    private int doctorId;
    private String doctorName;
    private String degree;
    private String departmentName;

    public int getShiftDoctorId() {
        return shiftDoctorId;
    }
    public void setShiftDoctorId(int shiftDoctorId) {
        this.shiftDoctorId = shiftDoctorId;
    }

    public int getShiftId() {
        return shiftId;
    }
    public void setShiftId(int shiftId) {
        this.shiftId = shiftId;
    }

    public int getDoctorId() {
        return doctorId;
    }
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getDoctorName() {
        return doctorName;
    }
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDegree() {
        return degree;
    }
    public void setDegree(String degree) {
        this.degree = degree;
    }

    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}
