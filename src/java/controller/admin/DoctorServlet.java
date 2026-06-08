package controller.admin;

import model.dao.DoctorDAO;
import model.dao.DepartmentDAO;
import model.entity.Doctor;
import model.entity.Department;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.List;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/doctor")
public class DoctorServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO; 

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; 
        }

        try {
            // (SỬA) Tách case "search" và "list"
            switch (action) {
                case "create":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteDoctor(request, response);
                    break;
                case "search": 
                    searchDoctors(request, response); 
                    break;
                default: 
                    listDoctors(request, response);
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
                    insertDoctor(request, response);
                    break;
                case "update":
                    updateDoctor(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listDoctors(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        List<Doctor> listDoctor = doctorDAO.getAllDoctors();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);
        request.setAttribute("listDoctor", listDoctor); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/doctors.jsp"); 
        dispatcher.forward(request, response);
    }

    // [GET] Chuyển tiếp đến form tạo mới (doctor_form.jsp)
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException,   SQLException {
        List<Department> listDepartment = departmentDAO.getAllDepartments();
        request.setAttribute("listDepartment", listDepartment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor_form.jsp"); 
        dispatcher.forward(request, response);
    }
    // [GET] Chuyển tiếp đến form sửa (doctor_form.jsp)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        Doctor existingDoctor = doctorDAO.getDoctorById(userId);
        List<Department> listDepartment = departmentDAO.getAllDepartments();
        request.setAttribute("doctor", existingDoctor);
        request.setAttribute("listDepartment", listDepartment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor_form.jsp"); 
        dispatcher.forward(request, response);
    }

    // [POST] Xử lý thêm bác sĩ
    private void insertDoctor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password"); 
        String fullname = request.getParameter("fullname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String gender = request.getParameter("gender");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String degree = request.getParameter("degree");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        Doctor newDoctor = new Doctor();
        newDoctor.setUsername(username);
        newDoctor.setPassword(password);
        newDoctor.setFullname(fullname);
        newDoctor.setDob(dob);
        newDoctor.setGender(gender);
        newDoctor.setPhonenum(phonenum);
        newDoctor.setAddress(address);
        newDoctor.setDegree(degree);
        newDoctor.setDepartmentId(departmentId);
        doctorDAO.addDoctor(newDoctor); 
        response.sendRedirect("doctor"); 
    }

    // [POST] Xử lý cập nhật bác sĩ
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId")); 
        String fullname = request.getParameter("fullname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String gender = request.getParameter("gender");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String degree = request.getParameter("degree");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        Doctor doctor = new Doctor();
        doctor.setUserId(userId);
        doctor.setFullname(fullname);
        doctor.setDob(dob);
        doctor.setGender(gender);
        doctor.setPhonenum(phonenum);
        doctor.setAddress(address);
        doctor.setDegree(degree);
        doctor.setDepartmentId(departmentId);
        doctorDAO.updateDoctor(doctor); 
        response.sendRedirect("doctor"); 
    }
    // [GET] Xử lý xóa bác sĩ
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id")); 
        doctorDAO.deleteDoctor(userId); 
        response.sendRedirect("doctor"); 
    }
    private void searchDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Doctor> listDoctor;
        if (keyword == null || keyword.trim().isEmpty()) {
            listDoctor = doctorDAO.getAllDoctors();
        } else {
            listDoctor = doctorDAO.searchDoctorsByName(keyword.trim());
        }
        request.setAttribute("listDoctor", listDoctor);
        request.setAttribute("keyword", keyword); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/doctors.jsp");
        dispatcher.forward(request, response);
    }
}