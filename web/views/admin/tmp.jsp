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


    <style>
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
    <div class="container">
        <!-- Hàng đầu: Chào mừng + đăng xuất -->
        <div class="row header-top align-items-center">
            <div class="col-5">
                <h2>Trang chủ</h2>
            </div>
            <div class="col-5 text-center"></div>
            <div class="col-2 text-end" style="margin-top: -10px;">
                <form action="${pageContext.request.contextPath}/logout" method="get" >
                    <button class="btn logout-btn w-100" >Đăng xuất</button>
                </form>
                
            </div>
        </div>

        <!-- Hàng hai: Nút chức năng -->
        <div class="row header-buttons">
            <div class="col-2 text-start">
                <button class="btn func-btn w-100">Xem ca trực</button>
            </div>
            <div class="col-2 text-start">
                <button class="btn func-btn w-100">Số lượt khám</button>
            </div>
            <div class="col-2 text-start">
                <button class="btn func-btn w-100">Số bệnh nhân</button>
            </div>           
        </div>
    </div>
    </header>

    
    <div class="user"><h1> Danh sách người dùng </h1></div>
    
    <div class="container">
        <div class="row">
            <div class="col-4">
            <form action="${pageContext.request.contextPath}/admin/user" method="get" class="d-flex">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Nhập họ tên" class="form-control me-2" style="width: 180px; height: 37px;">
                <button class="btn btn-primary">Tìm kiếm</button>
            </form>
            </div>
            <div class="col-5"></div>
            <div class="col-2 text-end"><button class="btn btn-primary w-100"> Thêm người dùng </button> </div>
        </div>
    </div>

    <table class="table-1" border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>#</th>
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
        if (users != null) {
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
                    <a href="${pageContext.request.contextPath}/admin/user?action=delete?id=<%=u.getUserId()%>" 
                    onclick="return confirm('Bạn có chắc muốn xóa user này không?')" 
                    class="btn btn-danger btn-sm">Xóa</a>
                </td>
            </tr>
        <%  
            }
        } else {
        %>
            <tr>
                <td colspan="10" style="text-align:center;">Không có dữ liệu người dùng</td>
            </tr>
        <%
            }
        %>
    </table>
</body>
</html>
