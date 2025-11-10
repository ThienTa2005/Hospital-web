package model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Utils.DBUtils;
import model.entity.User;
import model.entity.Doctor;

public class UserDAO {
    
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

public int createUser(User user) throws SQLException {
    String sql = "INSERT INTO users(username, password, fullname, dob, gender, phonenum, address, role) VALUES (?,?,?,?,?,?,?,?)";
    
        try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getFullname());
        ps.setDate(4, user.getDob());
        ps.setString(5, user.getGender());
        ps.setString(6, user.getPhonenum());
        ps.setString(7, user.getAddress());
        ps.setString(8, user.getRole());

        int affectedRows = ps.executeUpdate();
        if (affectedRows == 0) throw new SQLException("Tạo user thất bại.");

        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1); 
            } else {
                throw new SQLException("Không lấy được ID.");
            }
        }
    }
}
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
        
      
    }
    
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
