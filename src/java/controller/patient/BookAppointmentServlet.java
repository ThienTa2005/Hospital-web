package controller.patient;

import model.dao.DoctorDAO;
import model.dao.ShiftDoctorDAO;
import model.dao.AppointmentDAO;
import model.dao.DepartmentDAO;

import model.entity.User;
import model.entity.Doctor;
import model.entity.Department;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
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

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        /* =======================
           1. TÌM KIẾM – DANH SÁCH BÁC SĨ
           ======================= */

        String searchName = req.getParameter("q");
        String deptParam = req.getParameter("dept");

        Integer deptId = null;
        if (deptParam != null && !deptParam.isEmpty()) {
            try {
                deptId = Integer.parseInt(deptParam);
            } catch (Exception ignored) {
                deptId = null;
            }
        }

        List<Doctor> doctors = doctorDAO.searchDoctors(searchName, deptId);
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("doctors", doctors);
        req.setAttribute("departments", departments);
        req.setAttribute("searchName", searchName);
        req.setAttribute("selectedDeptId", deptParam);

        /* =======================
           2. XEM LỊCH CỦA 1 BÁC SĨ
           ======================= */

        String doctorIdStr = req.getParameter("doctorId");
        String dateStr = req.getParameter("date");

        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {

            int doctorId = Integer.parseInt(doctorIdStr);
            Doctor selectedDoctor = doctorDAO.getDoctorById(doctorId);
            req.setAttribute("selectedDoctor", selectedDoctor);

            if (dateStr != null && !dateStr.isEmpty()) {
                Date sqlDate = Date.valueOf(dateStr);

                List<Map<String, Object>> schedules =
                        shiftDoctorDAO.getDoctorScheduleByDate(doctorId, sqlDate);

                req.setAttribute("selectedDate", dateStr);
                req.setAttribute("schedules", schedules);
                req.setAttribute("noSchedule", schedules == null || schedules.isEmpty());
            }
        }

        /* =======================
           3. FORWARD SANG JSP
           ======================= */

        req.getRequestDispatcher("/views/patient/patient_booking.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String shiftDoctorIdStr = req.getParameter("shiftDoctorId");
        String doctorIdStr = req.getParameter("doctorId");
        String dateStr = req.getParameter("date");

        if (shiftDoctorIdStr == null || shiftDoctorIdStr.isEmpty()) {
            req.setAttribute("error", "Bạn chưa chọn khung giờ.");
            doGet(req, resp);
            return;
        }

        int shiftDoctorId = Integer.parseInt(shiftDoctorIdStr);

        model.entity.Appointment app = new model.entity.Appointment();
        app.setPatientId(user.getUserId());
        app.setShiftDoctorId(shiftDoctorId);

        boolean success = appointmentDAO.createBooking(app);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/appointment?action=list&success=true");
        } else {
            req.setAttribute("error", "Đặt lịch thất bại. Vui lòng thử lại.");
            req.setAttribute("doctorId", doctorIdStr);
            req.setAttribute("selectedDate", dateStr);
            doGet(req, resp);
        }
    }
}
