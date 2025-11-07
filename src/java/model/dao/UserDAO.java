package model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Utils.DBUtils;
import model.entity.User;
import model.entity.Doctor; // (MỚI) Cần import Doctor

public class UserDAO {
    
    // (MỚI) Thêm các câu SQL cho bảng vai trò
    private static final String INSERT_PATIENT_SQL = "INSERT INTO Patient (user_id) VALUES (?)";
    private static final String INSERT_DOCTOR_SQL = "INSERT INTO Doctor (user_id, degree, department_id) VALUES (?, ?, ?)";
    

    // (HÀM CŨ)
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password")); 
        u.setFullname(rs.getString("fullname"));
        u.setDob(rs.getDate("dob"));
        u.setGender(rs.getString("gender"));
        u.setPhonenum(rs.getString("phonenum"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        return u;
    }
    
    // (HÀM CŨ)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // (HÀM CŨ)
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username=? AND password=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; 
    }
    
    // (HÀM CŨ)
    public boolean isUsernameExist(String username) throws SQLException {
        String sql = "select 1 from users where username=?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); 
            }
        }
    }
    
    // (HÀM CŨ)
    public boolean checkEditUsername(String username, int id) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE username = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    return userId != id; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; 
    }

    // (HÀM ĐÃ SỬA LẠI HOÀN TOÀN)
    /**
     * Thêm user mới.
     * Hàm này sử dụng Transaction để thêm vào cả bảng Users và bảng vai trò (Patient/Doctor).
     */
    public boolean createUser(User user) throws SQLException {
        String sql_user = "insert into users(username, password, fullname, dob, gender, phonenum, address, role) values (?,?,?,?,?,?,?,?)";

        Connection connection = null;
        PreparedStatement psUser = null;
        PreparedStatement psRole = null; // Dùng cho Patient/Doctor
        ResultSet generatedKeys = null;
        boolean success = false;

        try {
            connection = DBUtils.getConnection();
            connection.setAutoCommit(false); // BẮT ĐẦU TRANSACTION

            // Bước 1: Thêm vào bảng Users
            psUser = connection.prepareStatement(sql_user, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getPassword()); // ⚠️ Cảnh báo: Mật khẩu plain text
            psUser.setString(3, user.getFullname());
            psUser.setDate(4, user.getDob());
            psUser.setString(5, user.getGender());
            psUser.setString(6, user.getPhonenum());
            psUser.setString(7, user.getAddress());
            psUser.setString(8, user.getRole());
            
            int affectedRows = psUser.executeUpdate();

            // Nếu Bước 1 thất bại, hủy bỏ
            if (affectedRows == 0) {
                connection.rollback();
                return false;
            }

            // Lấy user_id vừa tạo
            int userId = -1;
            generatedKeys = psUser.getGeneratedKeys();
            if (generatedKeys.next()) {
                userId = generatedKeys.getInt(1);
            }

            // Nếu không lấy được ID, hủy bỏ
            if (userId == -1) {
                connection.rollback();
                return false;
            }

            // Bước 2: Thêm vào bảng vai trò (Patient hoặc Doctor)
            // (Đây là logic bạn yêu cầu)
            if (user.getRole().equals("patient")) {
                psRole = connection.prepareStatement(INSERT_PATIENT_SQL);
                psRole.setInt(1, userId);
                psRole.executeUpdate();
                
            } else if (user.getRole().equals("doctor")) {
                // Giả định: nếu role là doctor, thì user phải là một đối tượng Doctor
                Doctor doctor = (Doctor) user; // Ép kiểu
                psRole = connection.prepareStatement(INSERT_DOCTOR_SQL);
                psRole.setInt(1, userId);
                psRole.setString(2, doctor.getDegree());
                psRole.setInt(3, doctor.getDepartmentId());
                psRole.executeUpdate();
            }
            // (Nếu là 'admin' hoặc 'nurse' thì không làm gì thêm)

            connection.commit(); // HOÀN TẤT TRANSACTION
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (connection != null) {
                connection.rollback(); // Hủy bỏ nếu có lỗi
            }
            throw e; // Ném lỗi ra ngoài
        } finally {
            // Đóng tất cả
            if (generatedKeys != null) generatedKeys.close();
            if (psRole != null) psRole.close();
            if (psUser != null) psUser.close();
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
        return success;
    }


    // (HÀM CŨ)
    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?;";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // (HÀM CŨ) - CẬP NHẬT USER
    // LƯU Ý: Hàm này chưa cập nhật bảng Doctor (degree, department).
    // Nếu bạn cần cập nhật cả thông tin Doctor, hàm này cũng cần được sửa lại
    public void updateUser(User user) throws SQLException {
        String sql = "update users set username=?, password=?, fullname=?, dob=?, gender=?, phonenum=?, address=?, role=? where user_id=?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); 
            ps.setString(3, user.getFullname());
            ps.setDate(4, user.getDob());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getPhonenum());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getRole());
            ps.setInt(9, user.getUserId());
            
            ps.executeUpdate();
        }
        
        // (BẠN CẦN THÊM LOGIC UPDATE BẢNG DOCTOR Ở ĐÂY NẾU CẦN)
    }
    
    // (HÀM CŨ)
    public List<User> searchByName(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE fullname LIKE ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + keyword + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}