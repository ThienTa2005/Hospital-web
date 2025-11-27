    <%@page import="model.entity.Patient"%>
    <%@page import="java.util.List"%>
    <%@page import="model.entity.Appointment"%>
    <%@page import="model.entity.MedicalRecord"%>
    <%@page import="model.entity.Test"%>
    <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

    <%
        Appointment app = (Appointment) request.getAttribute("appointment");
        List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
        List<Test> tests = (List<Test>) request.getAttribute("tests");
        Patient p = (Patient) request.getAttribute("patient");

        int age = 0;
        if (p != null && p.getDob() != null) {
            age = java.time.Period.between(p.getDob().toLocalDate(), java.time.LocalDate.now()).getYears();
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
            .main { flex-grow:1; display:flex; flex-direction:column; min-height:100vh; padding:20px; }
            .header { background-color:#40855e; color:white; padding:15px 20px; border-radius:6px; margin-bottom:25px; text-align:center;}
            .header h1 { margin:0; font-size:22px; }
            .card-section { background:#fff; border-radius:10px; box-shadow:0 4px 14px rgba(0,0,0,0.06); padding:16px 18px 20px; margin-bottom:20px; }
            h6.section-title { font-size:16px; font-weight:600; color:#2c693b; border-bottom:2px solid #198754; padding-bottom:5px; margin-bottom:12px; }
            .record-item { background:#f8f9fa; border-radius:8px; padding:12px; margin-bottom:10px; box-shadow:0 1px 3px rgba(0,0,0,0.1); }
            .record-item p { margin:4px 0; }
            .record-item .btn { margin-top:6px; }
            .btn-main { padding:6px 14px; border-radius:6px; border:none; background: linear-gradient(135deg,#2c693b,#40855e); color:#fff; font-weight:600; font-size:13px; }
            .modal-content { border-radius:10px; padding:10px; }
            .modal-header { background-color:#198754; color:#fff; border-bottom:none; border-radius:10px 10px 0 0; }
            .modal-footer { border-top:none; }
            .modal-body textarea, .modal-body input { resize:vertical; min-height:40px; }
            .medical-record-item {
                display: block !important;
            }   
        </style>
    </head>
    <body>
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <div class="main">
        <div class="header"><h1>Chi tiết lịch hẹn</h1></div>

        <!-- Thông tin bệnh nhân -->
        <div class="card-section">
            <h6 class="section-title">Thông tin bệnh nhân</h6>
            <% if (p != null) { %>
                <p><strong>Họ tên:</strong> <%= p.getFullname() %></p>
                <p><strong>Tuổi:</strong> <%= age %> | <strong>Giới tính:</strong> <%= "M".equals(p.getGender())?"Nam":"Nữ" %></p>
            <% } else { %>
                <p class="text-muted fst-italic">Không có thông tin bệnh nhân</p>
            <% } %>
            <button class="btn btn-success shadow-sm">
                <a href="${pageContext.request.contextPath}/doctor/appointmentList?patientId=<%= p != null ? p.getUserId() : "" %>" 
                   class="text-white text-decoration-none">
                    Xem lịch sử khám bệnh
                </a>
            </button>
        </div>

        <!-- Thông tin bác sĩ -->
        <div class="card-section">
            <h6 class="section-title">Thông tin bác sĩ</h6>
            <p><strong>Ngày:</strong> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(app.getShiftDate()) %></p>
            <p><strong>Bác sĩ:</strong> <%= app.getDoctorName() %> | <strong>Khoa:</strong> <%= app.getDepartmentName() %></p>
            <p><strong>Trạng thái:</strong> <%= app.getStatus() %></p>
        </div>

        <!-- Hồ sơ bệnh án -->
        <div class="card-section">
            <h6 class="section-title">Hồ sơ bệnh án</h6>
            <button class="btn btn-main btn-sm mb-2" type="button" data-bs-toggle="modal" data-bs-target="#recordModal"
                    onclick="openRecordForm('add',0)">Thêm hồ sơ bệnh án</button>

            <% if(records!=null && !records.isEmpty()){ %>
                <% for(MedicalRecord r : records){ %>
                    <div class="medical-record-item record-item">
                        <p><strong>Chẩn đoán:</strong> <%= r.getDiagnosis() %></p>
                        <p><strong>Ghi chú:</strong> <%= r.getNotes() %></p>
                        <p><strong>Đơn thuốc:</strong> <%= r.getPrescription() %></p>
                        <button class="btn btn-warning btn-sm me-1" type="button"
                                data-bs-toggle="modal" data-bs-target="#recordModal"
                                data-id="<%= r.getRecordId() %>"
                                onclick="openRecordForm('edit',<%= r.getRecordId() %>)">Sửa</button>
                        <a class="btn btn-danger btn-sm"
                           href="<%= request.getContextPath() %>/record?action=delete&record_id=<%= r.getRecordId() %>&appointment_id=<%= app.getAppointmentId() %>"
                           onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
                    </div>
                <% } %>
            <% } else { %>
                <p class="text-muted fst-italic">Chưa có hồ sơ bệnh án</p>
            <% } %>
        </div>

        <!-- Xét nghiệm -->
        <div class="card-section">
            <h6 class="section-title">Xét nghiệm</h6>
            <button class="btn btn-main btn-sm mb-2" type="button" data-bs-toggle="modal" data-bs-target="#testModal"
                    onclick="openTestForm('add',0)">Thêm xét nghiệm</button>

            <% if(tests!=null && !tests.isEmpty()) { 
                for(Test t : tests){ %>
                    <div class="record-item test-item">
                        <p><strong>Tên xét nghiệm:</strong> <%= t.getName() %></p>
                        <p><strong>Thời gian:</strong> <%= t.getTestTime() %></p>
                        <p><strong>Thông số:</strong> <%= t.getParameter() %> = <%= t.getParameterValue() %></p>
                        <p><strong>Đơn vị:</strong> <%= t.getUnit() %></p>
                        <p><strong>Giá trị tham chiếu:</strong> <%= t.getReferenceRange() %></p>
                        <button class="btn btn-warning btn-sm me-1" type="button"
                                data-bs-toggle="modal" data-bs-target="#testModal"
                                data-id="<%= t.getTestId() %>"
                                onclick="openTestForm('edit',<%= t.getTestId() %>)">Sửa</button>
                        <a class="btn btn-danger btn-sm"
                           href="<%= request.getContextPath() %>/test?action=delete&test_id=<%= t.getTestId() %>&appointment_id=<%= t.getAppointmentId() %>"
                           onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
                    </div>
            <% } } else { %>
                <p class="text-muted fst-italic">Chưa có xét nghiệm nào</p>
            <% } %>
        </div>
    </div>

    <!-- Modal Hồ sơ -->
    <div class="modal fade" id="recordModal" tabindex="-1" aria-hidden="true" style="margin-top: 60px">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/record" method="post">
                    <input type="hidden" name="action" id="modalAction" value="save">
                    <input type="hidden" name="appointment_id" value="<%= app.getAppointmentId() %>">
                    <input type="hidden" name="record_id" id="modalRecordId" value="">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Thêm hồ sơ</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-2">
                            <label>Chẩn đoán:</label>
                            <textarea name="diagnosis" id="modalDiagnosis" class="form-control" required></textarea>
                        </div>
                        <div class="mb-2">
                            <label>Ghi chú:</label>
                            <textarea name="notes" id="modalNotes" class="form-control"></textarea>
                        </div>
                        <div class="mb-2">
                            <label>Đơn thuốc:</label>
                            <textarea name="prescription" id="modalPrescription" class="form-control"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-main">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Xét nghiệm -->
    <div class="modal fade" id="testModal" tabindex="-1" aria-hidden="true" style="margin-top: 60px">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/test" method="post">
                    <input type="hidden" name="action" id="modalTestAction" value="add">
                    <input type="hidden" name="appointment_id" value="<%= app.getAppointmentId() %>">
                    <input type="hidden" name="shift_doctor_id" value="<%= app.getShiftDoctorId() %>">
                    <input type="hidden" name="test_id" id="modalTestId" value="">

                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTestTitle">Thêm xét nghiệm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-2"><label>Tên xét nghiệm:</label><input type="text" name="test_name" id="modalTestName" class="form-control" required></div>
                        <div class="mb-2"><label>Thời gian:</label><input type="datetime-local" name="test_time" id="modalTestTime" class="form-control" required></div>
                        <div class="mb-2"><label>Thông số:</label><input type="text" name="parameter" id="modalParameter" class="form-control"></div>
                        <div class="mb-2"><label>Giá trị:</label><input type="text" name="parameter_value" id="modalParameterValue" class="form-control"></div>
                        <div class="mb-2"><label>Đơn vị:</label><input type="text" name="unit" id="modalUnit" class="form-control"></div>
                        <div class="mb-2"><label>Giá trị tham chiếu:</label><input type="text" name="reference_range" id="modalReferenceRange" class="form-control"></div>
                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="card-section">
        <h6 class="section-title">Thao tác lịch hẹn</h6>
        <form action="<%= request.getContextPath() %>/doctor/appointmentAction" method="post" style="display:inline-block;">
            <input type="hidden" name="appointment_id" value="<%= app.getAppointmentId() %>">
            <input type="hidden" name="action" value="complete">
            <button type="submit" class="btn btn-success me-2" 
                    onclick="return confirm('Xác nhận đã hoàn tất việc khám cho bệnh nhân này?');">
                Hoàn tất khám
            </button>
        </form>

        <form action="<%= request.getContextPath() %>/doctor/appointmentAction" method="post" style="display:inline-block;">
            <input type="hidden" name="appointment_id" value="<%= app.getAppointmentId() %>">
            <input type="hidden" name="action" value="cancel">
            <button type="submit" class="btn btn-danger" 
                    onclick="return confirm('Xác nhận hủy lịch hẹn này?');">
                Hủy lịch hẹn
            </button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function openRecordForm(mode, recordId = '') {
        const modalTitle = document.getElementById('modalTitle');
        const modalRecordId = document.getElementById('modalRecordId');
        const modalDiagnosis = document.getElementById('modalDiagnosis');
        const modalNotes = document.getElementById('modalNotes');
        const modalPrescription = document.getElementById('modalPrescription');
        const modalAction = document.getElementById('modalAction');

        modalRecordId.value = '';
        modalDiagnosis.value = '';
        modalNotes.value = '';
        modalPrescription.value = '';

        if (mode === 'add') {
            modalTitle.textContent = 'Thêm hồ sơ bệnh án';
            modalAction.value = 'add';
        } else {
            const recordButton = document.querySelector(`.record-item button[data-id="${recordId}"]`);
            if (!recordButton) return alert("Không tìm thấy hồ sơ!");
            const recordItem = recordButton.closest('.record-item');

            modalRecordId.value = recordId;
            modalDiagnosis.value = recordItem.querySelector('p:nth-child(1)')?.textContent.replace('Chẩn đoán:', '').trim() || '';
            modalNotes.value = recordItem.querySelector('p:nth-child(2)')?.textContent.replace('Ghi chú:', '').trim() || '';
            modalPrescription.value = recordItem.querySelector('p:nth-child(3)')?.textContent.replace('Đơn thuốc:', '').trim() || '';

            if (mode === 'edit') {
                modalTitle.textContent = 'Sửa hồ sơ bệnh án';
                modalAction.value = 'update';
            } else if (mode === 'delete') {
                modalTitle.textContent = 'Xóa hồ sơ bệnh án';
                modalAction.value = 'delete';
            } else {
                return alert("Mode không hợp lệ!");
            }
        }
    }

    function openTestForm(mode, testId = '') {
        const modalTitle = document.getElementById('modalTestTitle');
        const modalTestId = document.getElementById('modalTestId');
        const modalTestName = document.getElementById('modalTestName');
        const modalTestTime = document.getElementById('modalTestTime');
        const modalParameter = document.getElementById('modalParameter');
        const modalParameterValue = document.getElementById('modalParameterValue');
        const modalUnit = document.getElementById('modalUnit');
        const modalReferenceRange = document.getElementById('modalReferenceRange');
        const formAction = document.getElementById('modalTestAction');

        modalTestId.value = '';
        modalTestName.value = '';
        modalTestTime.value = '';
        modalParameter.value = '';
        modalParameterValue.value = '';
        modalUnit.value = '';
        modalReferenceRange.value = '';

        if (mode === 'add') {
            modalTitle.textContent = 'Thêm xét nghiệm';
            formAction.value = 'add';
        } else {
            const testButton = document.querySelector(`.test-item button[data-id="${testId}"]`);
            if (!testButton) return alert("Không tìm thấy xét nghiệm!");
            const testItem = testButton.closest('.test-item');

            modalTestId.value = testId;
            modalTestName.value = testItem.querySelector('p:nth-child(1)')?.textContent.replace('Tên xét nghiệm:', '').trim() || '';
            const timeText = testItem.querySelector('p:nth-child(2)')?.textContent.replace('Thời gian:', '').trim() || '';
            const time = new Date(timeText);
            modalTestTime.value = isNaN(time) ? '' : time.toISOString().substring(0, 16);

            const paramText = testItem.querySelector('p:nth-child(3)')?.textContent.replace('Thông số:', '').trim() || '';
            if (paramText.includes('=')) {
                const [param, value] = paramText.split('=');
                modalParameter.value = param.trim();
                modalParameterValue.value = value.trim();
            }

            modalUnit.value = testItem.querySelector('p:nth-child(4)')?.textContent.replace('Đơn vị:', '').trim() || '';
            modalReferenceRange.value = testItem.querySelector('p:nth-child(5)')?.textContent.replace('Giá trị tham chiếu:', '').trim() || '';

            if (mode === 'edit') {
                modalTitle.textContent = 'Sửa xét nghiệm';
                formAction.value = 'update';
            } else if (mode === 'delete') {
                modalTitle.textContent = 'Xóa xét nghiệm';
                formAction.value = 'delete';
            } else {
                return alert("Mode không hợp lệ!");
            }
        }
    }

    </script>

    <jsp:include page="/views/shared/user_footer.jsp" />
    </body>
    </html>
