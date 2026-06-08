package controller.doctor;

import model.dao.AppointmentDAO;
import model.dao.DoctorDAO;
import model.dao.ShiftDoctorDAO;
import model.entity.Appointment;
import model.entity.Doctor;
import model.entity.Shift;
import model.entity.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private ShiftDoctorDAO shiftDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
        shiftDAO = new ShiftDoctorDAO();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getUserId();
        Doctor doctor = doctorDAO.getDoctorById(userId);

        boolean isOnShift = shiftDAO.isDoctorCurrentlyOnShift(userId);
        int shiftCount = shiftDAO.countShiftsInCurrentMonth(userId);
        List<Shift> todayShifts = shiftDAO.getShiftsToday(userId);

        List<Appointment> allAppointments = appointmentDAO.getAppointmentsByDoctorId(userId);
        
        int patientsTodayCount = 0;
        int pendingCount = 0;
        LocalDate today = LocalDate.now();

        for (Appointment app : allAppointments) {
            if ("pending".equalsIgnoreCase(app.getStatus())) {
                pendingCount++;
            }

            LocalDate appDate = app.getAppointmentDate().toLocalDateTime().toLocalDate();
            if (appDate.equals(today) && !"cancelled".equalsIgnoreCase(app.getStatus())) {
                patientsTodayCount++;
            }
        }

        request.setAttribute("doctor", doctor);
        
        request.setAttribute("isOnShift", isOnShift);
        request.setAttribute("shiftCount", shiftCount);
        request.setAttribute("todayShifts", todayShifts);
        

        request.setAttribute("patientsTodayCount", patientsTodayCount);
        request.setAttribute("pendingCount", pendingCount);

        request.getRequestDispatcher("/views/doctor/doctor_dashboard.jsp").forward(request, response);
    }
}