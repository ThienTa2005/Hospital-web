package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBUtils {
    // Thông tin kết nối
    private static final String URL = "jdbc:mysql://localhost:3306/clinic_db";
    private static final String USER = "root";
    private static final String PASSWORD = "041299"; // sửa thành mật khẩu của bạn

    // Hàm mở kết nối
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Ket noi DB thanh cong!");
        } catch (ClassNotFoundException e) {
            System.out.println("Khong tim thay Driver MySQL!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Loi ket noi DB!");
            e.printStackTrace();
        }
        return conn;
    }

    // Hàm đóng kết nối
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Đa đong ket noi.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Hàm in toàn bộ user
    public static void printUsers() {
        String query = "SELECT * FROM users";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("=== USERS ===");
            while (rs.next()) {
                int id = rs.getInt("id");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String role = rs.getString("role");
                System.out.printf("%d | %s | %s | %s%n", id, username, password, role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Hàm in toàn bộ bệnh nhân
    public static void printPatients() {
        String query = "SELECT * FROM patients";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("=== PATIENTS ===");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String dob = rs.getString("dob");
                String gender = rs.getString("gender");
                String address = rs.getString("address");
                String phone = rs.getString("phone");
                System.out.printf("%d | %s | %s | %s | %s | %s%n",
                        id, name, dob, gender, address, phone);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
