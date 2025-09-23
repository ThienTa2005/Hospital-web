<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin page</title>
    
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
    </style>
</head>

<body>
    <jsp:include page="/views/shared/user_header.jsp" />
  
<!--    <div class="user"><h1> THÊM NGƯỜI DÙNG </h1></div>-->
    
    <body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Card -->
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-header text-white text-center rounded-top-4" style="background-color: #40855E;">
                    <h4>Thêm người dùng</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/UserServlet?action=add" method="post" style="margin-top:10px;">
                        
                        <!-- Tên đăng nhập -->
                        <div class="row mb-3 align-items-center">
                            <label for="username" class="col-sm-3 col-form-label">Tên đăng nhập</label>
                            <div class="col-sm-9">
                                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required>
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
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <button type="submit" class="btn text-white" style="background-color: #40855E;">Lưu</button>
                            <a href="${pageContext.request.contextPath}/admin/user?action=list" class="btn btn-secondary">Hủy</a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Kiểm tra mật khẩu -->
<script>
    document.querySelector("form").addEventListener("submit", function(e) {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        if (password !== confirmPassword) {
            e.preventDefault();
            alert("Mật khẩu nhập lại không khớp!");
        }
    });
</script>



</body>
</html>