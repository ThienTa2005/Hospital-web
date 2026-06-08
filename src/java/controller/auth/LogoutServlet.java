package controller.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // lấy session nếu tồn tại
        if (session != null) {
            session.invalidate(); // xóa toàn bộ session
        }
        response.sendRedirect("/du_an1/login"); // quay về trang đăng nhập
    }
}
