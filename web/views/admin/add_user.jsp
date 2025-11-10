<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.dao.DepartmentDAO" %>
<%@ page import="model.entity.Department" %>
<%@ page import="java.util.List" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm người dùng</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    
    <style>
        body {
            background-color: #f4f7f6;
        }

        .card {
            border-radius: 10px;
        }
        
        .card-header {
            background: -webkit-linear-gradient(20deg, #5FBF76, #1E5631);
        }

        .card-header h4 {
            font-weight: bold;
        }
        
        h4 {
            margin-top: 10px;
        }

        .col-form-label {
            font-weight: 500;
        }

        .btn {
            font-weight: bold;
/*            padding: 8px 16px;*/
        }
        
        .container mt-5 {
            font-size: 1rem;
        }
        
        body.custom-page #header {
            margin-bottom: 10px !important;
        }
        
        .toast-container {
            top: 65px !important;    
            z-index: 1055;           
        }

    </style>
</head>

<body class="custom-page">
    <%
        request.setAttribute("currentPage", "user");
    %>
    <jsp:include page="/views/shared/user_header.jsp" />
  
<!--    <div class="user"><h1> THÊM NGƯỜI DÙNG </h1></div>-->

<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                 Thêm người dùng thành công!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<div class="container mt-5" style="padding-top: 0px;">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Card -->
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-header text-white text-center rounded-top-4">
                    <h4>Thêm người dùng</h4>
                </div>
                <div class="card-body">
                    <form id="addForm" action="${pageContext.request.contextPath}/admin/user?action=add" method="post" accept-charset="UTF-8">
                        
                        <!-- Tên đăng nhập -->
                        <div class="row mb-3 align-items-center">
                            <label for="username" class="col-sm-3 col-form-label">Tên đăng nhập</label>
                            <div class="col-sm-9">
                                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required>
                                <% if (request.getAttribute("errorMessage") != null) { %>
                                 <small id="usernameError" class="text-danger"><%= request.getAttribute("errorMessage") %></small>
                                 <% } %>

                            </div>
                        </div>

                        <!-- Mật khẩu -->
                        <div class="row mb-3 align-items-center">
                            <label for="password" class="col-sm-3 col-form-label">Mật khẩu</label>
                            <div class="col-sm-9">
                                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                            </div>
                        </div>

                        <!-- Nhập lại mật khẩu -->
                        <div class="row mb-3 align-items-center">
                            <label for="confirmPassword" class="col-sm-3 col-form-label">Nhập lại mật khẩu</label>
                            <div class="col-sm-9">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
                                <small id="passwordError" class="text-danger"></small>
                            </div>
                        </div>

                        <!-- Ho va ten -->
                        <div class="row mb-3 align-items-center">
                            <label for="fullname" class="col-sm-3 col-form-label">Họ và tên</label>
                            <div class="col-sm-9">
                                <input type="text" id="fullname" name="fullname" class="form-control" placeholder="Nhập họ và tên" required>
                            </div>
                        </div>
                        
                        <!-- Ngày sinh -->
                        <div class="row mb-3 align-items-center">
                            <label for="dob" class="col-sm-3 col-form-label">Ngày sinh</label>
                            <div class="col-sm-9">
                                <input type="date" id="dob" name="dob" class="form-control" required>
                            </div>
                        </div>

                        <!-- Giới tính -->
                        <div class="row mb-3 align-items-center">
                            <label class="col-sm-3 col-form-label">Giới tính</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <div class="form-check me-3">
                                    <input class="form-check-input" type="radio" name="gender" id="male" value="M" required>
                                    <label class="form-check-label" for="male">Nam</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="gender" id="female" value="F" required>
                                    <label class="form-check-label" for="female">Nữ</label>
                                </div>
                            </div>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="row mb-3 align-items-center">
                            <label for="phone" class="col-sm-3 col-form-label">Số điện thoại</label>
                            <div class="col-sm-9">
                                <input type="tel" id="phone" name="phone" class="form-control" placeholder="Nhập số điện thoại" pattern="[0-9]{10}" required>
                                <div class="form-text">Nhập đúng định dạng 10 chữ số</div>
                            </div>
                        </div>
                        
                        <!-- Dia chi -->
                         <div class="row mb-3 align-items-center">
                            <label for="address" class="col-sm-3 col-form-label">Địa chỉ</label>
                            <div class="col-sm-9">
                                <input type="text" id="address" name="address" class="form-control" placeholder="Nhập địa chỉ" required>
                            </div>
                        </div>

                        <!-- Vai trò -->
                        <div class="row mb-3 align-items-center">
                            <label for="role" class="col-sm-3 col-form-label">Vai trò</label>
                            <div class="col-sm-9">
                                <select id="role" name="role" class="form-select" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="admin">Admin</option>
                                    <option value="doctor">Bác sĩ</option>
                                    <option value="patient">Bệnh nhân</option>
                                </select>
                            </div>
                            
                            <!--BO SUNG THONG TIN BAC SI-->
                            
                            <div id="doctorFields" style="display: none; background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px; margin-bottom: 15px;">
                                <h6 class="text-success mb-3 border-bottom pb-2">Thông tin bổ sung (Dành cho Bác sĩ)</h6>

                                <div class="row mb-3 align-items-center">
                                    <label for="degree" class="col-sm-3 col-form-label">Bằng cấp</label>
                                    <div class="col-sm-9">
                                        <input type="text" id="degree" name="degree" class="form-control" placeholder="Vd: Thạc sĩ, Bác sĩ CKI">
                                    </div>
                                </div>

                               <div class="row mb-3 align-items-center">
                                    <label for="departmentId" class="col-sm-3 col-form-label">Chuyên khoa</label>
                                    <div class="col-sm-9">
                                        <select id="departmentId" name="departmentId" class="form-select">
                                            <option value="">-- Chọn chuyên khoa --</option>
                                            <% 
                                                // Gọi DAO để lấy danh sách khoa ngay tại đây
                                                DepartmentDAO deptDAO = new DepartmentDAO();
                                                List<Department> departments = deptDAO.getAllDepartments();

                                                if (departments != null) {
                                                    for (Department d : departments) {
                                            %>
                                                <option value="<%= d.getDepartmentID() %>">
                                                    <%= d.getDepartmentName() %>
                                                </option>
                                            <% 
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between" style="margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/admin/user?action=list" class="btn btn-secondary cancel-btn">Hủy</a>
                            <button type="submit" class="btn text-white save-btn" style="background-color: #40855E;">Lưu</button>
                            
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->


<!-- Kiem tra mat khau -->
<script>
  const form = document.getElementById("addForm");
  const password = document.getElementById("password");
  const confirmPassword = document.getElementById("confirmPassword");
  const errorMsg = document.getElementById("passwordError");

  // Kiem tra khi submit
  form.addEventListener("submit", function (e) {
    if (password.value.trim() !== confirmPassword.value.trim()) {
      e.preventDefault(); // Chặn submit
      errorMsg.textContent = " Mật khẩu nhập lại không khớp!";
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

  // Xoa loi khi go
  usernameInput.addEventListener("input", function () {
    if (usernameError.textContent.trim() !== "") {
      usernameError.textContent = "";           
      usernameInput.classList.remove("is-invalid"); 
    }
  });
</script>

<!-- Thong bao thanh cong -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("success") === "true") {
            const toastElement = document.getElementById('successToast');
            const toast = new bootstrap.Toast(toastElement, {
                delay: 3000 // 3 giay
            });
            toast.show();
            
            // Xoa url
            const url = new URL(window.location.href);
            url.searchParams.delete("success");
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }
    });
</script>

<script>
    // an/hiện thông tin bác sĩ
    const roleSelect = document.getElementById("role");
    const doctorFields = document.getElementById("doctorFields");
    const degreeInput = document.getElementById("degree");
    const deptInput = document.getElementById("departmentId");

    roleSelect.addEventListener("change", function() {
        if (this.value === "doctor") {
            doctorFields.style.display = "block";
            degreeInput.setAttribute("required", ""); // Bắt buộc nhập
            deptInput.setAttribute("required", "");
        } else {
            doctorFields.style.display = "none";
            degreeInput.removeAttribute("required");
            deptInput.removeAttribute("required");
            degreeInput.value = ""; // Xóa dữ liệu cũ nếu đổi ý
            deptInput.value = "";
        }
    });
</script>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>