<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page import="java.text.SimpleDateFormat" %>
    <%@ page import="java.util.List" %>
    <%@ page import="model.entity.Appointment" %>
    <%@ page import="model.entity.Department" %>
    <%@ page import="model.entity.User" %>
    <%@ page import="java.sql.Timestamp" %>
    <%@ page import="java.sql.Time" %>
    <%@ page import="java.sql.Date" %>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="model.dao.AppointmentDAO" %>
    <%@ page import="model.dao.DepartmentDAO" %>


    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Bệnh Nhân</title>
    <style>
        /* Các trang của patient cần có css của main, header và content wrapper*/
        .main {
            flex-grow: 1;
            display: flex;
            flex-direction: column; 
            min-height: 100vh;    
        }

        .header {
            background-color: #40855e;
            color: white;
            padding: 15px 20px;
            margin-bottom: 35px; 
            border-radius: 5px;
            display: flex;
            justify-content: center;
        }
        
        .content-wrapper {
            flex: 1;                
            padding: 20px;
            box-sizing: border-box;
        }

        /* Table*/
        table {
            width: 90%;                
            margin: 50px auto;          
            border-collapse: collapse;
            table-layout: auto;         
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        /* Ô dữ liệu và tiêu đề */
        th, td {
            padding: 10px 15px;
            text-align: center;
            border: 1px solid #ccc;
            white-space: nowrap;       
        }

        /* Dòng tiêu đề */
        th {
            background-color: #2c693b;
            color: white;
            font-weight: 600;
        }

        /* Màu xen kẽ và hiệu ứng hover */
        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tbody tr:hover {
            background-color: #eaf2ec;
            transition: background-color 0.2s;
        }

        /* Nút Xem chi tiết */
        .btn-detail {
            padding: 6px 12px;
            background-color: #706e6e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-detail:hover {
            background-color: #929292;
        }

        .filter {
            width: 90%;     
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin: 25px auto -20px auto;         
        }
        .filter input, .filter button {
            padding: 8px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .filter button {
            background-color: #2c693b;
            color: white;
            border: none;
            cursor: pointer;
        }
        .filter button:hover {
            background-color: #569571;
        }
        
        .filter select {
            padding: 5px 30px 5px 10px;
            appearance: none; 
            -webkit-appearance: none;
            -moz-appearance: none;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 10 10"><polygon points="0,0 10,0 5,5" fill="black"/></svg>') no-repeat right 10px center;
            background-size: 10px 10px;
        }
        
        .btn-nearest {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
            background: linear-gradient(135deg, #40855e, #569571);
            color: white;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: background 0.3s, transform 0.2s;
        }

        .btn-nearest:hover {
            background: linear-gradient(135deg, #2c693b, #40855e);
            transform: translateY(-2px);
        }

    </style>
</head>
<body>

    <jsp:include page="patient_navbar.jsp"/>
    
    <%
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    %>
        
    <!-- Main content -->
    <div class="main">
        <!-- Header -->
        <div class="content-wrapper">
            <div class="header">
                <h1>Danh sách lịch hẹn</h1>
            </div>
            
            <div style="width: 90%; margin: 10px auto; display: flex; justify-content: flex-end;">
                <a href="<%= request.getContextPath() %>/patient_dashboard?action=nearest" 
                class="btn-nearest">
                 <!-- Icon lịch SVG -->
                 <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" viewBox="0 0 16 16" style="margin-right:5px;">
                     <path d="M3 0h1v2H3V0zm9 0h1v2h-1V0zM1 3h14v12H1V3zm1 1v10h12V4H2zM4 6h2v2H4V6zm0 3h2v2H4V9zm3-3h2v2H7V6zm0 3h2v2H7V9z"/>
                 </svg>
                 Xem lịch hẹn gần nhất
             </a>
            </div>


            <!-- Filter/Search -->
            <form action="<%= request.getContextPath() %>/patient_dashboard" method="post" class="filter">
                <input type="hidden" name="action" value="list">

                <select name="departmentId">
                    <option value="">--Chọn chuyên khoa--</option>
                    <% 
                        List<Department> departments = (List<Department>) request.getAttribute("departments");
                        String selectedDept = (String) request.getAttribute("selectedDepartmentId");
                        for (Department dept : departments) {
                            String isSelected = String.valueOf(dept.getDepartmentID()).equals(selectedDept) ? "selected" : "";
                    %>
                        <option value="<%= dept.getDepartmentID() %>" <%= isSelected %> ><%= dept.getDepartmentName() %></option>
                    <% } %>
                </select>
                    
                 <!-- Dùng nếu muốn giữ value của lịch value="<%= request.getAttribute("selectedDate") != null ? request.getAttribute("selectedDate") : "" %>"-->
                <input type="date" name="appointmentDate"> 
                <select name="appointmentShift">
                    <option value="">--Chọn ca--</option>
                    <option value="morning" <%= "morning".equals(request.getAttribute("selectedShift")) ? "selected" : "" %> >Sáng</option>
                    <option value="afternoon" <%= "afternoon".equals(request.getAttribute("selectedShift")) ? "selected" : "" %> >Chiều</option>
                </select>

                <button type="submit">Tìm kiếm</button>

 
                <a href="#"
                   style="padding: 8px 12px; background-color:#2c693b; color:white; border-radius:4px; 
                          text-decoration:none; display:flex; align-items:center; gap:5px; margin-left:auto;">
                    <!-- SVG icon + -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" viewBox="0 0 16 16">
                        <path d="M8 1v14M1 8h14" stroke="white" stroke-width="2"/>
                    </svg>
                    Đặt Lịch Hẹn
                </a>

            </form>



            <!-- Table danh sách lịch hẹn -->
            <%
                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                if (appointments == null || appointments.isEmpty()) {

            %>
                <div style="text-align: center; margin-top: 100px; white-space: nowrap;">
                    Không có lịch hẹn nào được tìm thấy! 
                    <a href="#" style="color: #2c693b; font-weight: 600; text-decoration: underline; display: inline;">
                        Hãy đặt lịch ngay hôm nay?
                    </a>
                </div>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th style="text-align: left;">Tên bệnh nhân</th>
                            <th style="text-align: left;">Tên bác sĩ</th>
                            <th style="text-align: left;">Khoa khám</th>
                            <th>Ngày</th>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Appointment appt : appointments) { %>
                        <tr>
                            <td><%= appt.getAppointmentId() %></td>
                            <td style="text-align: left;"><%= appt.getPatientName() %></td>
                            <td style="text-align: left;"><%= appt.getDoctorName() %></td>
                            <td style="text-align: left;"><%= appt.getDepartmentName() %></td>
                            <td><%= dateFormat.format(appt.getAppointmentDate()) %></td>
                            <td><%= timeFormat.format(appt.getAppointmentDate()) %></td>
                            <td><%= appt.getStatus() %></td>
                            <td><button class="btn-detail">Xem</button></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
        <jsp:include page="patient_footer.jsp" />
    </div>
    
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

</script>
