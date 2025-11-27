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
import model.dao.PatientDAO;
import model.entity.Appointment;
import model.entity.Patient;

@WebServlet("/doctor/appointmentList")
public class AppointmentListServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bệnh nhân không hợp lệ");
            return;
        }

        int patientId = -1;
        try {
            patientId = Integer.parseInt(patientIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bệnh nhân không hợp lệ");
            return;
        }

        try {
            // Lấy bệnh nhân
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bệnh nhân");
                return;
            }

            // Lấy tất cả lịch sử appointment của bệnh nhân
            List<Appointment> appointments = appointmentDAO.getCompletedAppointmentsByPatientId(patientId);

            // Forward dữ liệu sang JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("patient", patient);

            RequestDispatcher rd = request.getRequestDispatcher("/views/doctor/appointment_list.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu");
        }
    }
}
