<%@page import="java.util.List"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.dao.DoctorDAO"%>
<%@page import="model.dao.DepartmentDAO"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String id = request.getParameter("id");
    Doctor doc = null;
    if (id != null && !id.isEmpty()) {
        try {
            DoctorDAO dao = new DoctorDAO();
            doc = dao.getDoctorByID(Integer.parseInt(id));
        } catch (NumberFormatException e) {
            doc = null;
        }
    }

    DepartmentDAO deptDao = new DepartmentDAO();
    List<model.entity.Department> departments = deptDao.getAllDepartments();
%>

<% if (doc != null) { %>
<form id="doctorForm"
      method="post"
      action="<%=request.getContextPath()%>/admin/doctor"
      style="height:100%; overflow-y:auto;">

    <!-- backend DoctorServlet.doPost dùng action=edit -->
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="userId" value="<%=doc.getUserId()%>">
    <input type="hidden" name="role" value="<%= doc.getRole() %>">

    <div class="mb-3 d-flex gap-2">
        <button type="button" class="btn btn-success flex-fill" id="editBtn">Sửa</button>
        <button type="submit" class="btn btn-success flex-fill" id="saveBtn" disabled>Lưu</button>
        <button type="button"
                class="btn btn-success flex-fill"
                style="background-color: #c9302c; border: none;"
                id="deleteBtn">
            Xóa
        </button>
    </div>

    <div class="mb-3">
        <label>Tên đăng nhập</label>
        <input type="text"
               name="username"
               class="form-control"
               value="<%=doc.getUsername()%>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Mật khẩu</label>
        <input type="text"
               name="password"
               class="form-control"
               value="<%= doc.getPassword() == null ? "" : doc.getPassword() %>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Họ tên</label>
        <input type="text"
               name="fullname"
               class="form-control"
               value="<%=doc.getFullname()%>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Ngày sinh</label>
        <!-- java.sql.Date.toString() -> yyyy-MM-dd, phù hợp input date -->
        <input type="date"
               name="dob"
               class="form-control"
               value="<%= doc.getDob() != null ? doc.getDob().toString() : "" %>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Giới tính</label>
        <select name="gender" class="form-select" disabled>
            <option value="M" <%= "M".equals(doc.getGender()) ? "selected" : "" %>>Nam</option>
            <option value="F" <%= "F".equals(doc.getGender()) ? "selected" : "" %>>Nữ</option>
        </select>
    </div>

    <div class="mb-3">
        <label>Điện thoại</label>
        <input type="text"
               name="phonenum"
               class="form-control"
               value="<%= doc.getPhonenum() == null ? "" : doc.getPhonenum() %>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Địa chỉ</label>
        <input type="text"
               name="address"
               class="form-control"
               value="<%= doc.getAddress() == null ? "" : doc.getAddress() %>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Bằng cấp</label>
        <input type="text"
               name="degree"
               class="form-control"
               value="<%= doc.getDegree() == null ? "" : doc.getDegree() %>"
               disabled>
    </div>

    <div class="mb-3">
        <label>Khoa</label>
        <select name="departmentId" class="form-select" disabled>
            <% for (model.entity.Department d : departments) { %>
                <option value="<%= d.getDepartmentID() %>"
                        <%= d.getDepartmentID() == doc.getDepartmentId() ? "selected" : "" %>>
                    <%= d.getDepartmentName() %>
                </option>
            <% } %>
        </select>
    </div>
</form>

<script>
$(document).ready(function () {
    // Bật chế độ sửa
    $('#editBtn').click(function () {
        // bật tất cả input/select trừ hidden
        $('#doctorForm')
            .find('input:not([type="hidden"]), select')
            .prop('disabled', false);

        $('#saveBtn').prop('disabled', false);
        $(this).prop('disabled', true);
    });

    // Xóa bác sĩ
    $('#deleteBtn').click(function () {
        if (confirm('Bạn có chắc muốn xóa bác sĩ này?')) {
            const id = $('input[name="userId"]').val();
            window.location.href =
                '<%=request.getContextPath()%>/admin/doctor?action=delete&id=' + id;
        }
    });

    // Gửi form cập nhật bằng AJAX
    $('#doctorForm').submit(function (e) {
        e.preventDefault();
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(), // action=edit + tất cả field
            success: function () {
                alert('Cập nhật bác sĩ thành công!');
                // reload lại trang danh sách để thấy dữ liệu mới
                window.location.reload();
            },
            error: function () {
                alert('Cập nhật thất bại, thử lại!');
            }
        });
    });
});
</script>

<% } else { %>
<div class="text-center text-muted mt-4">
    Không tìm thấy thông tin bác sĩ.
</div>
<% } %>
