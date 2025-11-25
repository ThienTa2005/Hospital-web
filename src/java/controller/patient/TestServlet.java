package controller.patient;

import model.dao.TestDAO;
import model.entity.Test;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/test")
public class TestServlet extends HttpServlet {

    private TestDAO dao = new TestDAO();

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) 
        {
            case "delete":
            {
                try
                {
                    deleteTest(req, resp);
                } catch (Exception ex)
                {
                    System.getLogger(TestServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                }
                break;
            }
                
            default:
            {
                try
                {
                    listTest(req, resp);
                } catch (Exception ex)
                {
                    System.getLogger(TestServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                }
            }

        }
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    {
        String action = req.getParameter("action");
        if (action == null) action = "add";

        switch (action) {
            case "add":
            {
                try
                {
                    addTest(req, resp);
                } catch (Exception ex)
                {
                    System.getLogger(TestServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                }
                break;
            }

            case "update":
            {
                try
                {
                    updateTest(req, resp);
                } catch (Exception ex)
                {
                    System.getLogger(TestServlet.class.getName()).
                            log(System.Logger.Level.ERROR, (String) null, ex);
                }
                 break;
            }
        }
    }

    // Liet ke tests theo appointment_id
    public void listTest(HttpServletRequest req, HttpServletResponse resp) throws Exception
    {
        int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));

        req.setAttribute("appointmentId", appointmentId);
        req.setAttribute("tests", dao.getTestByAppointmentId(appointmentId));

        req.getRequestDispatcher("/test_list.jsp").forward(req, resp);
    }

    // Them test
    public void addTest(HttpServletRequest req, HttpServletResponse resp) throws Exception 
    {
        int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));
        int shiftDoctorId = Integer.parseInt(req.getParameter("shift_doctor_id"));

        Test t = new Test();
        t.setName(req.getParameter("test_name"));
        t.setTestTime(Timestamp.valueOf(req.getParameter("test_time")));
        t.setParameter(req.getParameter("parameter"));
        t.setParameterValue(req.getParameter("parameter_value"));
        t.setUnit(req.getParameter("unit"));
        t.setReferenceRange(req.getParameter("reference_range"));
        t.setAppointmentId(appointmentId);
        t.setShiftDoctorId(shiftDoctorId);

        dao.addTest(t);
        resp.sendRedirect("test?action=list&appointment_id=" + appointmentId);
    }
    
    // Cap nhat test
    public void updateTest(HttpServletRequest req, HttpServletResponse resp) throws Exception
    {
        Test t = new Test();

        t.setTestId(Integer.parseInt(req.getParameter("test_id")));
        t.setName(req.getParameter("test_name"));
        t.setTestTime(Timestamp.valueOf(req.getParameter("test_time")));
        t.setParameter(req.getParameter("parameter"));
        t.setParameterValue(req.getParameter("parameter_value"));
        t.setUnit(req.getParameter("unit"));
        t.setReferenceRange(req.getParameter("reference_range"));
        t.setAppointmentId(Integer.parseInt(req.getParameter("appointment_id")));
        t.setShiftDoctorId(Integer.parseInt(req.getParameter("shift_doctor_id")));

        dao.updateTest(t);
        resp.sendRedirect("test?action=list&appointment_id=" + t.getAppointmentId());
    }

    // Xoa test
    public void deleteTest(HttpServletRequest req, HttpServletResponse resp) throws Exception
    {
        int testId = Integer.parseInt(req.getParameter("test_id"));
        int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));

        dao.deleteTest(testId);
        resp.sendRedirect("test?action=list&appointment_id=" + appointmentId);
    }
}