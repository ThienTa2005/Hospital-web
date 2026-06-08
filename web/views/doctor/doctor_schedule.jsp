<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.entity.Shift"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lịch Trực Cá Nhân</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    <style>
        body { background-color: #F3F6F8; font-family: 'Segoe UI', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }
        .main { flex: 1; width: 100%; max-width: 1200px; margin: 0 auto; padding-bottom: 60px; }
        /* --------------------- */

        :root { --primary: #40855E; --primary-light: #E8F5E9; }
        .mini-calendar { background: #fff; border-radius: 15px; padding: 18px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .mini-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; color: var(--primary); font-weight: bold; }
        .mini-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center; }
        .mini-day { width: 36px; height: 36px; line-height: 36px; border-radius: 50%; font-size: 0.9rem; cursor: pointer; position: relative; transition: 0.2s; text-decoration: none; color: #333; display: block; margin: 0 auto; }
        .mini-day:hover { background-color: var(--primary-light); color: var(--primary); transform: scale(1.1); }
        .mini-day.selected { background-color: var(--primary); color: white; box-shadow: 0 3px 8px rgba(64, 133, 94, 0.4); }
        .mini-day.has-shift::after { content: ''; position: absolute; left: 50%; transform: translateX(-50%); bottom: 5px; width: 5px; height: 5px; background-color: #FFC107; border-radius: 50%; }

        .shift-card-day { background: white; border-radius: 15px; margin-bottom: 15px; border-left: 5px solid transparent; box-shadow: 0 2px 6px rgba(0,0,0,0.02); transition: 0.3s; }
        .shift-card-day:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .shift-card-day.today { border-left-color: var(--primary); background-color: #fafffc; }

        .date-box { background-color: var(--primary-light); color: var(--primary); padding: 10px; border-radius: 8px; text-align: center; min-width: 70px; }
        .date-box .day { font-size: 1.5rem; font-weight: 800; line-height: 1; }
        .date-box .month { font-size: 0.8rem; text-transform: uppercase; }
        
        .shift-pill { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; margin-right: 8px; margin-bottom: 5px; }
        .pill-morning { background-color: #FFF8E1; color: #F57F17; border: 1px solid #FFE082; }
        .pill-afternoon { background-color: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }
        .pill-evening { background-color: #E0F2F1; color: #00695C; border: 1px solid #80CBC4; }
    </style>
</head>
<body>
    <jsp:include page="doctor_menu.jsp" />
    <jsp:include page="/views/shared/doctor_header.jsp" />

    <%
        LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
        if (selectedDate == null) selectedDate = LocalDate.now();
        int currentMonth = (int) request.getAttribute("currentMonth");
        int currentYear = (int) request.getAttribute("currentYear");
        int daysInMonth = (int) request.getAttribute("daysInMonth");
        int startDayOfWeek = (int) request.getAttribute("startDayOfWeek");
        List<Shift> myAllShifts = (List<Shift>) request.getAttribute("myAllShifts");
        List<Shift> myWeeklyShifts = (List<Shift>) request.getAttribute("myWeeklyShifts");
        
        DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd");
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM");
        DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    %>

    <div class="main">
        <div class="container mt-4 mb-5">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="mini-calendar">
                        <div class="mini-header">
                            <a href="?selectedDate=<%= selectedDate.minusMonths(1) %>" class="btn btn-sm text-success"><i class="fa-solid fa-chevron-left"></i></a>
                            <span><%= String.format("%02d", currentMonth) %>/<%= currentYear %></span>
                            <a href="?selectedDate=<%= selectedDate.plusMonths(1) %>" class="btn btn-sm text-success"><i class="fa-solid fa-chevron-right"></i></a>
                        </div>
                        <div class="mini-grid mb-2 text-muted" style="font-size: 0.75rem;"><div>T2</div><div>T3</div><div>T4</div><div>T5</div><div>T6</div><div>T7</div><div>CN</div></div>
                        <div class="mini-grid">
                            <% for (int i = 1; i < startDayOfWeek; i++) { %><div></div><% } 
                               for (int day = 1; day <= daysInMonth; day++) {
                                   LocalDate thisDate = LocalDate.of(currentYear, currentMonth, day);
                                   boolean isSelected = thisDate.equals(selectedDate);
                                   boolean hasShift = false;
                                   if (myAllShifts != null) {
                                       for (Shift s : myAllShifts) {
                                           if (s.getShiftDate().toString().equals(thisDate.toString())) { hasShift = true; break; }
                                       }
                                   }
                            %>
                                <a href="?selectedDate=<%=thisDate%>" class="mini-day <%= isSelected ? "selected" : "" %> <%= hasShift ? "has-shift" : "" %>">
                                    <%= day %>
                                </a>
                            <% } %>
                        </div>
                        <div class="mt-3 text-center small text-muted">
                            <span style="color: #FFC107; font-size: 1.2rem;">●</span> Ngày có lịch trực
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold text-secondary"><i class="fa-solid fa-list-check me-2"></i> Lịch trực tuần này</h4>
                        <span class="badge bg-white text-muted border shadow-sm p-2">
                            <%= selectedDate.format(fullFormatter) %> <i class="fa-solid fa-arrow-right mx-1"></i> <%= selectedDate.plusDays(6).format(fullFormatter) %>
                        </span>
                    </div>

                    <% for (int i = 0; i < 7; i++) {
                        LocalDate currentDate = selectedDate.plusDays(i);
                        boolean isToday = currentDate.equals(LocalDate.now());
                        List<Shift> dayShifts = new ArrayList<>();
                        if (myWeeklyShifts != null) {
                            for (Shift s : myWeeklyShifts) {
                                if (s.getShiftDate().toString().equals(currentDate.toString())) dayShifts.add(s);
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
                                        <%= isToday ? "Hôm nay" : "Thứ " + (currentDate.getDayOfWeek().getValue() == 7 ? "CN" : currentDate.getDayOfWeek().getValue() + 1) %>
                                    </h6>
                                    <% if (dayShifts.isEmpty()) { %>
                                        <p class="text-muted small mb-0 fst-italic">Không có lịch trực.</p>
                                    <% } else { 
                                        for (Shift s : dayShifts) {
                                            String start = s.getStartTime().toString().substring(0, 5);
                                            int hour = Integer.parseInt(start.split(":")[0]);
                                            String pillClass = (hour < 12) ? "pill-morning" : (hour < 18 ? "pill-afternoon" : "pill-evening");
                                            String label = (hour < 12) ? "Ca Sáng" : (hour < 18) ? "Ca Chiều" : "Ca Tối";
                                            String icon = (hour < 12) ? "fa-sun" : (hour < 18) ? "fa-cloud-sun" : "fa-moon";
                                    %>
                                        <span class="shift-pill <%= pillClass %>">
                                            <i class="fa-solid <%= icon %> me-1"></i> <%= label %> • <%= start %> - <%= s.getEndTime().toString().substring(0, 5) %>
                                        </span>
                                    <% } } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/views/shared/user_footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>