package controller.doctor;

import model.dao.ShiftDoctorDAO;
import model.entity.Shift;
import model.entity.User;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/doctor/schedule")
public class DoctorScheduleServlet extends HttpServlet {

    private ShiftDoctorDAO shiftDoctorDAO;

    @Override
    public void init() {
        shiftDoctorDAO = new ShiftDoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        String dateParam = req.getParameter("selectedDate");
        LocalDate selectedDate;
        try {
            selectedDate = (dateParam != null && !dateParam.isEmpty()) ? LocalDate.parse(dateParam) : LocalDate.now();
        } catch (Exception e) {
            selectedDate = LocalDate.now();
        }

        int year = selectedDate.getYear();
        int month = selectedDate.getMonthValue();
        YearMonth yearMonth = YearMonth.of(year, month);
        int daysInMonth = yearMonth.lengthOfMonth();
        int startDayOfWeek = yearMonth.atDay(1).getDayOfWeek().getValue();

        Date sqlFrom = Date.valueOf(selectedDate);
        Date sqlTo = Date.valueOf(selectedDate.plusDays(6));
        List<Shift> myWeeklyShifts = shiftDoctorDAO.getShiftsByDoctor(user.getUserId(), sqlFrom, sqlTo);

        Date monthStart = Date.valueOf(yearMonth.atDay(1));
        Date monthEnd = Date.valueOf(yearMonth.atEndOfMonth());
        List<Shift> myAllShifts = shiftDoctorDAO.getShiftsByDoctor(user.getUserId(), monthStart, monthEnd);

        req.setAttribute("selectedDate", selectedDate);
        req.setAttribute("currentMonth", month);
        req.setAttribute("currentYear", year);
        req.setAttribute("daysInMonth", daysInMonth);
        req.setAttribute("startDayOfWeek", startDayOfWeek);
        
        req.setAttribute("myAllShifts", myAllShifts);
        req.setAttribute("myWeeklyShifts", myWeeklyShifts);

        req.getRequestDispatcher("/views/doctor/doctor_schedule.jsp").forward(req, resp);
    }
}