<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.dao.DoctorDAO"%>
<%@page import="model.dao.DepartmentDAO"%>

<%
    String id = request.getParameter("id");
    Doctor doc = null;
    if (id != null && !id.isEmpty()) {
        DoctorDAO dao = new DoctorDAO();
        try {
            doc = dao.getDoctorById(Integer.parseInt(id));
        } catch (NumberFormatException e) {
            doc = null;
        }
    }

    DepartmentDAO deptDao = new DepartmentDAO();
    List<model.entity.Department> departments = deptDao.getAllDepartments();
%>

<% if(doc != null){ %>
<form id="doctorForm" method="post" action="<%=request.getContextPath()%>/admin/doctor" style="height:100%; overflow-y:auto;">

    <input type="hidden" name="action" value="update">
    <input type="hidden" name="userId" value="<%=doc.getUserId()%>">

    <div class="mb-3 d-flex gap-2">
        <button type="button" class="btn btn-success flex-fill" id="editBtn">Sửa</button>
        <button type="submit" class="btn btn-success flex-fill" id="saveBtn" disabled>Lưu</button>
        <button type="button" class="btn btn-success flex-fill" style="background-color: #c9302c; border: none;" id="deleteBtn">Xóa</button>
    </div>

    <div class="mb-3">
        <label>Họ tên</label>
        <input type="text" name="fullname" class="form-control" value="<%=doc.getFullname()%>" disabled>
    </div>

    <div class="mb-3">
        <label>Ngày sinh</label>
        <input type="date" name="dob" class="form-control" value="<%=doc.getDob()%>" disabled>
    </div>

    <div class="mb-3">
        <label>Giới tính</label>
        <select name="gender" class="form-select" disabled>
            <option value="M" <%= "Male".equals(doc.getGender()) ? "selected" : "" %>>Nam</option>
            <option value="F" <%= "Female".equals(doc.getGender()) ? "selected" : "" %>>Nữ</option>
        </select>
    </div>

    <div class="mb-3">
        <label>Điện thoại</label>
        <input type="text" name="phonenum" class="form-control" value="<%=doc.getPhonenum()%>" disabled>
    </div>

    <div class="mb-3">
        <label>Địa chỉ</label>
        <input type="text" name="address" class="form-control" value="<%=doc.getAddress()%>" disabled>
    </div>

    <div class="mb-3">
        <label>Trình độ</label>
        <input type="text" name="degree" class="form-control" value="<%=doc.getDegree()%>" disabled>
    </div>

    <div class="mb-3">
        <label>Khoa</label>
        <select name="departmentId" class="form-select" disabled>
            <% for(model.entity.Department d : departments){ %>
                <option value="<%=d.getDepartmentID()%>" <%= d.getDepartmentID() == doc.getDepartmentId() ? "selected" : "" %>><%=d.getDepartmentName()%></option>
            <% } %>
        </select>
    </div>
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function(){
    // Sửa thông tin
    $('#editBtn').click(function(){
        $('#doctorForm input, #doctorForm select').prop('disabled', false); // bật input/select
        $('#saveBtn').prop('disabled', false); // bật nút Lưu
        $(this).prop('disabled', true); // tắt nút Sửa
    });

    // Xoá bác sĩ
    $('#deleteBtn').click(function(){
        if(confirm('Bạn có chắc muốn xóa bác sĩ này?')){
            const id = $('input[name="userId"]').val();
            window.location.href = '<%=request.getContextPath()%>/admin/doctor?action=delete&id=' + id;
        }
    });

    // Gửi form cập nhật
    $('#doctorForm').submit(function(e){
        e.preventDefault(); 
        console.log($(this).serialize()); // Xem dữ liệu gửi đi
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(),
            success: function(){
                alert('Cập nhật bác sĩ thành công!');
                location.reload(); // reload cả trang để thấy dữ liệu mới
            },
            error: function(){
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

