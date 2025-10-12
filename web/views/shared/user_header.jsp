<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <a href="${pageContext.request.contextPath}/admin/user"
                class="${currentPage eq 'user' ? 'active' : ''}">
                Người dùng
            </a>

            <a href="${pageContext.request.contextPath}/admin/shift"
                class="${currentPage eq 'shift' ? 'active' : ''}">
                Ca trực
            </a>

            <a href="${pageContext.request.contextPath}/admin/doctor"
                class="${currentPage eq 'doctor' ? 'active' : ''}">
                Hồ sơ bác sĩ
            </a>

            <a href="${pageContext.request.contextPath}/admin/patient"
                class="${currentPage eq 'patient' ? 'active' : ''}">
                Hồ sơ bệnh nhân
            </a>
        </div>

        <!-- Đăng xuất -->
        <form action="${pageContext.request.contextPath}/logout" method="get" >
            <button class="btn logout-btn">Đăng xuất</button>
        </form>
    </div>
</section>