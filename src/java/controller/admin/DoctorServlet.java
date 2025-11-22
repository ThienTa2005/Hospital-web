package controller.admin;

import model.dao.DoctorDAO;
import model.dao.UserDAO;
import model.dao.DepartmentDAO;
import model.entity.Doctor;
import model.entity.User;
import model.entity.Department;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/doctor")
public class DoctorServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
        userDAO = new UserDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":      {
                try {
                    // 🔴 QUAN TRỌNG: phải có case này
                    showAddForm(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DoctorServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "search":
            {
                try {
                    searchDoctor(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DoctorServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "delete":
                deleteDoctor(request, response);
                break;
            default:
            {
                try {
                    listDoctor(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DoctorServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

        }
    }

    @Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String action = request.getParameter("action");
    if (action == null) action = "";

    try {
        switch (action) {
            case "add":
                addDoctor(request, response);
                break;
            case "edit":
                editDoctor(request, response);
                break;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath()
                + "/admin/doctor?action=list&success=false");
    }
}


    // ====== LIST ======
    private void listDoctor(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Department> departments = departmentDAO.getAllDepartments();

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);

        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);

        request.getRequestDispatcher("/views/admin/doctor.jsp")
               .forward(request, response);
    }

    // ====== SEARCH ======
    private void searchDoctor(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String keyword = request.getParameter("keyword");
        List<Doctor> doctors;

        if (keyword == null || keyword.trim().isEmpty()) {
            doctors = doctorDAO.getAllDoctors();
        } else {
            doctors = doctorDAO.searchByName(keyword.trim());
        }

        List<Department> departments = departmentDAO.getAllDepartments();

        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/views/admin/doctor.jsp")
               .forward(request, response);
    }

    // ====== HIỆN FORM THÊM BÁC SĨ ======
    private void showAddForm(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.setAttribute("currentPage", "doctor");

        // 🔴 đường dẫn này phải đúng với vị trí file JSP của em
        request.getRequestDispatcher("/views/admin/add_doctor.jsp")
               .forward(request, response);
    }

    // ====== THÊM BÁC SĨ (POST) ======
    private void addDoctor(HttpServletRequest request,
                           HttpServletResponse response)
            throws IOException, ServletException, ParseException, SQLException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        if (userDAO.isUsernameExist(username)) {
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại.");
            List<Department> departments = departmentDAO.getAllDepartments();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/views/admin/add_doctor.jsp")
                   .forward(request, response);
            return;
        }

        String password  = request.getParameter("password");
        String fullname  = request.getParameter("fullname");
        String dobStr    = request.getParameter("dob");
        String gender    = request.getParameter("gender");
        String phonenum  = request.getParameter("phonenum");
        String address   = request.getParameter("address");

        String degree    = request.getParameter("degree");
        String deptIdStr = request.getParameter("departmentId");
        int deptId = 0;
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            deptId = Integer.parseInt(deptIdStr);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = sdf.parse(dobStr);
        java.sql.Date sqlDate   = new java.sql.Date(utilDate.getTime());

        // tạo user role=doctor
        User u = new User(0, username, password, fullname,
                          sqlDate, gender, phonenum, address, "doctor");
        int newUserId = userDAO.createUser(u);

        // tạo record Doctor
        doctorDAO.addDoctorSpecifics(newUserId, degree, deptId);

        response.sendRedirect(request.getContextPath()
                + "/admin/doctor?action=list&success=true");
    }

    // ====== SỬA BÁC SĨ ======
    private void editDoctor(HttpServletRequest request,
                        HttpServletResponse response)
        throws IOException {

    try {
        int userId   = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");

        if (userDAO.checkEditUsername(username, userId)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/doctor?action=list&error=username-exist");
            return;
        }

        String password  = request.getParameter("password");
        String fullname  = request.getParameter("fullname");
        String dobStr    = request.getParameter("dob");
        String gender    = request.getParameter("gender");
        String phonenum  = request.getParameter("phonenum");
        String address   = request.getParameter("address");
        String role      = request.getParameter("role");

        String degree    = request.getParameter("degree");
        String deptIdStr = request.getParameter("departmentId");
        int deptId = 0;
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            deptId = Integer.parseInt(deptIdStr);
        }

        // 🔴 Nếu password trống -> giữ password cũ
        if (password == null || password.trim().isEmpty()) {
            User old = userDAO.getUserById(userId);
            if (old != null) {
                password = old.getPassword();
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = sdf.parse(dobStr);
        java.sql.Date sqlDate   = new java.sql.Date(utilDate.getTime());

        User u = new User(userId, username, password, fullname,
                          sqlDate, gender, phonenum, address, role);

        userDAO.updateUser(u);
        doctorDAO.updateDoctorSpecifics(userId, degree, deptId);

        response.sendRedirect(request.getContextPath()
                + "/admin/doctor?action=list&success=true");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath()
                + "/admin/doctor?action=list&success=false");
    }
}


    // ====== XÓA BÁC SĨ ======
    private void deleteDoctor(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser != null && currentUser.getUserId() == id) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/doctor?action=list&error=selfDelete");
            return;
        }

        userDAO.deleteUser(id); // ON DELETE CASCADE sẽ xóa luôn Doctor

        response.sendRedirect(request.getContextPath()
                + "/admin/doctor?action=list&delete=true");
    }
}
