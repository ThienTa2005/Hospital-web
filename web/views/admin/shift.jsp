<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.Map, java.util.List, model.entity.Doctor" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Ca trực</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/user_style.css">

    <style>
        body { background-color: #f5f5f5 !important; }
        .modal { z-index: 2600 !important; }
        .calendar-wrapper { width: 1225px; margin: 0 auto; }
        .calendar-table { width: 100%; border: 1px solid #ccc !important; table-layout: fixed; }
        .calendar-table thead th { background-color: #198754 !important; color: white; font-weight: 600; }
        .calendar-table td { border: 1.5px solid #000 !important; vertical-align: top; padding: 0; height: 100px; }

        .calendar-cell .cell-content {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            padding: 5px;
        }

        .calendar-cell.has-shift { background-color: #b3f9d8; }
        .calendar-cell.has-shift:hover { background-color: #58ffb1; cursor: pointer; }
        .calendar-cell:hover { background-color: #f0f0f0; cursor: pointer; }

        .day-number { width: 28px; height: 28px; line-height: 28px; display: inline-block; border-radius: 50%; background-color: #fff; color: #000; font-weight: 600; }

        .calendar-cell.today .day-number { background-color: #75eeff !important; }

        .shift-info { font-size: 12px; text-align: left; }
        .divider { border-top: 1px dashed #999; margin: 5px 0; width: 100%; }
        .shift-btn {
            width: 100%;
            padding: 5px 0 0 0;
            font-size: 10px !important;
            border: none;
            border-top: 1px dashed #999;
            background-color: transparent;
            border-radius: 0;
        }

        .shift-btn:hover {
            border-top: 1px dashed #999;
        }

        #shiftActionBtn {
            width: 140px;
            height: 35px;
            font-size: 14px;
            text-align: center;
            margin: 5px 0px;
        }

        #selectedDoctorsBox .doctor-item {
            padding: 8px 12px;
            border-radius: 8px;
            background: #fff;
            margin-bottom: 6px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #ddd;
        }

        #selectedDoctorsBox .doctor-name {
            font-weight: 500;
        }

        .btn-delete-doctor {
            padding: 4px 10px;
        }



    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "shift");
%>
<jsp:include page="/views/shared/user_header.jsp" />

<div class="title-box"><h3>DANH SÁCH CA TRỰC</h3></div>

<div class="d-flex justify-content-center">
    <div class="calendar-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <!-- BÊN TRÁI -->
            <div class="d-flex align-items-center">
                <h5 class="m-0 fw-bold me-2">Chọn ngày: </h5>

                <!-- Input chọn ngày -->
                <input type="date" id="selectedDate" class="form-control form-control-sm" style="width: 180px;">
            </div>

            <!-- BÊN PHẢI -->
            <div class="d-flex align-items-center" style="gap: 10px;">
                <button id="prevMonth" class="btn btn-outline-success btn-sm">&lt; Tháng trước</button>
                <h5 id="monthTitle" class="m-0 fw-bold text-center" style="width: 150px;">Tháng</h5>
                <button id="nextMonth" class="btn btn-outline-success btn-sm">Tháng sau &gt;</button>
            </div>

        </div>


        <div class="table-responsive">
            <table class="table calendar-table text-center align-middle">
                <thead>
                    <tr>
                        <th>Thứ 2</th>
                        <th>Thứ 3</th>
                        <th>Thứ 4</th>
                        <th>Thứ 5</th>
                        <th>Thứ 6</th>
                        <th>Thứ 7</th>
                        <th>Chủ nhật</th>
                    </tr>
                </thead>
                <tbody id="calendarBody"></tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal quản lý ca trực -->
<div class="modal fade" id="shiftModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header" style="background: #198754;">
        <h5 class="modal-title text-white w-100" id="shiftModalTitle">Quản lý ca trực</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="shiftDate">

        <div class="mb-3 d-flex align-items-center gap-2">
          <label class="me-2" style="min-width:85px;">Chọn ca trực:</label>
          <select class="form-select" id="shiftTypeSelect" style="width:180px;">
            <option value="morning">Ca sáng</option>
            <option value="afternoon">Ca chiều</option>
            <option value="night">Ca đêm</option>
          </select>
          <button class="btn btn-sm ms-2" id="shiftActionBtn"></button>
        </div>

        <div class="doctor-section">

            <!-- Hàng trên cùng -->
            <div class="d-flex align-items-center mb-3 gap-3">

                <label class="fw-bold m-0" style="min-width:200px;">
                    Danh sách bác sĩ trực ca:
                </label>

                <span class="m-0" style="margin-right: 27px !important; margin-left: 25px !important; width: 250px;">
                       Tổng số: <b id="doctorCount">0</b></span>

                <!-- Select danh sách bác sĩ -->
                <select id="doctorListSelect" class="form-select" style="min-width:250px;"> </select>

                <!-- Nút thêm bác sĩ -->
                <button class="btn btn-success" id="addDoctorBtn" style="width: 325px;">Thêm bác sĩ</button>

            </div>

            <!-- Danh sách bác sĩ đang trực -->
            <div id="selectedDoctorsBox" class="p-3 border rounded bg-light" style="min-height:80px;">
                <!-- Auto render -->
            </div>

        </div>


      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        <button type="button" class="btn btn-success" id="saveShiftBtn">Lưu Bác sĩ</button>
      </div>
    </div>
  </div>
</div>


<jsp:include page="/views/shared/user_footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ========== SETUP & HELPERS ========== */
const today = new Date();
let currentYear = today.getFullYear();
let currentMonth = today.getMonth();

const monthTitle = document.getElementById("monthTitle");
const calendarBody = document.getElementById("calendarBody");

 // shiftMap từ servlet; nếu null thì fallback về object rỗng
var shiftMap = <%= request.getAttribute("shiftMap") != null ? request.getAttribute("shiftMap") : "{}" %>;
if (typeof shiftMap === 'string') {
    try { shiftMap = JSON.parse(shiftMap); } catch(e) { shiftMap = {}; }
}
console.log("shiftMap:", shiftMap);

var allDoctorsList = <%= request.getAttribute("allDoctorsList") != null ? request.getAttribute("allDoctorsList") : "[]" %>;
if (typeof allDoctorsList === 'string') {
    try { allDoctorsList = JSON.parse(allDoctorsList); } catch(e) { allDoctorsList = []; }
}

console.log("allDoctorsList:", allDoctorsList);

function pad2(num) { return num < 10 ? '0' + num : num; }

/* DOM references global */
const shiftActionBtn = document.getElementById('shiftActionBtn');
const shiftSelect = document.getElementById('shiftTypeSelect');
const doctorSelect = document.getElementById('doctorListSelect');
const doctorCount = document.getElementById('doctorCount');
const saveShiftBtn = document.getElementById('saveShiftBtn');
const addDoctorBtn = document.getElementById('addDoctorBtn');

/* ========== GLOBAL: updateDoctorList (đưa ra ngoài) ========== */
function updateDoctorList() {
    const dateStr = document.getElementById('shiftDate').value;
    const shift = shiftSelect.value;

    const doctorsInShift = (shiftMap[dateStr] && shiftMap[dateStr][shift]) ? shiftMap[dateStr][shift] : [];

    const doctorSection = document.querySelector('.doctor-section');
    doctorSection.style.display = shiftMap[dateStr] && shiftMap[dateStr][shift] ? "block" : "none";

    doctorSelect.innerHTML = "";

    // Default option
    const defaultOpt = document.createElement("option");
    defaultOpt.value = "";
    defaultOpt.text = "-- Chọn Bác Sĩ --";
    defaultOpt.selected = true;
    doctorSelect.appendChild(defaultOpt);

    allDoctorsList.forEach(doc => {
        const opt = document.createElement("option");
        opt.value = doc.userId ?? doc.id;
        opt.text = doc.fullName;

        if (doctorsInShift.some(d => d.userId == opt.value)) {
            opt.disabled = true;
        }

        doctorSelect.appendChild(opt);
    });

    doctorCount.innerText = doctorsInShift.length;
}



/* ========== GLOBAL: updateShiftButton (dùng updateDoctorList) ========== */
function updateShiftButton() {
    const dateStr = document.getElementById('shiftDate').value;
    const shift = shiftSelect.value;
    const dayShift = shiftMap[dateStr] || {};

    const doctorSection = document.querySelector('.doctor-section');
    const selectedDoctorsBox = document.getElementById('selectedDoctorsBox');
    const doctorCount = document.getElementById('doctorCount');

    if (dayShift[shift]) {
        // Nếu ca trực tồn tại → hiện section
        doctorSection.style.display = "block";

        shiftActionBtn.innerText = "Xóa ca trực";
        shiftActionBtn.className = "btn btn-sm btn-danger uniform-btn";
        shiftActionBtn.onclick = () => {
            if (!confirm("Bạn có chắc chắn muốn xóa ca trực này không?")) return;

            const dateStr = document.getElementById('shiftDate').value;
            const shift = shiftSelect.value; // morning/afternoon/night

            fetch('<%=request.getContextPath()%>/admin/shift?action=deleteShiftFromClient', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    shiftType: shift,
                    shiftDate: dateStr
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    delete shiftMap[dateStr][shift];
                    updateShiftButton();
                    renderCalendar(currentYear, currentMonth);
                } else {
                    alert("Xóa ca trực thất bại: " + (data.message || ""));
                }
            })
            .catch(err => console.error(err));
        };

    } else {
        // Nếu ca trực chưa tồn tại → ẩn section
        doctorSection.style.display = "none";
        selectedDoctorsBox.innerHTML = "";
        doctorCount.innerText = 0;

        // Kiểm tra nếu dateStr không còn shift nào → xóa key
        if (shiftMap[dateStr] && Object.keys(shiftMap[dateStr]).length === 0) {
            delete shiftMap[dateStr];
        }

        shiftActionBtn.innerText = "Thêm ca trực";
        shiftActionBtn.className = "btn btn-sm btn-success";
        shiftActionBtn.onclick = () => {
            const dateStr = document.getElementById('shiftDate').value;
            const shift = shiftSelect.value;

            fetch('<%=request.getContextPath()%>/admin/shift?action=addShiftFromClient', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    shiftType: shift,
                    shiftDate: dateStr
                })
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    if(!shiftMap[dateStr]) shiftMap[dateStr] = {};
                    shiftMap[dateStr][shift] = [];

                    const doctorSection = document.querySelector('.doctor-section');
                    doctorSection.style.display = "block";
                    updateDoctorList();
                    updateShiftButton();
                    renderCalendar(currentYear, currentMonth);

                    console.log("Thêm ca trực thành công:", dateStr, shift);
                } else {
                    alert("Thêm ca trực thất bại: " + (data.message || ""));
                }
            })
            .catch(err => console.error(err));
        };
    }
}


