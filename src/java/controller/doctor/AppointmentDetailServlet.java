package controller.doctor;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.AppointmentDAO;
import model.dao.MedicalRecordDAO;
import model.dao.PatientDAO;
import model.dao.TestDAO;
import model.entity.Appointment;
import model.entity.MedicalRecord;
import model.entity.Patient;
import model.entity.Test;

@WebServlet("/doctor/appointmentDetail")
public class AppointmentDetailServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private TestDAO testDAO = new TestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập encoding UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int id = -1;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lịch hẹn không hợp lệ");
            return;
        }

        try {
            Appointment app = appointmentDAO.getAppointmentById(id);
            if (app == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch hẹn");
                return;
            }
            
            Patient patient = patientDAO.getPatientById(app.getPatientId());          
            List<MedicalRecord> records = medicalRecordDAO.getMedicalRecordByAppointmentId(id);
            List<Test> tests = testDAO.getTestByAppointmentId(id);
            System.out.println("RECORDS SIZE = " + records.size());

            request.setAttribute("patient", patient);
            request.setAttribute("appointment", app);
            request.setAttribute("records", records);
            request.setAttribute("tests", tests);

                RequestDispatcher rd = request.getRequestDispatcher("/views/doctor/appointment_detail.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu");
        }
    }
}
