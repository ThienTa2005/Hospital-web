<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page import="model.entity.User" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <style>
        /* Reset cơ bản */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }

        body {
            display: flex;
            min-height: 100vh;
            background-color: #f5f5f5;
        }
        
        .sidebar.collapsed {
            width: 80px;       /* chỉ hiện icon khi thu gọn */
        }

        /* Logout button căn giữa icon khi collapsed */
        .sidebar.collapsed .logout-btn {
            justify-content: center; /* căn giữa icon */
            padding-left: 0;
            padding-right: 0;
        }
        
        /* Khi sidebar collapsed */
        .sidebar.collapsed ul li,
        .sidebar.collapsed .logout-btn {
            justify-content: center; /* căn giữa icon */
            padding-left: 0 !important;  /* bỏ padding bên trái */
            padding-right: 0 !important; /* bỏ padding phải */
            gap: 0 !important;           /* bỏ khoảng cách giữa icon và text */
        }

        /* Ẩn chữ */
        .sidebar.collapsed ul li span,
        .sidebar.collapsed .logout-btn span {
            display: none !important;
        }

        /* Icon căn giữa */
        .sidebar.collapsed ul li .menu-icon,
        .sidebar.collapsed .logout-btn .menu-icon {
            margin: 0 auto; /* căn giữa icon */
            display: block; /* để margin auto hoạt động */
        }

        /* Logout button khi collapsed */
        .sidebar.collapsed .logout-btn {
            border-radius: 10px;          /* giữ bo tròn như trước */
            padding: 10px;                /* padding đều */
            width: 45px;                  /* bằng chiều rộng sidebar collapsed */
            justify-content: center;      /* căn giữa icon ngang */
            margin: auto auto 20px auto;     /* căn giữa button và giữ margin dưới */
            display: flex;
            align-items: center;          /* căn giữa icon dọc */
        }

        /* Icon trong logout button */
        .sidebar.collapsed .logout-btn .menu-icon {
            margin: 0 auto;               /* căn giữa icon */
            display: block;
        }


        /* Nút toggle sidebar - bên phải header sidebar */
        .sidebar-top .toggle-btn {
            margin-left: auto;          /* đẩy sang phải */
            background-color: transparent;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 15px;            /* kích thước icon */
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;     /* căn giữa icon bên trong button */
            font-weight: 100;
        }


        /* Ẩn chữ khi collapsed */
        .sidebar.collapsed .sidebar-top .greeting,
        .sidebar.collapsed h3,
        .sidebar.collapsed ul li span,
        .sidebar.collapsed .logout-btn span {
            display: none;
        }

        /* Icon menu vẫn hiển thị */
        .sidebar.collapsed ul li .menu-icon {
            margin: 0 auto;  /* căn giữa icon */
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background-color: #2c5038;
            color: white;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            transition: width 0.3s ease;
            overflow: hidden;  /* ẩn chữ khi thu gọn */
        }
       

        /* Logout button */
        .logout-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 33px;
            margin-top: auto;          /* đẩy xuống cuối */
            margin-left: 20px;
            margin-bottom: 20px;
            margin-right: 20px;
            cursor: pointer;
            background-color: #B23A48;; /* nền giống sidebar */
            color: white;
            border-radius: 10px;       /* bo tròn */
            transition: background-color 0.5s ease, transform 0.5s ease;
        }   

        
        .logout-btn .menu-icon {
            width: 25px;
            height: 25px;
            object-fit: cover;
            fill: currentColor;
            transition: transform 0.5s ease;
            margin-left: 5px;  /* dịch icon sang phải 1 chút */
        }

        .logout-btn span {
            margin-top: 2.5px;
            transition: transform 0.5s ease;
            margin-left: 3px;
        }

        /* Hover */
        .logout-btn:hover {
            background-color: #ec506a; /* đỏ đậm khi hover */
        }

        .logout-btn:hover span,
        .logout-btn:hover .menu-icon {
            color: white;
            fill: white;
            transform: scale(1.075);
        }

        /* Bỏ border/underline hover */
        .logout-btn::after {
            display: none;
        }

        
        .sidebar h2 {
            text-align: center;
            padding: 20px 0;
            background-color: #1a252f;
            margin-bottom: 20px;
        }
        
        /* Vùng icon + tên bệnh viện */
        .sidebar-top {
            display: flex;
            gap: 10px;
            padding: 20px 20px 20px 15px;
            background-color: #223725;
            color: #fff;
            align-items: center;           /* Chữ trắng */
            position: relative; /* thêm dòng này */
        }

        /* Icon bệnh viện */
        .sidebar-top .icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;      /* Bo tròn nhẹ */
            object-fit: cover;       /* Giữ tỉ lệ hình ảnh */
        }

        /* Phần chữ */
        .sidebar-top .greeting {
            display: flex;
            flex-direction: column;  /* Chữ xếp dọc: "Xin chào" + tên */
            font-family: Arial, sans-serif;
            font-size: 14px;
        }

        /* Chữ “Xin chào” */
        .sidebar-top .greeting .hello {
            font-weight: 400;
            color: #ccc;             /* Màu chữ nhạt hơn một chút */
        }

        /* Tên người */
        .sidebar-top .greeting .name {
            font-weight: 600;
            color: #fff;             /* Chữ nổi bật hơn */
        }

        
        #sidebar_header{
            padding: 0px 0px 10px 10px;
            display: flex;
            font-size: 20px;
            margin-bottom: 0px;
            
        }
        
        .sidebar h3{
            text-align: left;
            margin: 20px 20px 10px 15px;
            font-size: 15px;
            font-weight: 500;
            color: #ccc;   
        }
        
        .sidebar hr {
            margin: 20px 20px; /* khoảng cách đều */
            border: 0;
            border-top: 1px solid #7d7d7d; /* màu trung tính */
        }
        
        .sidebar ul {
            list-style: none;
        }

        /* Reset cơ bản cho a */
        .sidebar ul li a {
            display: flex;
            align-items: center;
            gap: 10px;               /* khoảng cách icon + text */
            padding: 10px 15px 10px 25px; /* giống li cũ */
            position: relative;      /* để ::before/::after hoạt động */
            color: #fff;
            text-decoration: none;
            transition: color 0.5s ease, fill 0.5s ease;
        }

        /* Hover background bo tròn */
        .sidebar ul li a::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10px;
            right: 10px;
            bottom: 0;
            background-color: transparent;
            border-radius: 10px;
            z-index: 0;
            transition: background-color 0.5s ease;
        }

        /* Khi hover */
        .sidebar ul li a:hover::before {
            background-color: #3a705b;
        }

        /* Hover đổi màu icon + text */
        .sidebar ul li a:hover span,
        .sidebar ul li a:hover .menu-icon {
            color: #5de292;
            fill: #5de292;
            transform: scale(1.075);
            position: relative;
            z-index: 1;
        }

        /* Border dưới hover */
        .sidebar ul li a::after {
            content: '';
            position: absolute;
            left: 10px;
            right: 10px;
            bottom: 0;
            height: 2px;
            background-color: #5de292;
            transform: scaleX(0);
            transition: transform 0.5s ease;
            z-index: 1;
        }

        .sidebar ul li a:hover::after {
            transform: scaleX(1);
        }

        /* Active state */
        .sidebar ul li.active a {
            background-color: #345e4c; /* giống hover nền */
        }

        .sidebar ul li.active a::before {
            background-color: #3a705b; /* bo tròn nền sáng */
        }

        .sidebar ul li.active a span,
        .sidebar ul li.active a .menu-icon {
            color: #5de292;
            fill: #5de292;
            transform: scale(1.075);
        }

        .sidebar ul li.active a::after {
            transform: scaleX(1); /* hiển thị border dưới */
        }
        
        a {
            display: flex;           /* giữ flex cho icon + text */
            align-items: center;
            gap: 10px;               /* khoảng cách icon và text */
            text-decoration: none;   /* bỏ underline */
            color: inherit;          /* lấy màu từ li, không dùng màu mặc định a */
            background: none;        /* bỏ background mặc định nếu có */
            padding: 0;              /* bỏ padding nếu muốn li kiểm soát padding */
            margin: 0;               /* bỏ margin mặc định */
        }

    </style>
