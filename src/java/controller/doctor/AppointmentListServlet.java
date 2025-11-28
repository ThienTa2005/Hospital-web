package controller.doctor;

import model.dao.AppointmentDAO;
import model.entity.Appointment;
import model.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/doctor/appointmentList")
public class AppointmentListServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");


        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Appointment> allList = appointmentDAO.getAppointmentsByDoctorId(user.getUserId());

        List<Appointment> pendingList = allList.stream()
                .filter(a -> "pending".equalsIgnoreCase(a.getStatus()))
                .collect(Collectors.toList());

        List<Appointment> confirmedList = allList.stream()
                .filter(a -> "confirmed".equalsIgnoreCase(a.getStatus()))
                .collect(Collectors.toList());

        List<Appointment> historyList = allList.stream()
                .filter(a -> "completed".equalsIgnoreCase(a.getStatus()) || "cancelled".equalsIgnoreCase(a.getStatus()))
                .collect(Collectors.toList());

        request.setAttribute("pendingList", pendingList);
        request.setAttribute("confirmedList", confirmedList);
        request.setAttribute("historyList", historyList);
        
        request.setAttribute("activePage", "appointment"); 

        request.getRequestDispatcher("/views/doctor/doctor_appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                if ("confirm".equals(action)) {
                    appointmentDAO.updateStatus(id, "confirmed");
                } else if ("cancel".equals(action)) {
                    appointmentDAO.updateStatus(id, "cancelled");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("appointmentList?msg=updated");
    }
}