package controller.patient;

import model.dao.AppointmentDAO;
import model.dao.DepartmentDAO;
import model.entity.User;
import model.entity.Appointment;
import model.entity.Department;

import java.io.IOException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/patient_dashboard")
public class PatientDashboardServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user != null) 
        {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(user.getUserId());
            List<Department> departments = departmentDAO.getAllDepartments();

            request.setAttribute("appointments", appointments);
            request.setAttribute("departments", departments);
            
            request.getRequestDispatcher("/views/patient/patient_dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) 
        {
            String action = request.getParameter("action");
            if ("list".equals(action)) 
            {
                showPatientAppointments(request, response, user);
            } else {
                doGet(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    private void showPatientAppointments(HttpServletRequest req, HttpServletResponse resp, User user)
        throws ServletException, IOException {

        String departmentIdStr = req.getParameter("departmentId");
        String dateStr = req.getParameter("appointmentDate");
        String shift = req.getParameter("appointmentShift");

        Integer departmentId = null;
        if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdStr);
            } catch (NumberFormatException e) {
                departmentId = null;
            }
        }

        LocalDate appointmentDate = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            appointmentDate = LocalDate.parse(dateStr);
        }

        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientFilter(
                user.getUserId(),
                departmentId,
                appointmentDate,
                shift
        );
        
        req.setAttribute("selectedDepartmentId", departmentIdStr);
        req.setAttribute("selectedDate", dateStr);
        req.setAttribute("selectedShift", shift);


        List<Department> departments = departmentDAO.getAllDepartments();
        req.setAttribute("departments", departments);
        req.setAttribute("appointments", appointments);

        req.getRequestDispatcher("/views/patient/patient_dashboard.jsp").forward(req, resp);
    }
}
