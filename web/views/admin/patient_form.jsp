<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.entity.Patient"%>
<%@page import="model.entity.User"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    Patient p = (Patient) request.getAttribute("patient");
    boolean isEdit = (p != null);
    User currentUser = (User) session.getAttribute("user");
    boolean isDoctor = (currentUser != null && "doctor".equals(currentUser.getRole()));
    String readOnlyAttr = isDoctor ? "disabled" : "";
    String title = isDoctor ? "Hồ sơ chi tiết bệnh nhân" : (isEdit ? "Cập nhật bệnh nhân" : "Thêm bệnh nhân mới");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= title %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <style>
        body { background-color: #f4f7f6; padding: 20px; }
        .main-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-header-custom {
            background: linear-gradient(to right, #569571, #3d7a5a);
            color: white;
            padding: 15px 20px;
        }
        .nav-tabs .nav-link.active {
            font-weight: bold;
            color: #569571;
            border-bottom: 3px solid #569571 !important;
        }
        .nav-tabs .nav-link {
            color: #555;
            border: none;
            border-bottom: 3px solid transparent;
        }
        .tab-content { padding: 20px; }
        .avatar-placeholder {
            width: 100px; height: 100px; background: #e9ecef; border-radius: 50%;
            display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #adb5bd;
        }
    </style>
</head>
<body>

<div class="container main-card p-0">
    <div class="card-header-custom d-flex justify-content-between align-items-center">
        <h5 class="mb-0 text-uppercase">
            <i class="fa-solid fa-user-injured me-2"></i> <%= title %>
        </h5>
        <a href="javascript:history.back()" class="btn btn-sm btn-light text-success fw-bold">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <div class="p-4 bg-white border-bottom">
        <div class="row">
            <div class="col-md-3 d-flex justify-content-center align-items-start">
                <div class="avatar-placeholder">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
            <div class="col-md-9">
                <form action="${pageContext.request.contextPath}/admin/patient" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                    <% if(isEdit) { %><input type="hidden" name="userId" value="<%= p.getUserId() %>"><% } %>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-bold">Họ và tên</label>
                            <input type="text" name="fullname" class="form-control form-control-lg fw-bold text-primary" 
                                   value="<%= isEdit ? p.getFullname() : "" %>" <%= readOnlyAttr %> required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Giới tính</label>
                            <select name="gender" class="form-select" <%= readOnlyAttr %>>
                                <option value="M" <%= isEdit && "M".equals(p.getGender()) ? "selected" : "" %>>Nam</option>
                                <option value="F" <%= isEdit && "F".equals(p.getGender()) ? "selected" : "" %>>Nữ</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" name="dob" class="form-control" 
                                   value="<%= isEdit ? p.getDob() : "" %>" <%= readOnlyAttr %> required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phonenum" class="form-control" 
                                   value="<%= isEdit ? p.getPhonenum() : "" %>" <%= readOnlyAttr %> required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <input type="text" name="address" class="form-control" 
                                   value="<%= isEdit ? p.getAddress() : "" %>" <%= readOnlyAttr %> required>
                        </div>
                        
                        <% if(!isDoctor) { %>
                        <div class="col-md-6">
                            <label class="form-label text-muted">Tên đăng nhập</label>
                            <input type="text" name="username" class="form-control form-control-sm" 
                                   value="<%= isEdit ? p.getUsername() : "" %>" <%= isEdit ? "readonly" : "required" %>>
                        </div>
                        <% if(!isEdit) { %>
                        <div class="col-md-6">
                            <label class="form-label text-muted">Mật khẩu</label>
                            <input type="password" name="password" class="form-control form-control-sm" required>
                        </div>
                        <% }} %>
                    </div>

                    <% if (!isDoctor) { %>
                        <div class="text-end mt-3">
                            <button type="submit" class="btn btn-success px-4">
                                <i class="fa-solid fa-save"></i> Lưu thông tin hành chính
                            </button>
                        </div>
                    <% } %>
                </form>
            </div>
        </div>
    </div>

    <% if(isEdit) { %>
    <div class="mt-3">
        <ul class="nav nav-tabs nav-fill px-3" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="appointment-tab" data-bs-toggle="tab" data-bs-target="#appointment" type="button" role="tab">
                    <i class="fa-regular fa-calendar-check me-2"></i>Lịch Hẹn
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="record-tab" data-bs-toggle="tab" data-bs-target="#record" type="button" role="tab">
                    <i class="fa-solid fa-notes-medical me-2"></i>Bệnh Án
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="test-tab" data-bs-toggle="tab" data-bs-target="#test" type="button" role="tab">
                    <i class="fa-solid fa-flask-vial me-2"></i>Xét Nghiệm
                </button>
            </li>
        </ul>

        <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show active" id="appointment" role="tabpanel">
                <div class="d-flex justify-content-between mb-3">
                    <h6 class="fw-bold text-primary">Lịch sử đặt hẹn</h6>
                    <% if(!isDoctor) { %><button class="btn btn-sm btn-primary">+ Đặt hẹn mới</button><% } %>
                </div>
                <table class="table table-striped table-hover text-center">
                    <thead class="table-light"><tr><th>Ngày</th><th>Giờ</th><th>Bác sĩ</th><th>Trạng thái</th></tr></thead>
                    <tbody>
                        <tr><td>25/11/2025</td><td>09:30</td><td>BS. Nguyễn Văn A</td><td><span class="badge bg-warning text-dark">Sắp tới</span></td></tr>
                        <tr><td>10/10/2025</td><td>14:00</td><td>BS. Trần Thị B</td><td><span class="badge bg-success">Đã khám</span></td></tr>
                    </tbody>
                </table>
            </div>

            <div class="tab-pane fade" id="record" role="tabpanel">
                <div class="d-flex justify-content-between mb-3">
                    <h6 class="fw-bold text-success">Lịch sử khám bệnh</h6>
                    <% if(isDoctor) { %><button class="btn btn-sm btn-success">+ Thêm bệnh án</button><% } %>
                </div>
                <div class="card mb-3 border-success">
                    <div class="card-header bg-success text-white d-flex justify-content-between">
                        <span>Ngày khám: 10/10/2025</span>
                        <span>BS. Trần Thị B</span>
                    </div>
                    <div class="card-body">
                        <p><strong>Chẩn đoán:</strong> Viêm họng cấp.</p>
                        <p><strong>Đơn thuốc:</strong> Paracetamol 500mg (2v/ngày), Vitamin C.</p>
                        <p class="text-muted fst-italic">Ghi chú: Bệnh nhân có tiền sử dị ứng Aspirin.</p>
                    </div>
                </div>
            </div>

            <div class="tab-pane fade" id="test" role="tabpanel">
                <h6 class="fw-bold text-info mb-3">Kết quả Cận lâm sàng</h6>
                <div class="alert alert-info text-center">Chưa có kết quả xét nghiệm nào.</div>
            </div>
        </div>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>