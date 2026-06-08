<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Đăng ký</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
  
  <style>
      /* Đặt ở cuối file CSS hoặc dưới cùng trong <style> */
        .is-invalid {
          border: 1px solid red !important;      /* Giữ viền đỏ */
          padding-right: 0 !important;           /* Reset padding */
          background-image: none !important;     /* Xóa icon */
          background-position: initial !important;
          background-size: initial !important;
        }

  </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "register");
%>
<jsp:include page="/views/shared/header.jsp" />

<div id="wrapper">
    <div id="content">
        <div id="bg-register">   
            <form id="form-register" action="${pageContext.request.contextPath}/register" method="post">
<!--                <input type="hidden" name="action" value="register">-->
                <h1 class="form-heading">Đăng ký</h1>

                <!-- Container 2 section -->
                <div class="form-sections">
                    <!-- Section 1: Tài khoản -->
                    <div class="form-section">
                        <h3 class="section-heading">Tài khoản</h3>
                        <div class="form-group">
                            <input type="text" id="username" class="form-input" name="username" placeholder="Tên đăng nhập" required>
                            <% if (request.getAttribute("errorMessage") != null) { %>
                                <small id="usernameError" class="text-danger"><%= request.getAttribute("errorMessage") %></small>
                            <% } %>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-input" id="password" name="password" placeholder="Mật khẩu" required>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-input" id="confirm_password" name="confirm_password" placeholder="Nhập lại mật khẩu" required>
                            <small id="passwordError" class="text-danger"></small>
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
<!--                    <input type="submit" value="Đăng ký" class="form-submit">-->
                        <button type="submit" class="form-submit">Đăng ký</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Kiem tra mat khau -->
<script>
  const form = document.getElementById("form-register");
  const password = document.getElementById("password");
  const confirmPassword = document.getElementById("confirm_password");
  const errorMsg = document.getElementById("passwordError");

  // Kiem tra
  form.addEventListener("submit", function (e) {
    if (password.value.trim() !== confirmPassword.value.trim()) {
      e.preventDefault(); // Chặn submit
      errorMsg.textContent = "⚠️ Mật khẩu nhập lại không khớp!";
      confirmPassword.classList.add("is-invalid"); // Thêm border đỏ Bootstrap
    } else {
      errorMsg.textContent = "";
      confirmPassword.classList.remove("is-invalid");
    }
  });

  // Xoa loi khi go lai
  confirmPassword.addEventListener("input", function () {
    if (password.value.trim() === confirmPassword.value.trim()) {
      errorMsg.textContent = "";
      confirmPassword.classList.remove("is-invalid");
    }
  });
</script>

<!-- Kiem tra ten dang nhap -->
<script>
  const usernameInput = document.getElementById("username");
  const usernameError = document.getElementById("usernameError");

  usernameInput.addEventListener("input", function () {
    if (usernameError.textContent.trim() !== "") {
      usernameError.textContent = "";           
      usernameInput.classList.remove("is-invalid"); 
    }
  });
</script>

<jsp:include page="/views/shared/footer.jsp" />
</body>
</html>