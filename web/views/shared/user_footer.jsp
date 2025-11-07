<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer id="footer">
     <p style="margin-top: 10px; padding-top: 10px;">© 2025. All rights reserved.</p>
</footer>

<script>
    window.addEventListener('load', adjustFooterPosition);
    window.addEventListener('resize', adjustFooterPosition);

    function adjustFooterPosition() {
        const footer = document.getElementById('footer');
        if (!footer) return;

        const bodyHeight = document.body.offsetHeight;
        const viewportHeight = window.innerHeight;

        // Nếu nội dung thấp hơn chiều cao màn hình → đẩy footer xuống cuối
        if (bodyHeight < viewportHeight) {
            footer.style.position = 'absolute';
            footer.style.bottom = '0';
            footer.style.left = '0';
            footer.style.width = '100%';
        } else {
            footer.style.position = 'static';
        }
    }
</script>