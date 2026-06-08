<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
    
    <style>
        * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }

      body {
        background-color: #f4f7f6;
        color: #333;
        line-height: 1.6;
      }

      #wrapper {
        max-width: 1200px;
        margin: 80px auto;
        padding: 30px 20px;
      }

      .about-section {
        background: #fff;
        border-radius: 12px;
        padding: 30px;
        margin-bottom: 40px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .about-section:hover {
        transform: translateY(-4px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
      }

      .about-section h3 {
        font-size: 1.8rem;
        color: #0077b6;
        margin-bottom: 20px;
        text-align: center;
        position: relative;
      }

      .about-section h3::after {
        content: "";
        display: block;
        width: 60px;
        height: 3px;
        background: #0077b6;
        margin: 10px auto 0;
        border-radius: 2px;
      }

      .about-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 25px;
        flex-wrap: wrap; /* Để mobile tự xuống hàng */
      }

      .about-row p {
        flex: 1;
        font-size: 1rem;
        color: #444;
        text-align: justify;
        padding: 10px;
      }

      .about-image {
        max-width: 350px;
        width: 100%;
        border-radius: 12px;
        object-fit: cover;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
      }

      .about-image:hover {
        transform: scale(1.05);
      }

      @media (max-width: 768px) {
        .about-row {
          flex-direction: column;
          text-align: center;
        }

        .about-row p {
          padding: 0;
        }

        .about-image {
          max-width: 100%;
        }
      }
   </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "about");
%>
<%@ include file="header.jsp" %>

<div id="wrapper">
    <div id="content">        
        <section class="about-section">
        <h3>Sứ mệnh</h3>
        <div class="about-row">
            <p>Sứ mệnh của chúng tôi là mang đến dịch vụ chăm sóc sức khỏe tận tâm,
               an toàn và chất lượng, giúp bệnh nhân được thăm khám, điều trị hiệu quả 
               và nâng cao chất lượng cuộc sống.
            </p>
            <img src="${pageContext.request.contextPath}/assets/mission.png" alt="Sứ mệnh" class="about-image">
        </div>
        </section>

        <section class="about-section">
            <h3>Đội ngũ</h3>
            <div class="about-row">
                <p>Đội ngũ bác sĩ của phòng khám là những chuyên gia giàu kinh nghiệm,
                    tận tâm và luôn cập nhật kiến thức y khoa mới nhất, sẵn sàng tư vấn,
                    chẩn đoán và điều trị bệnh nhân một cách chính xác và hiệu quả.
                </p>
                <img src="${pageContext.request.contextPath}/assets/team.jpg" alt="Đội ngũ" class="about-image">
            </div>
        </section>
    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>