package controller.admin;

import java.sql.*;
import Utils.DBUtils;
import model.dao.UserDAO;
import model.entity.User;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/user")
public class UserServlet extends HttpServlet
{
    private UserDAO userDAO;
        
    @Override
    public void init()
    {
        userDAO = new UserDAO();
    }
        
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");
        if(action == null) action = "list";
        
        switch(action) {
            case "delete":
                deleteUser(request, response);
                break;
            case "search":
                searchUser(request, response);
                break;
            default:
                listUser(request, response);
                break;
        }
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");
        
        switch(action) {
            case "add":
            {
                try
                {
                    addUser(request, response);
                } catch (SQLException ex)
                {
                    System.getLogger(UserServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                } catch (ParseException ex)
                {
                    System.getLogger(UserServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                }
            }
                break;

            case "edit":
                editUser(request, response);
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
    
    //Liet ke
    public void listUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        List<User> users = userDAO.getAllUsers();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }
    
    //Them
    public void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException,
IOException, SQLException, ParseException
    {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
 
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String username = request.getParameter("username");
        if(userDAO.isUsernameExist(username))
        {
            request.setAttribute("errorMessage", "⚠️ Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.");
            request.getRequestDispatcher("/views/admin/add_user.jsp").forward(request, response);
            return; // Dừng xử lý
        }
        String password = request.getParameter("password");
        String fullname = newString(request.getParameter("fullname"));
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = newString(request.getParameter("address"));
        String role = request.getParameter("role");
        
        java.util.Date utilDate = sdf.parse(dob);
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
        
        userDAO.createUser(new User(0, username, password, fullname, sqlDate, gender, phone, address, role));
        response.sendRedirect(request.getContextPath() + "/views/admin/add_user.jsp");
    }
    
    //Chinh sua
    public void editUser(HttpServletRequest request, HttpServletResponse response) throws ServletException,
IOException
    {
        
    }
    
    //Xoa
    public void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {       
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);
        
        response.sendRedirect(request.getContextPath() + "/admin/user");
    }
    
    //Tim kiem
    public void searchUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String keyword = request.getParameter("keyword");

        List<User> users;
        if (keyword == null || keyword.trim().isEmpty()) {           
            users = userDAO.getAllUsers();
        } else {         
            users = userDAO.searchByName(keyword.trim());
        }
       
        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword); 
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }
}
