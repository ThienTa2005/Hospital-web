package controller.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.ShiftDAO;
import model.dao.ShiftDoctorDAO;
import model.dao.AppointmentDAO;
import model.entity.Shift;
import model.entity.ShiftDoctor;
import model.entity.Appointment;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setAttribute("currentPage", "dashboard");

        LocalDate today = LocalDate.now();
        LocalDateTime nowDT = LocalDateTime.now();

        ShiftDAO shiftDAO = new ShiftDAO();
        ShiftDoctorDAO shiftDoctorDAO = new ShiftDoctorDAO();
        AppointmentDAO appointmentDAO = new AppointmentDAO();

        List<Shift> todayShifts = shiftDAO.getShiftsByDate(today);

        List<ShiftDoctor> doctorsOnShiftNowList = new ArrayList<>();

        for (Shift shift : todayShifts) {
            if (shift.getShiftDate() != null && shift.getStartTime() != null && shift.getEndTime() != null) {

                LocalDate shiftDate = shift.getShiftDate().toLocalDate();
                LocalDateTime start = LocalDateTime.of(shiftDate, shift.getStartTime().toLocalTime());
                LocalDateTime end = LocalDateTime.of(shiftDate, shift.getEndTime().toLocalTime());

                // Ca qua đêm thì cộng thêm 1 ngày cho end
                if (end.isBefore(start) || end.equals(start)) {
                    end = end.plusDays(1);
                }

                // Nếu thời điểm hiện tại nằm trong ca, thêm bác sĩ vào danh sách
                if (!nowDT.isBefore(start) && !nowDT.isAfter(end)) {
                    List<ShiftDoctor> doctorsInShift = shiftDoctorDAO.getDoctorsByShift(shift.getShiftId());
                    if (doctorsInShift != null && !doctorsInShift.isEmpty()) {
                        doctorsOnShiftNowList.addAll(doctorsInShift);
                    }
                }
            }
        }

        int doctorsOnShiftNowCount = doctorsOnShiftNowList.size();

        // Lấy danh sách lịch hẹn trong ngày
        List<Appointment> appointmentsTodayList = appointmentDAO.getAppointmentsByDate(today);

        request.setAttribute("doctorsOnShiftNowCount", doctorsOnShiftNowCount);
        request.setAttribute("doctorsOnShiftNowList", doctorsOnShiftNowList);
        request.setAttribute("appointmentsTodayList", appointmentsTodayList);
        request.setAttribute("appointmentsTodayCount", appointmentsTodayList.size());
        request.getRequestDispatcher("/views/admin/admin_dashboard/admin_dashboard.jsp")
               .forward(request, response);
    }
}
