package controller.patient;

import model.dao.MedicalRecordDAO;
import model.entity.MedicalRecord;
import model.entity.User;

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

        // ================== FIX ENCODING ==================
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        // ==================================================

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "view";
        }

        try {
            switch (action) {
                case "delete":
                    deleteRecord(request, response);
                    break;
                case "view":
                default:
                    viewRecord(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ================== FIX ENCODING ==================
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        // ==================================================

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            if ("save".equals(action)) {
                saveRecord(request, response);
            } else {
                viewRecord(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /** Xem / mở form hồ sơ theo appointment_id (dùng cho cả bác sĩ & bệnh nhân) */
    private void viewRecord(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String appointmentIdStr = request.getParameter("appointment_id");
        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            if ("patient".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient-history");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            }
            return;
        }
    }

    public void listRecords(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int appointmentId = Integer.parseInt((String) request.getAttribute("appointment_id"));
        List<MedicalRecord> list = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);
        request.setAttribute("records", list);
        request.setAttribute("appointment_id", appointmentId);

        String role = currentUser.getRole() != null ? currentUser.getRole().toLowerCase() : "";
        String destination;

        if ("doctor".equals(role)) {
            destination = "/views/doctor/doctor_medical_record.jsp";
        } else {
            destination = "/views/patient/patient_medical_record.jsp";
        }

        request.getRequestDispatcher(destination).forward(request, response);
    }

    /** Lưu (thêm mới hoặc cập nhật) hồ sơ từ form bác sĩ */
    private void saveRecord(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String appointmentIdStr = request.getParameter("appointment_id");
        String recordIdStr = request.getParameter("record_id");

        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        int appointmentId = Integer.parseInt(appointmentIdStr);
        int recordId = 0;
        if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
            recordId = Integer.parseInt(recordIdStr);
        }

        String diagnosis = request.getParameter("diagnosis");
        String notes = request.getParameter("notes");
        String prescription = request.getParameter("prescription");

        MedicalRecord record = new MedicalRecord(recordId, diagnosis, notes, prescription, appointmentId);

        if (recordId == 0) {
            medicalDAO.addRecord(record);
        } else {
            medicalDAO.updateRecord(record);
        }

        response.sendRedirect(request.getContextPath() + "/record?appointment_id=" + appointmentId);
    }

    /** Xóa hồ sơ (gọi từ doctor_schedule hoặc từ trang chi tiết) */
    private void deleteRecord(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String recordIdStr = request.getParameter("record_id");
        String appointmentIdStr = request.getParameter("appointment_id");
        String from = request.getParameter("from");
        String selectedDate = request.getParameter("selectedDate");

        if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
            int id = Integer.parseInt(recordIdStr);
            medicalDAO.delete(id);
        }

        String ctx = request.getContextPath();

        if ("schedule".equals(from)) {
            if (selectedDate != null && !selectedDate.isEmpty()) {
                response.sendRedirect(ctx + "/doctor/schedule?selectedDate=" + selectedDate);
            } else {
                response.sendRedirect(ctx + "/doctor/schedule");
            }
        } else if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
            response.sendRedirect(ctx + "/record?appointment_id=" + appointmentIdStr);
        } else {
            response.sendRedirect(ctx + "/doctor/schedule");
        }
    }
}
