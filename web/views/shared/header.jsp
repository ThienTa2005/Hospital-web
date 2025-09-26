<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section id="header">
    
  <div class="logo-container">
    <a href="#"><img src="views/shared/logo.png" class="logo"></a>
    <span class="logo-text">Phòng khám bl</span>
  </div>
    
  <div class="right-section">
    <div>
    <%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
    %>

        <ul id="navbar">
        <li><a href="<%= request.getContextPath() %>/index.jsp" class="<%= "index".equals(currentPage) ? "active" : "" %>">Trang chủ</a></li>
        <li><a href="<%= request.getContextPath() %>/login" class="<%= "login".equals(currentPage) ? "active" : "" %>">Đăng nhập</a></li>
        <li><a href="views/auth/register.jsp" class="<%= "register".equals(currentPage) ? "active" : "" %>">Đăng kí</a></li>
        <li><a href="about.jsp" class="<%= "about".equals(currentPage) ? "active" : "" %>">Về chúng tôi</a></li>
        <li><a href="#footer" class="<%= "contact".equals(currentPage) ? "active" : "" %>">Liên hệ</a></li>
        </ul>
    </div>
  </div>
    
</section>