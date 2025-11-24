<%@page import="model.entity.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section id="header">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <div class="container d-flex justify-content-between align-items-center" >

        <div class="header-logo">
            <a href="${pageContext.request.contextPath}/views/patient/patient_dashboard.jsp"
               style="text-decoration: none; color: inherit;">
                Trang chủ
            </a>
        </div>


        <!-- Menu điều hướng -->
       

<!--         Đăng xuất 
        <form action="${pageContext.request.contextPath}/logout" method="get" >
            <button class="btn logout-btn">Đăng xuất</button>
        </form>-->

        <div class="dropdown">
            <% User u = (User) session.getAttribute("user"); %>
            <button class="btn logout-btn" data-bs-toggle="dropdown" aria-expanded="false"> 
                <i class="fa-solid fa-user" style="margin-right: 5px; margin-left: 2px;"></i> <%= u.getFullname() %>
            </button>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="#">Hồ sơ</a>
                <li><a class="dropdown-item" href="#">Đặt lịch hẹn</a>
                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/appointment">Lịch sử khám bệnh</a>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </ul>
        </div>
    </div>
</section>