/* ========== attach events for calendar cell buttons ========== */
function attachShiftButtonEvents() {
    document.querySelectorAll('.shift-btn').forEach(btn => {
        btn.onclick = function() {
            const cell = this.closest('.calendar-cell');
            const dayNumber = cell.querySelector('.day-number').innerText;
            const month = currentMonth + 1;
            const year = currentYear;
            const dateStr = year + '-' + pad2(month) + '-' + pad2(dayNumber);

            document.getElementById('shiftDate').value = dateStr;

            // default chọn ca sáng (có thể đổi theo dữ liệu)
            // nếu muốn chọn ca có sẵn, có thể tìm ưu tiên morning > afternoon > night
            shiftSelect.value = 'morning';

            // gán onchange, gọi update và show modal
            shiftSelect.onchange = () => {
                updateDoctorList();
                updateShiftButton();
                renderSelectedDoctors();
            };

            updateDoctorList();
            updateShiftButton();
            renderSelectedDoctors();

            new bootstrap.Modal(document.getElementById('shiftModal')).show();
        };
    });
}

/* ============================
         RENDER CALENDAR
   ============================ */
function renderCalendar(year, month) {
    monthTitle.innerText = "Tháng " + (month + 1) + " / " + year;
    calendarBody.innerHTML = "";

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const startIndex = (firstDay === 0 ? 6 : firstDay - 1);

    let day = 1;

    for (let week = 0; week < 6; week++) {
        const row = document.createElement("tr");

        for (let i = 0; i < 7; i++) {
            const cell = document.createElement("td");
            cell.classList.add("calendar-cell");

            if ((week === 0 && i < startIndex) || day > daysInMonth) {
                cell.innerHTML = "";
                cell.style.backgroundColor = "#ffe7e7";
            } else {
                const key = year + '-' + pad2(month + 1) + '-' + pad2(day);
                const shift = shiftMap[key];

                let shiftHTML = "";
                let shiftClass = "";
                if (shift && (shift.morning || shift.afternoon || shift.night)) {
                    shiftClass = "has-shift";
                }
                
                if (shift) {
                    shiftClass = "has-shift";
                    let info = "";
                    if (shift.morning) info += "Ca sáng: " + shift["morning"].length + " người<br>";
                    if (shift.afternoon) info += "Ca chiều: " + shift["afternoon"].length + " người<br>";
                    if (shift.night) info += "Ca đêm: " + (shift["night"] ? shift["night"].length : 0) + " người";

                    shiftHTML =
                        '<div class="shift-info">' + info + '</div>' +
                        '<button class="btn btn-sm shift-btn">Xem ca trực</button>';
                } else {
                    shiftHTML = '<button class="btn btn-sm shift-btn">Thêm ca trực</button>';
                }

                cell.innerHTML =
                    '<div class="cell-content">' +
                        '<div class="day-number">' + day + '</div>' +
                        shiftHTML +
                    '</div>';

                if (shiftClass) cell.classList.add(shiftClass);
                if (day === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
                    cell.classList.add("today");
                }

                day++;
            }
            row.appendChild(cell);
        }
        calendarBody.appendChild(row);
    }

    attachShiftButtonEvents(); // gắn sự kiện sau khi render
}

