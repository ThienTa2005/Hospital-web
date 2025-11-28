package controller.doctor;

import model.dao.AppointmentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.entity.User;

@WebServlet("/doctor/appointmentAction")
public class AppointmentActionServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("appointment_id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int appointmentId = Integer.parseInt(idStr);
                
                if ("complete".equals(action)) {
                    appointmentDAO.updateStatus(appointmentId, "completed");
                    response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId + "&msg=completed");
                } 
                else if ("cancel".equals(action)) {
                    appointmentDAO.updateStatus(appointmentId, "cancelled");
                    response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId + "&msg=cancelled");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + idStr + "&error=fail");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }
}