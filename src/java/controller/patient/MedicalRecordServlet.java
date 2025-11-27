package controller.patient;

import model.dao.MedicalRecordDAO;
import model.dao.TestDAO;
import model.entity.MedicalRecord;
import model.entity.Test;
import model.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/record")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO;
    private TestDAO testDAO;

    @Override
    public void init() {
        medicalDAO = new MedicalRecordDAO();
        testDAO = new TestDAO(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String appointmentIdStr = request.getParameter("appointment_id");
        
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                List<MedicalRecord> records = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);
                MedicalRecord record = null;
                if (records != null && !records.isEmpty()) {
                    record = records.get(0);
                }
                List<Test> tests = testDAO.getTestByAppointmentId(appointmentId);

                request.setAttribute("record", record);
                request.setAttribute("tests", tests);

                request.setAttribute("activePage", "record");

                request.getRequestDispatcher("/views/patient/patient_medical_record.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("appointment?action=list&error=invalid_id");
            } catch (SQLException ex) {
                System.getLogger(MedicalRecordServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }
        } else {
            response.sendRedirect("appointment?action=list");
        }
    }
}