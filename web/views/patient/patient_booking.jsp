<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.entity.Doctor"%>
<%@page import="model.entity.Department"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%> 

<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String searchName = (String) request.getAttribute("searchName");
    String selectedDeptId = (String) request.getAttribute("selectedDeptId");
    model.entity.Doctor selectedDoctor = (model.entity.Doctor) request.getAttribute("selectedDoctor");
    String selectedDate = (String) request.getAttribute("selectedDate");
    
    if(selectedDate == null || selectedDate.isEmpty()) {
        selectedDate = LocalDate.now().toString();
    }

    List<Map<String,Object>> schedules = (List<Map<String,Object>>) request.getAttribute("schedules");
    Boolean noSchedule = (Boolean) request.getAttribute("noSchedule");
    String error = (String) request.getAttribute("error");

    List<String[]> next7Days = new ArrayList<>();
    LocalDate today = LocalDate.now();
    DateTimeFormatter showFmt = DateTimeFormatter.ofPattern("EEEE, dd/MM", new Locale("vi", "VN"));
    DateTimeFormatter valueFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    for (int i = 0; i < 7; i++) {
        LocalDate d = today.plusDays(i);
        String label = d.format(showFmt);
        if (i == 0) label = "Hôm nay, " + d.format(DateTimeFormatter.ofPattern("dd/MM"));
        String val = d.format(valueFmt);
        next7Days.add(new String[]{label, val});
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        body { background-color: #F3F6F8; font-family: 'Segoe UI', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }
        .main { flex: 1; width: 95%; max-width: 1400px; margin: 0 auto; padding-bottom: 30px; }
        .content-wrapper { padding: 20px 0; }
        
        .header { background: linear-gradient(135deg, #40855e, #2c6e49); color: white; padding: 25px; margin-bottom: 30px; border-radius: 12px; text-align: center; width: 100%; box-shadow: 0 4px 10px rgba(64, 133, 94, 0.2); }
        .header h1 { margin: 0; font-size: 26px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }

        .booking-layout { display: grid; grid-template-columns: 380px 1fr; grid-gap: 30px; align-items: start; }
        
        .doctor-list-card { background-color: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 20px; height: 800px; display: flex; flex-direction: column; }
        .doctor-list-scroll { flex: 1; overflow-y: auto; padding-right: 5px; }
        .doctor-list-scroll::-webkit-scrollbar { width: 5px; }
        .doctor-list-scroll::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }

        .doctor-item { display: flex; gap: 15px; padding: 15px; border-bottom: 1px solid #f0f0f0; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.2s; border-radius: 8px; align-items: start; }
        .doctor-item:hover { background-color: #f9f9f9; transform: translateX(5px); }
        .doctor-item.active { background-color: #e9f6ec; border-left: 4px solid #40855e; transform: none; }
        .doctor-avatar { width: 55px; height: 55px; border-radius: 50%; background: #d1e7dd; display: flex; align-items: center; justify-content: center; color: #40855e; font-size: 24px; flex-shrink: 0; margin-top: 5px; }

        .detail-card { background-color: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 30px; min-height: 800px; }
        
        .date-scroller { display: flex; gap: 10px; overflow-x: auto; padding: 5px; padding-bottom: 15px; margin-bottom: 20px; border-bottom: 1px solid #eee; scrollbar-width: thin; }
        .date-btn { flex: 1; min-width: 110px; padding: 12px 5px; text-align: center; border: 1px solid #ddd; border-radius: 10px; background: white; cursor: pointer; text-decoration: none; color: #555; transition: all 0.2s; font-size: 0.9rem; display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .date-btn:hover { border-color: #40855e; color: #40855e; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .date-btn.active { background-color: #40855e; color: white; border-color: #40855e; box-shadow: 0 4px 12px rgba(64, 133, 94, 0.4); transform: scale(1.05); font-weight: bold; }
        .date-btn span { display: block; font-weight: 600; margin-bottom: 2px; }

        .time-slot-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 15px; margin-top: 20px; }
        .time-slot-btn { padding: 15px; border: 1px solid #e0e0e0; background: #fff; color: #333; border-radius: 8px; cursor: pointer; transition: 0.2s; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; font-size: 1rem; }
        .time-slot-btn:hover { border-color: #40855e; color: #40855e; background-color: #f0f9f4; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }

        .empty-message { text-align: center; padding: 100px 0; color: #999; }
        .degree-text { color: #40855E; font-weight: 600; font-size: 0.85rem; margin-bottom: 2px; display: block; }
        .degree-badge { background-color: #e9f6ec; color: #40855E; border: 1px solid #40855E; padding: 5px 12px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; display: inline-block; margin-bottom: 10px; }

        @media (max-width: 992px) { .booking-layout { grid-template-columns: 1fr; } .doctor-list-card, .detail-card { height: auto; min-height: auto; } }
    </style>
</head>
<body>
    <jsp:include page="patient_menu.jsp" />

    <div class="main">
        <div class="content-wrapper">
            <div class="header"><h1><i class="fa-regular fa-calendar-check me-2"></i>Đặt lịch khám trực tuyến</h1></div>
            <% if (error != null) { %><div class="alert alert-danger text-center"><%= error %></div><% } %>

            <div class="booking-layout">
                
                <div class="doctor-list-card">
                    <h5 class="mb-3 text-success fw-bold"><i class="fa-solid fa-user-doctor me-2"></i>Chọn bác sĩ</h5>
                    <form class="mb-3" method="get" action="<%= request.getContextPath() %>/book-appointment">
                        <div class="d-flex gap-2 mb-2">
                            <input type="text" name="q" class="form-control" placeholder="Tên BS..." value="<%= (searchName != null ? searchName : "") %>">
                            <button type="submit" class="btn btn-success"><i class="fa-solid fa-search"></i></button>
                        </div>
                        <select name="dept" class="form-select" onchange="this.form.submit()">
                            <option value="">-- Tất cả chuyên khoa --</option>
                            <% if (departments != null) { for (Department d : departments) { String sel = (selectedDeptId != null && selectedDeptId.equals(String.valueOf(d.getDepartmentID()))) ? "selected" : ""; %>
                                <option value="<%= d.getDepartmentID() %>" <%= sel %>><%= d.getDepartmentName() %></option>
                            <% } } %>
                        </select>
                    </form>
                    
                    <div class="doctor-list-scroll">
                        <% if (doctors == null || doctors.isEmpty()) { %>
                            <div class="text-center text-muted py-3">Không tìm thấy bác sĩ.</div>
                        <% } else { for (Doctor d : doctors) { boolean isActive = (selectedDoctor != null && selectedDoctor.getUserId() == d.getUserId()); %>
                            <a class="doctor-item <%= isActive ? "active" : "" %>" href="<%= request.getContextPath() %>/book-appointment?doctorId=<%= d.getUserId() %>&date=<%= selectedDate %>&dept=<%= (selectedDeptId != null ? selectedDeptId : "") %>">
                                <div class="doctor-avatar"><i class="fa-solid fa-user-md"></i></div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 1.05rem;"><%= d.getFullName() %></div>
                                    <span class="degree-text"><i class="fa-solid fa-graduation-cap me-1"></i><%= d.getDegree() %></span>
                                    <div class="small text-muted"><%= d.getDepartmentName() != null ? d.getDepartmentName() : "Đa khoa" %></div>
                                </div>
                            </a>
                        <% } } %>
                    </div>
                </div>

                <div class="detail-card">
                    <% if (selectedDoctor == null) { %>
                        <div class="empty-message">
                            <img src="https://cdn-icons-png.flaticon.com/512/3652/3652191.png" width="100" style="opacity: 0.2; margin-bottom: 20px;">
                            <h4>Chưa chọn bác sĩ</h4>
                            <p>Vui lòng chọn một bác sĩ từ danh sách bên trái để xem lịch khám.</p>
                        </div>
                    <% } else { %>
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="doctor-avatar" style="width: 80px; height: 80px; font-size: 35px;"><i class="fa-solid fa-user-md"></i></div>
                            <div>
                                <h3 class="m-0 text-success fw-bold"><%= selectedDoctor.getFullname() %></h3>
                                <div class="mt-2"><span class="degree-badge"><i class="fa-solid fa-certificate me-1"></i><%= selectedDoctor.getDegree() %></span></div>
                                <div class="text-muted"><i class="fa-solid fa-stethoscope me-1"></i> <%= selectedDoctor.getDepartmentName() %></div>
                            </div>
                        </div>

                        <label class="fw-bold mb-2 d-block text-secondary"><i class="fa-regular fa-calendar me-2"></i>Lịch khám:</label>
                        <div class="date-scroller">
                            <% for (String[] day : next7Days) { boolean isSelected = day[1].equals(selectedDate); %>
                                <a href="<%= request.getContextPath() %>/book-appointment?doctorId=<%= selectedDoctor.getUserId() %>&date=<%= day[1] %>&dept=<%= (selectedDeptId != null ? selectedDeptId : "") %>" class="date-btn <%= isSelected ? "active" : "" %>">
                                    <span><%= day[0].split(",")[0] %></span> <small><%= day[0].split(",")[1] %></small> 
                                </a>
                            <% } %>
                        </div>

                        <div class="mt-4">
                            <% if (noSchedule != null && noSchedule) { %>
                                <div class="text-center py-5 text-muted"><i class="fa-regular fa-calendar-xmark fa-3x mb-3"></i><p>Bác sĩ không có lịch khám vào ngày này.<br>Vui lòng chọn ngày khác.</p></div>
                            <% } else if (schedules == null || schedules.isEmpty()) { %>
                            <% } else { %>
                                <label class="fw-bold mb-2 d-block text-success"><i class="fa-regular fa-clock me-2"></i>Các khung giờ còn trống:</label>
                                <div class="time-slot-list">
                                    <% 
                                       SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm:ss");
                                       
                                       for (Map<String,Object> row : schedules) { 
                                           java.sql.Time start = (java.sql.Time) row.get("startTime"); 
                                           java.sql.Time end = (java.sql.Time) row.get("endTime"); 
                                           
                                           String startStr = timeSdf.format(start);
                                    %>
                                        <form method="post" action="<%= request.getContextPath() %>/book-appointment" style="display: contents;">
                                            <input type="hidden" name="doctorId" value="<%= selectedDoctor.getUserId() %>"/>
                                            <input type="hidden" name="date" value="<%= selectedDate %>"/>
                                            <input type="hidden" name="shiftDoctorId" value="<%= row.get("shiftDoctorId") %>"/>
                                            
                                            <input type="hidden" name="startTime" value="<%= startStr %>"/>

                                            <button type="submit" class="time-slot-btn" title="Đặt lịch khung giờ này">
                                                <i class="fa-solid fa-check-circle text-success"></i>
                                                <%= start.toString().substring(0,5) %> - <%= end.toString().substring(0,5) %>
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                                <div class="mt-3 text-muted small fst-italic">* Nhấn vào khung giờ để xác nhận đặt lịch ngay lập tức.</div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/views/shared/user_footer.jsp" />
</body>
</html>