<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    
    <style>
        /* Layout Fix */
        body { background-color: #F3F6F8; font-family: 'Segoe UI', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }
        .main { flex: 1; width: 100%; max-width: 1200px; margin: 0 auto; padding-bottom: 60px; }
        .content-wrapper { padding: 20px 0; }

        /* Tabs Custom */
        .nav-pills .nav-link { color: #555; font-weight: 600; border-radius: 8px; padding: 10px 20px; margin-right: 10px; background: #fff; border: 1px solid #eee; }
        .nav-pills .nav-link.active { background-color: #40855E; color: white; border-color: #40855E; box-shadow: 0 4px 10px rgba(64, 133, 94, 0.3); }
        
        /* Card Style */
        .appt-card { background: white; border-radius: 12px; padding: 20px; margin-bottom: 15px; border-left: 5px solid #ccc; box-shadow: 0 2px 5px rgba(0,0,0,0.03); transition: 0.2s; }
        .appt-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.08); }
        
        .border-pending { border-left-color: #ffc107; }
        .border-confirmed { border-left-color: #0d6efd; }
        .border-completed { border-left-color: #198754; }
        .border-cancelled { border-left-color: #dc3545; }
        
        .time-badge { background: #f0f2f5; padding: 5px 10px; border-radius: 6px; font-weight: 700; color: #333; font-size: 0.9rem; }
    </style>
</head>
<body>
    <jsp:include page="doctor_menu.jsp" />
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <%
        List<Appointment> pendingList = (List<Appointment>) request.getAttribute("pendingList");
        List<Appointment> confirmedList = (List<Appointment>) request.getAttribute("confirmedList");
        List<Appointment> historyList = (List<Appointment>) request.getAttribute("historyList");
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm");
        
        String msg = request.getParameter("msg");
    %>

    <div class="main">
        <div class="content-wrapper">
            <h3 class="text-center mb-4" style="color: #40855E; font-weight: 700; text-transform: uppercase;">Quản lý lịch hẹn khám</h3>
            
            <% if("updated".equals(msg)) { %>
                <div class="alert alert-success text-center" style="max-width: 600px; margin: 0 auto 20px auto;">Cập nhật thành công!</div>
            <% } else if("exam_success".equals(msg)) { %>
                <div class="alert alert-success text-center" style="max-width: 600px; margin: 0 auto 20px auto;">Đã lưu bệnh án thành công!</div>
            <% } %>

            <ul class="nav nav-pills mb-4 justify-content-center" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" id="tab-confirmed" data-bs-toggle="pill" data-bs-target="#pills-confirmed" type="button">
                        <i class="fa-solid fa-stethoscope me-2"></i>Chờ khám (<%= confirmedList != null ? confirmedList.size() : 0 %>)
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="tab-pending" data-bs-toggle="pill" data-bs-target="#pills-pending" type="button">
                        <i class="fa-regular fa-clock me-2"></i>Chờ duyệt (<%= pendingList != null ? pendingList.size() : 0 %>)
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="tab-history" data-bs-toggle="pill" data-bs-target="#pills-history" type="button">
                        <i class="fa-solid fa-history me-2"></i>Lịch sử
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                
                <div class="tab-pane fade show active" id="pills-confirmed">
                    <% if (confirmedList == null || confirmedList.isEmpty()) { %>
                        <div class="text-center text-muted py-5">
                            <i class="fa-solid fa-user-check fa-3x mb-3 opacity-25"></i>
                            <p>Chưa có bệnh nhân nào đang chờ khám.</p>
                        </div>
                    <% } else { 
                        for (Appointment a : confirmedList) { %>
                        <div class="appt-card border-confirmed">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="time-badge me-2"><i class="fa-regular fa-clock me-1"></i><%= timeSdf.format(a.getAppointmentDate()) %> - <%= sdf.format(a.getAppointmentDate()) %></span>
                                    <h5 class="mt-2 mb-1 fw-bold text-primary"><%= a.getPatientName() %></h5>
                                    <small class="text-muted"><i class="fa-solid fa-file-medical me-1"></i> Mã: #<%= a.getAppointmentId() %></small>
                                </div>
                                <div>
                                    <button class="btn btn-success px-4 py-2 fw-bold shadow-sm" 
                                            onclick="openExamModal('<%= a.getAppointmentId() %>', '<%= a.getPatientName() %>')">
                                        <i class="fa-solid fa-user-doctor me-2"></i>KHÁM NGAY
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } } %>
                </div>

                <div class="tab-pane fade" id="pills-pending">
                    <% if (pendingList == null || pendingList.isEmpty()) { %>
                        <div class="text-center text-muted py-5">Không có yêu cầu mới.</div>
                    <% } else { 
                        for (Appointment a : pendingList) { %>
                        <div class="appt-card border-pending">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="time-badge me-2"><%= timeSdf.format(a.getAppointmentDate()) %> - <%= sdf.format(a.getAppointmentDate()) %></span>
                                    <h5 class="mt-2 mb-1"><%= a.getPatientName() %></h5>
                                    <p class="mb-0 text-warning fw-bold small"><i class="fa-solid fa-circle-pause me-1"></i>Chờ xác nhận</p>
                                </div>
                                <div>
                                    <form action="appointmentList" method="post" class="d-inline">
                                        <input type="hidden" name="id" value="<%= a.getAppointmentId() %>">
                                        <input type="hidden" name="action" value="confirm">
                                        <button class="btn btn-primary btn-sm me-2"><i class="fa-solid fa-check me-1"></i>Duyệt</button>
                                    </form>
                                    <form action="appointmentList" method="post" class="d-inline">
                                        <input type="hidden" name="id" value="<%= a.getAppointmentId() %>">
                                        <input type="hidden" name="action" value="cancel">
                                        <button class="btn btn-outline-danger btn-sm" onclick="return confirm('Hủy lịch này?')"><i class="fa-solid fa-xmark"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } } %>
                </div>

                <div class="tab-pane fade" id="pills-history">
                    <% if (historyList == null || historyList.isEmpty()) { %>
                        <div class="text-center text-muted py-5">Chưa có lịch sử khám.</div>
                    <% } else { 
                        for (Appointment a : historyList) { 
                           String statusClass = "completed".equals(a.getStatus()) ? "border-completed" : "border-cancelled";
                           String statusText = "completed".equals(a.getStatus()) ? "Đã khám xong" : "Đã hủy";
                           String statusColor = "completed".equals(a.getStatus()) ? "text-success" : "text-danger";
                    %>
                        <div class="appt-card <%= statusClass %>" style="opacity: 0.8;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="time-badge me-2"><%= timeSdf.format(a.getAppointmentDate()) %> - <%= sdf.format(a.getAppointmentDate()) %></span>
                                    <h5 class="mt-2 mb-1"><%= a.getPatientName() %></h5>
                                    <p class="mb-0 fw-bold small <%= statusColor %>"><%= statusText %></p>
                                </div>
                                <% if ("completed".equals(a.getStatus())) { %>
                                    <a href="<%= request.getContextPath() %>/doctor/appointmentDetail?id=<%= a.getAppointmentId() %>" class="btn btn-outline-secondary btn-sm">Xem lại hồ sơ</a>
                                <% } %>
                            </div>
                        </div>
                    <% } } %>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="examModal" tabindex="-1" data-bs-backdrop="static">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/doctor/examine" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title m-0"><i class="fa-solid fa-user-doctor me-2"></i>Thực hiện khám bệnh</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="appointment_id" id="modalAppId">
                        
                        <div class="alert alert-success py-2 mb-3">
                            Đang khám cho bệnh nhân: <strong id="modalPatientName" style="text-transform: uppercase;">...</strong>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">1. Chẩn đoán / Kết luận <span class="text-danger">*</span></label>
                            <input type="text" name="diagnosis" class="form-control" required placeholder="Ví dụ: Viêm họng cấp...">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">2. Triệu chứng / Ghi chú</label>
                                <textarea name="notes" class="form-control" rows="4" placeholder="Sốt, ho, đau họng..."></textarea>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">3. Đơn thuốc / Điều trị</label>
                                <textarea name="prescription" class="form-control" rows="4" placeholder="Tên thuốc - Liều lượng..."></textarea>
                            </div>
                        </div>

                        <hr>
                        
                        <label class="form-label fw-bold text-primary"><i class="fa-solid fa-flask me-2"></i>4. Chỉ định xét nghiệm (Nếu có)</label>
                        <div id="test-container">
                            </div>
                        <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addTestRow()">
                            <i class="fa-solid fa-plus"></i> Thêm chỉ định
                        </button>

                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success px-4 fw-bold">
                            <i class="fa-solid fa-check me-2"></i>HOÀN TẤT KHÁM
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function openExamModal(id, name) {
            document.getElementById('modalAppId').value = id;
            document.getElementById('modalPatientName').textContent = name;
            var myModal = new bootstrap.Modal(document.getElementById('examModal'));
            myModal.show();
        }

        function addTestRow() {
            const container = document.getElementById('test-container');
            const div = document.createElement('div');
            div.className = 'd-flex gap-2 mb-2';
            div.innerHTML = `
                <input type="text" name="test_name[]" class="form-control" placeholder="Tên xét nghiệm (VD: Công thức máu)">
                <input type="text" name="test_param[]" class="form-control" placeholder="Chỉ số cần đo (nếu có)">
                <button type="button" class="btn btn-outline-danger" onclick="this.parentElement.remove()"><i class="fa-solid fa-trash"></i></button>
            `;
            container.appendChild(div);
        }
    </script>
</body>
</html>