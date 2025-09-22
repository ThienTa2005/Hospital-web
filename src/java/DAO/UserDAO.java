package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.User;
import Utils.DBUtils;

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

    //thêm user
    public boolean createUser(User user) throws SQLException
    {
         if(!(isUsernameExist(user.getUsername())))
        {
                String sql="insert into users(username, password, fullname, dob, gender, phonenum, address, role) values (?,?,?,?,?,?,?,?)";
                
        
                 try(
                    Connection connection=DBUtils.getConnection();
                    PreparedStatement ps=connection.prepareStatement(sql)){
            
                     ps.setString(1,user.getUsername());
                     ps.setString(2,user.getPassword());
                     ps.setString(3,user.getFullname());
                     ps.setString(4,user.getDob());
                     ps.setString(5,user.getGender());
                     ps.setString(6,user.getPhonenum());
                     ps.setString(7,user.getAddress());
                     ps.setString(8,user.getRole());
                     
                 
                     return ps.executeUpdate()>0;
                }
        }
        System.out.println("USERNAME DA TON TAI");
        return false;
    }

    //xóa useruser
    public boolean deleteUser(String username) throws SQLException{
        if(isUsernameExist(username)){
             String sql="delete from users where username=?";
            try(
                Connection connection=DBUtils.getConnection();
                PreparedStatement ps=connection.prepareStatement(sql)){

                ps.setString(1,username);
                return ps.executeUpdate()>0;
            }
        }
        System.out.println("KHONG TON TAI USERNAME");
        return false; 
    }
    
    //truyen thang user moi, dung username de xac dinh doi tuong update
    public  boolean updateUser(User user) throws SQLException{
     if(isUsernameExist(user.getUsername())){
         String sql="update users set password=?,fullname=?,dob=?,gender=?,phonenum=?,address=?,role=? where username=?";
         try(
            Connection connection=DBUtils.getConnection();
            PreparedStatement ps=connection.prepareStatement(sql)){
             
             ps.setString(1,user.getPassword());
             ps.setString(2,user.getFullname());
             ps.setString(3,user.getDob());
             ps.setString(4,user.getGender());
             ps.setString(5,user.getPhonenum());
             ps.setString(6,user.getAddress());
             ps.setString(7,user.getRole());
             ps.setString(8,user.getUsername());
             
             return ps.executeUpdate()>0;
         }
     }
     return false;
     
    }
    
}

