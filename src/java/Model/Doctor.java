package Model;

public class Doctor {
    private int userId;          // khóa chính, tham chiếu tới Users.user_id
    private String degree;       // học vị
    private int departmentId;    // khoa (tham chiếu Department.department_id)

    // Constructor đầy đủ
    public Doctor(int userId, String degree, int departmentId) {
        this.userId = userId;
        this.degree = degree;
        this.departmentId = departmentId;
    }

    // Constructor rỗng
    public Doctor() {}

    // Getter & Setter
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
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

    @Override
    public String toString() {
        return "Doctor{" +
                "userId=" + userId +
                ", degree='" + degree + '\'' +
                ", departmentId=" + departmentId +
                '}';
    }
}
