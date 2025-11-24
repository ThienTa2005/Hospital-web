package controller.patient;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.dao.AppointmentDAO;
import model.dao.MedicalRecordDAO;
import model.entity.MedicalRecord;

@WebServlet("/record")
public class MedicalRecordServlet extends HttpServlet {

    private MedicalRecordDAO medicalDAO = new MedicalRecordDAO();
    private AppointmentDAO appDAO = new AppointmentDAO(); 

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try 
        {
            switch (action) 
            {
                case "add":
                    addRecord(request, response);
                    break;

                case "delete":
                    deleteRecord(request, response);
                    break;

                case "list":
                default:
                    listRecords(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) 
            {
                addRecord(request, response);
            }
            else if ("update".equals(action))
            {
                updateRecord(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void listRecords(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        int appointmentId = Integer.parseInt((String) request.getAttribute("appointment_id"));
        List<MedicalRecord> list = medicalDAO.getAppointmentById(appointmentId);
        request.setAttribute("records", list);
        request.setAttribute("appointment_id", appointmentId);
        request.getRequestDispatcher("/medical_record_list.jsp").forward(request, response);
    }


    public void addRecord(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        String diagnosis = request.getParameter("diagnosis");
        String notes = request.getParameter("notes");
        String prescription = request.getParameter("prescription");
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));

        MedicalRecord m = new MedicalRecord(0, diagnosis, notes, prescription, appointmentId);
        medicalDAO.addRecord(m);

        response.sendRedirect("record?action=list");
    }
    
    public void updateRecord(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        int recordId = Integer.parseInt((String) request.getAttribute("record_id"));
        int appointmentId = Integer.parseInt((String) request.getAttribute("appointment_id"));
        
        String diagnosis = (String) request.getAttribute("diagnosis");
        String notes = (String) request.getAttribute("notes");
        String prescription = (String) request.getAttribute("prescription");

        MedicalRecord m = new MedicalRecord(recordId, diagnosis, notes, prescription, appointmentId);

        if (medicalDAO.updateRecord(m)) {
            response.sendRedirect("records?action=list");
        } 
    }

    public void deleteRecord(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        int id = Integer.parseInt(request.getParameter("record_id"));
        medicalDAO.delete(id);
        response.sendRedirect("record?action=list");
    }
}

