package controller.patient;

import model.dao.AppointmentDAO;
import model.entity.Appointment;
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


@WebServlet("/appointment")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

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
                //Bệnh nhân xem danh sách các lịch hẹn của mình
                list = appointmentDAO.getAppointmentsByPatientId(user.getUserId());
                req.setAttribute("appointments", list);
                req.getRequestDispatcher("/views/patient/patient_appointments.jsp").forward(req, resp);
            } 
            else if ("doctor".equals(user.getRole())) {
                //bác sĩ xem danh sách bệnh nhân đặt lịch với mình
                LocalDate today = LocalDate.now();
                list = appointmentDAO.getAppointmentsByDoctorIdAndDate(user.getUserId(), today);

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
        
        if ("book".equals(action)) {
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");
            
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
    }
    
    
}