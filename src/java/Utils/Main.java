package Utils;

import model.entity.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class Main
{
    public static void main(String args[])
    {
        List<User> lst = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User u = new User(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getDate(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9));
                lst.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        for(User x : lst) System.out.println(x);
    }
}
