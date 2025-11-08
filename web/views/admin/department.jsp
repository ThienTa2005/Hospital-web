<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Department" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Phòng ban</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/user_style.css">
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
    request.setAttribute("currentPage", "department");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<main class="main-content">
    <div class="title-box"><h3> DANH SÁCH PHÒNG BAN </h3></div>

    <div class="container" style="margin-top: -5px; margin-bottom: 5px;">
        <div class="row">
            <!-- Form tìm kiếm -->
            <div class="col-5">
                <form action="${pageContext.request.contextPath}/admin/department" method="get" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Nhập tên phòng ban" class="form-control me-2" style="width: 180px; height: 37px;">
                    <button class="search-button btn btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="col-3"></div>

            <!-- Nút Thêm -->
            <div class="col-3 text-end">
                <button id="openAddModal" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addDepartmentModal">
                    <i class="fa-solid fa-plus"></i> Thêm phòng ban
                </button> 
            </div>
        </div>
    </div>

    <!-- Bảng danh sách phòng ban -->
    <div class="row mt-3">
        <div class="col-12">
            <table class="table-1" border="1" cellpadding="5" cellspacing="0">                  
                <tr>
                    <th>ID</th>
                    <th>Tên phòng ban</th>
                    <th>Quản lý</th>
                </tr>
                <%
                    List<Department> departments = (List<Department>) request.getAttribute("departments");
                    if (departments != null && !departments.isEmpty()) {
                        int index = 1;
                        for (Department dept : departments) {
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= dept.getDepartmentName() %></td>
                    <td class="text-center">
                        <a href="<%= request.getContextPath() %>/views/admin/doctors.jsp?deptId=<%= dept.getDepartmentID() %>" class="btn btn-success btn-sm me-1">
                            <i class="fa-solid fa-eye" style="border-radius: 5px"></i> Xem
                        </a>
                        <button class="btn btn-warning btn-sm me-1 edit-dept" style="border-radius: 5px" 
                                data-id="<%= dept.getDepartmentID() %>"
                                data-name="<%= dept.getDepartmentName() %>" 
                                data-bs-toggle="modal"
                                data-bs-target="#editDepartmentModal">
                            <i class="fa-solid fa-pen"></i> Sửa
                        </button>
                        <button class="btn btn-danger btn-sm me-1 delete-dept" style="border-radius: 5px"
                                data-id="<%= dept.getDepartmentID() %>" 
                                data-bs-toggle="modal" 
                                data-bs-target="#confirmDeleteModal">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="3" class="text-center">Không có dữ liệu</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</main>

<!-- Modal Thêm phòng ban -->
<div class="modal fade" id="addDepartmentModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="<%= request.getContextPath() %>/admin/department" method="post">
        <div class="modal-header" style="background: #569571;">
          <h5 class="modal-title text-white w-100">Thêm phòng ban</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" name="action" value="add">
            <div class="mb-3">
              <label>Tên phòng ban</label>
              <input type="text" class="form-control" name="department-name" required>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-success">Lưu</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Sửa phòng ban -->
<div class="modal fade" id="editDepartmentModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="<%= request.getContextPath() %>/admin/department" method="get">
        <div class="modal-header" style="background: #569571;">
          <h5 class="modal-title text-white w-100">Sửa phòng ban</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editDeptId">
            <div class="mb-3">
              <label>Tên phòng ban</label>
              <input type="text" class="form-control" name="department-name" id="editDeptName" required>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-success">Lưu</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Xóa phòng ban -->
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Xác nhận xóa</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        Bạn có chắc chắn muốn xóa phòng ban này không?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Xóa</a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // 1. Modal Xóa
    const deleteModal = document.getElementById('confirmDeleteModal');
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

    deleteModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const deptId = button.getAttribute('data-id');
        confirmDeleteBtn.href = "<%= request.getContextPath() %>/admin/department?action=delete&id=" + deptId;
    });

    // 2. Modal Sửa
    const editButtons = document.querySelectorAll('.edit-dept');
    editButtons.forEach(button => {
        button.addEventListener('click', function () {
            const deptId = this.dataset.id;
            const deptName = this.dataset.name;

            // Điền dữ liệu vào form Sửa
            document.getElementById('editDeptId').value = deptId;
            document.getElementById('editDeptName').value = deptName;

            // Đảm bảo action = update
            document.querySelector('#editDepartmentModal input[name="action"]').value = "update";
        });
    });

    // 3. Modal Thêm
    const addButton = document.getElementById('openAddModal');
    if(addButton) {
        addButton.addEventListener('click', function () {
            // Reset form Thêm
            const addFormInput = document.querySelector('#addDepartmentModal input[name="department-name"]');
            if(addFormInput) addFormInput.value = "";

            // Đảm bảo action = add
            document.querySelector('#addDepartmentModal input[name="action"]').value = "add";
        });
    }
});
</script>

<jsp:include page="/views/shared/user_footer.jsp" />
</body>
</html>
