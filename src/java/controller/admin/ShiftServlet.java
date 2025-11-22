package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import model.dao.ShiftDAO;
import model.entity.Shift;

@WebServlet("/admin/shift")
public class ShiftServlet extends HttpServlet {

    private ShiftDAO dao = new ShiftDAO();

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = req.getParameter("action");

        // Đọc flash-message từ session
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("successMessage") != null) {
            req.setAttribute("message", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage"); // dùng 1 lần rồi xóa
        }

        try {
            if (action == null || action.equals("list")) {
                req.setAttribute("shifts", dao.getAllShifts());
                req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
            } else if (action.equals("delete")) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deleteShift(id);
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list&ts=" + System.currentTimeMillis());
            } else if (action.equals("search")) {
                searchShift(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            // Thêm ca trực
            if ("add".equals(action)) {
                Date date = Date.valueOf(req.getParameter("date"));
                Time start = Time.valueOf(req.getParameter("start") + ":00");
                Time end = Time.valueOf(req.getParameter("end") + ":00");

                dao.addShift(new Shift(date, start, end));

                // Redirect với tham số ts để tránh cache, đảm bảo ca trực mới hiện ngay
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list&ts=" + System.currentTimeMillis());
            } // Sửa ca trực
            else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Date date = Date.valueOf(req.getParameter("date"));
                Time start = Time.valueOf(req.getParameter("start") + ":00");
                Time end = Time.valueOf(req.getParameter("end") + ":00");

                dao.updateShift(new Shift(id, date, start, end));

                HttpSession session = req.getSession();
                session.setAttribute("successMessage", "Cập nhật ca trực thành công!");

                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list&ts=" + System.currentTimeMillis());

            } // Action không hợp lệ -> quay về list
            else {
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi, quay về trang list với thông báo
            req.setAttribute("error", "Có lỗi xảy ra khi lưu ca trực: " + e.getMessage());
            try {
                req.setAttribute("shifts", dao.getAllShifts());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
        }
    }

    // ================== SEARCH ==================
    public void searchShift(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, SQLException {
        String dateStr = req.getParameter("date");
        String timeStr = req.getParameter("time");

        try {
            // 1. Không nhập gì -> hiện tất cả
            if ((dateStr == null || dateStr.isBlank())
                    && (timeStr == null || timeStr.isBlank())) {

                req.setAttribute("message", "Hiển thị tất cả ca trực");
                req.setAttribute("shifts", dao.getAllShifts());
                req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
                return;
            }

            // 2. Có ngày, không có giờ -> tìm theo ngày
            if (dateStr != null && !dateStr.isBlank()
                    && (timeStr == null || timeStr.isBlank())) {

                Date date = Date.valueOf(dateStr);
                List<Shift> list = dao.searchByDate(date);

                if (list.isEmpty()) {
                    req.setAttribute("error", "Không tìm thấy ca trực trong ngày đã chọn.");
                } else {
                    req.setAttribute("message", "Tìm thấy " + list.size() + " ca trực trong ngày.");
                }

                req.setAttribute("shifts", list);
                req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
                return;
            }

            // 3. Có ngày + giờ -> tìm theo thời gian cụ thể
            Date date = Date.valueOf(dateStr);
            Time time = Time.valueOf(timeStr + ":00");

            List<Shift> list = dao.searchByTime(date, time);

            if (list.isEmpty()) {
                req.setAttribute("error", "Không tìm thấy ca trực phù hợp thời gian.");
            } else {
                req.setAttribute("message", "Tìm thấy " + list.size() + " ca trực.");
            }

            req.setAttribute("shifts", list);
            req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tìm kiếm ca trực: " + e.getMessage());
            req.setAttribute("shifts", dao.getAllShifts());
            req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
        }
    }
}
