<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.MedicalRecord"%>

<%
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
    MedicalRecord currentRecord = (records != null && !records.isEmpty()) ? records.get(0) : null;

    Object appIdObj = request.getAttribute("appointment_id");
    String appointmentId = (appIdObj != null)
            ? String.valueOf(appIdObj)
            : request.getParameter("appointment_id");

    int recordId = (currentRecord != null) ? currentRecord.getRecordId() : 0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập hồ sơ bệnh án</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        body { background-color: #f3f6f9; }
        .card-record {
            max-width: 720px;
            margin: 30px auto 40px auto;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
        }
        .card-header-custom {
            background-color: #40855e;
            color: #fff;
            border-radius: 12px 12px 0 0;
        }
        .btn-save {
            border-radius: 999px;
            padding: 8px 24px;
        }
    </style>
</head>
<body>

    <% request.setAttribute("currentPage", "schedule"); %>
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <div class="container mt-4 mb-5">
        <div class="card card-record">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fa-solid fa-file-medical me-2"></i>
                    Hồ sơ bệnh án cho cuộc hẹn #<%= appointmentId %>
                </h5>
                <span class="badge bg-light text-success">
                    <i class="fa-solid fa-hashtag me-1"></i> 
                    Mã hồ sơ: <%= (recordId == 0) ? "Mới" : recordId %>
                </span>
            </div>

            <div class="card-body">
                <form action="<%= request.getContextPath() %>/record" method="post">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="appointment_id" value="<%= appointmentId %>">
                    <input type="hidden" name="record_id" value="<%= recordId %>">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Chẩn đoán</label>
                        <input type="text" class="form-control"
                               name="diagnosis"
                               value="<%= (currentRecord != null) ? currentRecord.getDiagnosis() : "" %>"
                               required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ghi chú</label>
                        <textarea class="form-control" name="notes" rows="3"><%= (currentRecord != null) ? currentRecord.getNotes() : "" %></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Đơn thuốc</label>
                        <textarea class="form-control" name="prescription" rows="3"><%= (currentRecord != null) ? currentRecord.getPrescription() : "" %></textarea>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="<%= request.getContextPath() %>/doctor/schedule"
                           class="btn btn-outline-secondary">
                            ← Quay lại lịch trực
                        </a>
                        <button type="submit" class="btn btn-success btn-save">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Lưu hồ sơ
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
