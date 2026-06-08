package model.entity;

import java.sql.Date;

public class User {
    private int userId;
    private String username;
    private String password;
    private String fullname;
    private Date dob;
    private String gender;
    private String phonenum;
    private String address;
    private String role;


    public User(int userId, String username, String password, String fullname, Date dob,
                String gender, String phonenum, String address, String role) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.dob = dob;
        this.gender = gender;
        this.phonenum = phonenum;
        this.address = address;
        this.role = role;
    }

    public User() {}

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

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullname='" + fullname + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}