</head>
<body>
     <% 
        User user = (User) session.getAttribute("user");  
    %>
    <div class="sidebar" id="sidebar">
        <!-- Header mới với icon + tên bệnh viện -->
        <div class="sidebar-top">
            <img src="../shared/logo.png" alt="Bệnh viện" class="icon">
            <div class="greeting">
                <span class="hello">Xin chào</span>
                <span class="name" style="margin-top: 5px; margin-left: 5px">
                    <%= user.getFullname() %>!
                </span>
            </div>
            <div class="toggle-btn" id="toggleBtn">&#x276E;</div>
        </div>

        <h3>Tính năng</h3>
        <ul>
            <li class="<%= request.getRequestURI().contains("patient_dashboard.jsp") ? "active" : "" %>">
                <a href="patient_dashboard.jsp">
                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                        <path d="M3 5h7l2 2h9c1.1 0 2 .9 2 2v10c0 1.1-.9 2-2 2H3c-1.1 0-2-.9-2-2V7c0-1.1.9-2 2-2z"></path>
                    </svg>
                    <span>Danh sách lịch hẹn</span>
                </a>
            </li>
            
            <li class="<%= request.getRequestURI().contains("patient_records.jsp") ? "active" : "" %>">
                <a href="patient_records.jsp">
                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                        <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v14c0 
                                 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 
                                 16H5V9h14v11zm0-13H5V6h14v1z"></path>
                     </svg>
                    <span>Tra cứu hồ sơ</span>
                </a>
            </li>
        </ul>


        <hr>

        <h3>Cài đặt</h3>
        <ul>
            <li>
                <a>
                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                        <path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5z"/>
                    </svg>
                    <span>Thông tin cá nhân</span>
                </a>
            </li>
            <li>
                <a>
                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                        <path d="M12 17a2 2 0 100-4 2 2 0 000 4zm6-7h-1V7a5 5 0 00-10 0v3H6c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2v-8c0-1.1-.9-2-2-2zm-6-5a3 3 0 013 3v3h-6V8a3 3 0 013-3zm6 13H6v-8h12v8z"></path>
                    </svg>
                    <span>Đổi mật khẩu</span>
                </a>
            </li>
        </ul>
        
        <a href="../auth/login.jsp" class="logout-btn <%= request.getRequestURI().contains("patient_dashboard.jsp") ? "active" : "" %>">
            <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="menu-icon" viewBox="0 0 24 24">
                <path d="M16 13v-2H7V8l-5 4 5 4v-3zM20 3H10v2h10v14H10v2h10c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
            </svg>
            <span>Đăng xuất</span>
        </a>
    </div>
            

</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('toggleBtn');

    toggleBtn.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        // đổi icon nút
        toggleBtn.innerHTML = sidebar.classList.contains('collapsed') ? '&#x276F;' : '&#x276E;';
    });
</script>
