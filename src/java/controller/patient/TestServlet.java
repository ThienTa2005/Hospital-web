package controller.patient;

import model.dao.TestDAO;
import model.entity.Test;
import model.entity.User;
import model.dao.AppointmentDAO;
import model.entity.Appointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.sql.Timestamp;

@WebServlet("/test")
public class TestServlet extends HttpServlet {

    private TestDAO testDAO;

    @Override
    public void init() throws ServletException {
        testDAO = new TestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Chỉ dùng để xem các xét nghiệm theo appointment_id
        String appointmentIdStr = request.getParameter("appointment_id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        try {
            viewTests(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action"); // từ modalTestAction
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        try {
            switch (action) {
                case "add":
                case "update":
                    saveTest(request, response);
                    break;
                case "delete":
                    deleteTest(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/doctor/schedule");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /** Xem danh sách xét nghiệm theo appointment_id */
    private void viewTests(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        List<Test> tests = testDAO.getTestByAppointmentId(appointmentId);

        request.setAttribute("appointment", appointment);
        request.setAttribute("tests", tests);

        request.getRequestDispatcher("/views/doctor/appointment_detail.jsp")
                .forward(request, response);
    }

    /** Thêm hoặc cập nhật xét nghiệm */
    private void saveTest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        int shiftDoctorId = Integer.parseInt(request.getParameter("shift_doctor_id"));

        String testIdStr = request.getParameter("test_id");
        int testId = (testIdStr != null && !testIdStr.isEmpty()) ? Integer.parseInt(testIdStr) : 0;

        String testName = request.getParameter("test_name");
        String parameter = request.getParameter("parameter");
        String parameterValue = request.getParameter("parameter_value");
        String unit = request.getParameter("unit");
        String referenceRange = request.getParameter("reference_range");

        String testTimeStr = request.getParameter("test_time");
        Timestamp testTime = null;

        if (testTimeStr != null && !testTimeStr.isEmpty()) {
            // Chuyển từ "yyyy-MM-ddTHH:mm" sang Timestamp
            testTime = Timestamp.valueOf(testTimeStr.replace("T", " ") + ":00");
        }

        Test test = new Test(); // tạo object rỗng
        test.setTestId(testId);
        test.setName(testName);
        test.setTestTime(testTime);
        test.setParameter(parameter);
        test.setParameterValue(parameterValue);
        test.setUnit(unit);
        test.setReferenceRange(referenceRange);
        test.setAppointmentId(appointmentId);
        test.setShiftDoctorId(shiftDoctorId);

        if (testId == 0) {
            testDAO.addTest(test); // action = add
        } else {
            testDAO.updateTest(test); // action = update
        }

        response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId);
    }

    /** Xóa xét nghiệm */
    private void deleteTest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String testIdStr = request.getParameter("test_id");
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));

        if (testIdStr != null && !testIdStr.isEmpty()) {
            int testId = Integer.parseInt(testIdStr);
            testDAO.deleteTest(testId);
        }

        response.sendRedirect(request.getContextPath() + "/doctor/appointmentDetail?id=" + appointmentId);
    }
}
