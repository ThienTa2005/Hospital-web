<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.User"%>
<%@page import="model.entity.Patient"%>
<%@page import="model.entity.Shift"%>
<%@page import="model.dao.DoctorDAO"%>
<%@page import="model.dao.AppointmentDAO"%>
<%@page import="model.entity.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Trang chủ</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

        <style>
            :root {
                --primary: #40855E;
                --primary-dark: #2c6e49;
                --accent: #FFC107;
                --bg-light: #F3F6F8;
            }
            body {
                background-color: var(--bg-light);
                font-family: 'Segoe UI', sans-serif;
            }

            .welcome-card {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 10px 25px rgba(64, 133, 94, 0.3);
                position: relative;
                overflow: hidden;
            }
            .welcome-card::after {
                content: "";
                position: absolute;
                top: -50%;
                right: -10%;
                width: 300px;
                height: 300px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
            }

            .stat-card {
                background: white;
                border-radius: 16px;
                padding: 20px;
                border: none;
                box-shadow: 0 4px 15px rgba(0,0,0,0.03);
                transition: transform 0.3s;
                height: 100%;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .icon-box {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin-bottom: 15px;
            }
            .bg-icon-blue {
                background: #E3F2FD;
                color: #1976d2;
            }
            .bg-icon-orange {
                background: #FFF3E0;
                color: #F57C00;
            }
            .bg-icon-green {
                background: #E8F5E9;
                color: #43A047;
            }

            /* Timeline */
            .timeline-item {
                border-left: 3px solid #e0e0e0;
                padding-left: 20px;
                margin-bottom: 20px;
                position: relative;
            }
            .timeline-item::before {
                content: "";
                position: absolute;
                left: -6px;
                top: 5px;
                width: 9px;
                height: 9px;
                border-radius: 50%;
                background: var(--primary);
            }
            .timeline-item.active {
                border-left-color: var(--primary);
            }
            .timeline-time {
                font-weight: 700;
                color: var(--primary);
                font-size: 0.9rem;
            }

            .action-btn {
                display: flex;
                align-items: center;
                padding: 15px;
                background: white;
                border-radius: 15px;
                text-decoration: none;
                color: #333;
                border: 1px solid #eee;
                transition: all 0.2s;
            }
            .action-btn:hover {
                background: var(--bg-light);
                border-color: var(--primary);
                color: var(--primary);
                transform: translateX(5px);
            }
            .action-icon {
                font-size: 1.5rem;
                margin-right: 15px;
                color: var(--primary);
            }
        </style>
    </head>
    <body>
        <jsp:include page="/views/shared/patient_header.jsp" />

        <%
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

            User user = (User) session.getAttribute("user");
            
            Long countMonth = (Long) request.getAttribute("countMonth");
            Appointment lastVisit = (Appointment) request.getAttribute("lastVisit");
            Appointment nextVisit = (Appointment) request.getAttribute("nextVisit");
            List<Appointment> upcomingList = (List<Appointment>) request.getAttribute("upcomingList");

            String todayStr = LocalDate.now().format(DateTimeFormatter.ofPattern("dd 'tháng' MM, yyyy"));

            if(countMonth == null) countMonth = 0L;
        %>

        <div class="container mt-4 mb-5">
            <div class="row g-4">

                <div class="col-lg-8">
                    <div class="welcome-card mb-4 animate__animated animate__fadeInLeft">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="fw-bold mb-1">Xin chào, <%= user.getFullname() %>! 👋</h2>

                                <div class="d-flex gap-3 align-items-center">
                                    <span class="badge bg-white text-success rounded-pill px-3 py-2 shadow-sm">
                                        <i class="fa-regular fa-calendar me-1"></i> <%= todayStr%>
                                    </span>                                
                                </div>
                            </div>
                            <div class="col-md-4 text-center d-none d-md-block">
                                <i class="fa-solid fa-user" style="font-size: 80px; opacity: 0.9;"></i>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="icon-box bg-icon-blue"><i class="fa-solid fa-calendar-days"></i></div>
                                <h3 class="fw-bold mb-1"><%= countMonth %></h3>
                                <p class="text-muted small mb-0">Số lịch hẹn tháng này</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="icon-box bg-icon-green"><i class="fa-solid fa-calendar-check"></i></div>
                                
                                <% if (lastVisit != null) { %>
                                    <h5 class="fw-bold mb-1"><%= dateFormat.format(lastVisit.getAppointmentDate()) %></h5>
                                    <p class="text-muted small mb-0">BS. <%= lastVisit.getDoctorName() %></p>
                                <% } else { %>
                                    <h3 class="fw-bold mb-1">--</h3> 
                                    <p class="text-muted small mb-0">Chưa có lịch sử khám</p>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="icon-box bg-icon-orange"><i class="fa-solid fa-calendar-day"></i></div>
                                
                                <% if (nextVisit != null) { %>
                                    <h5 class="fw-bold mb-1 text-danger"><%= dateFormat.format(nextVisit.getAppointmentDate()) %></h5>
                                    <p class="text-muted small mb-0"><%= timeFormat.format(nextVisit.getAppointmentDate()) %> - Sắp tới</p>
                                <% } else { %>
                                    <h3 class="fw-bold mb-1">--</h3> 
                                    <p class="text-muted small mb-0">Không có lịch sắp tới</p>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3 text-secondary">Truy cập nhanh</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/profile" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-user"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Hồ sơ</h6>
                                    <small class="text-muted">Điều chỉnh thông tin cá nhân</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%= request.getContextPath()%>/book-appointment" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;">
                                    <i class="fa-solid fa-file-medical"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold m-0">Đặt lịch hẹn</h6>
                                    <small class="text-muted">Đặt lịch hẹn trực tiếp với bác sĩ</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%= request.getContextPath()%>/appointment" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-book"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Lịch sử khám bệnh</h6>
                                    <small class="text-muted">Xem lịch sử khám bệnh</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%= request.getContextPath()%>/login" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-door-open"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Đăng xuất</h6>
                                    <small class="text-muted">Đăng xuất khỏi tài khoản</small>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100 rounded-4">
                        <div class="card-header bg-white border-0 pt-4 pb-0 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-dark m-0">Lịch hẹn sắp tới</h5>
                            <span class="badge bg-light text-dark"><%= (upcomingList != null) ? upcomingList.size() : 0 %> cuộc hẹn</span>
                        </div>
                        <div class="card-body">
                            <div class="mt-3">
                                <% if (upcomingList == null || upcomingList.isEmpty()) { %>
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-calendar-xmark fa-3x mb-3 opacity-25"></i>
                                    <p>Tháng này bạn không có lịch hẹn nào sắp tới.</p>
                                </div>
                                <% } else {
                                    for (Appointment a : upcomingList) {
                                        String time = timeFormat.format(a.getAppointmentDate()) + " " + dateFormat.format(a.getAppointmentDate());
                                %>
                                <div class="timeline-item active">
                                    <div class="timeline-time"><%= time%></div>
                                    <div class="fw-bold text-dark">BS. <%= a.getDoctorName() %></div>
                                    <small class="text-muted"><i class="fa-solid fa-location-dot me-1"></i> <%= a.getDepartmentName()%></small>
                                    <div class="mt-1">
                                        <span class="badge <%= "confirmed".equalsIgnoreCase(a.getStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                            <%= a.getStatus() %>
                                        </span>
                                    </div>
                                </div>
                                <%      }
                                    }
                                %>
                            </div>

                            <div class="alert alert-info bg-opacity-10 border-0 rounded-3 mt-4">
                                <small><i class="fa-solid fa-circle-info me-1"></i> Hệ thống tự động cập nhật danh sách lịch hẹn sắp tới của bạn.</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/views/shared/user_footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>