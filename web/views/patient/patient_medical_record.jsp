<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.MedicalRecord"%>

<%
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
    MedicalRecord currentRecord = (records != null && !records.isEmpty()) ? records.get(0) : null;

    Object appIdObj = request.getAttribute("appointment_id");
    String appointmentId = (appIdObj != null)
            ? String.valueOf(appIdObj)
            : request.getParameter("appointment_id");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hồ sơ bệnh án</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    <style>
        /* GIỐNG CẤU TRÚC CÁC TRANG PATIENT KHÁC */
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
            margin-bottom: 35px;
            border-radius: 5px;
            display: flex;
            justify-content: center;
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
        }

        /* CARD CHI TIẾT HỒ SƠ – rộng 90%, căn giữa giống table ở patient_records.jsp */
        .record-container {
            width: 90%;
            margin: 0 auto 30px auto;
        }

        .record-card {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            padding: 22px 26px 26px;
        }

        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .record-header h2 {
            font-size: 20px;
            margin: 0;
            color: #2c693b;
        }

        .badge-record {
            background-color: #e9f6ec;
            color: #2c693b;
            border-radius: 999px;
            padding: 4px 12px;
            font-size: 12px;
            border: 1px solid #b4dfbe;
        }

        .sub-info {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 18px;
        }

        .field-label {
            font-weight: 600;
            margin-bottom: 4px;
            color: #444;
        }

        .field-box,
        .field-textarea {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #dde2e7;
            background-color: #f9fbfd;
            padding: 10px 12px;
            font-size: 14px;
            color: #333;
        }

        .field-textarea {
            resize: none;
            min-height: 70px;
            line-height: 1.5;
        }

        .btn-back {
            display: inline-block;
            margin-top: 18px;
            padding: 8px 24px;
            border-radius: 999px;
            border: none;
            background-color: #2c693b;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-back:hover {
            background-color: #3f8f54;
        }

        /* TRƯỜNG HỢP CHƯA CÓ HỒ SƠ */
        .empty-card {
            text-align: center;
            padding: 40px 20px 30px 20px;
        }

        .empty-card h3 {
            color: #444;
            margin-bottom: 8px;
        }

        .empty-card p {
            color: #777;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

    <!-- MAIN GIỐNG patient_records.jsp -->
    <div class="main">
        <div class="content-wrapper">
            <div class="header">
                <h1>Chi tiết hồ sơ bệnh án</h1>
            </div>

            <div class="record-container">
                <% if (currentRecord != null) { %>
                    <div class="record-card">
                        <div class="record-header">
                            <h2>Hồ sơ cho cuộc hẹn #<%= appointmentId %></h2>
                            <span class="badge-record">Mã hồ sơ: <%= currentRecord.getRecordId() %></span>
                        </div>
                        <div class="sub-info">
                            Thông tin dưới đây được bác sĩ ghi nhận sau khi thăm khám.
                        </div>

                        <div class="mb-3">
                            <div class="field-label">Chẩn đoán</div>
                            <input type="text" class="field-box" readonly
                                   value="<%= currentRecord.getDiagnosis() %>">
                        </div>

                        <div class="mb-3">
                            <div class="field-label">Ghi chú</div>
                            <textarea class="field-textarea" readonly><%= currentRecord.getNotes() %></textarea>
                        </div>

                        <div class="mb-2">
                            <div class="field-label">Đơn thuốc</div>
                            <textarea class="field-textarea" readonly><%= currentRecord.getPrescription() %></textarea>
                        </div>

                        <a href="<%= request.getContextPath() %>/appointment" class="btn-back">
                            ← Quay lại tra cứu hồ sơ
                        </a>
                    </div>
                <% } else { %>
                    <div class="record-card empty-card">
                        <h3>Chưa có hồ sơ cho cuộc hẹn này</h3>
                        <p>Bác sĩ chưa cập nhật kết quả khám. Vui lòng kiểm tra lại sau.</p>
                        <a href="<%= request.getContextPath() %>/appointment" class="btn-back">
                            ← Quay lại tra cứu hồ sơ
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
