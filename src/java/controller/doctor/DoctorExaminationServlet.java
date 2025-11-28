package controller.doctor;

import model.dao.MedicalRecordDAO;
import model.entity.MedicalRecord;
import model.entity.Test;
import model.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/doctor/examine")
public class DoctorExaminationServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO = new MedicalRecordDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {

            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            String diagnosis = request.getParameter("diagnosis");
            String notes = request.getParameter("notes");
            String prescription = request.getParameter("prescription");

            MedicalRecord record = new MedicalRecord();
            record.setAppointmentId(appointmentId);
            record.setDiagnosis(diagnosis != null ? diagnosis : "");
            record.setNotes(notes != null ? notes : "");
            record.setPrescription(prescription != null ? prescription : "");

            List<Test> tests = new ArrayList<>();
            
            String[] testNames = request.getParameterValues("test_name[]");
            String[] testParams = request.getParameterValues("test_param[]");
            String[] testValues = request.getParameterValues("test_value[]"); 
            String[] testUnits = request.getParameterValues("test_unit[]");  
            
            if (testNames != null) {
                for (int i = 0; i < testNames.length; i++) {
                    if (testNames[i] != null && !testNames[i].trim().isEmpty()) {
                        Test t = new Test();
                        
                        t.setName(testNames[i]);

                        t.setParameter((testParams != null && i < testParams.length) ? testParams[i] : "-");
                        t.setParameterValue((testValues != null && i < testValues.length) ? testValues[i] : "-"); 
                        t.setUnit((testUnits != null && i < testUnits.length) ? testUnits[i] : ""); 
                        
                        t.setReferenceRange("-");
                        
                        tests.add(t);
                    }
                }
            }

            boolean success = medicalDAO.saveExamination(record, tests, appointmentId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointmentList?msg=exam_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointmentList?error=exam_fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentList?error=system");
        }
    }
}