<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Register</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body>
<%
    request.setAttribute("currentPage", "register");
%>
<jsp:include page="/views/shared/header.jsp" />

<div id="wrapper">
    <div id="content">
        <div id="bg-register">   <%-- giống bg-login nhưng style riêng nếu muốn --%>
            <form id="form-register" action="register" method="post">
                <h1 class="form-heading">Đăng ký</h1>

                <!-- Container 2 section -->
                <div class="form-sections">
                    <!-- Section 1: Tài khoản -->
                    <div class="form-section">
                        <h3 class="section-heading">Tài khoản</h3>
                        <div class="form-group">
                            <input type="text" class="form-input" name="username" placeholder="Tên đăng nhập" required>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-input" name="password" placeholder="Mật khẩu" required>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-input" name="confirm_password" placeholder="Nhập lại mật khẩu" required>
                        </div>
                    </div>

                    <!-- Section 2: Thông tin -->
                    <div class="form-section">
                        <h3 class="section-heading">Thông tin</h3>
                        <div class="form-group">
                            <input type="text" class="form-input" name="fullname" placeholder="Họ và tên" required>
                        </div>
                        <div class="form-group">
                            <label>Giới tính:</label>
                            <label style="margin-left: 20px;">
                                <input type="radio" name="gender" value="M" style="margin-right: 10px;" required>Nam
                            </label>
                            <label style="margin-left: 20px;">
                                <input type="radio" name="gender" value="F" style="margin-right: 10px;" required>Nữ
                            </label>
                        </div>
                        <div class="form-group">
                            <input type="date" class="form-input" name="dob" placeholder="Ngày sinh" required>
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-input" name="address" placeholder="Địa chỉ" required>
                        </div>
                        <div class="form-group">
                            <input type="tel" class="form-input" name="phonenum" placeholder="Số điện thoại" required>
                        </div>
                    </div>
                </div>

                <!-- Submit -->
                <div class="form-group" style="text-align: center;  margin-top: 20px;">
                    <input type="submit" value="Đăng ký" class="form-submit">
                </div>
            </form>
        </div>
    </div>
</div>


<jsp:include page="/views/shared/footer.jsp" />
</body>
</html>