package controller.admin;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.dao.DepartmentDAO;
import model.entity.Department;

@WebServlet("/admin/department")
public class DepartmentServlet extends HttpServlet
{
    private DepartmentDAO departmentDAO;
    
    @Override
    public void init()
    {
        departmentDAO = new DepartmentDAO();
    }
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");
        if(action == null) action = "list";
        
        switch(action) {
            case "add":
            {
                try
                {
                    addDepartment(request, response);
                } catch (SQLException ex)
                {}
            }
                break;
                
            case "delete":
            {
                try
                {
                    deleteDepartment(request, response);
                } catch(SQLException ex)
                {}
                break;
            }
            
            case "search":
            {
                try
                {
                    searchDepartment(request, response);
                } catch(SQLException ex)
                {}
                break;
            }

            case "update":
            {
                try
                {
                    updateDepartment(request, response);
                } catch(SQLException ex)
                {}
                break;
            }
            
            default:
            {
                try
                {
                    listDepartment(request, response);
                } catch (SQLException ex)
                {}
                break;
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        switch(action) {
            case "add":
                try {
                    addDepartment(request, response);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                break;
        }
    }

    
    //Chuan hoa UTF-8
    private static String newString(String item)
    {
        byte[] bytes = item.getBytes(StandardCharsets.ISO_8859_1); 
        item = new String(bytes, StandardCharsets.UTF_8);
        return item;
    }
    
    // Liet ke
    public void listDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException
    {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/views/admin/department.jsp").forward(request, response);
    }
    
    // Them
    public void addDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        String departmentName = request.getParameter("department-name");
        System.out.println(departmentName);
        if(departmentDAO.isDepartmentExist(departmentName))
        {
            return;
        }
        Department department = new Department(0, departmentName);
        departmentDAO.addDepartment(department);
        response.sendRedirect(request.getContextPath() + "/admin/department?action=list&success=true");
    }
    
    // Xoa
    public void deleteDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException
    {
        int id = Integer.parseInt(request.getParameter("id"));
        departmentDAO.deleteDepartment(id);
        response.sendRedirect(request.getContextPath() + "/admin/department?action=list&delete=true");
    }
    
    // Cap nhat
    public void updateDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException
    {
        int id = Integer.parseInt(request.getParameter("id"));
        String departmentName = request.getParameter("department-name");
        Department department = new Department(id, departmentName);
        departmentDAO.updateDepartment(department);
        response.sendRedirect(request.getContextPath() + "/admin/department?action=list&success=true");
    }
    
    // Tim kiem
    public void searchDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException 
    {
        String keyword = request.getParameter("keyword");
        List<Department> departments;
        if (keyword == null || keyword.trim().isEmpty()) {           
            departments = departmentDAO.getAllDepartments();
        } else {         
            departments = departmentDAO.searchByName(keyword.trim());
        }
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/views/admin/department.jsp").forward(request, response);
    }
}
