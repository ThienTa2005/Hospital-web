package controller.admin;

import model.dao.PatientDAO;
import model.entity.Patient; // Import Patient mới

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/patient")
public class PatientServlet extends HttpServlet {
    private PatientDAO patientDAO;
    // Không cần DoctorDAO ở đây nữa (trừ khi form thêm bệnh nhân có chọn bác sĩ)
    // Dựa trên CSDL mới, bệnh nhân không liên kết trực tiếp với bác sĩ (mà qua Appointment)

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; 
        }

        try {
            switch (action) {
                case "create":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deletePatient(request, response);
                    break;
                default:
                    listPatients(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    insertPatient(request, response);
                    break;
                case "update":
                    updatePatient(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // [GET] Hiển thị danh sách bệnh nhân (tới patients.jsp)
    private void listPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> listPatient = patientDAO.getAllPatients();
        request.setAttribute("patients", listPatient);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/patient.jsp"); 
        dispatcher.forward(request, response);
    }

    // [GET] Chuyển tiếp đến form tạo mới (patient_form.jsp)
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // (Bỏ phần load DoctorDAO vì CSDL mới không yêu cầu)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient_form.jsp"); 
        dispatcher.forward(request, response);
    }

    // [GET] Chuyển tiếp đến form sửa (patient_form.jsp)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dùng user_id thay vì id
        int userId = Integer.parseInt(request.getParameter("id")); 
        Patient existingPatient = patientDAO.getPatientById(userId);
        
        request.setAttribute("patient", existingPatient); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient_form.jsp"); 
        dispatcher.forward(request, response);
    }

    // [POST] Xử lý thêm bệnh nhân
    private void insertPatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        // Lấy thông tin từ bảng Users
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Cần mã hóa
        String fullname = request.getParameter("fullname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String gender = request.getParameter("gender");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");

        Patient newPatient = new Patient();
        newPatient.setUsername(username);
        newPatient.setPassword(password);
        newPatient.setFullname(fullname);
        newPatient.setDob(dob);
        newPatient.setGender(gender);
        newPatient.setPhonenum(phonenum);
        newPatient.setAddress(address);
        
        patientDAO.addPatient(newPatient);
        response.sendRedirect("patients"); // Quay lại trang danh sách
    }

    // [POST] Xử lý cập nhật bệnh nhân
    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId")); // Lấy từ input hidden
        String fullname = request.getParameter("fullname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String gender = request.getParameter("gender");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        // Không cho cập nhật username, password, role ở đây

        Patient patient = new Patient();
        patient.setUserId(userId);
        patient.setFullname(fullname);
        patient.setDob(dob);
        patient.setGender(gender);
        patient.setPhonenum(phonenum);
        patient.setAddress(address);

        patientDAO.updatePatient(patient);
        response.sendRedirect("patients"); // Quay lại trang danh sách
    }

    // [GET] Xử lý xóa bệnh nhân
    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id")); // Lấy user_id
        patientDAO.deletePatient(userId);
        response.sendRedirect("patients"); // Quay lại trang danh sách
    }
}