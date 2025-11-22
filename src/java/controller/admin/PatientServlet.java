package controller.admin;

import model.dao.PatientDAO;
import model.dao.UserDAO; 
import model.entity.Patient;
import model.entity.User; 
import Utils.DBUtils;
import java.sql.Connection;

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
    private UserDAO userDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

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

    private void listPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> listPatient = patientDAO.getAllPatients();
        request.setAttribute("patients", listPatient);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/patient.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
  
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/patient_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        Patient existingPatient = patientDAO.getPatientById(userId);
        
        request.setAttribute("patient", existingPatient);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/patient_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertPatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullname = request.getParameter("fullname");
            Date dob = Date.valueOf(request.getParameter("dob"));
            String gender = request.getParameter("gender");
            String phonenum = request.getParameter("phonenum");
            String address = request.getParameter("address");

            if (userDAO.isUsernameExist(username)) {
                response.sendRedirect("patient?action=list&error=username-exist");
                return;
            }

            User u = new User(0, username, password, fullname, dob, gender, phonenum, address, "patient");
            int newUserId = userDAO.createUser(u); // Gọi hàm tạo User chung

            if (newUserId > 0) {
               
                Connection conn = DBUtils.getConnection(); 
           
               patientDAO.addPatientSpecifics(newUserId);
                conn.close();
            }

            response.sendRedirect("patient?action=list&success=add");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patient?action=list&error=add-failed");
        }
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String fullname = request.getParameter("fullname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String gender = request.getParameter("gender");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");

        Patient patient = new Patient();
        patient.setUserId(userId);
        patient.setFullname(fullname);
        patient.setDob(dob);
        patient.setGender(gender);
        patient.setPhonenum(phonenum);
        patient.setAddress(address);

        patientDAO.updatePatient(patient);
        
        response.sendRedirect("patient?action=list&success=update");
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        patientDAO.deletePatient(userId);
        
        response.sendRedirect("patient?action=list&success=delete");
    }
}