<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Login Form</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<%
    request.setAttribute("currentPage", "login");
%>
<%@ include file="header.jsp" %>

<div id="wrapper">
    <div id="content">
        <div id="bg-login">
            <form id="form-login">
                <h1 class="form-heading">Đăng nhập</h1>
                <div class="form-group">
                    <input type="text" class="form-input" placeholder="Tên đăng nhập">
                </div>
                <div class="form-group">
                    <input type="password" class="form-input" placeholder="Mật khẩu">
                </div>
                <input type="submit" value="Đăng nhập" class="form-submit">
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
