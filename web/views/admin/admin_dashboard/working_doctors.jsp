<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.ZoneId"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.dao.ShiftDAO"%>
<%@page import="model.dao.ShiftDoctorDAO"%>
<%@page import="model.entity.Shift"%>
<%@page import="model.entity.ShiftDoctor"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh sách bác sĩ đang trực</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
</head>
<body>

<%
    request.setAttribute("currentPage", "working_doctors");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<main class="main-content">
    <div class="title-box"><h3>DANH SÁCH BÁC SĨ ĐANG TRỰC HIỆN TẠI</h3></div>

    <%
        ShiftDAO shiftDAO = new ShiftDAO();
        ShiftDoctorDAO shiftDoctorDAO = new ShiftDoctorDAO();

        Date now = new Date(System.currentTimeMillis());
        LocalDate currentDate = now.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

        SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
        int stt = 1;

        // Lấy tất cả ca trực hôm nay
        List<Shift> todayShifts = shiftDAO.getShiftsByDate(currentDate);
        for (Shift s : todayShifts) {
        System.out.println("ShiftID=" + s.getShiftId() + 
                       " Date=" + s.getShiftDate() + 
                       " Start=" + s.getStartTime() + 
                       " End=" + s.getEndTime());
}
    %>

 <table class="table-1" border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>STT</th>
        <th>Bác sĩ</th>
        <th>Khoa</th>
        <th>Ca trực</th>
        <th>Ngày trực</th>
        <th>Giờ bắt đầu</th>
        <th>Giờ kết thúc</th>
    </tr>

<%
    for (Shift shift : todayShifts) {
        if (shift.getShiftDate() != null && shift.getStartTime() != null && shift.getEndTime() != null) {
            LocalDate shiftDate = shift.getShiftDate().toLocalDate();
            LocalTime startTime = shift.getStartTime().toLocalTime();
            LocalTime endTime = shift.getEndTime().toLocalTime();
            LocalDateTime startDT = LocalDateTime.of(shiftDate, startTime);
            LocalDateTime endDT = LocalDateTime.of(shiftDate, endTime);
            LocalDateTime nowDT = LocalDateTime.now();

            if (!nowDT.isBefore(startDT) && !nowDT.isAfter(endDT)) {
                List<ShiftDoctor> doctorsInShift = shiftDoctorDAO.getDoctorsByShift(shift.getShiftId());

                if (!doctorsInShift.isEmpty()) {
                    for (ShiftDoctor sd : doctorsInShift) {
%>
                <tr>
                    <td><%= stt++ %></td>
                    <td><%= sd.getDoctorName() %></td>
                    <td><%= sd.getDepartmentName() %></td>
                    <td><%= shift.getShiftId() %></td>
                    <td><%= sdfDate.format(shift.getShiftDate()) %></td>
                    <td><%= sdfTime.format(shift.getStartTime()) %></td>
                    <td><%= sdfTime.format(shift.getEndTime()) %></td>
                </tr>
<%
                    }
                } else {
%>
    <tr>
        <td colspan="7" style="text-align:center; font-size:1rem;">Không có bác sĩ nào đang trực</td>
    </tr>
<%
                }
            }
        }
    }
%>
</table>

</main>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
