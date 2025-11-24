<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.Map, java.util.List, model.entity.Doctor" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thống kê</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style></style>
</head>
<body>
<jsp:include page="/views/shared/user_header.jsp" />

<div class="container mt-5">
    <h3 class="mb-3">Biểu đồ số ca trực trong tuần</h3>
    <canvas id="shiftsChart" style="width: 50%; height: 200px;"></canvas>
</div>

<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
     const labels = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"];
    const data = {
        labels: labels,
        datasets: [{
            label: 'Số ca trực',
            data: [3, 5, 2, 4, 6, 1, 0], // dữ liệu giả
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    };

    const config = {
        type: 'bar', // biểu đồ cột
        data: data,
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    stepSize: 1
                }
            }
        }
    };

    const shiftsChart = new Chart(
        document.getElementById('shiftsChart'),
        config
    );
</script>
</body>
</html>
