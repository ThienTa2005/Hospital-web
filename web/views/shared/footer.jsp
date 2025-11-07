<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <footer id="footer">
        <div class="col">
            <img class="logo" src="<%= request.getContextPath() %>/views/shared/logo.png">
        </div>
        <div class="col">
            <h5>Thông tin liên hệ</h5>
            <p><strong>Địa chỉ: </strong>Hà Nội, Việt Nam</p>
            <p><strong>Số điện thoại: </strong>+8423456789</p>
            <p><strong>Giờ làm việc: </strong>07:00 SA - 18:00 CH, T2 - T6</p>
        </div>
        <div class="col">
            <div class="follow">
                <h5>Theo dõi chúng tôi</h5>
                <div class="icon">
                    <a href="https://facebook.com" target="_blank">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="https://youtube.com" target="_blank">
                        <i class="fab fa-youtube"></i>
                    </a>
                </div>
            </div>
        </div>
    </footer>