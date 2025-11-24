<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page import="java.util.List" %>
    <%@ page import="model.entity.Appointment" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Bệnh Nhân</title>
    <style>
        .main {
            flex-grow: 1;
            display: flex;
            flex-direction: column; 
            min-height: 100vh;    
        }

        .header {
            background-color: #40855e;
            color: white;
            padding: 15px 20px;
            margin-bottom: 50px; 
            border-radius: 5px;
            display: flex;
            justify-content: center;
        }
        
        .content-wrapper {
            flex: 1;                
            padding: 20px;
        }
    </style>
</head>
<body>

    <jsp:include page="patient_navbar.jsp"/>

    <!-- Main content -->
    <div class="main">
        <div class="content-wrapper">
            Hello World!
        </div>
        <jsp:include page="patient_footer.jsp" />
    </div>
    
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

</script>
