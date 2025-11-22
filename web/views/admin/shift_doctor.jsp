<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.ShiftDoctor"%>
<%@page import="model.entity.Doctor"%>

<%
    List<ShiftDoctor> assignedDoctors = (List<ShiftDoctor>) request.getAttribute("assignedDoctors");
    List<Doctor> allDoctors = (List<Doctor>) request.getAttribute("allDoctors");
    Integer shiftIdObj = (Integer) request.getAttribute("shiftId");
    int shiftId = (shiftIdObj != null) ? shiftIdObj : -1;

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String delete = request.getParameter("delete");

    request.setAttribute("currentPage", "shift"); // nếu bạn có highlight menu
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân công bác sĩ vào ca trực</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

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
        }
        .table-1 {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .table-1 th {
            background: #40855E;
            color: #fff;
            text-align: center;
            padding: 10px;
        }
        .table-1 td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .table-1 tr:nth-child(even) {
            background: #f8f8f8;
        }
        .table-1 tr:hover {
            background: #eaf6ea;
        }
        .title-box h3 {
            font-weight: 600;
        }
    </style>
</head>
<body>

<jsp:include page="/views/shared/user_header.jsp" />

<div class="container-main">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="title-box">
            <h3>Phân công bác sĩ vào ca trực</h3>
            <% if (shiftId != -1) { %>
                <p class="text-muted mb-0">
                    Ca trực ID: <strong><%= shiftId %></strong>
                </p>
            <% } %>
        </div>

        <a href="${pageContext.request.contextPath}/admin/shift?action=list"
           class="btn btn-secondary">
            Quay lại danh sách ca trực
        </a>
    </div>

    <!-- Thông báo -->
    <% if ("true".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Phân công bác sĩ vào ca trực thành công.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if ("exist".equals(error)) { %>
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            Bác sĩ này đã được phân công cho ca trực này rồi.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if ("true".equals(delete)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Đã xóa bác sĩ khỏi ca trực.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Form phân công bác sĩ -->
    <div class="card mb-4">
        <div class="card-header" style="background-color:#40855E; color:white;">
            Thêm bác sĩ vào ca trực
        </div>
        <div class="card-body">
            <% if (shiftId == -1) { %>
                <p class="text-danger mb-0">Không xác định được ca trực. Vui lòng quay lại trang danh sách ca.</p>
            <% } else { %>
                <form method="post" action="${pageContext.request.contextPath}/admin/shift-doctor">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="shiftId" value="<%= shiftId %>">

                    <div class="row align-items-end">
                        <div class="col-md-8 mb-3">
                            <label for="doctorId" class="form-label">Chọn bác sĩ</label>
                            <select id="doctorId" name="doctorId" class="form-select" required>
                                <option value="">-- Chọn bác sĩ --</option>
                                <%
                                    if (allDoctors != null && !allDoctors.isEmpty()) {
                                        for (Doctor d : allDoctors) {
                                %>
                                    <option value="<%= d.getUserId() %>">
                                        <%= d.getFullname() %>
                                        <% if (d.getDegree() != null && !d.getDegree().isEmpty()) { %>
                                            - <%= d.getDegree() %>
                                        <% } %>
                                        <% if (d.getDepartmentName() != null && !d.getDepartmentName().isEmpty()) { %>
                                            (Khoa: <%= d.getDepartmentName() %>)
                                        <% } %>
                                    </option>
                                <%
                                        }
                                    } else {
                                %>
                                    <option value="">(Chưa có bác sĩ nào trong hệ thống)</option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3 text-md-end">
                            <button type="submit" class="btn btn-success mt-3 mt-md-0">
                                <i class="fa-solid fa-plus"></i> Thêm bác sĩ
                            </button>
                        </div>
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <!-- Danh sách bác sĩ đã phân công -->
    <h5>Danh sách bác sĩ đã được phân công</h5>
    <table class="table-1">
        <thead>
            <tr>
                <th>STT</th>
                <th>Họ tên</th>
                <th>Bằng cấp</th>
                <th>Khoa</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (assignedDoctors != null && !assignedDoctors.isEmpty()) {
                int stt = 1;
                for (ShiftDoctor sd : assignedDoctors) {
        %>
            <tr>
                <td><%= stt++ %></td>
                <td><%= sd.getDoctorName() %></td>
                <td><%= sd.getDegree() == null ? "" : sd.getDegree() %></td>
                <td><%= sd.getDepartmentName() == null ? "" : sd.getDepartmentName() %></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/shift-doctor?action=remove&shiftId=<%= shiftId %>&doctorId=<%= sd.getDoctorId() %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn có chắc muốn xóa bác sĩ này khỏi ca trực?');">
                        Xóa
                    </a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="5" class="text-center text-muted">
                    Chưa có bác sĩ nào được phân công cho ca trực này.
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

</div>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
