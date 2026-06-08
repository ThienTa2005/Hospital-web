package controller.patient;

import model.dao.MedicalRecordDAO;
import model.dao.AppointmentDAO;
import model.dao.TestDAO;
import model.dao.PatientDAO; 
import model.entity.MedicalRecord;
import model.entity.User;
import model.entity.Appointment;
import model.entity.Patient;
import model.entity.Test;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/record")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO;
    private AppointmentDAO appointmentDAO;
    private TestDAO testDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        medicalDAO = new MedicalRecordDAO();
        appointmentDAO = new AppointmentDAO();
        testDAO = new TestDAO();
        patientDAO = new PatientDAO(); 
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "view";

        try {
            if ("delete".equals(action)) {
                deleteRecord(request, response);
            } else {
                viewRecord(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList?error=system");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action"); 
        try {
            if ("save".equals(action) || "add".equals(action) || "update".equals(action)) {
                saveRecord(request, response);
            } else if ("delete".equals(action)) {
                deleteRecord(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointmentList");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList?error=save_fail");
        }
    }

    private void viewRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String appointmentIdStr = request.getParameter("appointment_id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList");
            return;
        }

        int appointmentId = Integer.parseInt(appointmentIdStr);

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy cuộc hẹn");
            return;
        }

        List<MedicalRecord> records = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);

        List<Test> tests = testDAO.getTestByAppointmentId(appointmentId);
        
        Patient patient = patientDAO.getPatientById(appointment.getPatientId());

        request.setAttribute("appointment", appointment);
        request.setAttribute("records", records);
        request.setAttribute("tests", tests);
        request.setAttribute("patient", patient); // <--- GỬI BIẾN PATIENT
        
        request.getRequestDispatcher("/views/doctor/appointment_detail.jsp").forward(request, response);
    }
    private void saveRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        String recordIdStr = request.getParameter("record_id");
        int recordId = 0;
        if (recordIdStr != null && !recordIdStr.isEmpty()) {
            try { recordId = Integer.parseInt(recordIdStr); } catch(Exception e) {}
        }
        String diagnosis = request.getParameter("diagnosis");
        String notes = request.getParameter("notes");
        String prescription = request.getParameter("prescription");

        MedicalRecord record = new MedicalRecord();
        record.setRecordId(recordId);
        record.setDiagnosis(diagnosis);
        record.setNotes(notes);
        record.setPrescription(prescription);
        record.setAppointmentId(appointmentId);

        if (recordId == 0) {
            medicalDAO.addRecord(record);
        } else {
            medicalDAO.updateRecord(record);
        }
        response.sendRedirect(request.getContextPath() + "/record?appointment_id=" + appointmentId + "&msg=saved");
    }

    private void deleteRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String recordIdStr = request.getParameter("record_id");
        String appointmentIdStr = request.getParameter("appointment_id");
        if (recordIdStr != null && !recordIdStr.isEmpty()) {
            int recordId = Integer.parseInt(recordIdStr);
            medicalDAO.delete(recordId);
        }
        if (appointmentIdStr != null) {
            response.sendRedirect(request.getContextPath() + "/record?appointment_id=" + appointmentIdStr + "&msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList");
        }
    }
}