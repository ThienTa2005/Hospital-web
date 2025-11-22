<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.entity.Patient"%>
<%@page import="model.entity.User"%>

<%
    Patient p = (Patient) request.getAttribute("patient");
    boolean isEdit = (p != null);
    User currentUser = (User) session.getAttribute("user");
    boolean isDoctor = (currentUser != null && "doctor".equals(currentUser.getRole()));
    String readOnlyAttr = isDoctor ? "disabled" : "";
    String title = isDoctor ? "Hồ sơ chi tiết bệnh nhân" : (isEdit ? "Cập nhật bệnh nhân" : "Thêm bệnh nhân mới");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= title %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; padding: 20px; }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-width: 700px;
            margin: 0 auto;
        }
        .form-label { font-weight: 600; color: #555; }
        input:disabled, select:disabled {
            background-color: #e9ecef;
            color: #495057;
            border: 1px solid #ced4da;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h4 class="text-center text-success mb-4 text-uppercase"><%= title %></h4>
    
    <form action="${pageContext.request.contextPath}/admin/patient" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
        <% if(isEdit) { %>
            <input type="hidden" name="userId" value="<%= p.getUserId() %>">
        <% } %>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" 
                       value="<%= isEdit ? p.getUsername() : "" %>" 
                       <%= isEdit ? "readonly" : (isDoctor ? "disabled" : "required") %>>
            </div>
            
            <% if(!isDoctor && !isEdit) { %>
            <div class="col-md-6 mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <% } %>
        </div>

        <div class="mb-3">
            <label class="form-label">Họ và tên</label>
            <input type="text" name="fullname" class="form-control" 
                   value="<%= isEdit ? p.getFullname() : "" %>" <%= readOnlyAttr %> required>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Ngày sinh</label>
                <input type="date" name="dob" class="form-control" 
                       value="<%= isEdit ? p.getDob() : "" %>" <%= readOnlyAttr %> required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Giới tính</label>
                <select name="gender" class="form-select" <%= readOnlyAttr %>>
                    <option value="M" <%= isEdit && "M".equals(p.getGender()) ? "selected" : "" %>>Nam</option>
                    <option value="F" <%= isEdit && "F".equals(p.getGender()) ? "selected" : "" %>>Nữ</option>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input type="text" name="phonenum" class="form-control" 
                   value="<%= isEdit ? p.getPhonenum() : "" %>" <%= readOnlyAttr %> required>
        </div>

        <div class="mb-3">
            <label class="form-label">Địa chỉ</label>
            <input type="text" name="address" class="form-control" 
                   value="<%= isEdit ? p.getAddress() : "" %>" <%= readOnlyAttr %> required>
        </div>

        <div class="d-flex justify-content-end mt-4 gap-2">
            <a href="javascript:history.back()" class="btn btn-secondary">Quay lại</a>

            <% if (!isDoctor) { %>
                <button type="submit" class="btn btn-success px-4">
                    <i class="fa-solid fa-save"></i> Lưu thông tin
                </button>
            <% } %>
        </div>
    </form>
</div>

</body>
</html>