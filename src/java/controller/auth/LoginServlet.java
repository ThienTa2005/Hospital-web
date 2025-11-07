package controller.auth;

import model.dao.UserDAO;
import model.entity.User;

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
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Check user test trước
//    if (username.equals("admin") && password.equals("123456")) {
//        HttpSession session = request.getSession();
//        User user = new User(0, "admin", "123456", "admin",new Date(System.currentTimeMillis()), "Admin User", "admin@gmail.com", "0123456789", "Hanoi");
//        session.setAttribute("user", user);
//        response.sendRedirect("views/admin/users.jsp");
//        return;
//    }

    // Nếu không trùng user test thì check DB
    User user = userDAO.checkLogin(username, password);

    if (user != null) {
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("username", username);
        switch (user.getRole()) {
            case "admin":                
                response.sendRedirect(request.getContextPath() + "/admin/user");
                break;
            case "doctor":
                response.sendRedirect("views/doctor/doctor_dashboard.jsp");
                break;
            case "patient":
                response.sendRedirect("views/patient/patient_dashboard.jsp");
                break;
            default:
                response.sendRedirect("index.jsp");
        }
    } else {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không chính xác!");
        response.sendRedirect("views/auth/login.jsp");
    }
}
}