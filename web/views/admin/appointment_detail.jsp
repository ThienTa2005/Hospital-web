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

<h6 class="fw-bold text-success">Thông tin bệnh nhân</h6>
<% if(p != null) { %>
    <p>Họ tên: <%= p.getFullname() %></p>
    <p>Tuổi: <%= age %> | Giới tính: <%= p.getGender() %></p>
<% } else { %>
    <p class="text-muted fst-italic">Không có thông tin bệnh nhân</p>
<% } %>

<h6 class="fw-bold text-success mt-3">Thông tin lịch hẹn</h6>
<p>Ngày: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(app.getShiftDate()) %></p>
<p>Bác sĩ: <%= app.getDoctorName() %> | Khoa: <%= app.getDepartmentName() %></p>
<p>Trạng thái: <%= app.getStatus() %></p>

<h6 class="fw-bold text-success mt-3">Hồ sơ bệnh án</h6>
<% if(records != null && !records.isEmpty()) { %>
    <% for(MedicalRecord r : records) { %>
        <div class="border p-2 mb-2">
            <p><strong>Chẩn đoán:</strong><br> <%= r.getDiagnosis() %></p>
            <p><strong>Ghi chú:</strong><br> <%= r.getNotes() %></p>
            <p><strong>Đơn thuốc:</strong><br> <%= r.getPrescription() %></p>
        </div>
    <% } %>
<% } else { %>
    <p class="text-muted fst-italic">Chưa có hồ sơ bệnh án.</p>
<% } %>

<h6 class="fw-bold text-success mt-3">Xét nghiệm</h6>
<% if(tests != null && !tests.isEmpty()) { %>
    <table class="table table-sm table-bordered">
        <thead>
            <tr>
                <th>Tên xét nghiệm</th>
                <th>Thời gian</th>
                <th>Tham số</th>
                <th>Giá trị</th>
                <th>Đơn vị</th>
                <th>Giá trị bình thường</th>
            </tr>
        </thead>
        <tbody>
        <% for(Test t : tests) { %>
            <tr>
                <td><%= t.getName() %></td>
                <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(t.getTestTime()) %></td>
                <td><%= t.getParameter() %></td>
                <td><%= t.getParameterValue() %></td>
                <td><%= t.getUnit() %></td>
                <td><%= t.getReferenceRange() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
<% } else { %>
    <p class="text-muted fst-italic">Chưa có xét nghiệm nào.</p>
<% } %>
