<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.User"%>
<%@page import="model.entity.Patient"%>
<%@page import="model.entity.Shift"%>
<%@page import="model.dao.DoctorDAO"%>
<%@page import="model.dao.AppointmentDAO"%>
<%@page import="model.entity.Appointment"%>
<%@page import="model.entity.Department"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Trang chủ</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    
    <style>
        :root {
            --primary: #40855E;
            --primary-dark: #2c6e49;
            --accent: #FFC107;
            --bg-light: #F3F6F8;
        }
        body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }
       

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

        .btn-detail {
            padding: 5px 8px;               
            background-color: #6c757d;       /* xám vừa phải */
            color: white;
            border: none;
            border-radius: 8px;              
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);  
            transition: background-color 0.3s;
        }

        .btn-detail:hover {
            background-color: #5a6268;       /* xám đậm hơn khi hover */
        }


        .filter {
            width: 90%;     
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin: 35px auto -30px auto;         
        }
        .filter input, .filter button {
            padding: 8px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        
        .filter select {
            padding: 5px 30px 5px 10px;
            appearance: none; 
            -webkit-appearance: none;
            -moz-appearance: none;
            background-color: white !important;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 10 10"><polygon points="0,0 10,0 5,5" fill="black"/></svg>') no-repeat right 10px center;
            background-size: 10px 10px;
        }
        
        .btn-nearest {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
            background: linear-gradient(135deg, #2c693b, #40855e);
            color: white;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: background 0.3s, transform 0.2s;
        }

        .btn-nearest:hover {
            background: linear-gradient(135deg, #40855e, #569571);
            transform: translateY(-2px);
        }
        
        .title-box {
            background-color: #f8fff9;
            border: 2px solid #3d7b47;
            border-radius: 12px;
            padding: 10px 20px;
            text-align: center;
            margin: 20px auto 10px auto;
            width: fit-content;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        title-box h3 {
            margin: 0;
            color: #2d6a3e;
            font-weight: 700;
            font-size: 1.8rem;
            letter-spacing: 1px;
        }
        
        .status-cancelled,
        .status-pending,
        .status-completed {
            display: inline-block;       /* cho padding + bo góc */
            padding: 2px 3px;
            border-radius: 12px;
            font-weight: 600;
            min-width: 80px;             /* chiều rộng tối thiểu */
            text-align: center;          /* căn chữ giữa span */
            box-sizing: border-box;
        }

        /* Màu theo trạng thái */
        .status-cancelled {
            color: #c00;
            background-color: #fdd;
            border: 1px solid #c00;
        }

        .status-pending {
            color: #e65c00;
            background-color: #ffe6cc;
            border: 1px solid #e65c00;
        }

        .status-completed {
            color: #007a00;
            background-color: #ccffcc;
            border: 1px solid #007a00;
        }

        .btn-nearest.no-move:hover {
            background: linear-gradient(135deg, #40855e, #569571);
            transform: none;
        }


    </style>
</head>
<body>
    <jsp:include page="/views/shared/patient_header.jsp" />

    
    <%
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    %>
        
    <!-- Main content -->
    <main class="main-content">
        <!-- Header -->
        <div class="title-box">
            <h3>Danh sách lịch hẹn</h3>
        </div>


        <!-- Filter/Search -->
        <form action="<%= request.getContextPath() %>/appointment" method="post" class="filter">
            <input type="hidden" name="action" value="filter">

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

            <button class="btn-nearest no-move" type="submit">Tìm kiếm</button>



            <a href="#" class="btn-nearest" style="gap:5px; margin-left:auto;">
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
                        <td style="text-align:center;">
                            <span class="status-<%= appt.getStatus().toLowerCase() %>">
                                <%= appt.getStatus() %>
                            </span>
                        </td>
                        <td><button class="btn-detail">Xem</button></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <%
            }
        %>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>