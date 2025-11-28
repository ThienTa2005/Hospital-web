<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.entity.Appointment"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch hẹn đang diễn ra</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

</head>

<body>
<%
    request.setAttribute("currentPage", "visiting_patients");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<main class="main-content container mt-4">
    <div class="title-box"><h3>DANH SÁCH LỊCH HẸN HÔM NAY</h3></div>

    <table class="table-1">
        <tr>
            <th>STT</th>
            <th>Bác sĩ</th>
            <th>Khoa</th>
            <th>Bệnh nhân</th>
            <th>Ngày hẹn</th>
            <th>Giờ bắt đầu</th>
            <th>Giờ kết thúc</th>
            <th>Trạng thái</th>
        </tr>

<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
    int stt = 1;

    if (appointments != null && !appointments.isEmpty()) {
        for (Appointment a : appointments) {
%>
        <tr>
            <td><%= stt++ %></td>
            <td><%= a.getDoctorName() %></td>
            <td><%= a.getDepartmentName() %></td>
            <td><%= a.getPatientName() %></td>
            <td><%= a.getShiftDate() != null ? sdfDate.format(a.getShiftDate()) : "" %></td>
            <td><%= a.getStartTime() != null ? sdfTime.format(a.getStartTime()) : "" %></td>
            <td><%= a.getEndTime() != null ? sdfTime.format(a.getEndTime()) : "" %></td>
            <td><%= a.getStatus() %></td>
        </tr>
<%
        }
    } else {
%>
        <tr>
            <td colspan="8" style="text-align:center; font-size: 1rem;">Không có lịch hẹn đang diễn ra</td>
        </tr>
<%
    }
%>
    </table>
</main>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
