<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.entity.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin page</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        
        * {
            
            font-family: 'Chiron GoRound TC', sans-serif;
          }
        /* Header tổng */
        header {
            margin-top: 0;
            background-color: #9EC8AF;
    /*        padding: 0 0;*/
        }



        /* Hàng đầu: Chào mừng + Đăng xuất */
        .header-top {
            margin-top: 0px;
    /*        border-radius: 8px;*/
    /*        padding: 10px 15px;*/
            margin-bottom: 20px;
        }

        /* Chữ trong header-top */
        .header-top h2 {
            margin: 0;
            font-size: 3rem;
        }

        /* Nút đăng xuất */
        .logout-btn {
            background-color: white;
            color: #40855E;
            border: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #f0f0f0;
        }

        /* Hàng nút chức năng */
        .header-buttons {
            margin-top: 10px;
            background-color: #9EC8AF;
        }

        /* Nút chức năng */
        .func-btn {
            background-color: #9EC8AF;
            border: none;
            color: #ffffff;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .func-btn:hover {
            background-color: #7fb898;
            cursor: pointer;
}

        
        .container {
            margin-top: 10px;
            margin-bottom: 15px;
            padding: 15px;
        }
        
        table th, table td {
            border: 1px solid black;
        }
        
        .table-1 {
            margin-top: 10px;
            margin-left: 55px;
            text-align: center;
            border-collapse: collapse;
            width: 90%;
        }

        .fullname {
            text-align: left;
        }
        
        .user {
            margin-top: 15px;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .edit {
            margin-left: 5px;
            margin-right: 10px;
        }
        
/*        body {
            background-color: #f0f4f0;
        }*/
        
        /* ====== HEADER MỚI ====== */
        header {
            background: #569571;
            border-radius: 0 0 15px 15px;
            padding: 1px 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            height: 80px;
            margin-bottom: 22px;
        }

        /* Logo và tên phòng khám */
        .header-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.6rem;
            font-weight: bold;
            color: white;
            margin-top: -5px;
        }

        .header-logo img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            padding: 4px;
        }
        
        h1 {
            margin-bottom: 10px;
            font-size: 36px; /* hoặc 2.25rem tùy layout */
            font-weight: 700; /* đậm */
            color: #2E7D32; /* xanh lá đậm giống trong ảnh */
          
        }

        /* Menu điều hướng */
        .nav-menu {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 25px;
            font-size: 1.2rem;
            font-weight: 600;
            margin-top: -5px;
        }

        .nav-menu a {
            text-decoration: none;
            color: #000;
            transition: 0.3s ease;
            padding: 5px 10px;
            border-radius: 8px;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            background: rgba(255,255,255,0.3);
            color: white;
        }

        /* Nút Đăng xuất */
        .logout-btn {
            background: white !important;
            color: #40855E !important;
            font-weight: bold;
            padding: 5px 20px;
            border-radius: 12px;
            border: 2px solid #40855E;
            transition: 0.3s;
        }

        .logout-btn:hover {
            background: #f0f0f0 !important;
        }

        /* ====== BẢNG DANH SÁCH NGƯỜI DÙNG ====== */
        .table-1 {
            width: 95%;
            margin: 15px auto;
            border-radius: 12px;
            overflow: hidden;
            border: none;
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .table-1 th {
            background: #40855E;
            color: white;
            padding: 12px;
            font-size: 1rem;
        }

        .table-1 td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .table-1 tr:nth-child(even) {
            background: #f8f8f8;
        }

        .table-1 tr:hover {
            background: #eaf6ea;
        }

        /* Nút chỉnh sửa và xóa */
        .edit,
        .btn-danger {
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .edit{
            background: #40855E;
            color: white;
            margin-bottom: 5px;
            border: none;
        }

        .edit:hover {
            background: #2f6d4b;   


        }
        
        .logout-btn {
            margin-top: -5px; /* điều chỉnh số px tùy ý */
        }


        .search-button{
            background: #40855E;
            color: white;
            border: none;
            border-radius: 8px;
        }

        .search-button:hover {
            background: #2f6d4b;
        }

        .add-button{
            background: #40855E;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.2rem;
            padding: 5px 10px;
        }

        .add-button:hover {
            background: #2f6d4b;
        }

        .btn-danger {
            background: #d9534f;
            border: none;
        }

        .btn-danger:hover {
            background: #c9302c;
        }
    </style>
</head>

<body>
<!--    <header>
        <div class="container">
            <div class="row">
                <div class="col-4"><h2>Xin chào, <%= (String) request.getAttribute("username")%></h2></div>
                <div class="col-6 text-center"></div>
                <div class="col-2 text-end"><button class="btn btn-primary w-100"> Đăng xuất </button> </div>
            </div>

            <div class="row" style="margin-top: 15px;">
                <div class="col-2 text-start"><button class="btn btn-primary w-100"> Xem ca trực </button></div>
                <div class="col-2 text-start"><button class="btn btn-primary w-100"> Số lượt khám </button></div>
                <div class="col-2 text-start"><button class="btn btn-primary w-100"> Số bệnh nhân </button></div>           
            </div>
        </div>
    </header>-->

    <header>
    <div class="container d-flex justify-content-between align-items-center" >
        <!-- Logo + Tên phòng khám -->
        <div class="header-logo">
<!--            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo">-->
            Quản lý phòng khám
        </div>

        <!-- Menu điều hướng -->
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/admin/user" class="active">Trang chủ</a>
            <a href="#">Ca trực</a>
            <a href="#">Hồ sơ bác sĩ</a>
            <a href="#">Hồ sơ bệnh nhân</a>
        </div>

        <!-- Đăng xuất -->
        <form action="${pageContext.request.contextPath}/logout" method="get" >
            <button class="btn logout-btn">Đăng xuất</button>
        </form>
    </div>
    </header>

    
    <div class="user"><h1> DANH SÁCH NGƯỜI DÙNG </h1></div>
    
    <div class="container">
        <div class="row">
            <div class="col-5">
            <form action="${pageContext.request.contextPath}/admin/user" method="get" class="d-flex">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Nhập họ tên" class="form-control me-2" style="width: 180px; height: 37px;">
                <button class="search-button" >Tìm kiếm</button>
            </form>
            </div>
            <div class="col-3"></div>
            <div class="col-3 text-end"><button class="add-button"> Thêm người dùng </button> </div>
        </div>
    </div>

    <table class="table-1" border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>STT</th>
            <th>Tên người dùng</th>
            <th>Mật khẩu</th>
            <th>Họ tên</th>
            <th>Ngày sinh</th>
            <th>Giới tính</th>
            <th>Số điện thoại</th>
            <th>Địa chỉ</th>
            <th>Vai trò</th>
            <th>Quản lý</th>

        </tr>
        <%
        List<User> users = (List<User>) request.getAttribute("users");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        if (users != null && !users.isEmpty()) {
            int STT = 1;
            for (User u : users) {
        %>

            <tr>
     
                <td><%= STT++ %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getPassword() %></td>
                <td class="fullname"><%= u.getFullname() %></td>
                <td><%= sdf.format(u.getDob()) %></td>
                <td><%= u.getGender() %></td>
                <td><%= u.getPhonenum() %></td>
                <td><%= u.getAddress() %></td>
                <td>
                    <%=
                        u.getRole().equals("doctor") ? "Bác sĩ" :
                        u.getRole().equals("admin") ? "Admin" :
                        u.getRole().equals("patient") ? "Bệnh nhân":
                        u.getRole()
                    %>
                </td>
                <td> 
                    <button class="edit"> Chỉnh sửa </button>
                    <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=<%=u.getUserId()%>" 
                    onclick="return confirm('Bạn có chắc muốn xóa user này không?')" 
                    class="btn btn-danger btn-sm">Xóa</a>
                </td>
            </tr>
        <%  
            }
        } else {
        %>
            <tr>
                <td colspan="10" style="text-align:center; font-size: 1rem;">Không có dữ liệu người dùng</td>
            </tr>
        <%
            }
        %>
    </table>
</body>
</html>
