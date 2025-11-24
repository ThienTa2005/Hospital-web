<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page import="java.util.List" %>
    <%@ page import="model.entity.Appointment" %>
    <%@ page import="java.sql.Timestamp" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Bệnh Nhân</title>
    <style>
        /* Các trang của patient cần có css của main, header và content wrapper*/
        .main {
            flex-grow: 1;
            display: flex;
            flex-direction: column; 
            min-height: 100vh;    
        }

        .header {
            background-color: #40855e;
            color: white;
            padding: 15px 20px;
            margin-bottom: 50px; 
            border-radius: 5px;
            display: flex;
            justify-content: center;
        }
        
        .content-wrapper {
            flex: 1;                
            padding: 20px;
        }

        /* Table*/
        table {
            width: 95%;                 
            max-width: 1200px;          
            min-width: 600px;           
            margin: 20px auto;          
            border-collapse: collapse;
            table-layout: auto;         
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        /* Ô dữ liệu và tiêu đề */
        th, td {
            padding: 10px 15px;
            text-align: center;
            border: 1px solid #ccc;
            white-space: nowrap;       
        }

        /* Dòng tiêu đề */
        th {
            background-color: #2c693b;
            color: white;
            font-weight: 600;
        }

        /* Màu xen kẽ và hiệu ứng hover */
        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tbody tr:hover {
            background-color: #eaf2ec;
            transition: background-color 0.2s;
        }

        /* Nút Xem chi tiết */
        .btn-detail {
            padding: 6px 12px;
            background-color: #706e6e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-detail:hover {
            background-color: #929292;
        }

        /* Filter/search */
        .filter {
            margin-bottom: 30px; 
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter input, .filter button {
            padding: 8px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .filter button {
            background-color: #2c693b;
            color: white;
            border: none;
            cursor: pointer;
        }
        .filter button:hover {
            background-color: #569571;
        }
        
        .filter select {
            padding: 5px 30px 5px 10px;
            appearance: none; 
            -webkit-appearance: none;
            -moz-appearance: none;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 10 10"><polygon points="0,0 10,0 5,5" fill="black"/></svg>') no-repeat right 10px center;
            background-size: 10px 10px;
        }

    </style>
</head>
<body>

    <jsp:include page="patient_navbar.jsp"/>

    <!-- Main content -->
    <div class="main">
        <!-- Header -->
        <div class="content-wrapper">
            <div class="header">
                <h1>Danh sách lịch hẹn</h1>
            </div>

            <!-- Filter/Search -->
            <div class="filter">
                <select>
                    <option value="">Chọn chuyên khoa</option>
                    <option value="khoa1">Khoa 1</option>
                    <option value="khoa2">Khoa 2</option>
                </select>
                <input type="date" placeholder="Chọn ngày">
                <select>
                    <option value="">Chọn ca khám</option>
                    <option value="sang">Sáng</option>
                    <option value="chieu">Chiều</option>
                </select>
                <button>Tìm kiếm</button>
            </div>

            <!-- Table danh sách lịch hẹn -->
            <%
                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                if (appointments == null || appointments.isEmpty()) {

            %>
                <div class="no-data">Không có lịch hẹn nào được tìm thấy.</div>
                <!-- Nút thêm mới -->
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPatientModal">
                  <i class="bi bi-plus-circle"></i> Thêm mới
                </button>
                            <!-- Modal -->
                <div class="modal fade" id="addPatientModal" tabindex="-1" aria-labelledby="addPatientModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">

                      <div class="modal-header">
                        <h5 class="modal-title" id="addPatientModalLabel">Thêm bệnh nhân mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                      </div>

                      <div class="modal-body">
                        <form>
                          <div class="mb-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" class="form-control" placeholder="Nhập họ tên bệnh nhân">
                          </div>
                          <div class="mb-3">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" class="form-control">
                          </div>
                          <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control">
                          </div>
                        </form>
                      </div>

                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu</button>
                      </div>

                    </div>
                  </div>
                </div>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Mã lịch hẹn</th>
                            <th>Mã bệnh nhân</th>
                            <th>Mã ca trực bác sĩ</th>
                            <th>Ngày hẹn</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (Appointment appt : appointments) { %>
                        <tr>
                            <td><%= appt.getAppointmentId() %></td>
                            <td><%= appt.getPatientId() %></td>
                            <td><%= appt.getShiftDoctorId() %></td>
                            <td><%= appt.getAppointmentDate() %></td>
                            <td><%= appt.getStatus() %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
        <jsp:include page="patient_footer.jsp" />
    </div>
    
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

</script>