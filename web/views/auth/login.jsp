<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
  <title>Đăng nhập</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
  
  <style>
      .form-heading {
          margin-bottom: 10px;
      }
      
      ul {
          margin-top: 16.5px;
      }
      
      .right-section::before {
          right: 0px;
      }
      
      .error-message {
            color: #dc3545; 
            font-size: 14px;
            margin-bottom: 10px;
            text-align: center; 
            background-color: #f8d7da;
            padding: 8px 10px;
            border: 1px solid #f5c2c7;
            border-radius: 5px;
        }

      .toast-container {
            position: fixed;
            top: 90px !important;    
            z-index: 1055;                   
      }
  </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "login");
%>
<jsp:include page="/views/shared/header.jsp" />


<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                 Đăng kí thành công! <br> Vui lòng đăng nhập để sử dụng dịch vụ.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<div id="wrapper">
    <div id="content">
        <div id="bg-login">
            <form id="form-login" action="${pageContext.request.contextPath}/login" method="post">
                <h1 class="form-heading">Đăng nhập</h1>
                
                <% 
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    if (errorMessage != null) { 
                %>
                    <div class="error-message">
                        <small><%= errorMessage %></small>
                    </div>
                <% 
                    session.removeAttribute("errorMessage"); 
                    } 
                %>

                <div class="form-group">
                    <input type="text" name="username" class="form-input" placeholder="Tên đăng nhập" required>
                </div>
                <div class="form-group">
                    <input type="password" name="password" class="form-input" placeholder="Mật khẩu" required>
                </div>
                <input type="submit" value="Đăng nhập" class="form-submit">
                <div class="form-register">
                <p>Bạn chưa có tài khoản? 
                   <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Đăng ký</a>
                </p>
                </div>
            </form>
        </div>
    </div>
</div>
                
<!-- Thong bao -->
<script> 
    document.addEventListener("DOMContentLoaded", () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("success") === "true") {
            const toastElement = document.getElementById('successToast');
            const toast = new bootstrap.Toast(toastElement, {
                delay: 3000 // 3 giay
            });
            toast.show();
            
            // Xoa url
            const url = new URL(window.location.href);
            url.searchParams.delete("success");
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }
    });
</script>

<jsp:include page="/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>