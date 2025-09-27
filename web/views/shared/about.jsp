<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
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
