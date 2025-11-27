package controller.patient;

import model.dao.MedicalRecordDAO;
import model.dao.TestDAO; // Cần thêm import này
import model.entity.MedicalRecord;
import model.entity.Test;
import model.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/record")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO;
    private TestDAO testDAO; // DAO để lấy xét nghiệm

    @Override
    public void init() {
        medicalDAO = new MedicalRecordDAO();
        testDAO = new TestDAO(); // Khởi tạo TestDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy ID cuộc hẹn từ URL
        String appointmentIdStr = request.getParameter("appointment_id");
        
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);

                // 1. Lấy hồ sơ bệnh án (MedicalRecord) - Giả sử 1 cuộc hẹn có 1 hồ sơ
                // Lưu ý: Hàm này trả về List nhưng ta chỉ lấy cái đầu tiên
                List<MedicalRecord> records = medicalDAO.getMedicalRecordByAppointmentId(appointmentId);
                MedicalRecord record = null;
                if (records != null && !records.isEmpty()) {
                    record = records.get(0);
                }

                // 2. Lấy danh sách xét nghiệm (Test)
                // Bạn cần đảm bảo TestDAO có hàm getTestByAppointmentId
                List<Test> tests = testDAO.getTestByAppointmentId(appointmentId);

                // 3. Gửi dữ liệu sang JSP
                request.setAttribute("record", record);
                request.setAttribute("tests", tests);
                
                // Đánh dấu active menu (nếu cần dùng menu tròn)
                request.setAttribute("activePage", "record");

                request.getRequestDispatcher("/views/patient/patient_medical_record.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("appointment?action=list&error=invalid_id");
            } catch (SQLException ex) {
                System.getLogger(MedicalRecordServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }
        } else {
            // Nếu không có ID, quay về danh sách
            response.sendRedirect("appointment?action=list");
        }
    }
}