document.getElementById("selectedDate").addEventListener("change", function()
{
    let selected = this.value;
    
    if (!selected) return;
    let part = selected.split("-");
    let year = parseInt(part[0]);
    let month = parseInt(part[1]) - 1;
    
    currentMonth = month;
    currentYear = year;
    
    renderCalendar(year, month);
});
    

/* ========== NÚT CHUYỂN THÁNG ========== */
document.getElementById("prevMonth").onclick = () => {
    currentMonth--;
    if (currentMonth < 0) { currentMonth = 11; currentYear--; }
    renderCalendar(currentYear, currentMonth);
};

document.getElementById("nextMonth").onclick = () => {
    currentMonth++;
    if (currentMonth > 11) { currentMonth = 0; currentYear++; }
    renderCalendar(currentYear, currentMonth);
};

/* ========== NÚT THÊM BÁC SĨ (tạm local) ========== */
addDoctorBtn.addEventListener('click', () => {
    const selectedId = doctorSelect.value;
    if (!selectedId) {
        alert("Hãy chọn bác sĩ trước.");
        return;
    }

    const dateStr = document.getElementById('shiftDate').value;
    const shift = shiftSelect.value;

    if (!shiftMap[dateStr]) shiftMap[dateStr] = {};
    if (!shiftMap[dateStr][shift]) shiftMap[dateStr][shift] = [];

    const selectedDoctor = allDoctorsList.find(d => d.userId == selectedId || d.id == selectedId);

    shiftMap[dateStr][shift].push({
        userId: selectedDoctor.userId ?? selectedDoctor.id,
        fullName: selectedDoctor.fullName,
        departmentName: selectedDoctor.departmentName ?? ""
    });

    updateDoctorList();
    renderSelectedDoctors();
});



