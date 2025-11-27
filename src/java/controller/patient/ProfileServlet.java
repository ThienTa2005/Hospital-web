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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Báo cho Navbar biết đang ở trang profile
        request.setAttribute("activePage", "profile");
        request.getRequestDispatcher("/views/patient/patient_profile.jsp").forward(request, response);
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
            // 1. Lấy dữ liệu từ form
            String newPhone = request.getParameter("phonenum");
            String newAddress = request.getParameter("address");
            
            // 2. Gọi DAO để update xuống Database
            boolean success = userDAO.updateUserProfile(user.getUserId(), newPhone, newAddress);
            
            if (success) {
                // 3. QUAN TRỌNG: Cập nhật lại Session
                // Nếu thiếu bước này, F5 lại trang web vẫn hiện thông tin cũ
                user.setPhonenum(newPhone);
                user.setAddress(newAddress);
                session.setAttribute("user", user); 
                
                // Redirect kèm thông báo thành công
                response.sendRedirect("profile?msg=updated");
            } else {
                response.sendRedirect("profile?error=fail");
            }
        }
    }
}