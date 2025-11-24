<%@page import="model.entity.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section id="header">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .dropdown-item.active {
            background-color: #e8f5e9 !important; 
            color: #333 !important;                  
        }

        .dropdown-item:hover {
            background-color: #e8f5e9 !important;    
            color: #333 !important;
        }
    </style>
    <div class="container d-flex justify-content-between align-items-center" >
        <!-- Logo + Tên phòng khám -->
<!--        <div class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo">
            Quản lý phòng khám
        </div>-->

        <div class="header-logo">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               style="text-decoration: none; color: inherit;">
                Quản lý phòng khám
            </a>
        </div>


        <!-- Menu điều hướng 
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/admin/user"
                class="${currentPage eq 'user' ? 'active' : ''}">
                Người dùng
            </a>

            <a href="${pageContext.request.contextPath}/admin/shift"
                class="${currentPage eq 'shift' ? 'active' : ''}">
                Ca trực
            </a>               

            <a href="${pageContext.request.contextPath}/admin/department"
                class="${currentPage eq 'doctor' ? 'active' : ''}">
                Phòng ban
            </a>

            <a href="${pageContext.request.contextPath}/admin/patient"
                class="${currentPage eq 'patient' ? 'active' : ''}">
                Hồ sơ bệnh nhân
            </a>
        </div>
        
        <form action="${pageContext.request.contextPath}/logout" method="get" >
            <button class="btn logout-btn">Đăng xuất</button>
        </form>-->

        
        <div class="dropdown">
            <% User u = (User) session.getAttribute("user"); %>
            
            <button class="btn logout-btn" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fa-solid fa-user" style="margin-right: 5px; margin-left: 2px;"></i> 
                <%= u.getFullname() %>
            </button>

            <ul class="dropdown-menu dropdown-menu-end">

                <li>
                    <a class="dropdown-item ${currentPage eq 'dashboard' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/dashboard">
                        Trang chính
                    </a>
                </li>

                <li>
                    <a class="dropdown-item ${currentPage eq 'user' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/user">
                        Người dùng
                    </a>
                </li>

                <li>
                    <a class="dropdown-item ${currentPage eq 'shift' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/shift">
                        Ca trực
                    </a>
                </li>

                <li>
                    <a class="dropdown-item ${currentPage eq 'doctor' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/department">
                        Phòng ban
                    </a>
                </li>

                <li>
                    <a class="dropdown-item ${currentPage eq 'patient' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/patient">
                        Hồ sơ bệnh nhân
                    </a>
                </li>

                <li><hr class="dropdown-divider"></li>

                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                        Đăng xuất
                    </a>
                </li>

            </ul>
        </div>
    </div>
</section>