<%@page import="model.entity.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section id="header">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <div class="container d-flex justify-content-between align-items-center" >
        <!-- Logo + Tên phòng khám -->
<!--        <div class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo">
            Quản lý phòng khám
        </div>-->

        <div class="header-logo">
            <a href="${pageContext.request.contextPath}/admin/user?action=list" 
               style="text-decoration: none; color: inherit;">
                Quản lý phòng khám
            </a>
        </div>

        <div class="dropdown">
            <% User u = (User) session.getAttribute("user"); %>
            <button class="btn logout-btn" data-bs-toggle="dropdown" aria-expanded="false"> 
                <i class="fa-solid fa-user" style="margin-right: 5px; margin-left: 2px;"></i> <%= u.getFullname() %>
            </button>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="#">Đổi mật khẩu</a>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </ul>
        </div>
    </div>
</section>