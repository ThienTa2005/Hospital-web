    <%@page import="model.entity.Patient"%>
<%@page import="java.text.SimpleDateFormat"%>
    <%@page import="model.entity.Appointment"%>
    <%@page import="java.util.List"%>
    <%@page import="java.util.Date"%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Lịch sử khám bệnh</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

        <style>
            .toast-container { top: 65px !important; z-index: 1055; }
            .modal-backdrop { z-index: 2500 !important; }
            .modal { z-index: 2600 !important; }
        </style>
    </head>

    <body>
    <%
        request.setAttribute("currentPage", "appointment_list");
    %>
    <%
        Patient patient = (model.entity.Patient) request.getAttribute("patient");
        String patientName = (patient != null) ? patient.getFullname() : "Bệnh nhân";
    %>
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <main class="main-content">
        <div class="title-box"><h3>LỊCH SỬ KHÁM BỆNH CỦA <%= patientName %></h3></div>

        <table class="table-1" border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>STT</th>
                <th>Bác sĩ</th>
                <th>Khoa</th>
                <th>Bệnh nhân</th>
                <th>Ngày hẹn</th>
                <th>Giờ bắt đầu</th>
                <th>Giờ kết thúc</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
    <%
        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
        SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
        int stt = 1;

        if (appointments != null && !appointments.isEmpty()) {
            for (Appointment a : appointments) {
    %>
            <tr>
                <td><%= stt++ %></td>
                <td><%= a.getDoctorName() %></td>
                <td><%= a.getDepartmentName() %></td>
                <td><%= a.getPatientName() %></td>
                <td><%= sdfDate.format(a.getShiftDate()) %></td>
                <td><%= sdfTime.format(a.getStartTime()) %></td>
                <td><%= sdfTime.format(a.getEndTime()) %></td>
                <td><%= a.getStatus() %></td>
                <td>
                    <button class="btn btn-success btn-sm btn-view-detail" 
                            data-id="<%= a.getAppointmentId() %>">
                            Xem chi tiết
                    </button>
                </td>
            </tr>
    <%
            }
        } else {
    %>
            <tr>
                <td colspan="9" style="text-align:center; font-size: 1rem;">Không có lịch hẹn nào.</td>
            </tr>
    <%
        }
    %>
        </table>
    </main>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <div class="modal fade" id="appointmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header bg-success text-white">
              <h5 class="modal-title">Chi tiết lịch hẹn</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="modal-detail-content">
              <div class="text-center">Đang tải</div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
          </div>
        </div>
      </div>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const buttons = document.querySelectorAll(".btn-view-detail");
            const modalContent = document.getElementById("modal-detail-content");
            const basePath = "<%= request.getContextPath() %>";

            buttons.forEach(btn => {
                btn.addEventListener("click", function() {
                    const appointmentId = this.dataset.id;

                    fetch(basePath + "/doctor/appointmentDetail?id=" + appointmentId)
                    .then(response => {
                        if(!response.ok) throw new Error("Lỗi fetch");
                        return response.text();
                    })
                    .then(html => {
                        modalContent.innerHTML = html;
                        const modal = new bootstrap.Modal(document.getElementById('appointmentModal'));
                        modal.show();
                    })
                    .catch(err => {
                        console.error(err);
                        modalContent.innerHTML = "<p class='text-danger'>Không tải được chi tiết.</p>";
                    });
                });
            });
        });
    </script>
    </body>
</html>
