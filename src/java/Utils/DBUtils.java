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
    private static final String PASSWORD = "Conmeodeptraiphongdo"; // sửa thành mật khẩu của bạn

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
}
