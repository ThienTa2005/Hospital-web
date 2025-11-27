<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.entity.User" %>
<% 
    // Giữ logic active để tô màu nếu cần, hoặc bỏ qua cũng được
    String activePage = (String) request.getAttribute("activePage");
    if(activePage == null) activePage = "";
%>
<style>
    /* Container cố định ở góc phải màn hình */
    .fab-container {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 9999;
        display: flex;
        flex-direction: column-reverse; /* Nút chính ở dưới cùng */
        align-items: center;
        gap: 15px; /* Khoảng cách giữa các nút */
    }

    /* Nút chính to nhất */
    .fab-main {
        width: 60px;
        height: 60px;
        background: linear-gradient(135deg, #2c5038, #40855E);
        border-radius: 50%;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 24px;
        cursor: pointer;
        transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    /* Nút con (các tính năng) */
    .fab-item {
        width: 50px;
        height: 50px;
        background-color: white;
        border-radius: 50%;
        box-shadow: 0 3px 10px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #2c5038;
        text-decoration: none;
        position: relative;
        
        /* Mặc định ẩn đi */
        opacity: 0;
        transform: translateY(20px) scale(0.8);
        pointer-events: none; /* Không bấm được khi ẩn */
        transition: all 0.3s ease;
    }

    /* SVG Icon */
    .fab-item svg, .fab-main svg {
        width: 24px;
        height: 24px;
        fill: currentColor;
    }

    /* Tooltip (Chữ hiện bên cạnh nút con) */
    .fab-item::after {
        content: attr(data-tooltip);
        position: absolute;
        right: 65px; /* Cách nút 1 chút về bên trái */
        background-color: rgba(0,0,0,0.7);
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        white-space: nowrap;
        opacity: 0;
        transition: opacity 0.2s;
        pointer-events: none;
    }

    /* --- HIỆU ỨNG KHI HOVER VÀO CONTAINER --- */
    
    /* Xoay nút chính */
    .fab-container:hover .fab-main {
        transform: rotate(45deg); /* Biến dấu + thành dấu x */
        background: #B23A48; /* Đổi màu thành đỏ (như nút đóng) */
    }

    /* Hiện các nút con */
    .fab-container:hover .fab-item {
        opacity: 1;
        transform: translateY(0) scale(1);
        pointer-events: auto;
    }

    /* Hiện tooltip khi hover vào từng nút con */
    .fab-item:hover::after {
        opacity: 1;
    }

    .fab-item:hover {
        background-color: #2c5038;
        color: white;
    }

    /* Delay nhẹ để tạo hiệu ứng cuộn từng cái (Stagger) */
    .fab-container:hover .fab-item:nth-child(2) { transition-delay: 0.05s; }
    .fab-container:hover .fab-item:nth-child(3) { transition-delay: 0.1s; }
    .fab-container:hover .fab-item:nth-child(4) { transition-delay: 0.15s; }
    .fab-container:hover .fab-item:nth-child(5) { transition-delay: 0.2s; }
    .fab-container:hover .fab-item:nth-child(6) { transition-delay: 0.25s; }

</style>

<div class="fab-container">
    <div class="fab-main">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
    </div>

    <a href="<%= request.getContextPath() %>/login" class="fab-item" data-tooltip="Đăng xuất" style="color: #B23A48;">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M16 13v-2H7V8l-5 4 5 4v-3zM20 3H10v2h10v14H10v2h10c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/></svg>
    </a>

    <a href="<%= request.getContextPath()  %>/change-password" class="fab-item" data-tooltip="Đổi mật khẩu">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M12 17a2 2 0 100-4 2 2 0 000 4zm6-7h-1V7a5 5 0 00-10 0v3H6c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2v-8c0-1.1-.9-2-2-2zm-6-5a3 3 0 013 3v3h-6V8a3 3 0 013-3zm6 13H6v-8h12v8z"></path>
        </svg>
    </a>
    <a href="<%= request.getContextPath() %>/profile" class="fab-item <%= "profile".equals(activePage) ? "active-fab" : "" %>" data-tooltip="Hồ sơ cá nhân">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5z"/></svg>
    </a>

    <a href="<%= request.getContextPath() %>/appointment?action=list" class="fab-item <%= "appointment".equals(activePage) ? "active-fab" : "" %>" data-tooltip="Lịch hẹn của tôi">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg>
    </a>

    <a href="<%= request.getContextPath() %>/patient_dashboard" class="fab-item <%= "dashboard".equals(activePage) ? "active-fab" : "" %>" data-tooltip="Trang chủ">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
    </a>
</div>