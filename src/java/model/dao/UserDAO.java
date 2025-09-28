package model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Utils.DBUtils;
import model.entity.User;

public class UserDAO {
    // Lấy tất cả user
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getDate("dob"),
                        rs.getString("gender"),
                        rs.getString("phonenum"),
                        rs.getString("address"),
                        rs.getString("role")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Check login
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username=? AND password=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("fullname"),
                            rs.getDate("dob"),
                            rs.getString("gender"),
                            rs.getString("phonenum"),
                            rs.getString("address"),
                            rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // sai tk/mk
    }
    
    public boolean isUsernameExist(String username) throws SQLException{
        String sql="select 1 from users where username=?";
        try(
            Connection connection=DBUtils.getConnection();
            PreparedStatement ps=connection.prepareStatement(sql)){
            
            ps.setString(1,username);
            
            try(ResultSet rs=ps.executeQuery())
            {
                return rs.next();
            } 
           
        }
    }
    
    public boolean checkEditUsername(String username, int id) throws SQLException
    {
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

    //thêm user
    public boolean createUser(User user) throws SQLException
    {
        String sql="insert into users(username, password, fullname, dob, gender, phonenum, address, role) values (?,?,?,?,?,?,?,?)";

        try(
           Connection connection=DBUtils.getConnection();
           PreparedStatement ps=connection.prepareStatement(sql)){

            ps.setString(1,user.getUsername());
            ps.setString(2,user.getPassword());
            ps.setString(3,user.getFullname());
            ps.setDate(4, new java.sql.Date(user.getDob().getTime()));
            ps.setString(5,user.getGender());
            ps.setString(6,user.getPhonenum());
            ps.setString(7,user.getAddress());
            ps.setString(8,user.getRole());

            return ps.executeUpdate() > 0;
        }       
    }

    //xóa user
//    public boolean deleteUser(String username) throws SQLException{
//        if(isUsernameExist(username)){
//             String sql="delete from users where username=?";
//            try(
//                Connection connection=DBUtils.getConnection();
//                PreparedStatement ps=connection.prepareStatement(sql)){
//
//                ps.setString(1,username);
//                return ps.executeUpdate()>0;
//            }
//        }
//        System.out.println("KHONG TON TAI USERNAME");
//        return false; 
//    }
    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?;";
        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("Rows deleted: " + rows);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //truyen thang user moi, dung username de xac dinh doi tuong update
    public  void updateUser(User user) throws SQLException{
         String sql="update users set username=?, password=?,fullname=?,dob=?,gender=?,phonenum=?,address=?,role=? where user_id=?";
         try(
            Connection connection = DBUtils.getConnection();
            PreparedStatement ps=connection.prepareStatement(sql)){
             
             ps.setString(1, user.getUsername());
             ps.setString(2,user.getPassword());
             ps.setString(3,user.getFullname());
             ps.setDate(4,user.getDob());
             ps.setString(5,user.getGender());
             ps.setString(6,user.getPhonenum());
             ps.setString(7,user.getAddress());
             ps.setString(8,user.getRole());
             ps.setInt(9,user.getUserId());
             
             ps.executeUpdate();
         }
    }
    
    //Tim kiem theo ten
    public List<User> searchByName(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE fullname LIKE ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getDate(5),
                        rs.getString(6),
                        rs.getString(7),
                        rs.getString(8),
                        rs.getString(9)
                ));
            }
            for(User u : list) System.out.println(u);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
}
