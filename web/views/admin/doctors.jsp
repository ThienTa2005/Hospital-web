<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<%--<%@page import="model.entity.Doctor"%>
<%@page import="dao.DoctorDAO"%>--%>
<%--<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>

<%--
    String deptId = request.getParameter("deptId");
    List<Doctor> doctors = null;
    if (deptId != null) {
        doctors = DoctorDAO.getDoctorsByDepartment(deptId);
        request.setAttribute("doctors", doctors);
    }
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Phòng ban</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/user_style.css">
</head>
<body>
    <jsp:include page="/views/shared/user_header.jsp" />

    <div class="container mt-5">
        <h2 class="mb-4">Danh sách bác sĩ của khoa ...</h2>

        <div class="row">
            <!-- Cột trái: danh sách bác sĩ -->
            <div class="col-md-6 border-end">
                <table class="table table-striped" id="doctorsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Chuyên môn</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <%--
                    <tbody>
                        <c:forEach var="doc" items="${doctors}">
                            <tr>
                                <td>${doc.id}</td>
                                <td>${doc.fullname}</td>
                                <td>${doc.specialty}</td>
                                <td>
                                    <button class="btn btn-sm btn-info viewDoctor" data-id="${doc.id}">
                                        View
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty doctors}">
                            <tr><td colspan="4" class="text-center text-muted">Chưa có bác sĩ nào</td></tr>
                        </c:if>
                    </tbody>
                    --%>
                </table>
            </div>

            <!-- Cột phải: load doctor_form.jsp -->
            <div class="col-md-6" id="doctorFormContainer">
                <p class="text-center mt-5 text-muted">Chọn một bác sĩ để xem chi tiết.</p>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        /*
        $(document).ready(function(){
            $('.viewDoctor').click(function(){
                const doctorId = $(this).data('id');
                $('#doctorFormContainer').load(
                    '${pageContext.request.contextPath}/views/admin/doctor_form.jsp?id=' + doctorId
                );
            });
        });
        */
    </script>
</body>
</html>
