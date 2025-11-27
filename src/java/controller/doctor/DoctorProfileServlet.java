package controller.patient;

import model.dao.UserDAO;
import model.entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/doctor/profile")
public class DoctorProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("activePage", "profile");
        request.getRequestDispatcher("/views/doctor/doctor_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            String newPhone = request.getParameter("phonenum");
            String newAddress = request.getParameter("address");       
            boolean success = userDAO.updateUserProfile(user.getUserId(), newPhone, newAddress);
            
            if (success) {
                user.setPhonenum(newPhone);
                user.setAddress(newAddress);
                session.setAttribute("user", user); 
                response.sendRedirect("profile?msg=updated");
            } else {
                response.sendRedirect("profile?error=fail");
            }
        }
    }
}