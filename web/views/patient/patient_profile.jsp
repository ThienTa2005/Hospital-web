<%@page contentType="text/html" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<%@page import="model.entity.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
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
            max-width: 1100px; 
            margin: 0 auto; 
            padding-bottom: 30px; 
        }
        .content-wrapper { padding: 30px 20px; }


        .profile-header-card { background: white; border-radius: 15px; padding: 30px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05); height: 100%; }
        .avatar-circle { width: 120px; height: 120px; background-color: #e9f6ec; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px auto; color: #40855E; font-size: 3.5rem; border: 4px solid #fff; box-shadow: 0 5px 15px rgba(64, 133, 94, 0.15); }
        .profile-form-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .btn-save { background-color: #40855E; color: white; padding: 10px 30px; border-radius: 8px; border: none; font-weight: 600; transition: 0.3s; }
        .btn-save:hover { background-color: #2c6e49; transform: translateY(-2px); color: white; }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp"/>

    <div class="main">
        <div class="content-wrapper">
            <% User user = (User) session.getAttribute("user");
               String msg = request.getParameter("msg"); %>
            <% if ("updated".equals(msg)) { %><div class="alert alert-success alert-dismissible fade show">Cập nhật thành công!</div><% } %>

            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="profile-header-card">
                        <div class="avatar-circle"><i class="fa-solid fa-user"></i></div>
                        <h4 class="fw-bold mb-1"><%= user.getFullname() %></h4>
                        <p class="text-muted mb-3">@<%= user.getUsername() %></p>
                        <div class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill mb-4">Bệnh nhân</div>
                        <hr>
                        <div class="text-muted"><i class="fa-solid fa-phone me-2"></i> <%= user.getPhonenum() %></div>
                        <div class="text-muted mt-2"><i class="fa-solid fa-location-dot me-2"></i> <%= user.getAddress() %></div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="profile-form-card">
                        <h5 class="mb-4 pb-2 border-bottom" style="color: #40855E; font-weight: 700;">Thông tin chi tiết</h5>
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="row g-3">
                                <div class="col-md-6"><label class="form-label fw-bold">Họ và tên</label><input type="text" class="form-control bg-light" value="<%= user.getFullname() %>" readonly></div>
                                <div class="col-md-6"><label class="form-label fw-bold">Tên đăng nhập</label><input type="text" class="form-control bg-light" value="<%= user.getUsername() %>" readonly></div>
                                <div class="col-md-6"><label class="form-label fw-bold">Số điện thoại</label><input type="text" name="phonenum" class="form-control" value="<%= user.getPhonenum() %>" required></div>
                                <div class="col-md-6"><label class="form-label fw-bold">Địa chỉ</label><input type="text" name="address" class="form-control" value="<%= user.getAddress() %>" required></div>
                            </div>
                            <div class="mt-4 text-end"><button type="submit" class="btn btn-save">Lưu thay đổi</button></div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>