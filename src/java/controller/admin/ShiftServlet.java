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
                req.setAttribute("shifts", dao.getAllShifts());
                req.getRequestDispatcher("/views/admin/shift.jsp").forward(req, resp);
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
}
