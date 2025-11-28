package controller.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.AppointmentDAO;
import model.entity.Appointment;

@WebServlet("/admin/visiting_patients")
public class VisitingPatientsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        LocalDate today = LocalDate.now();
        List<Appointment> allTodayAppointments = appointmentDAO.getAppointmentsByDate(today);

        // Lọc lịch hẹn đang diễn ra
        LocalDateTime now = LocalDateTime.now();
        List<Appointment> ongoingAppointments = allTodayAppointments.stream()
            .filter(a -> a.getStartTime() != null && a.getEndTime() != null)
            .filter(a -> {
                LocalDateTime start = LocalDateTime.of(a.getShiftDate().toLocalDate(), a.getStartTime().toLocalTime());
                LocalDateTime end = LocalDateTime.of(a.getShiftDate().toLocalDate(), a.getEndTime().toLocalTime());
                return !now.isBefore(start) && !now.isAfter(end);
            })
            .toList();

        request.setAttribute("appointments", ongoingAppointments);

        // Forward đến JSP
        request.getRequestDispatcher("/views/admin/admin_dashboard/visiting_patients.jsp")
               .forward(request, response);
    }
}
