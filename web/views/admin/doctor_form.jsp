<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Doctor"%>
<%@page import="dao.DoctorDAO"%>

<%
    String id = request.getParameter("id");
    Doctor doc = null;
    if (id != null) {
        doc = DoctorDAO.getDoctorById(id);
    }
%>

<% if (doc != null) { %>
    <div class="card">
        <div class="card-body">
            <h4 class="card-title mb-3">Thông tin bác sĩ</h4>
            <p><strong>ID:</strong> <%= doc.getId() %></p>
            <p><strong>Họ tên:</strong> <%= doc.getFullname() %></p>
            <p><strong>Chuyên môn:</strong> <%= doc.getSpecialty() %></p>
            <p><strong>Khoa:</strong> <%= doc.getDepartmentName() %></p>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=<%= doc.getId() %>" class="btn btn-primary btn-sm">Edit</a>
                <a href="${pageContext.request.contextPath}/admin/doctors/delete?id=<%= doc.getId() %>" class="btn btn-danger btn-sm">Delete</a>
            </div>
        </div>
    </div>
<% } else { %>
    <div class="text-center text-muted mt-4">
        Không tìm thấy thông tin bác sĩ.
    </div>
<% } %>
