<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>403 - Không có quyền truy cập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            max-width: 500px;
            width: 100%;
        }
        h1 {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 10px;
        }
        h2 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #333;
        }
        .btn {
            background-color: #1b5e3a;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #14502c;
        }
        .countdown {
            margin-top: 15px;
            color: #666;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>403</h1>
        <h2>Bạn không có quyền truy cập trang này!</h2>
        <a href="${pageContext.request.contextPath}/login" class="btn">Quay lại đăng nhập</a>
        <div class="countdown">Tự động chuyển hướng sau <span id="time">5</span> giây...</div>
    </div>

    <script>
        let timeLeft = 5;
        const timer = document.getElementById("time");
        const interval = setInterval(() => {
            timeLeft--;
            timer.textContent = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(interval);
                window.location.href = "${pageContext.request.contextPath}/login";
            }
        }, 1000);
    </script>
</body>
</html>