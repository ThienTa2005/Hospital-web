package model.dao;

import Utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import model.entity.Department;

public class DepartmentDAO
{
    // Lay tat ca chuyen khoa
    public List<Department> getAllDepartments() throws SQLException
    {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Department";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) 
        {
            while(rs.next())
            {
                list.add(new Department(rs.getInt("department_id"), rs.getString("name")));
            }
        }
        return list;
    }
    
    // Kiem tra chuyen khoa da ton tai
    public boolean isDepartmentExist(String keyword) throws SQLException
    {
        String sql = "SELECT 1 FROM Department WHERE name = ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setString(1, keyword);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
    
    // Them chuyen khoa
    public void addDepartment(Department department) throws SQLException
    {
        String sql = "INSERT INTO Department(name) VALUES(?)";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setString(1, department.getDepartmentName());
            ps.executeUpdate();
        }
    }
    
    // Xoa chuyen khoa 
    public void deleteDepartment(int id) throws SQLException
    {
        String sql = "DELETE FROM Department WHERE department_id = ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
        }
    }
    
    // Cap nhat chuyen khoa 
    public void updateDepartment(Department department) throws SQLException
    {
        String sql = "UPDATE Department SET name = ? WHERE department_id = ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql))
        {
            ps.setString(1, department.getDepartmentName());
            ps.setInt(2, department.getDepartmentID());
            ps.executeUpdate();
        }
    }
    
    // Tim kiem chuyen khoa theo ten
    public List<Department> searchByName(String keyword) throws SQLException
    {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Department WHERE name LIKE ?";
        try(Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);)
        {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next())
            {
                list.add(new Department(rs.getInt(1), rs.getString(2)));
            }
        }
        return list;
    }
}
