package controller.patient;

import model.dao.AppointmentDAO;
import model.dao.DepartmentDAO;
import model.entity.User;
import model.entity.Appointment;
import model.entity.Department;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/patient_dashboard")
public class PatientDashboardServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");

        if (user != null) {
            List<Appointment> allAppointments = appointmentDAO.getAppointmentsByPatientId(user.getUserId());
            List<Department> departments = departmentDAO.getAllDepartments();
            LocalDate now = LocalDate.now();
            long countMonth = allAppointments.stream()
                    .filter(a -> {
                        LocalDate appDate = a.getAppointmentDate().toLocalDateTime().toLocalDate();
                        return appDate.getMonth() == now.getMonth() && appDate.getYear() == now.getYear();
                    })
                    .count();
            Appointment lastVisit = allAppointments.stream()
                    .filter(a -> "completed".equalsIgnoreCase(a.getStatus()))
                    .sorted(Comparator.comparing(Appointment::getAppointmentDate).reversed())
                    .findFirst().orElse(null);
            Appointment nextVisit = allAppointments.stream()
                    .filter(a -> ("pending".equalsIgnoreCase(a.getStatus()) || "confirmed".equalsIgnoreCase(a.getStatus())))
                    .filter(a -> a.getAppointmentDate().toLocalDateTime().toLocalDate().isAfter(now.minusDays(1)))
                    .sorted(Comparator.comparing(Appointment::getAppointmentDate))
                    .findFirst().orElse(null);
            List<Appointment> upcomingList = allAppointments.stream()
                    .filter(a -> ("pending".equalsIgnoreCase(a.getStatus()) || "confirmed".equalsIgnoreCase(a.getStatus())))
                    .filter(a -> a.getAppointmentDate().toLocalDateTime().toLocalDate().isAfter(now.minusDays(1)))
                    .sorted(Comparator.comparing(Appointment::getAppointmentDate))
                    .limit(5)
                    .collect(Collectors.toList());

            request.setAttribute("appointments", allAppointments);
            request.setAttribute("departments", departments);

            request.setAttribute("countMonth", countMonth);
            request.setAttribute("lastVisit", lastVisit);
            request.setAttribute("nextVisit", nextVisit);
            request.setAttribute("upcomingList", upcomingList);

            request.getRequestDispatcher("/views/patient/patient_dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}