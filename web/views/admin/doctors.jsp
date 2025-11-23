<%@page import="java.util.List"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.dao.DoctorDAO"%>
<%@page import="model.dao.DepartmentDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String deptIdParam = request.getParameter("deptId");
    int deptIdInt = (deptIdParam != null && !deptIdParam.isEmpty()) ? Integer.parseInt(deptIdParam) : -1;

    DoctorDAO dao = new DoctorDAO();
    List<Doctor> doctors = dao.getAllDoctors();
    if (deptIdInt != -1) {
        doctors = doctors.stream()
                         .filter(d -> d.getDepartmentId() == deptIdInt)
                         .collect(java.util.stream.Collectors.toList());
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách bác sĩ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/user_style.css">
<style>

html, body {
    height: 100%;
    margin: 0;
}
body {
    display: flex;
    flex-direction: column;
}

.container-main { 
    flex: 1; 
    padding: 20px;
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.row.doctors-row {
    display: flex;
    gap: 15px;
    align-items: flex-start;
}


.col-doctors {
    flex: 1;
    max-width: 50%;
}

#doctorFormContainer {
    flex: 1;
    max-width: 50%;
    background-color: white;
    padding: 15px;
    border-radius: 8px;
    min-height: 400px;
    max-height: 75vh; 
    overflow-y: auto;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.table-1 {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 0;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.table-1 th {
    background: #40855E;
    color: white;
    padding: 12px;
    text-align: center;
}
.table-1 td {
    padding: 10px;
    border: 1px solid #ddd;
    text-align: center;
}
.table-1 tr:nth-child(even) { background: #f8f8f8; }
.table-1 tr:hover { background: #eaf6ea; }

.viewDoctor {
    background: #40855E;
    color: white;
    border: none;
    padding: 5px 12px;
    border-radius: 8px;
    cursor: pointer;
}
.viewDoctor:hover { background: #2f6d4b; }

#footer {
    background-color: #569571;
    color: white;
    display: flex;                
    justify-content: center;     
    align-items: center;         
    height: 40px;
    text-align: center;
    padding: 12px 0;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    font-size: 0.9rem;
    box-shadow: 0 -2px 6px rgba(0,0,0,0.1);
    width: 100%;
}
</style>
</head>
<body>

<jsp:include page="/views/shared/user_header.jsp" />

<div class="container-main">
    <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>
        Danh sách bác sĩ
        <% if (deptIdInt != -1) { %>
            của khoa: <%= new DepartmentDAO().getAllDepartments().stream()
                    .filter(d -> d.getDepartmentID() == deptIdInt)
                    .findFirst().map(d -> d.getDepartmentName()).orElse("") %>
        <% } %>
    </h2>
    <button class="btn btn-success" id="addDoctorBtn">
        <i class="fa-solid fa-plus"></i> Thêm bác sĩ
    </button>
    </div>


    <div class="row doctors-row">
        <!-- Bảng bên trái -->
        <div class="col-doctors">
            <table class="table-1">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Trình độ</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <% if (doctors != null && !doctors.isEmpty()) {
                       for (Doctor doc : doctors) { %>
                    <tr>
                        <td><%= doc.getUserId() %></td>
                        <td><%= doc.getFullName() %></td>
                        <td><%= doc.getDegree() %></td>
                        <td>
                            <button class="viewDoctor" data-id="<%= doc.getUserId() %>">Xem</button>
                        </td>
                    </tr>
                <%   }
                   } else { %>
                    <tr>
                           <td colspan="4" class="text-center text-muted">Chưa có bác sĩ nào.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Form bên phải -->
        <div id="doctorFormContainer">
            <p class="text-center text-muted mt-5">Chọn một bác sĩ để xem chi tiết.</p>
        </div>
    </div>
</div>

<!-- Modal Thêm bác sĩ -->
<div class="modal fade" id="addDoctorModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form id="addDoctorForm" method="post" action="<%= request.getContextPath() %>/admin/doctor">
        <input type="hidden" name="action" value="add">
        <div class="modal-header" style="background-color:#40855E;">
          <h5 class="modal-title text-white">Thêm bác sĩ</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <div class="mb-3">
                <label class="form-label fw-bold">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Họ tên</label>
                <input type="text" name="fullname" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Ngày sinh</label>
                <input type="date" name="dob" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Giới tính</label>
                <select name="gender" class="form-select" required>
                    <option value="M">Nam</option>
                    <option value="F">Nữ</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Điện thoại</label>
                <input type="text" name="phonenum" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Địa chỉ</label>
                <input type="text" name="address" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Trình độ (Bằng cấp)</label>
                <input type="text" name="degree" class="form-control" placeholder="Vd: Thạc sĩ, CKI" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Khoa</label>
                <select name="departmentId" class="form-select" required>
                    <% for(model.entity.Department d : new model.dao.DepartmentDAO().getAllDepartments()){ %>
                        <option value="<%=d.getDepartmentID()%>"><%=d.getDepartmentName()%></option>
                    <% } %>
                </select>
            </div>
        </div>       
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-success">Thêm</button>
        </div>
      </form>
    </div>
  </div>
</div>

                

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function(){
    $('.viewDoctor').click(function(){
        const doctorId = $(this).data('id');
        $('#doctorFormContainer').load('<%= request.getContextPath() %>/views/admin/doctor_form.jsp?id=' + doctorId);
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const currentDeptId = urlParams.get('deptId');
    const addDoctorBtn = document.getElementById('addDoctorBtn');
    if (addDoctorBtn) {
        addDoctorBtn.addEventListener('click', function() {
            const addModalEl = document.getElementById('addDoctorModal');
            const addModal = new bootstrap.Modal(addModalEl);
            
            //Tự động chọn Khoa đó trong Form
            if (currentDeptId) {
                const deptSelect = addModalEl.querySelector('select[name="departmentId"]');
                if (deptSelect) {
                    deptSelect.value = currentDeptId; 
                }
            }
            
            addModal.show();
        });
    }
});

</script>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
