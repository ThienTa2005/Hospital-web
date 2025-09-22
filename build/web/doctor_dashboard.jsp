<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Doctor Page</title>
  <link rel="stylesheet" href="style.css">
</head>

<body>
<%@ include file="header.jsp" %>
  <ul id="menubar">
    <li><a href="#">Lịch hẹn</a></li>
    <li><a href="#">Hồ sơ bệnh án</a></li>
    <li><a href="#">Đơn thuốc</a></li>
    <li><a href="#">Lịch sử khám</a></li>
    <li><a href="#">Danh sách ca trực</a></li>
  </ul>

<section id="bg-home">
    <h1>Hẹn khám với các chuyên gia có chuyên môn và uy tín hàng đầu</h1>
    <a href="login.jsp"><button>Đặt lịch ngay!</button></a>
</section>


<%@ include file="footer.jsp" %>
</body>
</html>
