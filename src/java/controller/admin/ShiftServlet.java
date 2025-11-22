package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import model.dao.ShiftDAO;
import model.entity.Shift;
import java.util.Map;
import java.util.ArrayList;
import com.google.gson.Gson;
import java.util.HashMap;
import model.dao.DoctorDAO;
import model.entity.Doctor;

@WebServlet("/admin/shift")
public class ShiftServlet extends HttpServlet 
{
    private ShiftDAO dao = new ShiftDAO();

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    {
        String action = req.getParameter("action");

        try {
            if (action == null || action.equals("list")) 
            {
//                req.setAttribute("shifts", dao.getAllShifts());
//                req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
                
                req.setAttribute("allDoctorsList", new Gson().toJson(new DoctorDAO().getAllDoctors())); 
                
                getAllShiftGrouped(req, resp);
            }

            else if (action.equals("delete")) 
            {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deleteShift(id);
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list");
            }
            
            else if (action.equals("search")) 
            {
                searchShift(req, resp);
            }
            else if ("saveDoctors".equals(action)) {
                int shiftId = Integer.parseInt(req.getParameter("shiftId"));
                String doctorsJson = req.getParameter("doctors"); // JSON array [{userId:..., fullName:...}, ...]

                Gson gson = new Gson();
                Doctor[] doctors = gson.fromJson(doctorsJson, Doctor[].class);

                dao.saveDoctorsInShift(shiftId, List.of(doctors));

                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\"}");
                return;
            }
            else if("deleteShiftFromClient".equals(action)) {
                int shiftId = Integer.parseInt(req.getParameter("shiftId"));

                try {
                    dao.deleteShiftAndDoctors(shiftId);
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"status\":\"success\"}");
                } catch(Exception e) {
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    {
        String action = req.getParameter("action");

        try {
            if (action.equals("add")) 
            {
                Date date = Date.valueOf(req.getParameter("date"));
                Time start = Time.valueOf(req.getParameter("start") + ":00");
                Time end = Time.valueOf(req.getParameter("end") + ":00");

                dao.addShift(new Shift(date, start, end));
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list");
            }

            else if (action.equals("edit")) 
            {
                int id = Integer.parseInt(req.getParameter("id"));
                Date date = Date.valueOf(req.getParameter("date"));
                Time start = Time.valueOf(req.getParameter("start") + ":00");
                Time end = Time.valueOf(req.getParameter("end") + ":00");

                dao.updateShift(new Shift(id, date, start, end));
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void searchShift(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException      {
        String dateStr = req.getParameter("date");
        String timeStr = req.getParameter("time");

        try {
            if (dateStr == null || dateStr.isEmpty() ||
                timeStr == null || timeStr.isEmpty()) 
            {
                resp.sendRedirect(req.getContextPath() + "/admin/shift?action=list");
                return;
            }

            Date date = Date.valueOf(dateStr);           
            Time time = Time.valueOf(timeStr + ":00");   
            
            List<Shift> list = dao.searchByTime(date, time);

            req.setAttribute("shifts", list);
            req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);          
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void getAllShiftGrouped(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        Map<String, Map<String, List<Doctor>>> result = new HashMap<>();

        try {
            List<Shift> allShifts = dao.getAllShifts();

            for (Shift s : allShifts) {

                String date = s.getShiftDate().toString();
                String period = getPeriod(s.getStartTime()); 
                List<Doctor> doctors = dao.getAllDoctorsInShift(s.getShiftId());

                result
                    .computeIfAbsent(date, d -> new HashMap<>())
                    .computeIfAbsent(period, e -> doctors);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        Gson gson = new Gson();
        String shiftMap = gson.toJson(result);
        
        System.out.println(shiftMap);

        req.setAttribute("shiftMap", shiftMap);
        req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
    }

    
    private String getPeriod(Time start) {
        String t = start.toString();

        switch (t) {
            case "07:00:00": return "morning";
            case "08:00:00": return "morning";
            case "13:00:00": return "afternoon";
            case "19:00:00": return "night";
            default: return "unknown";
        }
    }
}