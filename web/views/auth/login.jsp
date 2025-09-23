<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Login Form</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body>
<%
    request.setAttribute("currentPage", "login");
%>
<jsp:include page="/views/shared/header.jsp" />

<div id="wrapper">
    <div id="content">
        <div id="bg-login">
            <form id="form-login" action="login" method="post">
                <h1 class="form-heading">Đăng nhập</h1>
                <div class="form-group">
                    <input type="text" name="username" class="form-input" placeholder="Tên đăng nhập" required>
                </div>
                <div class="form-group">
                    <input type="password" name="password" class="form-input" placeholder="Mật khẩu" required>
                </div>
                <input type="submit" value="Đăng nhập" class="form-submit">
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/shared/footer.jsp" />
</body>
</html>