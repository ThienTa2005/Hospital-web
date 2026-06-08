<%@page import="model.entity.ShiftDoctor"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bác sĩ đang trực</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
</head>
<body>

<%
    request.setAttribute("currentPage", "working_doctors");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<main class="container mt-4">
    <div class="title-box mb-3">
        <h3>DANH SÁCH BÁC SĨ ĐANG TRỰC HIỆN TẠI</h3>
    </div>

<%
    List<ShiftDoctor> doctorsOnShiftNow = (List<ShiftDoctor>) request.getAttribute("doctorsOnShiftNow");
%>

    <table class="table-1">
        <tr>
            <th>STT</th>
            <th>Bác sĩ</th>
            <th>Khoa</th>
        </tr>
<%
    if (doctorsOnShiftNow != null && !doctorsOnShiftNow.isEmpty()) {
        int stt = 1;
        for (ShiftDoctor sd : doctorsOnShiftNow) {
%>
        <tr>
            <td><%= stt++ %></td>
            <td><%= sd.getDoctorName() %></td>
            <td><%= sd.getDepartmentName() %></td>
        </tr>
<%
        }
    } else {
%>
        <tr>
            <td colspan="3" class="text-muted fst-italic">Hiện không có bác sĩ nào đang trực.</td>
        </tr>
<%
    }
%>
    </tbody>
</table>

</main>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
