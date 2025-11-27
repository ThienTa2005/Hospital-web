<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>

        body { 
            background-color: #F3F6F8; 
            font-family: 'Segoe UI', sans-serif; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
        }
        .main { 
            flex: 1; 
            width: 100%; 
            max-width: 600px; 
            margin: 0 auto; 
            padding-bottom: 30px; 
        }
        .content-wrapper { padding: 40px 20px; }


        .password-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        
        .card-title {
            color: #40855E;
            font-weight: 700;
            text-align: center;
            margin-bottom: 25px;
            text-transform: uppercase;
        }

        .form-label { font-weight: 600; color: #555; }
        
        .form-control:focus {
            border-color: #40855E;
            box-shadow: 0 0 0 0.25rem rgba(64, 133, 94, 0.25);
        }

        .btn-submit {
            background-color: #40855E;
            color: white;
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
        }
        .btn-submit:hover { background-color: #2c6e49; transform: translateY(-2px); color: white; }
        
        .input-group-text { cursor: pointer; background: white; border-left: none; }
        .form-control { border-right: none; }
        .input-group:focus-within .input-group-text { border-color: #40855E; }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp"/>

    <div class="main">
        <div class="content-wrapper">
            <div class="password-card">
                <h3 class="card-title"><i class="fa-solid fa-lock me-2"></i>Đổi Mật Khẩu</h3>

                <%
                    String msg = (String) request.getAttribute("msg");
                    String error = (String) request.getAttribute("error");
                %>
                
                <% if (msg != null) { %>
                    <div class="alert alert-success text-center shadow-sm"><i class="fa-solid fa-check-circle"></i> <%= msg %></div>
                <% } %>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger text-center shadow-sm"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/change-password" method="post">
                    
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <div class="input-group">
                            <input type="password" name="oldPass" id="oldPass" class="form-control" required>
                            <span class="input-group-text" onclick="togglePass('oldPass', this)"><i class="fa-solid fa-eye"></i></span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <div class="input-group">
                            <input type="password" name="newPass" id="newPass" class="form-control" required>
                            <span class="input-group-text" onclick="togglePass('newPass', this)"><i class="fa-solid fa-eye"></i></span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Nhập lại mật khẩu mới</label>
                        <div class="input-group">
                            <input type="password" name="confirmPass" id="confirmPass" class="form-control" required>
                            <span class="input-group-text" onclick="togglePass('confirmPass', this)"><i class="fa-solid fa-eye"></i></span>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">Xác nhận thay đổi</button>
                    
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/patient_dashboard" class="text-decoration-none text-secondary">Quay lại trang chủ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    
    <script>
        function togglePass(fieldId, iconSpan) {
            const input = document.getElementById(fieldId);
            const icon = iconSpan.querySelector('i');
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = "password";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>