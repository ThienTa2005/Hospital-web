package controller.auth;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.UserDAO;
import model.dao.PatientDAO; 
import model.entity.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private PatientDAO patientDAO; 
        
    @Override
    public void init() {
        userDAO = new UserDAO();
        patientDAO = new PatientDAO(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }
    
    private static String newString(String item) {
        if (item == null) return null;
        byte[] bytes = item.getBytes(StandardCharsets.ISO_8859_1); 
        return new String(bytes, StandardCharsets.UTF_8);
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String username = request.getParameter("username");        
        
        try {
            if (userDAO.isUsernameExist(username)) {
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác."); 
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
                return;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        //Lấy dữ liệu từ form
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String password = request.getParameter("password");
        String fullname = newString(request.getParameter("fullname"));
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phonenum");
        String address = newString(request.getParameter("address"));
        String role = "patient"; // Mặc định là patient
        
        java.sql.Date sqlDate = null;
        try {
            java.util.Date utilDate = sdf.parse(dob);
            sqlDate = new java.sql.Date(utilDate.getTime());
        } catch (ParseException ex) {
            ex.printStackTrace();
        }
        
        User u = new User(0, username, password, fullname, sqlDate, gender, phone, address, role);
        
        try {
            
            int newUserId = userDAO.createUser(u);
            
            if (newUserId > 0) {                
                patientDAO.addPatientSpecifics(newUserId);
                
                // Thành công -> Chuyển về login
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?success=true");
            } else {
                request.setAttribute("errorMessage", "Đăng ký thất bại (Lỗi cơ sở dữ liệu).");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }
}