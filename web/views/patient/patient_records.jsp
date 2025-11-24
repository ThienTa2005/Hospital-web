<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>

    <title>Tra cứu hồ sơ | Bệnh nhân</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }

        body {
            display: flex;
            min-height: 100vh;
            background-color: #f5f5f5;
        }

        .main {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .content-wrapper {
            flex: 1;
            padding: 20px;
        }

        .header {
            background-color: #2c693b;
            color: white;
            padding: 15px 20px;
            margin-bottom: 30px;
            border-radius: 5px;
            text-align: center;
        }

        .header h1 {
            font-size: 26px;
            margin: 0;
        }

        .table-container {
            width: 90%;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
            font-size: 14px;
        }

        thead th {
            background-color: #2c693b;
            color: #fff;
            padding: 10px;
        }

        tbody td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .status {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            text-transform: capitalize;
        }

        .status.accepted {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status.completed {
            background-color: #cfe2ff;
            color: #084298;
        }

        .status.pending {
            background-color: #fff3cd;
            color: #664d03;
        }

        .status.cancelled {
            background-color: #f8d7da;
            color: #842029;
        }

        .record-label {
            font-size: 13px;
            color: #6c757d;
        }

        .record-missing {
            color: #dc3545;
            font-weight: 600;
        }

        .btn-detail {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 4px;
            background-color: #6c757d;
            color: #fff;
            text-decoration: none;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .btn-detail:hover {
            background-color: #5a6268;
        }

        .summary {
            width: 90%;
            margin: 10px auto 0 auto;
            text-align: right;
            color: #666;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #777;
        }

        .empty-state img {
            opacity: 0.5;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <jsp:include page="patient_navbar.jsp"/>

    <%
        List<Map<String, Object>> historyList =
                (List<Map<String, Object>>) request.getAttribute("historyList");
        if (historyList == null) historyList = new ArrayList<>();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    %>

    <div class="main">
        <div class="content-wrapper">
            <div class="header">
                <h1>Hồ sơ bệnh án & lịch sử khám</h1>
            </div>

            <div class="table-container">
                <%
                    if (historyList.isEmpty()) {
                %>
                    <div class="empty-state">
                        <img src="https://cdn-icons-png.flaticon.com/512/4076/4076504.png"
                             alt="Empty" width="80">
                        <p>Hiện chưa có cuộc hẹn nào trong lịch sử để tra cứu hồ sơ.</p>
                    </div>
                <%
                    } else {
                %>
                    <table>
                        <thead>
                        <tr>
                            <th>Bác sĩ</th>
                            <th>Khoa khám</th>
                            <th>Ngày</th>
                            <th>Giờ</th>
                            <th>Trạng thái</th>
                            <th>Hồ sơ bệnh án</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for (Map<String, Object> row : historyList) {
                                Integer appId = (Integer) row.get("appointment_id");
                                Timestamp apptTs = (Timestamp) row.get("appointment_date");
                                String status = (String) row.get("status");
                                String doctorName = (String) row.get("doctor_name");
                                String deptName = (String) row.get("dept_name");
                                Integer recordId = (Integer) row.get("record_id");

                                String dateStr = apptTs != null ? dateFormat.format(apptTs) : "";
                                String timeStr = apptTs != null ? timeFormat.format(apptTs) : "";

                                String statusCss = "status ";
                                if ("accepted".equalsIgnoreCase(status)) statusCss += "accepted";
                                else if ("completed".equalsIgnoreCase(status)) statusCss += "completed";
                                else if ("pending".equalsIgnoreCase(status)) statusCss += "pending";
                                else if ("cancelled".equalsIgnoreCase(status)) statusCss += "cancelled";
                        %>
                            <tr>
                                <td><%= doctorName %></td>
                                <td><%= deptName %></td>
                                <td><%= dateStr %></td>
                                <td><%= timeStr %></td>
                                <td><span class="<%= statusCss %>"><%= status %></span></td>
                                <td>
                                    <% if (recordId != null) { %>
                                        <a href="<%= request.getContextPath() %>/record?appointment_id=<%= appId %>"
                                           class="btn-detail">Xem</a>
                                    <% } else { %>
                                        <span class="record-label record-missing">Chưa có hồ sơ</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                <%
                    }
                %>
            </div>

            <% if (!historyList.isEmpty()) { %>
            <div class="summary">
                Tổng số cuộc hẹn: <strong><%= historyList.size() %></strong>
            </div>
            <% } %>
        </div>

        <jsp:include page="patient_footer.jsp" />
    </div>

</body>
</html>
