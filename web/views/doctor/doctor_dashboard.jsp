<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Doctor</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
  <section id="header">
    <div class="container d-flex justify-content-between align-items-center" >
        <!-- Logo + Tên phòng khám -->
<!--        <div class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo">
            Quản lý phòng khám
        </div>-->

        <div class="header-logo">
            <a href="${pageContext.request.contextPath}/admin/user?action=list" 
               style="text-decoration: none; color: inherit;">
                Quản lý phòng khám
            </a>
        </div>


        <!-- Menu điều hướng -->
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/admin/user" class="active">Người dùng</a>
            <a href="#">Ca trực</a>
            <a href="#">Hồ sơ bác sĩ</a>
            <a href="#">Hồ sơ bệnh nhân</a>
        </div>

        <!-- Đăng xuất -->
        <form action="${pageContext.request.contextPath}/logout" method="get" >
            <button class="btn logout-btn">Đăng xuất</button>
        </form>
    </div>
</section>
    <body> 
        
    </body>
</head>