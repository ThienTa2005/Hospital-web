<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.entity.Department"%>

<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String searchName = (String) request.getAttribute("searchName");
    String selectedDeptId = (String) request.getAttribute("selectedDeptId");

    model.entity.Doctor selectedDoctor = (model.entity.Doctor) request.getAttribute("selectedDoctor");
    String selectedDate = (String) request.getAttribute("selectedDate");
    List<Map<String,Object>> schedules = (List<Map<String,Object>>) request.getAttribute("schedules");
    Boolean noSchedule = (Boolean) request.getAttribute("noSchedule");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch hẹn với bác sĩ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        .main {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content-wrapper {
            flex: 1;
            padding: 20px;
            box-sizing: border-box;
        }
        .header {
            background-color: #40855e;
            color: white;
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 6px;
            display: flex;
            justify-content: center;
        }
        .header h1 { margin: 0; font-size: 22px; }

        .booking-layout {
            width: 90%;
            margin: 0 auto 30px auto;
            display: grid;
            grid-template-columns: 1.1fr 1.3fr;
            grid-gap: 20px;
        }

        /* Cột danh sách bác sĩ */
        .doctor-list-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            padding: 14px 16px 18px;
        }
        .section-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #2c693b;
        }
        .search-row {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .search-row input,
        .search-row select {
            border-radius: 6px;
        }
        .btn-main {
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background: linear-gradient(135deg,#2c693b,#40855e);
            color: #fff;
            font-weight: 600;
            font-size: 13px;
        }

        .doctor-item {
            display: flex;
            gap: 10px;
            padding: 8px 6px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        .doctor-item:last-child {
            border-bottom: none;
        }
        .doctor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e0f2e7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #2c693b;
        }
        .doctor-info-title {
            font-weight: 600;
            margin-bottom: 2px;
        }
        .doctor-info-sub {
            font-size: 12px;
            color: #777;
        }
        .doctor-item.active {
            background-color: #f0f8f3;
        }

        /* Cột chi tiết bác sĩ + chọn giờ */
        .detail-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            padding: 16px 18px 20px;
            min-height: 260px;
        }
        .doctor-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .doctor-dept {
            font-size: 13px;
            color: #666;
            margin-bottom: 10px;
        }
        .small-label {
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 4px;
        }
        .hint {
            font-size: 12px;
            color: #777;
        }

        .time-slot-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
            margin-bottom: 10px;
        }
        .time-slot-btn {
            min-width: 64px;
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid #2c693b;
            background-color: #fff;
            font-size: 13px;
            cursor: pointer;
        }
        .time-slot-btn:hover {
            background-color: #e6f5ec;
        }

        .btn-confirm {
            padding: 7px 22px;
            border-radius: 999px;
            border: none;
            background-color: #2c693b;
            color: #fff;
            font-size: 14px;
        }
        .btn-confirm:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .empty-message {
            text-align: center;
            color: #777;
            margin-top: 20px;
        }

        @media (max-width: 900px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="main">
    <div class="content-wrapper">
        <div class="header">
            <h1>Đặt lịch hẹn trực tiếp với bác sĩ</h1>
        </div>

        <!-- Lỗi chung -->
        <% if (error != null) { %>
            <div class="alert alert-danger w-75 mx-auto"><%= error %></div>
        <% } %>

        <div class="booking-layout">

            <!-- CỘT 1: DANH SÁCH BÁC SĨ + TÌM KIẾM -->
            <div class="doctor-list-card">
                <div class="section-title">Chọn bác sĩ</div>

                <form class="search-row" method="get" action="<%= request.getContextPath() %>/book-appointment">
                    <input type="text" name="q" class="form-control flex-grow-1"
                           placeholder="Tìm bác sĩ, chuyên khoa..."
                           value="<%= (searchName != null ? searchName : "") %>"/>

                    <select name="dept" class="form-select" style="min-width:150px;">
                        <option value="">--Tất cả khoa--</option>
                        <%
                            if (departments != null) {
                                for (Department d : departments) {
                                    String sel = (selectedDeptId != null
                                                  && selectedDeptId.equals(String.valueOf(d.getDepartmentID())))
                                                 ? "selected" : "";
                        %>
                        <option value="<%= d.getDepartmentID() %>" <%= sel %>>
                            <%= d.getDepartmentName() %>
                        </option>
                        <%      }
                            }
                        %>
                    </select>

                    <button type="submit" class="btn-main">
                        <i class="fa-solid fa-magnifying-glass"></i> Tìm
                    </button>
                </form>

                <div style="max-height: 350px; overflow-y: auto; margin-top: 6px;">
                    <%
                        if (doctors == null || doctors.isEmpty()) {
                    %>
                        <div class="empty-message">Không tìm thấy bác sĩ phù hợp.</div>
                    <%
                        } else {
                            for (Doctor d : doctors) {
                                boolean isActive = (selectedDoctor != null && selectedDoctor.getUserId() == d.getUserId());
                    %>
                        <a class="doctor-item <%= isActive ? "active" : "" %>"
                           href="<%= request.getContextPath() %>/book-appointment?doctorId=<%= d.getUserId() %>">
                            <div class="doctor-avatar">
                                <i class="fa-solid fa-user-doctor"></i>
                            </div>
                            <div>
                                <div class="doctor-info-title"><%= d.getFullName() %></div>
                                <div class="doctor-info-sub">
                                    <%= d.getDepartmentName() != null ? d.getDepartmentName() : "Chưa có chuyên khoa" %>
                                </div>
                            </div>
                        </a>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!-- CỘT 2: THÔNG TIN BÁC SĨ + CHỌN NGÀY / GIỜ -->
            <div class="detail-card">
                <%
                    if (selectedDoctor == null) {
                %>
                    <div class="empty-message">
                        Vui lòng chọn một bác sĩ bên trái để xem lịch khám và đặt lịch.
                    </div>
                <%
                    } else {
                %>
                    <div class="doctor-name"><%= selectedDoctor.getFullname() %></div>
                    <div class="doctor-dept">
                        <i class="fa-solid fa-stethoscope"></i>
                        <%= selectedDoctor.getDepartmentName() != null ? selectedDoctor.getDepartmentName() : "Chưa có chuyên khoa" %>
                    </div>

                    <form method="get" action="<%= request.getContextPath() %>/book-appointment" class="row g-2 align-items-end mb-3">
                        <input type="hidden" name="doctorId" value="<%= selectedDoctor.getUserId() %>"/>
                        <div class="col-md-6">
                            <label class="small-label">Ngày khám</label>
                            <input type="date" name="date" class="form-control"
                                   value="<%= (selectedDate != null ? selectedDate : "") %>" required/>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn-main mt-2 w-100">
                                Xem lịch
                            </button>
                        </div>
                    </form>

                    <%
                        if (noSchedule != null && noSchedule) {
                    %>
                        <div class="empty-message">
                            Không có bác sĩ trong ca / ngày này. Vui lòng chọn ngày khác.
                        </div>
                    <%
                        } else if (schedules == null || schedules.isEmpty()) {
                    %>
                        <div class="hint">
                            Chọn ngày rồi ấn "Xem lịch" để hiển thị các khung giờ đặt khám.
                        </div>
                    <%
                        } else {
                    %>
                        <div class="small-label">Địa chỉ & chuyên khoa</div>
                        <div class="hint mb-2">
                            <%
                                Map<String,Object> first = schedules.get(0);
                                String deptName = (String) first.get("departmentName");
                                String address  = (String) first.get("address");
                            %>
                            <strong><%= deptName != null ? deptName : "" %></strong><br/>
                            <%= address != null ? address : "" %>
                        </div>

                        <div class="small-label">Chọn khung giờ khám</div>

                        <form method="post" action="<%= request.getContextPath() %>/book-appointment">
                            <input type="hidden" name="doctorId" value="<%= selectedDoctor.getUserId() %>"/>
                            <input type="hidden" name="date" value="<%= selectedDate %>"/>

                            <div class="time-slot-list">
                                <%
                                    for (Map<String,Object> row : schedules) {
                                        int shiftDoctorId = (Integer) row.get("shiftDoctorId");
                                        java.sql.Time start = (java.sql.Time) row.get("startTime");
                                        java.sql.Time end   = (java.sql.Time) row.get("endTime");
                                %>
                                    <button type="submit" name="shiftDoctorId"
                                            value="<%= shiftDoctorId %>" class="time-slot-btn">
                                        <%= start.toString().substring(0,5) %> - <%= end.toString().substring(0,5) %>
                                    </button>
                                <%
                                    }
                                %>
                            </div>

                            <div class="hint">
                                Chọn một khung giờ để xác nhận đặt lịch.
                            </div>
                        </form>
                    <%
                        }
                    %>
                <%
                    }
                %>
            </div>

        </div><!-- /.booking-layout -->

        <div class="text-center">
            <a href="<%= request.getContextPath() %>/appointment" class="btn btn-link">
                ← Quay lại danh sách lịch hẹn
            </a>
        </div>
    </div>
</div>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
