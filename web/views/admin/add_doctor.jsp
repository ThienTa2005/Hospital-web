<%@page import="java.util.List"%>
<%@page import="model.entity.Department"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thêm bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
</head>
<body>
<%
    request.setAttribute("currentPage", "doctor");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<div class="container mt-4">
    <h3>Thêm bác sĩ</h3>

    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div class="alert alert-danger"><%= errorMessage %></div>
    <%
        }
        List<Department> departments = (List<Department>) request.getAttribute("departments");
    %>

    <form action="${pageContext.request.contextPath}/admin/doctor" method="post">
        <input type="hidden" name="action" value="add">

        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Mật khẩu</label>
                <input type="text" name="password" class="form-control" required>
            </div>

            <div class="col-md-6 mb-3">
                <label>Họ tên</label>
                <input type="text" name="fullname" class="form-control" required>
            </div>
            <div class="col-md-3 mb-3">
                <label>Ngày sinh</label>
                <input type="date" name="dob" class="form-control" required>
            </div>
            <div class="col-md-3 mb-3">
                <label>Giới tính</label>
                <select name="gender" class="form-control">
                    <option value="M">Nam</option>
                    <option value="F">Nữ</option>
                </select>
            </div>

            <div class="col-md-6 mb-3">
                <label>Số điện thoại</label>
                <input type="text" name="phonenum" class="form-control">
            </div>
            <div class="col-md-6 mb-3">
                <label>Địa chỉ</label>
                <input type="text" name="address" class="form-control">
            </div>

            <div class="col-md-6 mb-3">
                <label>Bằng cấp</label>
                <input type="text" name="degree" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Khoa</label>
                <select name="departmentId" class="form-control">
                    <option value="">-- Chọn khoa --</option>
                    <%
                        if (departments != null) {
                            for (Department d : departments) {
                    %>
                        <option value="<%= d.getDepartmentID() %>"><%= d.getDepartmentName()%></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>

        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/admin/doctor?action=list" class="btn btn-secondary">Hủy</a>
            <button type="submit" class="btn btn-success">Lưu</button>
        </div>
    </form>
</div>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
