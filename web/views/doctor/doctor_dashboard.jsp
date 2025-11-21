<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.User" %>
<%@ page import="model.entity.Doctor" %>
<%@ page import="model.dao.DoctorDAO" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Trang chủ</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

        <style>
            .left-panel, .right-panel {
                min-height: 70vh;
            }

            .left-panel {
                border-right: 2px solid #e0e0e0;
            }

            .info-box {
                background: #f8f9fa;
                border-radius: 10px;
                border: 1px solid #ddd;
                padding: 20px;
            }

            .action-table td, .action-table th {
                vertical-align: middle;
            }

            h2 {
                font-weight: 600;
            }
        </style>
    </head>
    <body>
    <jsp:include page="/views/shared/empty_header.jsp" />
    <%
        User user = (User) session.getAttribute("user");       
        Doctor doctor = null;

        if(user != null && "doctor".equals(user.getRole())) {
            DoctorDAO doctorDAO = new DoctorDAO();
            doctor = doctorDAO.getDoctorById(user.getUserId());
            request.setAttribute("doctor", doctor);
        }
    %>

        <div class="container-fluid mt-4">
            <div class="row">

                <div class="col-md-9 left-panel">
                    <h2 class="mb-4"></h2>

                    <div class="info-box p-4">
                        <p><strong>Họ tên:</strong> ${doctor.fullname}</p>
                        <p><strong>Ngày sinh:</strong> ${doctor.dob}</p>
                        <p><strong>Giới tính:</strong> ${doctor.gender}</p>
                        <p><strong>Số điện thoại:</strong> ${doctor.phonenum}</p>
                        <p><strong>Địa chỉ:</strong> ${doctor.address}</p>
                        <p><strong>Phòng ban:</strong> ${doctor.departmentName}</p>
                        <p><strong>Trình độ:</strong> ${doctor.degree}</p>
                    </div>
                    <div class="info-box p-4">
                        <p><strong>Lịch trực sắp tới</strong></p>
                    </div>
                </div>

                <div class="col-md-3 right-panel">
                    <h2 class="mb-4">Thao tác</h2>

                    <table class="table table-bordered action-table">
                        <tbody>
                            <tr>
                                <td>Trang chính</td>
                                <td><a class="btn btn-success btn-sm"  href="${pageContext.request.contextPath}/views/doctor/doctor_dashboard.jsp">Xem</a></td>
                            </tr>
                            <tr>
                                <td>Xem ca trực</td>
                                <td><a class="btn btn-success btn-sm"  href="${pageContext.request.contextPath}/views/doctor/doctor_schedule.jsp">Xem</a></td>
                            </tr>
                            <tr>
                                <td>Xem lịch hẹn</td>
                                <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                            </tr>
                            <tr>
                                <td>Cập nhật hồ sơ</td>
                                <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                            </tr>
                            <tr>
                                <td>Đăng ký lịch trực</td>
                                <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>

        <jsp:include page="/views/shared/user_footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" 
        crossorigin="anonymous"></script>

    </body>
</html>
