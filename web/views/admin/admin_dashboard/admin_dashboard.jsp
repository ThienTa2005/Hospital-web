    <%@page import="java.time.ZoneId"%>
<%@page import="java.time.LocalTime"%>
    <%@page import="java.time.LocalDateTime"%>
    <%@page import="model.entity.ShiftDoctor"%>
    <%@page import="model.dao.ShiftDAO"%>
    <%@page import="java.time.LocalDate"%>
    <%@page import="model.entity.Appointment"%>
    <%@page import="model.dao.AppointmentDAO"%>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@page import="model.entity.User"%>
    <%@page import="model.entity.Doctor"%>
    <%@page import="model.entity.Shift"%>
    <%@page import="model.dao.DoctorDAO"%>
    <%@page import="model.dao.ShiftDoctorDAO"%>
    <%@page import="java.util.List"%>
    <%@page import="java.util.ArrayList"%>
    <%@page import="java.sql.Time"%>
    <%@page import="java.time.format.DateTimeFormatter"%>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Trang chủ</title>

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
            body { background-color: var(--bg-light); font-family: 'Segoe UI', sans-serif; }

            /* Hero Card */
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
                content: ""; position: absolute; top: -50%; right: -10%; width: 300px; height: 300px;
                background: rgba(255,255,255,0.1); border-radius: 50%;
            }

            /* Stat cards */
            .stat-card {
                background: white; border-radius: 16px; padding: 20px;
                border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.03);
                transition: transform 0.3s;
                height: 100%;
            }
            .stat-card:hover { transform: translateY(-5px); }
            .icon-box {
                width: 50px; height: 50px; border-radius: 12px;
                display: flex; align-items: center; justify-content: center;
                font-size: 1.5rem; margin-bottom: 15px;
            }
            .bg-icon-blue { background: #E3F2FD; color: #1E88E5; }
            .bg-icon-orange { background: #FFF3E0; color: #F57C00; }
            .bg-icon-green { background: #E8F5E9; color: #43A047; }

            /* Timeline */
            .timeline-item {
                border-left: 3px solid #e0e0e0; padding-left: 20px; margin-bottom: 20px; position: relative;
            }
            .timeline-item::before {
                content: ""; position: absolute; left: -6px; top: 5px;
                width: 9px; height: 9px; border-radius: 50%; background: var(--primary);
            }
            .timeline-item.active { border-left-color: var(--primary); }
            .timeline-time { font-weight: 700; color: var(--primary); font-size: 0.9rem; }

            /* Action buttons */
            .action-btn {
                display: flex; align-items: center; padding: 15px;
                background: white; border-radius: 15px; text-decoration: none;
                color: #333; border: 1px solid #eee; transition: all 0.2s;
            }
            .action-btn:hover {
                background: var(--bg-light); border-color: var(--primary); color: var(--primary);
                transform: translateX(5px);
            }
            .action-icon { font-size: 1.5rem; margin-right: 15px; color: var(--primary); }
        </style>
    </head>
    <body>
        <%
            request.setAttribute("currentPage", "dashboard");
        %>
        <jsp:include page="/views/shared/user_header.jsp" />
        
    <%
        User user = (User) session.getAttribute("user");        
        Doctor doctor = null; 

        String docName = (doctor != null) ? doctor.getFullname() : (user != null ? user.getFullname() : "Admin");
        String todayStr = LocalDate.now().format(DateTimeFormatter.ofPattern("dd 'tháng' MM, yyyy"));
        
         LocalDate today = LocalDate.now();

        Integer doctorsOnShiftNowCount = (Integer) request.getAttribute("doctorsOnShiftNowCount");
        Integer appointmentsTodayCount = (Integer) request.getAttribute("appointmentsTodayCount");

        List<Appointment> appointmentsTodayList = (List<Appointment>) request.getAttribute("appointmentsTodayList");
        
        System.out.println("Số bác sĩ đang trực: " + (doctorsOnShiftNowCount != null ? doctorsOnShiftNowCount : 0));
        System.out.println("Số lịch hẹn hôm nay: " + (appointmentsTodayCount != null ? appointmentsTodayCount : 0));
    %>

        <div class="container mt-4 mb-5">
            <div class="row g-4">

                <div class="col-lg-8">
                    <div class="welcome-card mb-4 animate__animated animate__fadeInLeft">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="fw-bold mb-1">Xin chào, <%= docName %>! 👋</h2>
                                <div class="d-flex gap-3 align-items-center">
                                    <span class="badge bg-white text-success rounded-pill px-3 py-2 shadow-sm">
                                        <i class="fa-regular fa-calendar me-1"></i> <%= todayStr %>
                                    </span>                              
                                    <%-- if (isOnShift) { %>
                                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm animate__animated animate__pulse animate__infinite">
                                            <i class="fa-solid fa-clock me-1"></i> <strong>Đang trong ca trực</strong>
                                        </span>
                                    <% } else { %>
                                        <span class="badge bg-success bg-opacity-25 text-white border border-white rounded-pill px-3 py-2">
                                            <i class="fa-solid fa-mug-hot me-1"></i> Đang nghỉ ngơi
                                        </span>
                                    <% } --%>
                                </div>
                            </div>
                            <div class="col-md-4 text-center d-none d-md-block">
                                <i class="fa-solid fa-user-tie" style="font-size: 80px; opacity: 0.9;"></i>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <!-- Số bác sĩ đang trực -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin/working_doctors" class="action-btn shadow-sm">
                                <div class="stat-card m-0 w-100">
                                    <div class="icon-box bg-icon-blue"><i class="fa-solid fa-user-doctor"></i></div>
                                    <h3 class="fw-bold mb-1">
                                        <%= request.getAttribute("doctorsOnShiftNowCount") != null 
                                            ? request.getAttribute("doctorsOnShiftNowCount") 
                                            : 0 %>
                                    </h3>
                                    <p class="text-muted small mb-0">Số bác sĩ có ca trực hiện tại</p>
                                </div>
                            </a>        
                        </div>

                        <!-- Số lịch hẹn hôm nay -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin/visiting_patients" class="action-btn shadow-sm">
                                <div class="stat-card m-0 w-100">
                                    <div class="icon-box bg-icon-green"><i class="fa-solid fa-calendar-days"></i></div>
                                    <h3 class="fw-bold mb-1">
                                        <%= request.getAttribute("appointmentsTodayCount") != null 
                                            ? request.getAttribute("appointmentsTodayCount") 
                                            : 0 %>
                                    </h3>
                                    <p class="text-muted small mb-0">Số lịch hẹn hôm nay</p>
                                </div>
                            </a>
                        </div>

                        <!-- Link báo cáo -->
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin/report" class="action-btn shadow-sm">
                                <div class="stat-card m-0 w-100 text-center" style="height: 188px;"> 
                                    <div class="icon-box bg-icon-orange"><i class="fa-solid fa-clipboard-list"></i></div>
                                    <h6 class="fw-bold mb-1 text-success" style="margin: 0;">Xem thống kê</h6> 
                                    <p class="text-muted small mb-0">Thống kê lịch hẹn trong tuần</p>
                                </div>
                            </a>
                        </div>
                    </div>


                    <h5 class="fw-bold mb-3 text-secondary">Truy cập nhanh</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/admin/user" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-users"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Danh sách người dùng</h6>
                                    <small class="text-muted">Thông tin người dùng</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/admin/shift" class="action-btn shadow-sm" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-calendar-days"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Xem ca trực</h6>
                                    <small class="text-muted">Điều phối ca trực</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/admin/department" class="action-btn shadow-sm" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-hospital"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Danh sách phòng ban</h6>
                                    <small class="text-muted">Các phòng ban thuộc phòng khám</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/admin/patient" class="action-btn shadow-sm" class="action-btn shadow-sm">
                                <div class="action-icon text-success" style="font-size: 2rem;"><i class="fa-solid fa-user-injured"></i></div>
                                <div>
                                    <h6 class="fw-bold m-0">Hồ sơ Bệnh nhân</h6>
                                    <small class="text-muted">Xem lịch sử khám và bệnh án</small>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100 rounded-4">
                        <div class="card-header bg-white border-0 pt-4 pb-0 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-dark m-0">Các lịch hẹn đang diễn ra</h5>                       
                        </div>
                        <div class="card-body">
                            <div class="mt-3">
                            <%
                               boolean hasCurrent = false;
                               LocalTime now = LocalTime.now(); // thời gian hiện tại

                                for (Appointment appt : appointmentsTodayList) {
                                    if (appt.getShiftDate() != null && appt.getShiftDate().toLocalDate().isEqual(today)) { // lọc lịch hôm nay
                                        if (appt.getStartTime() != null && appt.getEndTime() != null) { // lọc lịch trong khung giờ hiện tại
                                            java.time.LocalTime start = appt.getStartTime().toLocalTime();
                                            java.time.LocalTime end = appt.getEndTime().toLocalTime();

                                            if (!now.isBefore(start) && !now.isAfter(end)) {
                                                hasCurrent = true;
                                                String timeRange = start.toString().substring(0,5) + " - " + end.toString().substring(0,5);
                            %>
                                <div class="timeline-item active animate__animated animate__pulse animate__infinite">
                                    <div class="timeline-time"><%= timeRange %>
                                        <span class="timeline-badge">Đang diễn ra</span>
                                    </div>
                                    <div class="fw-bold text-dark">Bác sĩ: <%= appt.getDoctorName() %></div>
                                    <div class="fw-bold text-dark">Bệnh nhân: <%= appt.getPatientName() %></div>
                                    <small class="text-muted"><i class="fa-solid fa-notes-medical me-1"></i> Trạng thái: <%= appt.getStatus() %></small>
                                </div>
                            <%
                                            }
                                        }
                                    }
                                }

                                if (!hasCurrent) {
                            %>
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-calendar-xmark fa-3x mb-3 opacity-25"></i>
                                    <p>Không có lịch hẹn nào đang diễn ra.</p>
                                </div>
                            <%
                                }
                            %>
                            </div>

                            <div class="alert alert-info bg-opacity-10 border-0 rounded-3 mt-4">
                                <small><i class="fa-solid fa-circle-info me-1"></i> Hệ thống tự động cập nhật trạng thái dựa trên giờ hiện tại.</small>
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