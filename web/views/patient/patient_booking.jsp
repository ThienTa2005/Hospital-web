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
    <title>Đặt lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        /* --- FIX FOOTER --- */
        body { 
            background-color: #F3F6F8; 
            font-family: 'Segoe UI', sans-serif; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
        }
        .main { 
            flex: 1; /* Đẩy footer xuống */
            width: 100%; 
            max-width: 1200px; 
            margin: 0 auto; 
            padding-bottom: 30px; 
        }
        .content-wrapper { padding: 20px; }
        /* ---------------- */

        .header { background-color: #40855e; color: white; padding: 20px; margin-bottom: 25px; border-radius: 10px; text-align: center; }
        .header h1 { margin: 0; font-size: 24px; font-weight: 700; }
        .booking-layout { display: grid; grid-template-columns: 1fr 1.5fr; grid-gap: 25px; }
        .doctor-list-card { background-color: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 20px; }
        .search-row { display: flex; gap: 10px; margin-bottom: 15px; }
        .doctor-item { display: flex; gap: 15px; padding: 12px; border-bottom: 1px solid #f0f0f0; cursor: pointer; text-decoration: none; color: inherit; transition: 0.2s; border-radius: 8px; }
        .doctor-item:hover { background-color: #f9f9f9; }
        .doctor-item.active { background-color: #e9f6ec; border-left: 4px solid #40855e; }
        .doctor-avatar { width: 45px; height: 45px; border-radius: 50%; background: #d1e7dd; display: flex; align-items: center; justify-content: center; color: #40855e; font-size: 20px; }
        .detail-card { background-color: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; min-height: 400px; }
        .doctor-name { font-size: 22px; font-weight: 700; color: #333; margin-bottom: 5px; }
        .time-slot-list { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 15px; }
        .time-slot-btn { padding: 8px 15px; border: 1px solid #40855e; background: white; color: #40855e; border-radius: 50px; cursor: pointer; transition: 0.2s; }
        .time-slot-btn:hover { background: #40855e; color: white; }
        @media (max-width: 768px) { .booking-layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp" />

    <div class="main">
        <div class="content-wrapper">
            <div class="header"><h1><i class="fa-regular fa-calendar-check me-2"></i>Đặt lịch khám</h1></div>
            <% if (error != null) { %><div class="alert alert-danger text-center"><%= error %></div><% } %>

            <div class="booking-layout">
                <div class="doctor-list-card">
                    <h5 class="mb-3 text-success fw-bold">1. Chọn bác sĩ</h5>
                    <form class="search-row" method="get" action="<%= request.getContextPath() %>/book-appointment">
                        <input type="text" name="q" class="form-control" placeholder="Tên bác sĩ..." value="<%= (searchName != null ? searchName : "") %>">
                        <select name="dept" class="form-select" style="width: 140px;">
                            <option value="">Tất cả khoa</option>
                            <% if (departments != null) { for (Department d : departments) { String sel = (selectedDeptId != null && selectedDeptId.equals(String.valueOf(d.getDepartmentID()))) ? "selected" : ""; %>
                                <option value="<%= d.getDepartmentID() %>" <%= sel %>><%= d.getDepartmentName() %></option>
                            <% } } %>
                        </select>
                        <button type="submit" class="btn btn-success"><i class="fa-solid fa-search"></i></button>
                    </form>
                    <div style="max-height: 500px; overflow-y: auto;">
                        <% if (doctors == null || doctors.isEmpty()) { %>
                            <div class="text-center text-muted py-3">Không tìm thấy bác sĩ.</div>
                        <% } else { for (Doctor d : doctors) { boolean isActive = (selectedDoctor != null && selectedDoctor.getUserId() == d.getUserId()); %>
                            <a class="doctor-item <%= isActive ? "active" : "" %>" href="<%= request.getContextPath() %>/book-appointment?doctorId=<%= d.getUserId() %>">
                                <div class="doctor-avatar"><i class="fa-solid fa-user-md"></i></div>
                                <div><div class="fw-bold"><%= d.getFullName() %></div><div class="small text-muted"><%= d.getDepartmentName() != null ? d.getDepartmentName() : "Đa khoa" %></div></div>
                            </a>
                        <% } } %>
                    </div>
                </div>

                <div class="detail-card">
                    <h5 class="mb-3 text-success fw-bold">2. Chọn thời gian</h5>
                    <% if (selectedDoctor == null) { %>
                        <div class="empty-message text-center py-5"><p class="mt-3 text-muted">Vui lòng chọn một bác sĩ ở danh sách bên trái.</p></div>
                    <% } else { %>
                        <div class="doctor-name"><%= selectedDoctor.getFullname() %></div>
                        <p class="text-muted"><i class="fa-solid fa-hospital me-1"></i> Khoa: <%= selectedDoctor.getDepartmentName() %></p>
                        <hr>
                        <form method="get" action="<%= request.getContextPath() %>/book-appointment" class="row g-3 align-items-end mb-4">
                            <input type="hidden" name="doctorId" value="<%= selectedDoctor.getUserId() %>"/>
                            <div class="col-md-6"><label class="fw-bold mb-1">Ngày mong muốn:</label><input type="date" name="date" class="form-control" value="<%= (selectedDate != null ? selectedDate : "") %>" required onchange="this.form.submit()"/></div>
                        </form>
                        <% if (noSchedule != null && noSchedule) { %>
                            <div class="alert alert-warning">Bác sĩ không có lịch làm việc vào ngày này.</div>
                        <% } else if (schedules == null || schedules.isEmpty()) { %>
                            <p class="text-muted">Vui lòng chọn ngày để xem các khung giờ trống.</p>
                        <% } else { %>
                            <label class="fw-bold mb-2">Khung giờ còn trống:</label>
                            <form method="post" action="<%= request.getContextPath() %>/book-appointment">
                                <input type="hidden" name="doctorId" value="<%= selectedDoctor.getUserId() %>"/><input type="hidden" name="date" value="<%= selectedDate %>"/>
                                <div class="time-slot-list">
                                    <% for (Map<String,Object> row : schedules) { java.sql.Time start = (java.sql.Time) row.get("startTime"); java.sql.Time end = (java.sql.Time) row.get("endTime"); %>
                                        <button type="submit" name="shiftDoctorId" value="<%= row.get("shiftDoctorId") %>" class="time-slot-btn"><%= start.toString().substring(0,5) %> - <%= end.toString().substring(0,5) %></button>
                                    <% } %>
                                </div>
                            </form>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/views/shared/user_footer.jsp" />
</body>
</html>