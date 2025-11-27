<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String contextPath = request.getContextPath(); %>
<style>

    .fab-container { 
        position: fixed; 
        bottom: 30px; 
        right: 30px; 
        z-index: 9999; 
        display: flex; 
        flex-direction: column-reverse; 
        align-items: center; 
        gap: 15px; 
    }

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
        opacity: 0; 
        transform: translateY(20px) scale(0.8); 
        pointer-events: none; 
        transition: all 0.3s ease; 
    }

    .fab-item svg { width: 24px; height: 24px; fill: currentColor; }
    .fab-main svg { width: 28px; height: 28px; fill: currentColor; }


    .fab-item::after { 
        content: attr(data-tooltip); 
        position: absolute; 
        right: 60px; 
        background-color: rgba(0,0,0,0.8); 
        color: white; 
        padding: 5px 10px; 
        border-radius: 5px; 
        font-size: 12px; 
        white-space: nowrap; 
        opacity: 0; 
        transition: opacity 0.2s; 
        pointer-events: none; 
    }

    .fab-container:hover .fab-main { transform: rotate(45deg); background: #B23A48; }
    .fab-container:hover .fab-item { opacity: 1; transform: translateY(0) scale(1); pointer-events: auto; }
    .fab-item:hover::after { opacity: 1; }
    .fab-item:hover { background-color: #2c5038; color: white; }

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

    <a href="<%= contextPath %>/logout" class="fab-item" data-tooltip="Đăng xuất" style="color: #B23A48;">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M16 13v-2H7V8l-5 4 5 4v-3zM20 3H10v2h10v14H10v2h10c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/></svg>
    </a>

    <a href="<%= contextPath %>/doctor/profile" class="fab-item" data-tooltip="Hồ sơ cá nhân">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5z"/></svg>
    </a>

    <a href="<%= contextPath %>/doctor/appointmentList" class="fab-item" data-tooltip="Quản lý lịch hẹn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
        </svg>
    </a>

    <a href="<%= contextPath %>/doctor/schedule" class="fab-item" data-tooltip="Lịch trực">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11z"/></svg>
    </a>

    <a href="<%= contextPath %>/doctor/dashboard" class="fab-item" data-tooltip="Trang chủ">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
    </a>
</div>