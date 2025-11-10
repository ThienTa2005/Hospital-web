<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.entity.User"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.Doctor"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hồ sơ bác sĩ</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    
    <style>
        .toast-container {
            top: 65px !important;    
            z-index: 1055;           
        }
        
        .modal-backdrop {
            z-index: 2500 !important;
         }

          .modal {
            z-index: 2600 !important;
        }

    </style>
</head>

<body>
    <%
        request.setAttribute("currentPage", "doctor");
    %>
    <jsp:include page="/views/shared/user_header.jsp" />
    
    <!-- Thanh cong -->   
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                     Chỉnh sửa thành công!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>
    
    <!-- That bai  -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="errorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    Chỉnh sửa thất bại! <br>
                    Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <!-- Xoa thanh cong -->   
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="deleteToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                     Xóa thành công!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>
    
    <!-- Xoa ban than  -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="selfDelete" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    Bạn không được xóa tài khoản của chính mình!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>
  
    <main class="main-content">
        <div class="title-box"><h3> DANH SÁCH BÁC SĨ</h3></div>

        <div class="container" style="margin-top: -5px; margin-bottom: 5px;">
            <div class="row">
                <div class="col-5">
                <form action="${pageContext.request.contextPath}/admin/doctor" method="get" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Nhập thông tin bác sĩ" class="form-control me-2" style="width: 180px; height: 37px;">
                    <button class="search-button" >Tìm kiếm</button>
                </form>
                </div>
                <div class="col-3"></div>
                <div class="col-3 text-end"><a href="${pageContext.request.contextPath}/views/admin/add_user.jsp" class="add-button">
                  <i class="fa-solid fa-user-plus" style="margin-right: 5px;"></i>  Thêm người dùng
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
                <th>Bằng cấp</th>
                <th>Khoa</th>
                <th>Quản lý</th>

            </tr>
            <%
            List<Doctor> users = (List<Doctor>) request.getAttribute("listDoctor");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            if (users != null && !users.isEmpty()) {
                int STT = 1;
                for (Doctor u : users) {
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
                    <td><%= u.getDegree() %></td>
                    <td><%= u.getDepartmentName()%></td>
                    <td> 
    <!--                    <button class="edit"> Chỉnh sửa </button>-->
    <!--                    <a href="#" class="edit" data-bs-toggle="modal" >Chỉnh sửa</a>-->

                            <button class="edit" 
                                data-bs-toggle="modal" data-bs-target="#editModal"
                                data-id="<%=u.getUserId()%>"
                                data-username="<%=u.getUsername()%>"
                                data-password="<%=u.getPassword()%>"
                                data-fullname="<%=u.getFullname()%>"
                                data-dob="<%=sdf.format(u.getDob())%>"
                                data-gender="<%=u.getGender()%>"
                                data-phonenum="<%=u.getPhonenum()%>"
                                data-address="<%=u.getAddress()%>"
                                data-role="<%=u.getRole()%>">
                                Chỉnh sửa
                            </button>

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
    </main>
    
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
    
    <!-- Modal chinh sua -->
    <div class="modal fade" id="editModal" tabindex="-1">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <form action="${pageContext.request.contextPath}/admin/user?action=edit" method="post">
            <div class="modal-header" style="background: #569571;">
              <h5 class="modal-title text-center w-100" id="modalTitle" style="font-weight: 500; color: white;">Chỉnh sửa người dùng</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="userId" id="userId">

                <div class="mb-3">
                  <label>Tên đăng nhập</label>
                  <input type="text" class="form-control" name="username" id="username" required>
                </div>
                <div class="mb-3">
                  <label>Mật khẩu</label>
                  <input type="text" class="form-control" name="password" id="password" required>
                </div>
                <div class="mb-3">
                  <label>Họ tên</label>
                  <input type="text" class="form-control" name="fullname" id="fullname" required>
                </div>
                <div class="mb-3">
                  <label>Ngày sinh</label>
                  <input type="date" class="form-control" name="dob" id="dob">
                </div>
                <div class="mb-3">
                  <label>Giới tính</label>
                  <select class="form-control" name="gender" id="gender">
                    <option value="M">Nam</option>
                    <option value="F">Nữ</option>
                  </select>
                </div>
                <div class="mb-3">
                  <label>Số điện thoại</label>
                  <input type="text" class="form-control" name="phonenum" id="phonenum">
                </div>
                <div class="mb-3">
                  <label>Địa chỉ</label>
                  <input type="text" class="form-control" name="address" id="address">
                </div>
                <div class="mb-3">
                  <label>Vai trò</label>
                  <select class="form-control" name="role" id="role">
                    <option value="admin">Admin</option>
                    <option value="doctor">Bác sĩ</option>
                    <option value="patient">Bệnh nhân</option>
                  </select>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="window.location.href='${pageContext.request.contextPath}/admin/user?action=list'">Đóng</button>
              <button type="submit" class="btn btn-success">Lưu</button>            
            </div>
          </form>
        </div>
      </div>
    </div>
    
    <!-- Chinh sua -->
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        const editButtons = document.querySelectorAll('.edit');

        editButtons.forEach(button => {
            button.addEventListener('click', function () {
                // Lay du lieu
                const userId = this.dataset.id;
                const username = this.dataset.username;
                const password = this.dataset.password;
                const fullname = this.dataset.fullname;
                const dob = this.dataset.dob;          
                const gender = this.dataset.gender;
                const phonenum = this.dataset.phonenum;
                const address = this.dataset.address;
                const role = this.dataset.role;

                // Gan vao o input
                document.getElementById('userId').value = userId;
                document.getElementById('username').value = username;
                document.getElementById('password').value = password;
                document.getElementById('fullname').value = fullname;
                document.getElementById('dob').value = dob.split('/').reverse().join('-'); // yyyy-MM-dd
                document.getElementById('phonenum').value = phonenum;
                document.getElementById('address').value = address;
                document.getElementById('gender').value = gender;
                document.getElementById('role').value = role;

                // hidden action = "edit"
                document.getElementById('formAction').value = "edit";
            });
        });
    });
    </script>
    
    <!-- Ten dang nhap da ton tai -->  
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("error") === "username-exist") {
                const toastElement = document.getElementById('errorToast');
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 3000 // 3 giay
                });
                toast.show();
                
                // Xoa url
                const url = new URL(window.location.href);
                url.searchParams.delete("error");
                window.history.replaceState({}, document.title, url.pathname + url.search);
            }
        });
    </script>
    
    <!-- Chinh sua thanh cong -->
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("success") === "true") {
                const toastElement = document.getElementById('successToast');
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 3000 // 3 giay
                });
                toast.show();
                
                // Xoa url
                const url = new URL(window.location.href);
                url.searchParams.delete("success");
                window.history.replaceState({}, document.title, url.pathname + url.search);
            }
        });
    </script>

    <!-- Chinh sua that bai -->
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("delete") === "true") {
                const toastElement = document.getElementById('deleteToast');
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 3000 // 3 giay
                });
                toast.show();
                
                // Xoa url
                const url = new URL(window.location.href);
                url.searchParams.delete("delete");
                window.history.replaceState({}, document.title, url.pathname + url.search);
            }
        });
    </script>
    
    <!-- Xoa tai khoan ban than -->  
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("error") === "selfDelete") {
                const toastElement = document.getElementById('selfDelete');
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 3000 // 3 giay
                });
                toast.show();
                
                // Xoa url
                const url = new URL(window.location.href);
                url.searchParams.delete("error");
                window.history.replaceState({}, document.title, url.pathname + url.search);
            }
        });
    </script>
    
    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>