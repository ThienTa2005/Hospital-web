package Controller;

import DAO.UserDAO;
import Model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang login.jsp
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Check user test trước
    if (username.equals("admin") && password.equals("123456")) {
        HttpSession session = request.getSession();
        User user = new User(0, "admin", "123456", "admin",new Date(System.currentTimeMillis()), "Admin User", "admin@gmail.com", "0123456789", "Hanoi");
        session.setAttribute("user", user);
        response.sendRedirect("views/admin/Admin_dashboard.jsp");
        return;
    }

    // Nếu không trùng user test thì check DB
    User user = userDAO.checkLogin(username, password);

    if (user != null) {
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        switch (user.getRole()) {
            case "admin":
                response.sendRedirect("views/admin/Admin_dashboard.jsp");
                break;
            case "doctor":
                response.sendRedirect("views/admin/Doctor_dashboard.jsp");
                break;
            case "patient":
                response.sendRedirect("views/admin/Patient_dashboard.jsp");
                break;
            default:
                response.sendRedirect("index.jsp");
        }
    } else {
        request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
}
}
