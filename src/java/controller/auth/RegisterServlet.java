package controller.auth;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.UserDAO;
import model.entity.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet
{
    private UserDAO userDAO;
        
    public void init()
    {
        userDAO = new UserDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang login.jsp
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }
    //Chuan hoa UTF-8
    private static String newString(String item)
    {
        byte[] bytes = item.getBytes(StandardCharsets.ISO_8859_1); 
        item = new String(bytes, StandardCharsets.UTF_8);
        return item;
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String username = request.getParameter("username");        
        try
        {
            if(userDAO.isUsernameExist(username))
            {
                request.setAttribute("errorMessage", "⚠️ Tên đăng nhập đã tồn tại, vui lòng chọn tên khác."); 
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
                return;
            }
        } catch (SQLException ex)
        {
            System.getLogger(RegisterServlet.class.getName()).
                    log(System.Logger.Level.ERROR, (String) null, ex);
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        String password = request.getParameter("password");
        String fullname = newString(request.getParameter("fullname"));
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phonenum");
        String address = newString(request.getParameter("address"));
        String role = "patient";
        
        java.util.Date utilDate = null;
        try
        {
            utilDate = sdf.parse(dob);
        } catch (ParseException ex)
        {
            System.getLogger(RegisterServlet.class.getName()).
                    log(System.Logger.Level.ERROR, (String) null, ex);
        }
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
        
        User u = new User(0, username, password, fullname, sqlDate, gender, phone, address, role);
        try
        {
            if (userDAO.createUser(u)) {
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?success=false");
            }
        } catch (SQLException ex)
        {
            System.getLogger(RegisterServlet.class.getName()).
                    log(System.Logger.Level.ERROR, (String) null, ex);
        }

    }
}
