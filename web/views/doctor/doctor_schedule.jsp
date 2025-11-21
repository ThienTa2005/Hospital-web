<%@page import="java.time.temporal.WeekFields"%>
<%@page import="java.time.temporal.IsoFields"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.User" %>
<%@ page import="model.entity.Doctor" %>
<%@ page import="model.dao.DoctorDAO" %>
<%@ page import="java.time.*" %>
<%@ page import="java.util.*" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Lịch trực bác sĩ</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

        <style>
            .left-panel, .right-panel { min-height: 70vh; }
            .left-panel { border-right: 2px solid #e0e0e0; }
            .info-box { background: #f8f9fa; border-radius: 10px; border: 1px solid #ddd; padding: 20px; }
            table th, table td { text-align: center; vertical-align: middle; }
        </style>
    </head>
    <body>
    <jsp:include page="/views/shared/empty_header.jsp" />

    <%
        User user = (User) session.getAttribute("user");       
        Doctor doctor = null;
        if(user != null && "doctor".equals(user.getRole())) {
            DoctorDAO doctorDAO = new DoctorDAO();
            doctor = doctorDAO.getDoctorById(user.getUserId());
            request.setAttribute("doctor", doctor);
        }

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Năm và tuần được chọn
        int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : LocalDate.now().getYear();
        int selectedWeek = request.getParameter("week") != null ? Integer.parseInt(request.getParameter("week")) : LocalDate.now().get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);

        // Tính ngày đầu tuần và các ngày trong tuần
        LocalDate firstDayOfWeek = LocalDate.ofYearDay(selectedYear, 1)
                .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, selectedWeek)
                .with(DayOfWeek.MONDAY);

        List<LocalDate> weekDays = new ArrayList<>();
        for(int i=0; i<7; i++) {
            weekDays.add(firstDayOfWeek.plusDays(i));
        }

        // 24 ca giờ
        String[] shifts = new String[24];
        for(int i=0; i<24; i++) {
            int start = i;
            int end = (i+1) % 24;
            shifts[i] = start + "h - " + end + "h";
        }
    %>

    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Thoi khoa bieu -->
            <div class="col-md-9 left-panel">
                <h2 class="mb-3"><strong>Lịch làm việc</strong></h2>

                <form class="mb-3 d-flex gap-2" method="get">
                    <!-- Dropdown năm -->
                    <label for="year">Năm:</label>
                    <select id="year" name="year" class="form-control form-control-sm" style="width:100px;" onchange="this.form.submit()">
                        <% 
                        int currentYear = LocalDate.now().getYear();
                        for (int y = 2000; y <= 2050; y++) {
                            String selected = (y == selectedYear) ? "selected" : "";
                        %>
                            <option value="<%= y %>" <%= selected %>><%= y %></option>
                        <% } %>
                    </select>

                    <!-- Dropdown tuần -->
                    <label for="week">Tuần:</label>
                    <select id="week" name="week" class="form-control form-control-sm" style="width:250px;">
                        <%
                            // Số tuần tối đa của năm ISO
                            WeekFields wf = WeekFields.ISO; // ISO tuần, Thứ Hai là đầu tuần
                            LocalDate lastDayOfYear = LocalDate.of(selectedYear, 12, 31);
                            int maxWeeks = LocalDate.of(selectedYear, 12, 28).get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);

                            for (int w = 1; w <= maxWeeks; w++) {
                                // Lấy ngày đầu tuần theo ISO
                                LocalDate startOfWeek = LocalDate.of(selectedYear, 1, 4)
                                        .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, w)
                                        .with(DayOfWeek.MONDAY);

                                LocalDate endOfWeek = startOfWeek.plusDays(6);

                                // Nếu startOfWeek < 1/1, hiển thị 1/1 làm đầu tuần
                                if (startOfWeek.getYear() < selectedYear) startOfWeek = LocalDate.of(selectedYear,1,1);
                                // Nếu endOfWeek > 31/12, hiển thị 31/12 làm cuối tuần
                                if (endOfWeek.getYear() > selectedYear) endOfWeek = LocalDate.of(selectedYear,12,31);

                                String selected = (w == selectedWeek) ? "selected" : "";
                        %>
                                <option value="<%= w %>" <%= selected %>>
                                    Tuần <%= w %> (<%= startOfWeek.format(dtf) %> - <%= endOfWeek.format(dtf) %>)
                                </option>
                        <% } %>
                    </select>

                    <button type="submit" class="btn btn-success btn-sm">Xem</button>
                </form>

                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th style="width:120px;">Ca trực</th>
                            <% for(LocalDate d : weekDays) { %>
                                <th><%= d.format(dtf) %> (<%= d.getDayOfWeek().toString().substring(0,3) %>)</th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(String shift : shifts) { %>
                        <tr>
                            <td><%= shift %></td>
                            <% for(LocalDate d : weekDays) {
                                   String shiftTime = "-";  // Hiện tại chưa có dữ liệu
                            %>
                            <td><%= shiftTime %></td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!--Thao tác-->
            <div class="col-md-3 right-panel">
                <h2 class="mb-3">Thao tác</h2>
                <table class="table table-bordered action-table">
                    <tbody>
                        <tr>
                            <td>Trang chính</td>
                            <td><a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/views/doctor/doctor_dashboard.jsp">Xem</a></td>
                        </tr>
                        <tr>
                            <td>Xem ca trực</td>
                            <td><a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/views/doctor/doctor_schedule.jsp">Xem</a></td>
                        </tr>
                        <tr>
                            <td>Xem lịch hẹn</td>
                            <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                        </tr>
                        <tr>
                            <td>Cập nhật hồ sơ</td>
                            <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                        </tr>
                        <tr>
                            <td>Đăng ký lịch trực</td>
                            <td><a class="btn btn-success btn-sm" href="#">Xem</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