/* ========== LƯU CA TRỰC (tạm client-side) ========== */
saveShiftBtn.addEventListener('click', () => {
    const dateStr = document.getElementById('shiftDate').value;
    const shiftType = shiftSelect.value;
    const doctorsList = (shiftMap[dateStr] && shiftMap[dateStr][shiftType]) ? shiftMap[dateStr][shiftType] : [];
   
    if (doctorsList.length === 0) {
        alert("Không có bác sĩ nào để lưu!");
        return;
    }


    fetch('/du_an1/admin/shift?action=saveDoctors', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            shiftType: shiftType,
            shiftDate: dateStr,
            doctors: JSON.stringify(doctorsList)
        })
    })
    .then(res => res.json()) // trực tiếp parse JSON, không cần try/catch
    .then(data => {
        if (data.status === "success") {
            alert("Lưu bác sĩ ca trực thành công!");
            bootstrap.Modal.getInstance(document.getElementById('shiftModal')).hide();
            renderCalendar(currentYear, currentMonth);
        } else {
            alert("Lỗi: " + (data.message || "Không xác định"));
        }
    })
    .catch(err => console.error(err));
});



function renderSelectedDoctors() {
    var dateStr = document.getElementById('shiftDate').value;
    var shift = shiftSelect.value;

    var box = document.getElementById('selectedDoctorsBox');
    box.innerHTML = "";

    var doctorsList = (shiftMap[dateStr] && shiftMap[dateStr][shift]) ? shiftMap[dateStr][shift] : [];

    for (var i = 0; i < doctorsList.length; i++) {
        var doc = doctorsList[i];
        var item = document.createElement("div");
        item.classList.add("doctor-item");

        // Hiển thị id, tên, bộ phận
        item.innerHTML =
            '<span class="doctor-name">[' + (doc.userId) + '] ' + doc.fullName + ' - ' + (doc.departmentName) + '</span>' +
            '<button class="btn btn-danger btn-sm btn-delete-doctor">Xóa</button>';

        // gắn sự kiện xóa
        (function(index){
            item.querySelector('button').addEventListener('click', function() {
                if (confirm("Xóa bác sĩ này khỏi ca trực?")) {
                    const idToRemove = doc.userId ?? doc.id;
                    const dateStr = document.getElementById('shiftDate').value;
                    const shift = shiftSelect.value;

                    // Lọc trực tiếp
                    shiftMap[dateStr][shift] = shiftMap[dateStr][shift].filter(d => (d.userId ?? d.id) != idToRemove);

                    // Nếu shift rỗng → xóa luôn ca
                    if (shiftMap[dateStr][shift].length === 0) {
                        delete shiftMap[dateStr][shift];
                    }
                    // Nếu ngày rỗng → xóa luôn ngày
                    if (shiftMap[dateStr] && Object.keys(shiftMap[dateStr]).length === 0) {
                        delete shiftMap[dateStr];
                    }

                    updateDoctorList();
                    renderSelectedDoctors();
                    renderCalendar(currentYear, currentMonth);
                }
            });
        })(i);

        box.appendChild(item);
    }
}


/* ========== RENDER LẦN ĐẦU ========== */
renderCalendar(currentYear, currentMonth);

</script>
</body>
</html>
