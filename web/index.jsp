<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Homepage</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body>
<%
    request.setAttribute("currentPage", "index");
%>
<jsp:include page="/views/shared/header.jsp" />

<section id="bg-home">
    <h1>Hẹn khám với các chuyên gia có chuyên môn và uy tín hàng đầu</h1>
    <a href="views/auth/login.jsp"><button>Đặt lịch ngay!</button></a>
</section>

<jsp:include page="/views/shared/footer.jsp" />
</body>
</html>
