package controller.admin;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.AppointmentDAO;
import model.entity.Appointment;

@WebServlet("/admin/report")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AppointmentDAO appointmentDAO = new AppointmentDAO();

        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);

        Map<LocalDate, Integer> appointmentsPerDay = new LinkedHashMap<>();

        for (int i = 0; i < 7; i++) {
            LocalDate date = startOfWeek.plusDays(i);
            List<Appointment> list = appointmentDAO.getAppointmentsByDate(date);
            appointmentsPerDay.put(date, list != null ? list.size() : 0);
        }

        request.setAttribute("appointmentsPerDay", appointmentsPerDay);

        request.getRequestDispatcher("/views/admin/admin_dashboard/report.jsp")
               .forward(request, response);
    }
}
