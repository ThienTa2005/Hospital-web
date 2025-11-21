<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.entity.ShiftDoctor"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân công Bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
</head>
<body>
    <% request.setAttribute("currentPage", "shift"); %>
    <jsp:include page="/views/shared/user_header.jsp" />

    <%
        int shiftId = (Integer) request.getAttribute("shiftId");
        List<ShiftDoctor> assignedDoctors = (List<ShiftDoctor>) request.getAttribute("assignedDoctors");
        List<Doctor> allDoctors = (List<Doctor>) request.getAttribute("allDoctors");
    %>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3><i class="fa-solid fa-user-clock"></i> PHÂN CÔNG CHO CA SỐ #<%= shiftId %></h3>
            <a href="${pageContext.request.contextPath}/admin/shift" class="btn btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-success text-white">Thêm bác sĩ vào ca</div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/shift-doctor" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="shiftId" value="<%= shiftId %>">
                            
                            <div class="mb-3">
                                <label class="form-label">Chọn Bác sĩ:</label>
                                <select name="doctorId" class="form-select" required size="10">
                                    <% if (allDoctors != null) {
                                        for (Doctor d : allDoctors) { %>
                                        <option value="<%= d.getUserId() %>">
                                            <%= d.getFullname() %> (<%= d.getDepartmentName() %>)
                                        </option>
                                    <% }} %>
                                </select>
                            </div>
                            <button class="btn btn-success w-100">Thêm ngay</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">Danh sách đang trực</div>
                    <div class="card-body p-0">
                        <table class="table table-striped mb-0">
                            <thead>
                                <tr>
                                    <th>Bác sĩ</th>
                                    <th>Chuyên khoa</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (assignedDoctors != null && !assignedDoctors.isEmpty()) {
                                    for (ShiftDoctor sd : assignedDoctors) { %>
                                <tr>
                                    <td><%= sd.getDoctorName() %></td>
                                    <td><%= sd.getDepartmentName() %></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/shift-doctor?action=remove&shiftId=<%= shiftId %>&doctorId=<%= sd.getDoctorId() %>" 
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Xóa bác sĩ này khỏi ca?');">Xóa</a>
                                    </td>
                                </tr>
                                <% }} else { %>
                                <tr><td colspan="3" class="text-center p-3">Chưa có ai.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>