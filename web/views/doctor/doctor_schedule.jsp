<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.servlet.http.HttpSession"%>

<%@page import="model.entity.Shift"%>
<%@page import="model.entity.Appointment"%>
<%@page import="model.entity.MedicalRecord"%>
<%@page import="model.entity.User"%>
<%@page import="model.dao.AppointmentDAO"%>
<%@page import="model.dao.MedicalRecordDAO"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lịch Trực Cá Nhân</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    <style>
        :root { --primary: #40855E; --primary-light: #E8F5E9; --bg-gray: #F8F9FA; }

        body { background-color: var(--bg-gray); }

        .mini-calendar {
            background: #fff;
            border-radius: 15px;
            padding: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .mini-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            color: var(--primary);
            font-weight: bold;
        }
        .mini-header button {
            border: none;
            background: transparent;
            color: var(--primary);
        }
        .mini-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
            text-align: center;
        }
        .mini-day {
            width: 36px;
            height: 36px;
            line-height: 36px;
            border-radius: 50%;
            font-size: 0.9rem;
            cursor: pointer;
            position: relative;
            transition: 0.2s;
        }
        .mini-day:hover {
            background-color: var(--primary-light);
            color: var(--primary);
            transform: scale(1.1);
        }
        .mini-day.selected {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 3px 8px rgba(64, 133, 94, 0.4);
        }
        .mini-day.has-shift::after {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            bottom: 5px;
            width: 8px;
            height: 4px;
            background-color: #FFC107;
            border-radius: 50%;
        }
        .mini-day.selected.has-shift::after {
            background-color: white;
        }

        .shift-card-day {
            background: white;
            border-radius: 15px;
            margin-bottom: 15px;
            border-left: 5px solid transparent;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: 0.3s;
        }
        .shift-card-day:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .shift-card-day.today {
            border-left-color: var(--primary);
            background-color: #fafffc;
        }

        .date-box {
            background-color: var(--primary-light);
            color: var(--primary);
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            min-width: 80px;
        }
        .date-box .day {
            font-size: 1.5rem;
            font-weight: 800;
            line-height: 1;
        }
        .date-box .month {
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        .shift-pill {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 999px;
            font-size: 0.85rem;
            margin-right: 8px;
            margin-top: 10px;
            margin-bottom: 5px;
            border: 1px solid transparent;
        }
        .pill-morning {
            background-color: #FFF8E1;
            color: #F57F17;
            border-color: #FFE082;
        }
        .pill-afternoon {
            background-color: #FFF3E0;
            color: #E65100;
            border-color: #FFCC80;
        }
        .pill-evening {
            background-color: #E0F2F1;
            color: #00695C;
            border-color: #80CBC4;
        }

        .btn-floating-home {
            position: fixed;
            bottom: 30px;
            right: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: white;
            color: var(--primary);
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s cubic-bezier(0.68,-0.55,0.27,1.55);
            z-index: 100;
            text-decoration: none;
            overflow: hidden;
        }
        .btn-floating-home span {
            max-width: 0;
            opacity: 0;
            font-size: 1rem;
            font-weight: 600;
            white-space: nowrap;
            transition: all 0.3s ease;
            margin-left: 0;
        }
        .btn-floating-home:hover {
            width: 160px;
            background-color: var(--primary);
            color: white;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(64, 133, 94, 0.3);
        }
        .btn-floating-home:hover span {
            max-width: 100px;
            opacity: 1;
            margin-left: 10px;
        }

        .patient-row {
            font-size: 0.9rem;
        }
        .patient-row strong {
            margin-right: 4px;
        }
    </style>
</head>
<body>

    <% request.setAttribute("currentPage", "schedule"); %>
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <%
        LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
        if (selectedDate == null) selectedDate = LocalDate.now();

        int currentMonth  = (int) request.getAttribute("currentMonth");
        int currentYear   = (int) request.getAttribute("currentYear");
        int daysInMonth   = (int) request.getAttribute("daysInMonth");
        int startDayOfWeek = (int) request.getAttribute("startDayOfWeek");

        List<Shift> myAllShifts    = (List<Shift>) request.getAttribute("myAllShifts");
        List<Shift> myWeeklyShifts = (List<Shift>) request.getAttribute("myWeeklyShifts");

        // lấy bác sĩ hiện tại
        HttpSession sess = request.getSession(false);
        User currentUser = (sess != null) ? (User) sess.getAttribute("user") : null;
        int doctorId = (currentUser != null) ? currentUser.getUserId() : 0;

        // danh sách lịch hẹn của bác sĩ
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> doctorAppointments = new ArrayList<>();
        if (doctorId > 0) {
            doctorAppointments = appointmentDAO.getAppointmentsByDoctorId(doctorId);
        }

        // map appointment -> medical record
        MedicalRecordDAO medDAO = new MedicalRecordDAO();
        Map<Integer, MedicalRecord> appointmentRecordMap = new HashMap<>();
        try {
            for (Appointment ap : doctorAppointments) {
                List<MedicalRecord> tmp = medDAO.getMedicalRecordByAppointmentId(ap.getAppointmentId());
                if (tmp != null && !tmp.isEmpty()) {
                    appointmentRecordMap.put(ap.getAppointmentId(), tmp.get(0));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        DateTimeFormatter dayFormatter   = DateTimeFormatter.ofPattern("dd");
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM");
        DateTimeFormatter fullFormatter  = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    %>

    <div class="container mt-4 mb-5">
        <div class="row">
            <!-- MINI CALENDAR -->
            <div class="col-md-4 mb-4">
                <div class="mini-calendar">
                    <div class="mini-header">
                        <%
                            LocalDate prevMonthDate = selectedDate.minusMonths(1);
                            LocalDate nextMonthDate = selectedDate.plusMonths(1);
                        %>
                        <a href="?selectedDate=<%=prevMonthDate%>" class="btn btn-sm btn-light text-success">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                        <span><%= String.format("%02d", currentMonth) %>/<%= currentYear %></span>
                        <a href="?selectedDate=<%=nextMonthDate%>" class="btn btn-sm btn-light text-success">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>

                    <div class="mini-grid mb-2 text-muted" style="font-size: 0.75rem;">
                        <div>T2</div><div>T3</div><div>T4</div><div>T5</div><div>T6</div><div>T7</div><div>CN</div>
                    </div>

                    <div class="mini-grid">
                        <%
                            int dayOfWeekCounter = 1;
                            for (int i = 1; i < startDayOfWeek; i++) {
                        %>
                            <div></div>
                        <%
                                dayOfWeekCounter++;
                            }

                            for (int day = 1; day <= daysInMonth; day++) {
                                LocalDate thisDate = LocalDate.of(currentYear, currentMonth, day);
                                String dateStr = thisDate.toString();
                                boolean isSelected = thisDate.equals(selectedDate);
                                boolean hasShift = false;

                                if (myAllShifts != null) {
                                    for (Shift s : myAllShifts) {
                                        if (s.getShiftDate().toString().equals(dateStr)) {
                                            hasShift = true;
                                            break;
                                        }
                                    }
                                }
                        %>
                            <a href="?selectedDate=<%=dateStr%>" class="text-decoration-none text-dark">
                                <div class="mini-day mx-auto <%= isSelected ? "selected" : "" %> <%= hasShift ? "has-shift" : "" %>">
                                    <%= day %>
                                </div>
                            </a>
                        <% } %>
                    </div>
                    <div class="mt-3 text-center">
                        <small class="text-muted">● Ngày có lịch trực</small>
                    </div>
                </div>
            </div>

            <!-- WEEKLY SCHEDULE -->
            <div class="col-md-8">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold text-secondary">
                        <i class="fa-solid fa-list-check me-2"></i> Lịch trực của tôi
                    </h4>
                    <span class="badge bg-white text-muted border shadow-sm p-2">
                        Tuần từ: <%= selectedDate.format(fullFormatter) %>
                        <i class="fa-solid fa-arrow-right mx-1"></i>
                        <%= selectedDate.plusDays(6).format(fullFormatter) %>
                    </span>
                </div>

                <%
                    for (int i = 0; i < 7; i++) {
                        LocalDate currentDate = selectedDate.plusDays(i);
                        String currentDateStr = currentDate.toString();
                        boolean isToday = currentDate.equals(LocalDate.now());

                        List<Shift> dayShifts = new ArrayList<>();
                        if (myWeeklyShifts != null) {
                            for (Shift s : myWeeklyShifts) {
                                if (s.getShiftDate().toString().equals(currentDateStr)) {
                                    dayShifts.add(s);
                                }
                            }
                        }
                %>
                    <div class="shift-card-day p-3 <%= isToday ? "today" : "" %>">
                        <div class="d-flex align-items-center">
                            <div class="date-box me-3">
                                <div class="day"><%= currentDate.format(dayFormatter) %></div>
                                <div class="month">T<%= currentDate.format(monthFormatter) %></div>
                            </div>

                            <div class="flex-grow-1">
                                <h6 class="fw-bold mb-2 <%= isToday ? "text-success" : "text-dark" %>">
                                    <%= isToday ? "Hôm nay" :
                                            "Thứ " + (currentDate.getDayOfWeek().getValue() == 7 ? "CN" : currentDate.getDayOfWeek().getValue() + 1) %>
                                </h6>

                                <% if (dayShifts.isEmpty()) { %>
                                    <p class="text-muted small mb-0 fst-italic">Không có lịch trực.</p>
                                <% } else { %>
                                    <div>
                                        <%
                                            for (Shift s : dayShifts) {
                                                String start = s.getStartTime().toString().substring(0, 5);
                                                int hour = Integer.parseInt(start.split(":")[0]);
                                                String pillClass = "pill-evening";
                                                String icon = "fa-moon";
                                                String label = "Ca Tối";
                                                if (hour < 12) { pillClass = "pill-morning"; icon = "fa-sun"; label = "Ca Sáng"; }
                                                else if (hour < 18) { pillClass = "pill-afternoon"; icon = "fa-cloud-sun"; label = "Ca Chiều"; }

                                                // tìm các cuộc hẹn thuộc ca này
                                                List<Appointment> shiftAppointments = new ArrayList<>();
                                                if (doctorAppointments != null) {
                                                    for (Appointment ap : doctorAppointments) {
                                                        if (ap.getShiftDate() != null &&
                                                            ap.getShiftDate().toLocalDate().equals(currentDate) &&
                                                            ap.getStartTime() != null &&
                                                            s.getStartTime() != null &&
                                                            ap.getStartTime().equals(s.getStartTime())) {
                                                            shiftAppointments.add(ap);
                                                        }
                                                    }
                                                }
                                        %>
                                            <div class="mb-2">
                                                <div>
                                                    <span class="shift-pill <%= pillClass %>" title="<%= label %>">
                                                        <i class="fa-solid <%= icon %> me-1"></i>
                                                        <%= label %> • <%= start %> - <%= s.getEndTime().toString().substring(0, 5) %>
                                                    </span>
                                                </div>

                                                <% if (shiftAppointments.isEmpty()) { %>
                                                    <div class="text-muted small ms-3 fst-italic">
                                                        Chưa có bệnh nhân đặt lịch trong ca này.
                                                    </div>
                                                <% } else { %>
                                                    <div class="mt-1 ms-2">
                                                        <% for (Appointment ap : shiftAppointments) {
                                                            MedicalRecord mr = appointmentRecordMap.get(ap.getAppointmentId());
                                                        %>
                                                            <div class="d-flex align-items-center justify-content-between py-1 border-bottom border-light patient-row">
                                                                <div>
                                                                    <strong><%= ap.getPatientName() %></strong>
                                                                    <span class="text-muted small">
                                                                        • Mã hẹn: <%= ap.getAppointmentId() %>
                                                                    </span>
                                                                </div>
                                                                <div class="btn-group btn-group-sm">
                                                                    <% if (mr == null) { %>
                                                                        <a href="<%= request.getContextPath() %>/record?appointment_id=<%= ap.getAppointmentId() %>"
                                                                           class="btn btn-outline-success btn-sm">
                                                                            Thêm hồ sơ
                                                                        </a>
                                                                    <% } else { %>
                                                                        <a href="<%= request.getContextPath() %>/record?appointment_id=<%= ap.getAppointmentId() %>"
                                                                           class="btn btn-outline-primary btn-sm">
                                                                            Sửa
                                                                        </a>
                                                                        <a href="<%= request.getContextPath() %>/record?action=delete&record_id=<%= mr.getRecordId() %>&appointment_id=<%= ap.getAppointmentId() %>&from=schedule&selectedDate=<%= selectedDate %>"
                                                                           class="btn btn-outline-danger btn-sm"
                                                                           onclick="return confirm('Bạn chắc chắn muốn xóa hồ sơ bệnh án này?');">
                                                                            Xóa
                                                                        </a>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                        <% } %>
                                                    </div>
                                                <% } %>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } // end for 7 ngày %>

                <div style="height: 50px;"></div>
            </div>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/views/doctor/doctor_dashboard.jsp"
       class="btn-floating-home" title="Quay về Dashboard">
        <i class="fa-solid fa-house"></i>
        <span>Trang chủ</span>
    </a>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
