<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.Map, java.time.DayOfWeek, java.time.LocalDate" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thống kê</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<jsp:include page="/views/shared/user_header.jsp" />

<div class="container mt-5">
    <h3 class="mb-3">Thống kê lịch hẹn trong tuần</h3>
    <canvas id="appointmentsChart" style="width: 70%; height: 300px;"></canvas>
</div>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const labels = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"];
    
    const dataValues = [
        <% 
            Map<LocalDate, Integer> map = (Map<LocalDate, Integer>) request.getAttribute("appointmentsPerDay");
            for (LocalDate date = LocalDate.now().with(DayOfWeek.MONDAY); 
                 !date.isAfter(LocalDate.now().with(DayOfWeek.SUNDAY)); 
                 date = date.plusDays(1)) {
                int count = map.getOrDefault(date, 0);
                out.print(count);
                if (!date.equals(LocalDate.now().with(DayOfWeek.SUNDAY))) out.print(",");
            }
        %>
    ];

    const data = {
        labels: labels,
        datasets: [{
            label: 'Số lịch hẹn',
            data: dataValues,
            backgroundColor: 'rgba(144, 238, 144, 0.5)',
            borderColor: 'rgba(144, 238, 144, 1)',
            borderWidth: 1
        }]
    };

    const config = {
        type: 'bar',
        data: data,
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    stepSize: 1,
                    ticks: {
                    stepSize: 1, 
                    callback: function(value) {
                        return Number.isInteger(value) ? value : null;
                    }
                }
                }
            }
        }
    };

    const appointmentsChart = new Chart(
        document.getElementById('appointmentsChart'),
        config
    );
</script>
</body>
</html>
