<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section id="header">
    <div class="container d-flex justify-content-between align-items-center" >
        <!-- Logo + Tên phòng khám -->
        <div class="header-logo">
<!--            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo">-->
            Quản lý phòng khám
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