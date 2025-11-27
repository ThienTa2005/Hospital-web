package controller.patient;

import model.dao.DoctorDAO;
import model.dao.ShiftDoctorDAO;
import model.dao.AppointmentDAO;
import model.dao.DepartmentDAO;

import model.entity.User;
import model.entity.Doctor;
import model.entity.Department;
import model.entity.Appointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private ShiftDoctorDAO shiftDoctorDAO;
    private AppointmentDAO appointmentDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        shiftDoctorDAO = new ShiftDoctorDAO();
        appointmentDAO = new AppointmentDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String searchName = req.getParameter("q");
        String deptParam = req.getParameter("dept");
        Integer deptId = null;
        if (deptParam != null && !deptParam.isEmpty()) {
            try { deptId = Integer.parseInt(deptParam); } catch (Exception ignored) {}
        }

        List<Doctor> doctors = doctorDAO.searchDoctors(searchName, deptId);
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("doctors", doctors);
        req.setAttribute("departments", departments);
        req.setAttribute("searchName", searchName);
        req.setAttribute("selectedDeptId", deptParam);

        String doctorIdStr = req.getParameter("doctorId");
        String dateStr = req.getParameter("date");

        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                Doctor selectedDoctor = doctorDAO.getDoctorById(doctorId);
                req.setAttribute("selectedDoctor", selectedDoctor);

                if (dateStr != null && !dateStr.isEmpty()) {
                    Date sqlDate = Date.valueOf(dateStr);
                    List<Map<String, Object>> schedules = shiftDoctorDAO.getDoctorScheduleByDate(doctorId, sqlDate);
                    
                    req.setAttribute("selectedDate", dateStr);
                    req.setAttribute("schedules", schedules);
                    req.setAttribute("noSchedule", schedules == null || schedules.isEmpty());
                }
            } catch (NumberFormatException e) { }
        }

        req.getRequestDispatcher("/views/patient/patient_booking.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String shiftDoctorIdStr = req.getParameter("shiftDoctorId");
        String doctorIdStr = req.getParameter("doctorId");
        String dateStr = req.getParameter("date");    
        String startTimeStr = req.getParameter("startTime"); 

        if (shiftDoctorIdStr == null || shiftDoctorIdStr.isEmpty()) {
            req.setAttribute("error", "Vui lòng chọn khung giờ.");
            doGet(req, resp);
            return;
        }

        try {
            int shiftDoctorId = Integer.parseInt(shiftDoctorIdStr);

            if (dateStr == null || startTimeStr == null) {
                throw new Exception("Dữ liệu ngày giờ bị thiếu!");
            }
            
            LocalDate datePart = LocalDate.parse(dateStr.trim()); 

            LocalTime timePart = LocalTime.parse(startTimeStr.trim()); 
            LocalDateTime dateTimePart = LocalDateTime.of(datePart, timePart);
            Timestamp appointmentDate = Timestamp.valueOf(dateTimePart);
            System.out.println(">>> CHECK ĐẶT LỊCH: " + appointmentDate.toString());

            Appointment app = new Appointment();
            app.setPatientId(user.getUserId());
            app.setShiftDoctorId(shiftDoctorId);
            app.setAppointmentDate(appointmentDate); 
            app.setStatus("pending");

            boolean success = appointmentDAO.createBooking(app);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/appointment?action=list&success=true");
            } else {
                req.setAttribute("error", "Đặt lịch thất bại. Vui lòng thử lại.");
                req.setAttribute("doctorId", doctorIdStr);
                req.setAttribute("selectedDate", dateStr);
                doGet(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi xử lý ngày giờ: " + e.getMessage());
            req.setAttribute("doctorId", doctorIdStr);
            req.setAttribute("selectedDate", dateStr);
            doGet(req, resp);
        }
    }
}