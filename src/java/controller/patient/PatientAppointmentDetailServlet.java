package controller.patient;

import model.dao.AppointmentDAO;
import model.dao.MedicalRecordDAO;
import model.dao.PatientDAO;
import model.dao.TestDAO;
import model.entity.Appointment;
import model.entity.MedicalRecord;
import model.entity.Patient;
import model.entity.Test;
import model.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/appointmentDetail")
public class PatientAppointmentDetailServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private MedicalRecordDAO medicalDAO = new MedicalRecordDAO();
    private TestDAO testDAO = new TestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));

            Appointment app = appointmentDAO.getAppointmentById(appointmentId);
            
 
            if (app == null || app.getPatientId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem cuộc hẹn này.");
                return;
            }

            Patient patient = patientDAO.getPatientById(app.getPatientId());
            List<MedicalRecord> records = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);
            List<Test> tests = testDAO.getTestByAppointmentId(appointmentId);

            request.setAttribute("appointment", app);
            request.setAttribute("patient", patient);
            request.setAttribute("records", records);
            request.setAttribute("tests", tests);
            
       
            request.setAttribute("activePage", "record");


            request.getRequestDispatcher("/views/doctor/appointment_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
        }
    }
}