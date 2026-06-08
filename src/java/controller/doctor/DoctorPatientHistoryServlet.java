package controller.doctor;

import model.dao.AppointmentDAO;
import model.dao.PatientDAO;
import model.entity.Appointment;
import model.entity.Patient;
import model.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/patientHistory")
public class DoctorPatientHistoryServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList");
            return;
        }

        try {
            int patientId = Integer.parseInt(patientIdStr);

            Patient patient = patientDAO.getPatientById(patientId);

            List<Appointment> historyList = appointmentDAO.getAppointmentsByPatientId(patientId);

            
            request.setAttribute("patient", patient);
            request.setAttribute("historyList", historyList);
            
            request.getRequestDispatcher("/views/doctor/doctor_patient_history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList");
        }
    }
}