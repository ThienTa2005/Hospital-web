<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.entity.MedicalRecord"%>
<%@page import="model.entity.Test"%>
<%@page import="java.text.SimpleDateFormat"%>

<%

    MedicalRecord record = (MedicalRecord) request.getAttribute("record");
    List<Test> tests = (List<Test>) request.getAttribute("tests");
    String appointmentId = request.getParameter("appointment_id");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hồ sơ bệnh án</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    
    <style>
        body { 
            background-color: #F3F6F8; 
            font-family: 'Segoe UI', sans-serif; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
        }
        .main { 
            flex: 1; 
            width: 100%; 
            max-width: 900px; 
            margin: 0 auto; 
            padding-bottom: 80px; 
        }
        .content-wrapper { padding: 30px 20px; }

        .medical-paper {
            background-color: white;
            border-radius: 8px; 
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            border-top: 5px solid #40855E; 
        }

        .paper-header {
            padding: 25px 30px;
            border-bottom: 2px dashed #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fcfcfc;
        }
        
        .paper-title { font-weight: 700; color: #2c5038; margin: 0; font-size: 1.5rem; }
        .paper-id { color: #888; font-family: monospace; font-size: 1rem; }

        .paper-body { padding: 30px; }

        .section-box { margin-bottom: 30px; }
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #40855E;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .diagnosis-box {
            background-color: #e9f6ec;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #40855E;
            font-weight: 600;
            color: #333;
        }

        .note-box {
            color: #555;
            line-height: 1.6;
            font-style: italic;
        }

        .prescription-list {
            background-color: #fff9e6; 
            padding: 20px;
            border: 1px solid #f0e6cc;
            border-radius: 8px;
            font-family: 'Courier New', Courier, monospace; 
            white-space: pre-line;
            color: #444;
        }

        .test-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .test-table th { background-color: #f1f1f1; padding: 10px; text-align: left; }
        .test-table td { border-bottom: 1px solid #eee; padding: 10px; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-icon { font-size: 4rem; margin-bottom: 20px; color: #ddd; }

        .back-nav { margin-top: 20px; }
        .back-nav a { text-decoration: none; color: #666; font-weight: 600; display: inline-flex; align-items: center; gap: 5px; transition: 0.2s; }
        .back-nav a:hover { color: #40855E; transform: translateX(-5px); }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp" />

    <div class="main">
        <div class="content-wrapper">
            
            <div class="back-nav mb-3">
                <a href="<%= request.getContextPath() %>/appointment?action=list">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <div class="medical-paper">
                <% if (record != null) { %>
                    <div class="paper-header">
                        <div>
                            <h2 class="paper-title"><i class="fa-solid fa-file-medical me-2"></i>Phiếu Kết Quả Khám</h2>
                            <small class="text-muted">Phòng khám Đa khoa</small>
                        </div>
                        <div class="text-end">
                            <div class="paper-id">Mã HS: #<%= record.getRecordId() %></div>
                            <div class="paper-id">Cuộc hẹn: #<%= appointmentId %></div>
                        </div>
                    </div>

                    <div class="paper-body">
                        <div class="section-box">
                            <h4 class="section-title"><i class="fa-solid fa-stethoscope"></i> Chẩn đoán & Kết luận</h4>
                            <div class="diagnosis-box">
                                <%= record.getDiagnosis() %>
                            </div>
                        </div>

                        <div class="section-box">
                            <h4 class="section-title"><i class="fa-solid fa-user-doctor"></i> Lời dặn của bác sĩ</h4>
                            <div class="note-box">
                                "<%= (record.getNotes() != null && !record.getNotes().isEmpty()) ? record.getNotes() : "Không có lời dặn thêm." %>"
                            </div>
                        </div>

                        <% if (tests != null && !tests.isEmpty()) { %>
                        <div class="section-box">
                            <h4 class="section-title"><i class="fa-solid fa-flask"></i> Kết quả xét nghiệm</h4>
                            <table class="test-table">
                                <thead>
                                    <tr>
                                        <th>Tên xét nghiệm</th>
                                        <th>Chỉ số</th>
                                        <th>Giá trị</th>
                                        <th>Đơn vị</th>
                                        <th>Ngưỡng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Test t : tests) { %>
                                    <tr>
                                        <td><%= t.getName() %></td>
                                        <td><b><%= t.getParameter() %></b></td>
                                        <td style="color: #d63384; font-weight: bold;"><%= t.getParameterValue() %></td>
                                        <td><%= t.getUnit() %></td>
                                        <td><%= t.getReferenceRange() %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>

                        <div class="section-box mb-0">
                            <h4 class="section-title"><i class="fa-solid fa-pills"></i> Đơn thuốc</h4>
                            <div class="prescription-list">
                                <%= (record.getPrescription() != null && !record.getPrescription().isEmpty()) 
                                    ? record.getPrescription() 
                                    : "Không có đơn thuốc." %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="p-3 bg-light text-center border-top">
                        <small class="text-muted">Phiếu khám này có giá trị lưu hành nội bộ.</small>
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <i class="fa-regular fa-folder-open empty-icon"></i>
                        <h3>Chưa có hồ sơ bệnh án</h3>
                        <p>Bác sĩ chưa cập nhật kết quả khám cho cuộc hẹn này.<br>Vui lòng quay lại sau khi buổi khám kết thúc.</p>
                        <a href="<%= request.getContextPath() %>/appointment?action=list" class="btn btn-primary mt-3">Quay lại danh sách</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
</body>
</html>