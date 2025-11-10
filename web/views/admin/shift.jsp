<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ca trực</title>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">
    </head>
    <body>
        <%
            request.setAttribute("currentPage", "shift");
        %>
        <jsp:include page="/views/shared/user_header.jsp" />
        
        <div class="title-box"><h3>DANH SÁCH CA TRỰC</h3></div>
        
        <div class="container" style="margin-top: -5px; margin-bottom: 5px;">
            <div class="row">
                <div class="col-5">
                <form action="${pageContext.request.contextPath}/admin/shift" method="get" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Nhập ca trực" class="form-control me-2" style="width: 180px; height: 37px;">
                    <button class="search-button" >Tìm kiếm</button>
                </form>
                </div>
                <div class="col-3"></div>
                <div class="col-3 text-end"><a href="${pageContext.request.contextPath}/views/admin/add_shift.jsp" class="add-button">
                  <i class="fa-solid fa-house-medical" style="margin-right: 5px;"></i>  Thêm ca trực
                    </a> 
                </div>
            </div>
        </div>
        
        <jsp:include page="/views/shared/user_footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>