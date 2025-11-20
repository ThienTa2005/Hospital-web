package controller.admin;

import model.dao.DoctorDAO;
import model.dao.ShiftDoctorDAO;
import model.entity.Doctor;
import model.entity.ShiftDoctor;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/shift-doctor")
public class ShiftDoctorServlet extends HttpServlet {
    
    private ShiftDoctorDAO shiftDoctorDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        shiftDoctorDAO = new ShiftDoctorDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        //Mặc định sẽ hiện danh sách ca
        String action = request.getParameter("action");
        if (action == null) action = "view";
        
        switch (action) {
            case "remove":
                removeDoctor(request, response);
                break;
            default:
                viewShiftDoctors(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addDoctorToShift(request, response);
        }
    }

    private void viewShiftDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int shiftId = Integer.parseInt(request.getParameter("shiftId"));
            List<ShiftDoctor> assignedDoctors = shiftDoctorDAO.getDoctorsByShift(shiftId);
            List<Doctor> allDoctors = doctorDAO.getAllDoctors();
            
            request.setAttribute("assignedDoctors", assignedDoctors);
            request.setAttribute("allDoctors", allDoctors);
            request.setAttribute("shiftId", shiftId); 
            request.getRequestDispatcher("/views/admin/shift_doctor.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("shift"); 
        }
    }
    private void addDoctorToShift(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int shiftId = Integer.parseInt(request.getParameter("shiftId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        
        boolean success = shiftDoctorDAO.addDoctorToShift(shiftId, doctorId);
        
        String msg = success ? "success=true" : "error=exist";
        response.sendRedirect("shift-doctor?action=view&shiftId=" + shiftId + "&" + msg);
    }
    private void removeDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int shiftId = Integer.parseInt(request.getParameter("shiftId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        shiftDoctorDAO.removeDoctorFromShift(shiftId, doctorId);
        
        response.sendRedirect("shift-doctor?action=view&shiftId=" + shiftId + "&delete=true");
    }
}