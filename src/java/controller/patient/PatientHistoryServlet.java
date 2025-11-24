package controller.patient;

import model.dao.AppointmentDAO;
import model.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/patient-history")
public class PatientHistoryServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // chưa đăng nhập → quay về trang login (tùy dự án bạn chỉnh lại đường dẫn)
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Lấy danh sách lịch sử khám (kèm record_id nếu đã có hồ sơ)
            List<Map<String, Object>> historyList =
                    appointmentDAO.getPatientHistoryMap(user.getUserId());

            request.setAttribute("historyList", historyList);

            // forward sang JSP hiển thị lịch sử
            request.getRequestDispatcher("/views/patient/patient_records.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
