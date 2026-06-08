<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.entity.User"%> <%@page import="model.entity.Patient"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.Appointment"%>
<%@page import="model.entity.MedicalRecord"%>
<%@page import="model.entity.Test"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.Period"%>

<%
    // 1. Lấy role của user hiện tại
    User currentUser = (User) session.getAttribute("user");
    String role = (currentUser != null) ? currentUser.getRole() : "";

    Appointment app = (Appointment) request.getAttribute("appointment");
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
    List<Test> tests = (List<Test>) request.getAttribute("tests");
    Patient p = (Patient) request.getAttribute("patient");

    int age = 0;
    if (p != null && p.getDob() != null) {
        age = Period.between(p.getDob().toLocalDate(), LocalDate.now()).getYears();
    }
%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết lịch hẹn</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        body { background-color: #F3F6F8; font-family: 'Segoe UI', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }
        .main { flex: 1; width: 100%; max-width: 1000px; margin: 0 auto; padding-bottom: 60px; }
        .content-wrapper { padding: 30px 20px; }
        
        .header { background-color:#40855e; color:white; padding:15px 20px; border-radius:6px; margin-bottom:25px; text-align:center;}
        .header h1 { margin:0; font-size:22px; }
        .card-section { background:#fff; border-radius:10px; box-shadow:0 4px 14px rgba(0,0,0,0.06); padding:16px 18px 20px; margin-bottom:20px; }
        h6.section-title { font-size:16px; font-weight:600; color:#2c693b; border-bottom:2px solid #198754; padding-bottom:5px; margin-bottom:12px; }
        
        .record-item { background:#f8f9fa; border-radius:8px; padding:12px; margin-bottom:10px; box-shadow:0 1px 3px rgba(0,0,0,0.1); }
        .record-item p { margin:4px 0; }
        
        .test-item { border-left: 4px solid #17a2b8; }
        
        /* Nút Quay lại */
        .btn-back {
            display: inline-flex; align-items: center;
            text-decoration: none; color: #666; font-weight: 600; margin-bottom: 15px;
        }
        .btn-back:hover { color: #40855e; }
    </style>
</head>
<body>
    
    <% if ("doctor".equals(role)) { %>
        <jsp:include page="doctor_menu.jsp" />
        <jsp:include page="/views/shared/doctor_header.jsp" />
    <% } else { %>
        <jsp:include page="../patient/patient_menu.jsp" /> <jsp:include page="/views/shared/patient_header.jsp" />
    <% } %>

    <div class="main">
        <div class="content-wrapper">
            
            <% if ("doctor".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/doctor/appointmentList" class="btn-back">
                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách quản lý
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/appointment?action=list" class="btn-back">
                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách lịch hẹn
                </a>
            <% } %>

            <div class="header"><h1>Chi tiết lịch hẹn #<%= app.getAppointmentId() %></h1></div>
            
            <div class="row">
                <div class="col-md-4">
                    <div class="card-section">
                        <h6 class="section-title"><i class="fa-solid fa-user-injured me-2"></i>Thông tin bệnh nhân</h6>
                        <% if (p != null) { %>
                            <p><strong>Họ tên:</strong> <%= p.getFullname() %></p>
                            <p><strong>Tuổi:</strong> <%= age %> | <strong>Giới tính:</strong> <%= "M".equals(p.getGender())?"Nam":"Nữ" %></p>
                            <p><strong>SĐT:</strong> <%= p.getPhonenum() %></p>
                            
                            <% if ("doctor".equals(role)) { %>
                                <div class="mt-3 text-center">
                                    <a href="${pageContext.request.contextPath}/doctor/patientHistory?patientId=<%= p.getUserId() %>" 
                                       class="btn btn-outline-success w-100 btn-sm">
                                        <i class="fa-solid fa-clock-rotate-left me-1"></i> Xem lịch sử khám cũ
                                    </a>
                                </div>
                            <% } %>
                        <% } else { %>
                            <p class="text-muted fst-italic">Không tìm thấy thông tin bệnh nhân.</p>
                        <% } %>
                    </div>

                    <div class="card-section">
                        <h6 class="section-title"><i class="fa-solid fa-calendar-check me-2"></i>Thông tin lịch hẹn</h6>
                        <p><strong>Ngày khám:</strong> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(app.getShiftDate()) %></p>
                        <p><strong>Giờ khám:</strong> <%= new java.text.SimpleDateFormat("HH:mm").format(app.getStartTime()) %></p>
                        <p><strong>Khoa:</strong> <%= app.getDepartmentName() %></p>
                        <p><strong>Trạng thái:</strong> 
                            <span class="badge <%= "completed".equalsIgnoreCase(app.getStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= app.getStatus() %>
                            </span>
                        </p>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card-section">
                        <h6 class="section-title"><i class="fa-solid fa-file-medical me-2"></i>Hồ sơ bệnh án</h6>
                        
                        <% if(records!=null && !records.isEmpty()){ %>
                            <% for(MedicalRecord r : records){ %>
                                <div class="record-item">
                                    <p><strong><i class="fa-solid fa-stethoscope text-success me-2"></i>Chẩn đoán:</strong> <%= r.getDiagnosis() %></p>
                                    <p><strong><i class="fa-regular fa-note-sticky text-warning me-2"></i>Ghi chú:</strong> <%= r.getNotes() %></p>
                                    <div class="p-2 bg-light border rounded mt-2">
                                        <strong><i class="fa-solid fa-pills text-danger me-2"></i>Đơn thuốc:</strong><br>
                                        <span style="white-space: pre-line;"><%= r.getPrescription() %></span>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-regular fa-folder-open fa-2x mb-2 opacity-25"></i>
                                <p>Chưa có hồ sơ bệnh án nào được ghi nhận.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="card-section">
                        <h6 class="section-title"><i class="fa-solid fa-flask me-2"></i>Kết quả xét nghiệm</h6>

                        <% if(tests!=null && !tests.isEmpty()) { 
                            for(Test t : tests){ %>
                                <div class="record-item test-item">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p class="mb-1"><strong>Tên:</strong> <%= t.getName() %></p>
                                            <p class="mb-1 text-muted small">TG: <%= t.getTestTime() %></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="mb-1"><strong>Kết quả:</strong> <span class="fw-bold text-primary"><%= t.getParameterValue() %></span> (<%= t.getParameter() %>)</p>
                                            <p class="mb-1 small">Đơn vị: <%= t.getUnit() %> | Ngưỡng: <%= t.getReferenceRange() %></p>
                                        </div>
                                    </div>
                                </div>
                        <% } } else { %>
                            <p class="text-muted fst-italic text-center">Không có chỉ định xét nghiệm.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>