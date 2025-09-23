package controller.admin;

import java.sql.*;
import Utils.DBUtils;
import model.dao.UserDAO;
import model.entity.User;
import java.io.IOException;
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
            case "add":
                addUser(request, response);
                break;
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
