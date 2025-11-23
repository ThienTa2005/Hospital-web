<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page import="java.util.List" %>
    <%@ page import="model.entity.Appointment" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Bệnh Nhân</title>
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
            transition: background-color 0.2s ease, transform 0.2s ease;
        }   

        
        .logout-btn .menu-icon {
            width: 25px;
            height: 25px;
            object-fit: cover;
            fill: currentColor;
            transition: transform 0.2s ease;
            margin-left: 5px;  /* dịch icon sang phải 1 chút */
        }

        .logout-btn span {
            margin-top: 2.5px;
            transition: transform 0.2s ease;
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

        .sidebar ul li {
            display: flex;
            align-items: center;
            padding: 10px 15px 10px 25px;
            cursor: pointer;
            gap: 10px;
            position: relative;
            color: #fff;
            transition: color 0.2s ease;
        }
            
        .sidebar ul li:hover span,
        .sidebar ul li:hover .menu-icon {
            transform: scale(1.075);
        }


        /* Tạo "hover background" bo tròn */
        .sidebar ul li::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10px;
            right: 10px;
            bottom: 0;
            background-color: transparent;
            border-radius: 10px; /* bo tròn */
            z-index: 0;
            transition: background-color 0.2s ease;
        }

        /* Khi hover: chỉ background bo tròn sáng lên */
        .sidebar ul li:hover::before {
            background-color: #3a705b;
        }

        /* Chữ và icon lên trên background */
        .sidebar ul li span,
        .sidebar ul li .menu-icon {
            position: relative;
            z-index: 1;
            transition: color 0.2s ease, fill 0.2s ease;
        }

        /* Hover đổi màu chữ + icon */
        .sidebar ul li:hover span,
        .sidebar ul li:hover .menu-icon {
            color: #5de292;
            fill: #5de292; /* nếu SVG */
        }

        /* Border dưới hover */
        .sidebar ul li::after {
            content: '';
            position: absolute;
            left: 10px;
            right: 10px;
            bottom: 0;
            height: 2px;
            background-color: #5de292;
            transform: scaleX(0);
            transition: transform 0.2s ease;
        }

        .sidebar ul li:hover::after {
            transform: scaleX(1);
        }


        .sidebar ul li .menu-icon {
            width: 25px;
            height: 25px;
            object-fit: cover;
        }
        
        .sidebar ul li span {
            margin-top: 5px; /* chữ xuống dưới */
        }


        .sidebar ul li:hover {
            background-color: #345e4c;
        }

        /* Main container */
        .main {
            flex-grow: 1;
            padding: 20px;
        }

        /* Header */
        .header {
            background-color: #40855e;
            color: white;
            padding: 15px 20px;
            margin-bottom: 50px; 
            border-radius: 5px;
            display: flex;
            justify-content: center;
        }

        /* Table*/
        table {
            width: 90%;                  /* ✅ Chiếm khoảng 90% chiều ngang trang */
            max-width: 1200px;           /* ✅ Giới hạn tối đa để không quá to */
            min-width: 600px;            /* ✅ Không nhỏ quá khi ít cột */
            margin: 20px auto;           /* ✅ Căn giữa bảng */
            border-collapse: collapse;
            table-layout: auto;          /* ✅ Cho phép cột co giãn theo chữ */
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        /* Ô dữ liệu và tiêu đề */
        th, td {
            padding: 10px 15px;
            text-align: center;
            border: 1px solid #ccc;
            white-space: nowrap;         /* ✅ Giúp ô không xuống dòng, vừa khít chữ */
        }

        /* Dòng tiêu đề */
        th {
            background-color: #2c693b;
            color: white;
            font-weight: 600;
        }

        /* Màu xen kẽ và hiệu ứng hover */
        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tbody tr:hover {
            background-color: #eaf2ec;
            transition: background-color 0.2s;
        }

        /* Nút Xem chi tiết */
        .btn-detail {
            padding: 6px 12px;
            background-color: #706e6e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-detail:hover {
            background-color: #929292;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 10px;
            color: #555;
            margin-top: 20px;
        }

        /* Filter/search */
        .filter {
            margin-bottom: 30px; 
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter select, .filter input, .filter button {
            padding: 8px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .filter button {
            background-color: #2c693b;
            color: white;
            border: none;
            cursor: pointer;
        }
        .filter button:hover {
            background-color: #569571;
        }
        
        

    </style>
</head>
<body>

    <div class="sidebar" id="sidebar">
        <!-- Header mới với icon + tên bệnh viện -->
        <div class="sidebar-top">
            <img src="../shared/logo.png" alt="Bệnh viện" class="icon">
            <div class="greeting">
                <span class="hello">Xin chào</span>
                <span class="name">Lê Thành Thông</span>
            </div>
            <div class="toggle-btn" id="toggleBtn">&#x276E;</div>
        </div>

        <h3>Tính năng</h3>
        <ul>
            <li>
                <!-- Inline SVG với fill="currentColor" -->
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                    <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v14c0 
                             1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 
                             16H5V9h14v11zm0-13H5V6h14v1z"></path>
                 </svg>
                <span>Tra cứu hồ sơ</span>
            </li>
            <li>
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                    <path d="M3 5h7l2 2h9c1.1 0 2 .9 2 2v10c0 1.1-.9 2-2 2H3c-1.1 0-2-.9-2-2V7c0-1.1.9-2 2-2z"></path>
                </svg>
                <span>Danh sách lịch hẹn</span>
            </li>
        </ul>


        <hr>

        <h3>Cài đặt</h3>
        <ul>
            <li>
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                    <path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5z"/>
                </svg>
                <span>Thông tin cá nhân</span>
            </li>
            <li>
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 24 24" fill="currentColor" class="menu-icon">
                    <path d="M12 17a2 2 0 100-4 2 2 0 000 4zm6-7h-1V7a5 5 0 00-10 0v3H6c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2v-8c0-1.1-.9-2-2-2zm-6-5a3 3 0 013 3v3h-6V8a3 3 0 013-3zm6 13H6v-8h12v8z"></path>
                </svg>
                <span>Đổi mật khẩu</span>
            </li>
        </ul>
        
         <!-- Logout nút cuối cùng -->
        <div class="logout-btn">
            <!-- SVG icon thoát/ổ khóa, fill=currentColor -->
            <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="menu-icon" viewBox="0 0 24 24">
                <path d="M16 13v-2H7V8l-5 4 5 4v-3zM20 3H10v2h10v14H10v2h10c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
            </svg>
            <span>Đăng xuất</span>
        </div>
    </div>


    <!-- Main content -->
    <div class="main">
        <!-- Header -->
        <div class="header">
            <h1>Danh sách lịch hẹn</h1>
        </div>

        <!-- Filter/Search -->
        <div class="filter">
            <select>
                <option value="">Chọn chuyên khoa</option>
                <option value="khoa1">Khoa 1</option>
                <option value="khoa2">Khoa 2</option>
            </select>
            <input type="date" placeholder="Chọn ngày">
            <select>
                <option value="">Chọn ca khám</option>
                <option value="sang">Sáng</option>
                <option value="chieu">Chiều</option>
            </select>
            <button>Tìm kiếm</button>
        </div>

        <!-- Table danh sách lịch hẹn -->
        <%
            List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
            if (appointments == null || appointments.isEmpty()) {
        %>
            <div class="no-data">Không có lịch hẹn nào được tìm thấy.</div>
            <!-- Nút thêm mới -->
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPatientModal">
              <i class="bi bi-plus-circle"></i> Thêm mới
            </button>
                        <!-- Modal -->
            <div class="modal fade" id="addPatientModal" tabindex="-1" aria-labelledby="addPatientModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">

                  <div class="modal-header">
                    <h5 class="modal-title" id="addPatientModalLabel">Thêm bệnh nhân mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                  </div>

                  <div class="modal-body">
                    <form>
                      <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" class="form-control" placeholder="Nhập họ tên bệnh nhân">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-control">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control">
                      </div>
                    </form>
                  </div>

                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                  </div>

                </div>
              </div>
            </div>
        <%
            } else {
        %>
            <table>
                <thead>
                    <tr>
                        <th>Mã lịch hẹn</th>
                        <th>Mã bệnh nhân</th>
                        <th>Mã ca trực bác sĩ</th>
                        <th>Ngày hẹn</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Appointment appt : appointments) { %>
                    <tr>
                        <td><%= appt.getAppointmentId() %></td>
                        <td><%= appt.getPatientId() %></td>
                        <td><%= appt.getShiftDoctorId() %></td>
                        <td><%= appt.getAppointmentDate() %></td>
                        <td><%= appt.getStatus() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <%
            }
        %>

        <!-- Footer -->
        <div class="footer">
            © 2025 Phòng khám Metal Lotus. All rights reserved.
        </div>
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
