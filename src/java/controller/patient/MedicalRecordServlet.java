package controller.patient;

import model.dao.MedicalRecordDAO;
import model.entity.MedicalRecord;
import model.entity.User;
import model.dao.AppointmentDAO;
import model.entity.Appointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/record")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO;

    @Override
    public void init() throws ServletException {
        medicalDAO = new MedicalRecordDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Chỉ dùng để xem hồ sơ theo appointment_id
        String appointmentIdStr = request.getParameter("appointment_id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        try {
            viewRecord(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action"); // từ modalAction
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        try {
            switch (action) {
                case "add":
                case "update":
                    saveRecord(request, response);
                    break;
                case "delete":
                    deleteRecord(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/doctor/schedule");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /** Xem hồ sơ theo appointment_id */
    private void viewRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        List<MedicalRecord> records = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);

        request.setAttribute("appointment", appointment);
        request.setAttribute("records", records);

        request.getRequestDispatcher("/views/doctor/appointment_detail.jsp")
                .forward(request, response);
    }

    /** Thêm hoặc cập nhật hồ sơ */
    private void saveRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        String recordIdStr = request.getParameter("record_id");
        int recordId = (recordIdStr != null && !recordIdStr.isEmpty()) ? Integer.parseInt(recordIdStr) : 0;

        String diagnosis = request.getParameter("diagnosis");
        String notes = request.getParameter("notes");
        String prescription = request.getParameter("prescription");

        MedicalRecord record = new MedicalRecord(recordId, diagnosis, notes, prescription, appointmentId);

        if (recordId == 0) {
            medicalDAO.addRecord(record); // action = add
        } else {
            medicalDAO.updateRecord(record); // action = update
        }

        response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId);
    }

    /** Xóa hồ sơ */
    private void deleteRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String recordIdStr = request.getParameter("record_id");
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));

        if (recordIdStr != null && !recordIdStr.isEmpty()) {
            int recordId = Integer.parseInt(recordIdStr);
            medicalDAO.delete(recordId);
        }

        response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId);
    }
}
