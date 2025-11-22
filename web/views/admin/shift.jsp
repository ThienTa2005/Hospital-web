<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ca trực</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    </head>
    <body>
        <%
            // Trang hiện tại để highlight menu
            request.setAttribute("currentPage", "shift");
        %>
        <jsp:include page="/views/shared/user_header.jsp" />

        <div class="title-box">
            <h3>DANH SÁCH CA TRỰC</h3>
        </div>

        <!-- Thông báo (nếu có) -->
        <div class="container mt-2">
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
        </div>

        <!-- Thanh tìm kiếm + nút thêm ca trực -->
        <div class="container" style="margin-top: -5px; margin-bottom: 10px;">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <!-- Tìm kiếm theo ngày (bắt buộc) + giờ (không bắt buộc) -->
                    <form action="${pageContext.request.contextPath}/admin/shift" method="get" class="row gy-2 gx-2 align-items-end">
                        <input type="hidden" name="action" value="search">

                        <div class="col-auto">
                            <label class="form-label mb-0 small">Ngày trực </label>
                            <input type="date" name="date" class="form-control">
                        </div>

                        <div class="col-auto">
                            <label class="form-label mb-0 small">Giờ (không bắt buộc)</label>
                            <input type="time" name="time" class="form-control">
                        </div>

                        <div class="col-auto">
                            <button class="search-button">
                                <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>

                <div class="col-md-2"></div>

                <div class="col-md-3 text-end mt-2 mt-md-0">
                    <!-- Thêm ca trực -->
                    <a href="${pageContext.request.contextPath}/views/admin/add_shift.jsp" class="add-button">
                        <i class="fa-solid fa-house-medical me-1"></i> Thêm ca trực
                    </a>
                </div>
            </div>
        </div>




        <!-- Bảng danh sách ca trực -->
        <div class="container mb-4">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 5%;">#</th>
                            <th style="width: 10%;">Mã ca</th>
                            <th style="width: 20%;">Ngày trực</th>
                            <th style="width: 20%;">Giờ bắt đầu</th>
                            <th style="width: 20%;">Giờ kết thúc</th>
                            <th style="width: 25%;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty shifts}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    Chưa có ca trực nào.
                                </td>
                            </tr>
                        </c:if>

                        <!-- items="shifts" là List<Shift> được Servlet setAttribute -->
                        <c:forEach var="shift" items="${shifts}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${shift.shiftId}</td>
                                <td>
                                    <!-- shiftDate là java.util.Date -->
                                    <fmt:formatDate value="${shift.shiftDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>${shift.startTime}</td>
                                <td>${shift.endTime}</td>
                                <td>
                                    <!-- Sửa ca trực: dẫn tới form edit (bạn tạo edit_shift.jsp) -->
                                    <a href="${pageContext.request.contextPath}/views/admin/edit_shift.jsp?shiftId=${shift.shiftId}"
                                       class="btn btn-sm btn-warning me-1">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </a>

                                    <!-- Phân công bác sĩ cho ca trực -->
                                    <a href="${pageContext.request.contextPath}/admin/shift-doctor?action=view&shiftId=${shift.shiftId}"
                                       class="btn btn-sm btn-primary me-1">
                                        <i class="fa-solid fa-user-doctor"></i> Phân công bác sĩ
                                    </a>

                                    <!-- Xóa ca trực -->
                                    <a href="${pageContext.request.contextPath}/admin/shift?action=delete&id=${shift.shiftId}"
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa ca trực này không?');">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="/views/shared/user_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
