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
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Chuyển hướng sang trang giao diện
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

        // 1. Lấy dữ liệu từ form
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // 2. Validate dữ liệu
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

        // 3. Kiểm tra mật khẩu cũ
        boolean isOldPassCorrect = userDAO.checkOldPassword(user.getUserId(), oldPass);
        
        if (!isOldPassCorrect) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác!");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
            return;
        }

        // 4. Thực hiện đổi mật khẩu
        boolean success = userDAO.changePassword(user.getUserId(), newPass);

        if (success) {
            // Cập nhật lại session (nếu session có lưu pass - dù thường là không nên)
            user.setPassword(newPass);
            session.setAttribute("user", user);
            
            // Gửi thông báo thành công
            request.setAttribute("msg", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/patient/patient_change_password.jsp").forward(request, response);
        }
    }
}