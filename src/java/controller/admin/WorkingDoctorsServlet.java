package controller.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.ShiftDAO;
import model.dao.ShiftDoctorDAO;
import model.entity.Shift;
import model.entity.ShiftDoctor;

@WebServlet("/admin/working_doctors")
public class WorkingDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ShiftDAO shiftDAO = new ShiftDAO();
        ShiftDoctorDAO shiftDoctorDAO = new ShiftDoctorDAO();
        LocalDate today = LocalDate.now();
        LocalDateTime now = LocalDateTime.now();

        List<Shift> todayShifts = shiftDAO.getShiftsByDate(today);
        List<ShiftDoctor> doctorsOnShiftNow = new java.util.ArrayList<>();

        for (Shift shift : todayShifts) {
            if (shift.getShiftDate() != null && shift.getStartTime() != null && shift.getEndTime() != null) {
                LocalDateTime start = LocalDateTime.of(shift.getShiftDate().toLocalDate(), shift.getStartTime().toLocalTime());
                LocalDateTime end = LocalDateTime.of(shift.getShiftDate().toLocalDate(), shift.getEndTime().toLocalTime());

                if (!now.isBefore(start) && !now.isAfter(end)) {
                    List<ShiftDoctor> doctorsInShift = shiftDoctorDAO.getDoctorsByShift(shift.getShiftId());
                    if (doctorsInShift != null) {
                        doctorsOnShiftNow.addAll(doctorsInShift);
                    }
                }
            }
        }

        request.setAttribute("doctorsOnShiftNow", doctorsOnShiftNow);
        request.getRequestDispatcher("/views/admin/admin_dashboard/working_doctors.jsp")
               .forward(request, response);
    }
}
