package model.entity;

import java.sql.Date;

public class Doctor {

    // ====== Thông tin từ bảng Users ======
    private int userId;
    private String username;
    private String password;    // nếu cần edit user bác sĩ
    private String fullname;
    private Date dob;
    private String gender;
    private String phonenum;
    private String address;
    private String role;

    // ====== Thông tin riêng của bảng Doctor ======
    private String degree;
    private int departmentId;

    // ====== Thông tin từ bảng Department (JOIN) ======
    private String departmentName;

    // ====== Constructor rỗng ======
    public Doctor() {}

    // ====== Constructor đầy đủ ======
    public Doctor(int userId, String username, String password, String fullname,
                  Date dob, String gender, String phonenum, String address, String role,
                  String degree, int departmentId, String departmentName) {

        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.dob = dob;
        this.gender = gender;
        this.phonenum = phonenum;
        this.address = address;
        this.role = role;

        this.degree = degree;
        this.departmentId = departmentId;
        this.departmentName = departmentName;
    }

    // ====== Getter & Setter ======
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Date getDob() {
        return dob;
    }
    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhonenum() {
        return phonenum;
    }
    public void setPhonenum(String phonenum) {
        this.phonenum = phonenum;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }

    public String getDegree() {
        return degree;
    }
    public void setDegree(String degree) {
        this.degree = degree;
    }

    public int getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    // ====== Debug nhanh ======
    @Override
    public String toString() {
        return "Doctor{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullname='" + fullname + '\'' +
                ", degree='" + degree + '\'' +
                ", departmentId=" + departmentId +
                ", departmentName='" + departmentName + '\'' +
                '}';
    }
}
