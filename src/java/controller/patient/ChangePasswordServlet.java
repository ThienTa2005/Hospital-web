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

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");
        if (newPass == null || !newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
            return;
        }

        if (newPass.length() < 6) {
             request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
             request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
             return;
        }
        boolean isOldPassCorrect = userDAO.checkOldPassword(user.getUserId(), oldPass);
        
        if (!isOldPassCorrect) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác!");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
            return;
        }
        boolean success = userDAO.changePassword(user.getUserId(), newPass);

        if (success) {
            user.setPassword(newPass);
            session.setAttribute("user", user);

            request.setAttribute("msg", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
        }
    }
}