<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm ca trực</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    </head>
    <body>
        <%
            // Để highlight menu "Ca trực"
            request.setAttribute("currentPage", "shift");
        %>
        <jsp:include page="/views/shared/user_header.jsp" />

        <div class="title-box">
            <h3>THÊM CA TRỰC</h3>
        </div>

        <div class="container mt-3 mb-4" style="max-width: 700px;">
            <!-- Thông báo nếu sau này có set message/error -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title mb-3">Thông tin ca trực</h5>

                    <!-- Form thêm ca trực -->
                    <form action="${pageContext.request.contextPath}/admin/shift" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label">Ngày trực <span class="text-danger">*</span></label>
                            <!-- name="date" đúng với ShiftServlet: Date.valueOf(req.getParameter("date")) -->
                            <input type="date" name="date" class="form-control" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giờ bắt đầu <span class="text-danger">*</span></label>
                                <!-- name="start" đúng với ShiftServlet: Time.valueOf(req.getParameter("start") + ":00") -->
                                <input type="time" name="start" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giờ kết thúc <span class="text-danger">*</span></label>
                                <!-- name="end" đúng với ShiftServlet -->
                                <input type="time" name="end" class="form-control" required>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-3">
                            <a href="${pageContext.request.contextPath}/admin/shift?action=list" class="btn btn-secondary">
                                <i class="fa-solid fa-arrow-left-long me-1"></i> Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="fa-solid fa-floppy-disk me-1"></i> Lưu ca trực
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/views/shared/user_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
