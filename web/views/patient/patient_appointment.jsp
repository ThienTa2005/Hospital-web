<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Appointment"%>
<%@page import="model.entity.Department"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Danh sách lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        :root { --primary: #40855E; --bg-light: #F3F6F8; }
        
        /* --- FIX LỖI FOOTER KHÔNG DÍNH ĐÁY --- */
        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', sans-serif;
            /* Sử dụng Flex column để đẩy footer xuống */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .main-content {
            /* flex: 1 sẽ chiếm toàn bộ khoảng trống còn lại, đẩy footer xuống cuối */
            flex: 1;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        /* ------------------------------------- */

        table { width: 100%; margin: 30px auto; border-collapse: collapse; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        th, td { padding: 12px 15px; text-align: center; border-bottom: 1px solid #eee; white-space: nowrap; }
        th { background-color: var(--primary); color: white; font-weight: 600; text-transform: uppercase; font-size: 0.9rem; }
        tbody tr:hover { background-color: #f1f8f4; }
        .btn-detail { padding: 6px 12px; background-color: #6c757d; color: white; border: none; border-radius: 6px; text-decoration: none; font-size: 0.85rem; transition: 0.3s; }
        .btn-detail:hover { background-color: #5a6268; color: white; }
        .status-cancelled { color: #dc3545; background-color: #fadbd8; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .status-pending { color: #fd7e14; background-color: #ffe0b2; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .status-completed { color: #198754; background-color: #d1e7dd; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .filter { display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 20px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); align-items: center; }
        .filter select, .filter input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; outline: none; }
        .btn-search { background-color: var(--primary); color: white; border: none; padding: 8px 20px; border-radius: 6px; font-weight: 600; }
        .title-box { text-align: center; margin-bottom: 30px; margin-top: 20px; }
        .title-box h3 { color: var(--primary); font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }
        .btn-add { background: linear-gradient(135deg, #2c693b, #40855e); color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; margin-left: auto; display: flex; align-items: center; gap: 5px; font-weight: 600; }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp" />

    <%
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    %>

    <main class="main-content">
        <div class="title-box"><h3>Danh sách lịch hẹn</h3></div>

        <form action="<%= request.getContextPath()%>/appointment" method="post" class="filter">
            <input type="hidden" name="action" value="filter">
            <select name="departmentId">
                <option value="">-- Tất cả chuyên khoa --</option>
                <%
                    List<Department> departments = (List<Department>) request.getAttribute("departments");
                    String selectedDept = (String) request.getAttribute("selectedDepartmentId");
                    if (departments != null) {
                        for (Department dept : departments) {
                            String isSelected = String.valueOf(dept.getDepartmentID()).equals(selectedDept) ? "selected" : "";
                %>
                    <option value="<%= dept.getDepartmentID()%>" <%= isSelected%> ><%= dept.getDepartmentName()%></option>
                <%      }
                    } %>
            </select>
            <input type="date" name="appointmentDate" value="<%= request.getAttribute("selectedDate") != null ? request.getAttribute("selectedDate") : ""%>">
            <select name="appointmentShift">
                <option value="">-- Tất cả ca --</option>
                <option value="morning" <%= "morning".equals(request.getAttribute("selectedShift")) ? "selected" : ""%> >Sáng</option>
                <option value="afternoon" <%= "afternoon".equals(request.getAttribute("selectedShift")) ? "selected" : ""%> >Chiều</option>
            </select>
            <button class="btn-search" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
            <a href="<%= request.getContextPath()%>/book-appointment" class="btn-add"><i class="fa-solid fa-plus"></i> Đặt Lịch Mới</a>
        </form>

        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
           if (appointments == null || appointments.isEmpty()) { %>
            <div style="text-align: center; margin-top: 50px; color: #777;">
                <p>Không tìm thấy lịch hẹn nào.</p>
                <a href="<%= request.getContextPath()%>/book-appointment" style="color: #40855E; font-weight: 600;">Đặt lịch ngay?</a>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Mã</th>
                        <th style="text-align: left;">Bệnh nhân</th>
                        <th style="text-align: left;">Bác sĩ</th>
                        <th style="text-align: left;">Khoa</th>
                        <th>Ngày</th>
                        <th>Giờ</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Appointment appt : appointments) {%>
                    <tr>
                        <td>#<%= appt.getAppointmentId()%></td>
                        <td style="text-align: left;"><%= appt.getPatientName()%></td>
                        <td style="text-align: left;"><%= appt.getDoctorName()%></td>
                        <td style="text-align: left;"><%= appt.getDepartmentName()%></td>
                        <td><%= dateFormat.format(appt.getAppointmentDate())%></td>
                        <td><%= timeFormat.format(appt.getAppointmentDate())%></td>
                        <td><span class="status-<%= appt.getStatus().toLowerCase()%>"><%= appt.getStatus()%></span></td>
                        <td>
                            <% if ("completed".equalsIgnoreCase(appt.getStatus())) {%>
                                <a href="<%= request.getContextPath()%>/record?appointment_id=<%= appt.getAppointmentId()%>" class="btn-detail"><i class="fa-solid fa-file-medical"></i> Xem hồ sơ</a>
                            <% } else if ("pending".equalsIgnoreCase(appt.getStatus())) { %>
                                <a href="<%= request.getContextPath()%>/appointment?action=cancel&id=<%= appt.getAppointmentId()%>" class="text-danger" style="text-decoration: none; font-size: 0.9rem;" onclick="return confirm('Hủy lịch này?')">Hủy</a>
                            <% } else { %> -- <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </main>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>