<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <style>

        #footer {
            background-color: #569571;
            color: white;
            text-align: center;
            padding: 8px 15px;  
            font-size: 14px;
            line-height: 1.4;
            border-top: 1px solid #ccc;
            box-shadow: 0 -1px 3px rgba(0,0,0,0.1);
            border-radius: 10px;
        }

        #footer a {
            color: white;
            text-decoration: none;
            margin: 0 5px;
        }
        #footer a:hover {
            color: #5de292;
        }
        
        #footer p {
            margin-top: 5px !important;
            padding-top: 0px !important;
        }

        @media (max-width: 768px) {
            #footer {
                font-size: 12px;
                padding: 6px 10px;
            }
        }

    </style>
</head>
<body>
    <jsp:include page="/views/shared/user_footer.jsp" /> 
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

</script>
