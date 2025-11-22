<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.dao.ShiftDAO"%>
<%@page import="model.entity.Shift"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sửa ca trực</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    </head>
    <body>
        <%
            // highlight menu Ca trực
            request.setAttribute("currentPage", "shift");

            String idParam = request.getParameter("shiftId");  // từ URL: ?shiftId=...
            Shift shift = null;
            if (idParam != null) {
                try {
                    int shiftId = Integer.parseInt(idParam);
                    ShiftDAO dao = new ShiftDAO();
                    shift = dao.getShiftById(shiftId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>

        <jsp:include page="/views/shared/user_header.jsp" />

        <div class="title-box">
            <h3>CẬP NHẬT CA TRỰC</h3>
        </div>

        <div class="container mt-3 mb-4" style="max-width: 700px;">
            <%
                if (shift == null) {
            %>
                <div class="alert alert-danger">
                    Không tìm thấy ca trực cần sửa.
                </div>
                <a href="<%= request.getContextPath() %>/admin/shift?action=list" class="btn btn-secondary">
                    <i class="fa-solid fa-arrow-left-long me-1"></i> Quay lại danh sách
                </a>
            <%
                } else {
                    // Chuẩn bị giá trị cho input type="time" (HH:mm)
                    String startTimeStr = shift.getStartTime().toString();
                    if (startTimeStr.length() >= 5) startTimeStr = startTimeStr.substring(0, 5);

                    String endTimeStr = shift.getEndTime().toString();
                    if (endTimeStr.length() >= 5) endTimeStr = endTimeStr.substring(0, 5);
            %>

            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title mb-3">Thông tin ca trực</h5>

                    <!-- Form cập nhật ca trực -->
                    <form action="<%= request.getContextPath() %>/admin/shift" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= shift.getShiftId() %>">

                        <div class="mb-3">
                            <label class="form-label">Ngày trực <span class="text-danger">*</span></label>
                            <!-- shift.getShiftDate() là java.sql.Date -> toString() = yyyy-MM-dd -->
                            <input type="date" name="date" class="form-control"
                                   value="<%= shift.getShiftDate() %>" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giờ bắt đầu <span class="text-danger">*</span></label>
                                <input type="time" name="start" class="form-control"
                                       value="<%= startTimeStr %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giờ kết thúc <span class="text-danger">*</span></label>
                                <input type="time" name="end" class="form-control"
                                       value="<%= endTimeStr %>" required>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-3">
                            <a href="<%= request.getContextPath() %>/admin/shift?action=list" class="btn btn-secondary">
                                <i class="fa-solid fa-arrow-left-long me-1"></i> Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-floppy-disk me-1"></i> Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <%
                } // end else shift != null
            %>
        </div>

        <jsp:include page="/views/shared/user_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
