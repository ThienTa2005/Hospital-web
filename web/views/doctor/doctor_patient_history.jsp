<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.entity.Patient"%>
<%@page import="model.entity.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử bệnh nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    <style>
        body { background-color: #F3F6F8; font-family: 'Segoe UI', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }
        .main { flex: 1; width: 100%; max-width: 1000px; margin: 0 auto; padding-bottom: 60px; }
        .content-wrapper { padding: 30px 20px; }
        .history-table { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .history-table th { background: #40855e; color: white; font-weight: 600; text-align: center; }
        .history-table td { vertical-align: middle; }
        .status-completed { color: #198754; background: #d1e7dd; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .status-cancelled { color: #dc3545; background: #fadbd8; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
    </style>
</head>
<body>
    <jsp:include page="doctor_menu.jsp" />
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <%
        Patient p = (Patient) request.getAttribute("patient");
        List<Appointment> historyList = (List<Appointment>) request.getAttribute("historyList");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>

    <div class="main">
        <div class="content-wrapper">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-success m-0"><i class="fa-solid fa-file-medical-alt me-2"></i>Lịch sử khám bệnh</h3>
                <a href="javascript:history.back()" class="btn btn-outline-secondary rounded-pill"><i class="fa-solid fa-arrow-left me-2"></i>Quay lại</a>
            </div>

            <% if (p != null) { %>
                <div class="alert alert-success shadow-sm mb-4">
                    Đang xem lịch sử của bệnh nhân: <strong><%= p.getFullname() %></strong> - SĐT: <%= p.getPhonenum() %>
                </div>
            <% } %>

            <div class="table-responsive history-table">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Ngày khám</th>
                            <th>Bác sĩ</th>
                            <th>Khoa</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (historyList != null && !historyList.isEmpty()) {
                            for (Appointment a : historyList) { %>
                            <tr>
                                <td><%= sdf.format(a.getAppointmentDate()) %></td>
                                <td><%= a.getDoctorName() %></td>
                                <td><%= a.getDepartmentName() %></td>
                                <td class="text-center">
                                    <span class="status-<%= a.getStatus() %>"><%= a.getStatus() %></span>
                                </td>
                                <td class="text-center">
                                    <% if ("completed".equalsIgnoreCase(a.getStatus())) { %>
                                        <a href="<%= request.getContextPath() %>/doctor/appointmentDetail?id=<%= a.getAppointmentId() %>" 
                                           class="btn btn-sm btn-primary">
                                            <i class="fa-solid fa-eye"></i> Xem chi tiết
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted">--</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">Bệnh nhân chưa có lịch sử khám nào.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>