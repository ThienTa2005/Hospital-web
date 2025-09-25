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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
</head>

<body>
    <jsp:include page="/views/shared/user_header.jsp" />
  
    <div class="user"><h1> DANH SÁCH NGƯỜI DÙNG </h1></div>
    
    <div class="container" style="margin-top: -5px; margin-bottom: 5px;">
        <div class="row">
            <div class="col-5">
            <form action="${pageContext.request.contextPath}/admin/user" method="get" class="d-flex">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Nhập họ tên" class="form-control me-2" style="width: 180px; height: 37px;">
                <button class="search-button" >Tìm kiếm</button>
            </form>
            </div>
            <div class="col-3"></div>
            <div class="col-3 text-end"><a href="${pageContext.request.contextPath}/views/admin/add_user.jsp" class="add-button">
                Thêm người dùng
                </a> 
            </div>
        </div>
    </div>

    <table class="table-1" border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>STT</th>
            <th>Tên đăng nhập</th>
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
                <td><%= 
                        u.getGender().equals("M") ? "Nam" :
                        u.getGender().equals("F") ? "Nữ" :
                        u.getGender()
                %></td>
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
<!--                    <button class="edit"> Chỉnh sửa </button>-->
                    <a href="#" class="edit" data-bs-toggle="modal" >Chỉnh sửa</a>

<!--                    <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=<%=u.getUserId()%>" 
                    onclick="return confirm('Bạn có chắc muốn xóa user này không?')" 
                    class="btn btn-danger btn-sm">Xóa</a>-->
                    
<!--                    <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=<%=u.getUserId()%>" 
                  class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal">Xóa</a>-->
                    
                    <a href="#" 
                        class="btn btn-danger btn-sm" 
                        data-bs-toggle="modal" 
                        data-bs-target="#confirmDeleteModal"
                        data-id="<%= u.getUserId() %>">
                        Xóa
                    </a>
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
    
    <!-- Modal Xác Nhận Xóa -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title">Xác nhận xóa</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            Bạn có chắc chắn muốn xóa người dùng này không?
          </div>
<!--        <div class="modal-footer"> 
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button> 
                <a href="deleteUser?id=1" class="btn btn-danger" style="padding: 8px 12px;">Xóa</a>
            </div>-->
            
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <a id="confirmDeleteBtn" href="#" class="btn btn-danger" style="padding: 8px 12px;">Xóa</a>
          </div>
        </div>
      </div>
    </div>
    
    
    
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const deleteModal = document.getElementById('confirmDeleteModal');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

        deleteModal.addEventListener('show.bs.modal', function (event) {
          const button = event.relatedTarget;
          const userId = button.getAttribute('data-id');

          if (userId && userId.trim() !== "") {
             confirmDeleteBtn.href = contextPath + "/admin/user?action=delete&id=" + userId;
          } else {
            console.error("⚠ ID người dùng bị rỗng!");
            confirmDeleteBtn.href = "#";
          }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>
