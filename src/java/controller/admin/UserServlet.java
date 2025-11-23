package controller.admin;

import model.dao.DoctorDAO;
import model.dao.PatientDAO;
import model.dao.UserDAO;
import model.entity.User;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/user")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                String successParam = request.getParameter("success");
                request.setAttribute("success", successParam);
                request.getRequestDispatcher("/views/admin/add_user.jsp").forward(request, response);
                break;

            case "delete":
                deleteUser(request, response);
                break;

            case "search":
                searchUser(request, response);
                break;

            default:
                listUser(request, response);
                break;
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = (String) request.getParameter("action");
        // System.out.println(action); // Debug log
        switch (action) {
            case "add": {
                try {
                    addUser(request, response);
                } catch (SQLException | ParseException ex) {
                    ex.printStackTrace();
             
                    response.sendRedirect(request.getContextPath() + "/admin/user?action=add&success=false");
                }
                break;
            }

            case "edit": {
                try {
                    editUser(request, response);
                } catch (SQLException | ParseException ex) {
                    ex.printStackTrace();
                }
                break;
            }
        }
    }

    private static String newString(String item) {
        if(item == null) return "";
        byte[] bytes = item.getBytes(StandardCharsets.ISO_8859_1);
        item = new String(bytes, StandardCharsets.UTF_8);
        return item;
    }

    // Liet ke users
    public void listUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    public void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, ParseException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        
        if(userDAO.isUsernameExist(username)) {
             request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại.");
             request.getRequestDispatcher("/views/admin/add_user.jsp").forward(request, response);
             return;
        }

        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname"); 
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender"); // Đảm bảo JSP gửi 'M' hoặc 'F'
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        String degree = request.getParameter("degree");
        String deptIdParam = request.getParameter("departmentId");

        int departmentId = 0;
        if (deptIdParam != null && !deptIdParam.trim().isEmpty()) {
            try {
                departmentId = Integer.parseInt(deptIdParam);
            } catch (NumberFormatException e) {
                departmentId = 0;
            }
        }

        if ("doctor".equals(role) && departmentId == 0) {
            request.setAttribute("errorMessage", "Vui lòng chọn chuyên khoa cho bác sĩ.");
            request.getRequestDispatcher("/views/admin/add_user.jsp").forward(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = sdf.parse(dob);
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

        try {
            User u = new User(0, username, password, fullname, sqlDate, gender, phone, address, role);
            int newUserId = userDAO.createUser(u);

            if (newUserId > 0) {
                if ("doctor".equals(role)) {
                    doctorDAO.addDoctorSpecifics(newUserId, degree, departmentId);
                } else if ("patient".equals(role)) {
                    patientDAO.addPatientSpecifics(newUserId);
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/user?action=list&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/user?action=add&success=false");
        }
    }
    public void editUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, ParseException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        int id = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");

        if (userDAO.checkEditUsername(username, id)) {
            response.sendRedirect(request.getContextPath() + "/admin/user?action=list&error=username-exist");
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname"); // request đã set UTF-8
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        java.util.Date utilDate = sdf.parse(dob);
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

        User u = new User(id, username, password, fullname, sqlDate, gender, phone, address, role);
        userDAO.updateUser(u);
        response.sendRedirect(request.getContextPath() + "/admin/user?action=list&success=true");
    }

    // Xoa
    public void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if(idParam == null || idParam.isEmpty()) {
             response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
             return;
        }
        
        int id = Integer.parseInt(idParam);

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser != null && currentUser.getUserId() == id) {
            response.sendRedirect(request.getContextPath() + "/admin/user?action=list&error=selfDelete");
            return;
        }

        userDAO.deleteUser(id);
        response.sendRedirect(request.getContextPath() + "/admin/user?action=list&delete=true");
    }

    // Tim kiem
    public void searchUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        List<User> users;
        if (keyword == null || keyword.trim().isEmpty()) {
            users = userDAO.getAllUsers();
        } else {
            users = userDAO.searchByName(keyword.trim());
        }

        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }
}