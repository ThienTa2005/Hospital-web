package model.entity;

import com.google.gson.annotations.SerializedName;

public class Doctor extends User {

    // Thuộc tính riêng (cũng nên là private)
    private String degree;
    private int departmentId;
    private String departmentName; // Thuộc tính JOIN
    
    @SerializedName("fullName")
    private String fullname;

    // Constructor
    public Doctor() {
        super();
        // Dùng setter để gán giá trị cho trường private của cha
        setRole("doctor"); 
    }
    
    public String getFullName() 
    {
        return fullname;
    }
    
    public void setFullName(String fullname)
    {
        this.fullname = fullname;
    }
    
    // Getters and Setters cho các thuộc tính riêng
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
}