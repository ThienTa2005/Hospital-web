package controller.patient;

import model.dao.AppointmentDAO;
import model.entity.Appointment;
import model.dao.DepartmentDAO;
import model.entity.Department;
import model.entity.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.dao.DepartmentDAO;


@WebServlet("/appointment")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        if ("list".equals(action)) {
            List<Appointment> list = null;

            if ("patient".equals(user.getRole())) {
                list = appointmentDAO.getAppointmentsByPatientId(user.getUserId());
                List<Department> departments = departmentDAO.getAllDepartments();

                req.setAttribute("appointments", list);
                req.setAttribute("departments", departments);
            
                req.getRequestDispatcher("/views/patient/patient_appointment.jsp").forward(req, resp);
            } 
            else if ("doctor".equals(user.getRole())) {
                //bác sĩ xem danh sách bệnh nhân đặt lịch với mình
                list = appointmentDAO.getAppointmentsByDoctorId(user.getUserId());
                req.setAttribute("appointments", list);
                req.getRequestDispatcher("/views/doctor/doctor_appointments.jsp").forward(req, resp);
            }
            else if ("admin".equals(user.getRole())) {
                //Admin xem danh sách lịch hẹn của patient
                String patientId = req.getParameter("patientId");
                int pId = 0;
                if(patientId != null)
                {
                    pId = Integer.parseInt(patientId);
                }
                list = appointmentDAO.getAppointmentsByPatientId(pId);
                req.setAttribute("appointments", list);
                req.getRequestDispatcher("/views/admin/appointments.jsp").forward(req, resp);
            }
        } 
        else if ("cancel".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            appointmentDAO.cancelAppointment(id);
            resp.sendRedirect("appointment?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        
        if ("book".equals(action)) {
            int shiftDoctorId = Integer.parseInt(req.getParameter("shiftDoctorId"));
            
            Appointment app = new Appointment();
            app.setPatientId(user.getUserId());
            app.setShiftDoctorId(shiftDoctorId);
            
            boolean success = appointmentDAO.createBooking(app);
            
            if (success) {
                resp.sendRedirect("appointment?action=list&success=true");
            } else {
                resp.sendRedirect("appointment_form.jsp?error=fail");
            }
        }
        else if ("filter".equals(action)) 
        {
            showPatientAppointments(req, resp, user);
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

        req.getRequestDispatcher("/views/patient/patient_appointment.jsp").forward(req, resp);
    }
}
