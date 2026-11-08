# DPV TOUR DU LICH --- DEVELOPER HANDOFF

## 1. Mục đích

Đây là tài liệu bàn giao triển khai cho **Backend, Frontend và QA**.
Team dùng tài liệu này cùng `DPV_TourDuLich_FINAL.sql` để code mà không
cần đọc lại toàn bộ lịch sử phân tích.

**Stack:** ASP.NET Core Web API + Entity Framework Core + MySQL 8.0+ +
React.

Luồng tổng quát:

``` text
USER → PAGE → FUNCTION → API → CONTROLLER → SERVICE → DATABASE → BUSINESS RULE → TEST
```

Nguyên tắc: API là hợp đồng giữa FE và BE. Không tự ý đổi endpoint,
field, status hoặc nghiệp vụ mà không cập nhật tài liệu.

------------------------------------------------------------------------

# 2. DATABASE FINAL

Database chuẩn: `DPV_TourDuLich_FINAL.sql`.

Hiện có **56 bảng**:

### Account/Security

`TAI_KHOAN`, `VAI_TRO`, `QUYEN`, `TAI_KHOAN_VAI_TRO`, `VAI_TRO_QUYEN`,
`PHIEN_DANG_NHAP`, `DAT_LAI_MAT_KHAU`, `LICH_SU_VAI_TRO`.

### Employee/Department

`NHAN_VIEN`, `BAN`, `NHAN_VIEN_BAN`, `CHUYEN_MON_HDV`, `NGON_NGU`,
`NHAN_VIEN_NGON_NGU`.

### Customer

`KHACH_HANG`.

### Master

`QUOC_GIA`, `TINH_THANH`, `DIA_DIEM`, `LOAI_TOUR`.

### Tour operation

`TOUR`, `TOUR_DIA_DIEM`, `DOT_KHOI_HANH`, `LICH_TRINH`, `PHAN_CONG_HDV`,
`TIEN_TRINH_TOUR`, `HINH_ANH_TIEN_TRINH`.

### Booking/payment

`CHINH_SACH_HUY`, `QUY_TAC_HUY`, `BOOKING`, `HANH_KHACH`, `THANH_TOAN`,
`DOI_SOAT_GIAO_DICH`, `HUY_BOOKING`, `HOAN_TIEN`.

### Custom tour

`YEU_CAU_TOUR_RIENG`, `YEU_CAU_TOUR_DIA_DIEM`, `PHAN_CONG_YEU_CAU_TOUR`,
`BAO_GIA_TOUR_RIENG`, `CHI_TIET_BAO_GIA`, `TOUR_TU_YEU_CAU`.

### Budget/Expense

`NGAN_SACH_DOT`, `CHI_TIET_NGAN_SACH`, `CHI_PHI`, `CHUNG_TU_CHI_PHI`,
`DUYET_CHI_PHI`.

### Incident/Schedule

`SU_CO_TOUR`, `CHUNG_TU_SU_CO`, `THAY_DOI_LICH_TRINH`,
`PHAN_HOI_THAY_DOI`, `HUY_DOT_KHOI_HANH`.

### Supporting

`CHUYEN_BOOKING`, `DANH_GIA_TOUR`, `TOUR_YEU_THICH`, `THONG_BAO`,
`NHAT_KY_HE_THONG`, `LIEN_HE`.

### CSDL không có

-   `BAN_QUOC_GIA`
-   `PHUONG_TIEN`
-   Xử lý thuế chi tiết

`TOUR.loai_tour` cũ đã được chốt thay bằng `TOUR.loai_tour_id` → `LOAI_TOUR.id`.

`LICH_TRINH` thuộc từng `DOT_KHOI_HANH`, vì mỗi departure có lịch trình
vận hành riêng.

------------------------------------------------------------------------

# 3. ROLES

System roles:

``` text
ADMIN
QUAN_LY_TONG
TRUONG_BAN
HDV
NHAN_VIEN
KHACH_HANG
```

**VAI_TRO hệ thống khác `NHAN_VIEN_BAN.vai_tro_trong_ban`.**

Một nhân viên có thể có system role `HDV` nhưng đồng thời giữ chức vụ
`TRUONG_BAN` trong một ban.

------------------------------------------------------------------------

# 4. SECURITY

## Password

-   BCrypt/hash.
-   Không lưu plaintext.
-   Không trả `password_hash`.

## Refresh token

-   Hash trước khi lưu `PHIEN_DANG_NHAP.refresh_token_hash`.

## Reset password

-   Hash token.
-   Token dùng một lần.
-   Kiểm tra expiry/status.

## Authorization

-   Backend mới là nơi quyết định quyền.
-   Không tin `customerId`, `employeeId`, role do FE gửi nếu có thể lấy
    từ JWT.
-   Frontend chỉ dùng permission để UX.

------------------------------------------------------------------------

# 5. API CONVENTION

JSON camelCase.

Ví dụ:

``` json
{
  "id": 1,
  "tenTour": "Da Nang - Hoi An",
  "trangThai": "CONG_KHAI"
}
```

Error format:

``` json
{
  "code": "BOOKING_001",
  "message": "Đợt khởi hành đã hết chỗ.",
  "details": null,
  "timestamp": "2026-09-22T10:00:00Z"
}
```

HTTP: `400` validation, `401` unauthenticated, `403` forbidden, `404`
not found, `409` conflict, `422` business validation, `500` server
error.

------------------------------------------------------------------------

# 6. MODULE AUTHENTICATION

  ID        Method   Endpoint                      Quyền
  --------- -------- ----------------------------- ------------------------
  AUTH-01   POST     `/api/auth/login`             Public
  AUTH-02   POST     `/api/auth/register`          Public
  AUTH-03   POST     `/api/auth/logout`            Auth
  AUTH-04   POST     `/api/auth/forgot-password`   Public
  AUTH-05   POST     `/api/auth/reset-password`    Public
  AUTH-06   POST     `/api/auth/refresh-token`     Public + valid refresh
  AUTH-07   GET      `/api/auth/me`                Auth

### AUTH-01 Login

Request:

``` json
{"email":"user@gmail.com","matKhau":"12345678"}
```

Flow:

``` text
validate → TAI_KHOAN → status → BCrypt
→ roles → Access Token
→ Refresh Token → hash + PHIEN_DANG_NHAP
→ update lan_dang_nhap_cuoi
```

Không trả password/hash.

### AUTH-02 Register

Request gồm `hoTen,email,soDienThoai,matKhau,xacNhanMatKhau`.

Một transaction:

``` text
TAI_KHOAN + TAI_KHOAN_VAI_TRO(KHACH_HANG) + KHACH_HANG
```

### AUTH-03 Logout

Nhận refresh token, tìm session, đánh dấu logout.

### AUTH-04 Forgot password

Không được tiết lộ email có tồn tại hay không.

### AUTH-05 Reset password

Validate token → expiry → unused → BCrypt password mới → mark token
used.

### AUTH-06 Refresh

Hash token → validate session/account → issue access token mới.

### AUTH-07 Me

Lấy account hiện tại từ JWT + role + customer/employee profile.

------------------------------------------------------------------------

# 7. ACCOUNT & ROLE

  ID           Method   Endpoint
  ------------ -------- ---------------------------------------
  ACCOUNT-01   GET      `/api/admin/accounts`
  ACCOUNT-02   GET      `/api/admin/accounts/{id}`
  ACCOUNT-03   POST     `/api/admin/accounts`
  ACCOUNT-04   POST     `/api/admin/accounts/{id}/roles`
  ACCOUNT-05   PUT      `/api/admin/accounts/{id}/roles`
  ACCOUNT-06   PUT      `/api/admin/accounts/{id}/lock`
  ACCOUNT-07   PUT      `/api/admin/accounts/{id}/unlock`
  ACCOUNT-08   PUT      `/api/admin/accounts/{id}/deactivate`
  ACCOUNT-09   GET      `/api/admin/roles`
  ACCOUNT-10   GET      `/api/admin/permissions`
  ACCOUNT-11   PUT      `/api/admin/roles/{id}/permissions`

Rules: - Admin quản lý role hệ thống. - Lock phải invalidate sessions. -
Không hard delete account. - Role change ghi `LICH_SU_VAI_TRO`. - Tạo
account nhân viên phải tạo `NHAN_VIEN` phù hợp. - Không trả password
hash.

------------------------------------------------------------------------

# 8. CUSTOMER

  -------------------------------------------------------------------------------------------------------------------
  ID                      Method                  Endpoint
  ----------------------- ----------------------- -------------------------------------------------------------------
  CUSTOMER-01             GET                     `/api/customers/me`

  CUSTOMER-02             PUT                     `/api/customers/me`

  CUSTOMER-03             GET                     `/api/customers/me/bookings`

  CUSTOMER-04             GET                     `/api/customers/me/bookings/{bookingId}`

  CUSTOMER-05             GET                     `/api/customers/me/bookings/{bookingId}/passengers`

  CUSTOMER-06             PUT                     `/api/customers/me/bookings/{bookingId}/passengers/{passengerId}`
  -------------------------------------------------------------------------------------------------------------------

Ownership luôn kiểm tra:

``` text
JWT → KHACH_HANG → BOOKING.khach_hang_id
```

Không cho customer xem/sửa booking của người khác.

`KHACH_HANG` = người đặt/sở hữu account/profile.\
`HANH_KHACH` = người thực tế tham gia tour. Booker có thể là passenger.

------------------------------------------------------------------------

# 9. MASTER DATA

## Country

``` text
GET  /api/countries
GET  /api/countries/{id}
POST /api/admin/countries
PUT  /api/admin/countries/{id}
PUT  /api/admin/countries/{id}/deactivate
```

## Province

``` text
GET  /api/provinces?countryId={id}
GET  /api/provinces/{id}
POST /api/admin/provinces
PUT  /api/admin/provinces/{id}
PUT  /api/admin/provinces/{id}/deactivate
```

## Location

``` text
GET  /api/locations?provinceId={id}
GET  /api/locations/{id}
POST /api/admin/locations
PUT  /api/admin/locations/{id}
PUT  /api/admin/locations/{id}/deactivate
```

## Tour type

``` text
GET  /api/tour-types
POST /api/admin/tour-types
PUT  /api/admin/tour-types/{id}
PUT  /api/admin/tour-types/{id}/deactivate
```

## Language

``` text
GET  /api/languages
POST /api/admin/languages
PUT  /api/admin/languages/{id}
PUT  /api/admin/languages/{id}/deactivate
```

Master data không hard-code trong React. Admin deactivate thay vì xóa
lịch sử.

------------------------------------------------------------------------

# 10. TOUR

### Khái niệm

``` text
TOUR = sản phẩm/khung tour
DOT_KHOI_HANH = một lần khởi hành
```

### Status

``` text
NHAP → CHO_DUYET → DA_DUYET → CONG_KHAI → NGUNG_BAN
CHO_DUYET → TU_CHOI → NHAP
```

### API

``` text
GET  /api/tours
GET  /api/tours/{tourId}
POST /api/manager/tours
PUT  /api/manager/tours/{tourId}
POST /api/manager/tours/{tourId}/locations
DELETE /api/manager/tours/{tourId}/locations/{locationId}
POST /api/manager/tours/{tourId}/submit
POST /api/admin/tours/{tourId}/approve
POST /api/admin/tours/{tourId}/reject
POST /api/admin/tours/{tourId}/publish
POST /api/admin/tours/{tourId}/stop-selling
```

Rules: - `loaiTourId` FK tới `LOAI_TOUR`. - `TOUR_DIA_DIEM` lưu thứ
tự. - Admin/Quản lý tổng có quyền tour theo scope; Trưởng ban theo phạm
vi được giao. - Không hard delete tour đã có lịch sử. - Giá TOUR là giá
tham chiếu. - Giá departure là giá bán thực tế. - Giá booking là
snapshot.

Không nhận `nguoiTaoId` từ FE nếu có thể lấy employee từ JWT.

------------------------------------------------------------------------

# 11. DEPARTURE

API:

``` text
GET  /api/tours/{tourId}/departures
GET  /api/departures/{departureId}
POST /api/manager/tours/{tourId}/departures
PUT  /api/manager/departures/{departureId}
PUT  /api/manager/departures/{departureId}/open
PUT  /api/manager/departures/{departureId}/close
PUT  /api/manager/departures/{departureId}/cancel
GET  /api/departures/{departureId}/availability
```

Rules: - `ngayKetThuc > ngayKhoiHanh`. - capacity \> 0. -
`soChoDaDat <= soChoToiDa`. - Full/closed/cancelled không nhận
booking. - Mỗi departure có state riêng. - `LICH_TRINH` thuộc departure.

------------------------------------------------------------------------

# 12. GUIDE ASSIGNMENT

``` text
GET    /api/manager/departures/{departureId}/available-guides
GET    /api/manager/departures/{departureId}/guides
POST   /api/manager/departures/{departureId}/guides
PUT    /api/manager/departures/{departureId}/guides/{employeeId}
DELETE /api/manager/departures/{departureId}/guides/{employeeId}
GET    /api/employees/{employeeId}/assignments
```

Rules: - HDV active. - Có role phù hợp. - Không trùng lịch. - Có thể
kiểm tra chuyên môn/ngôn ngữ. - Một departure có thể nhiều HDV. - Chỉ
một `HDV_CHINH`, còn lại `HDV_PHU`.

Overlap:

``` text
startA <= endB AND endA >= startB
```

------------------------------------------------------------------------

# 13. BOOKING

API:

``` text
GET  /api/departures/{departureId}/booking-availability
POST /api/bookings
GET  /api/customers/me/bookings
GET  /api/customers/me/bookings/{bookingId}
PUT  /api/customers/me/bookings/{bookingId}/passengers/{passengerId}
GET  /api/manager/bookings
GET  /api/manager/bookings/{bookingId}
```

## Create booking

Request có `dotKhoiHanhId`, số người lớn/trẻ em/em bé và danh sách
passenger.

Backend:

``` text
authenticate
→ current customer
→ load departure
→ transaction + lock/atomic capacity
→ validate status/date/capacity
→ validate passengers
→ lấy giá departure
→ backend tự tính total
→ snapshot giá
→ create BOOKING
→ create HANH_KHACH
→ update capacity
→ commit
```

**Không tin `tongTien` từ frontend.**

Booking statuses:

``` text
CHO_THANH_TOAN
DA_THANH_TOAN
DA_XAC_NHAN
DA_HUY
HOAN_TIEN
HOAN_THANH
HET_HAN
```

### Critical concurrency test

Nếu còn 1 chỗ và 2 khách đặt đồng thời:

``` text
chỉ 1 booking được thành công
so_cho_da_dat không bao giờ > so_cho_toi_da
```

------------------------------------------------------------------------

# 14. PAYMENT

Giai đoạn đầu: **Mock Payment**.

API:

``` text
POST /api/bookings/{bookingId}/payments
GET  /api/bookings/{bookingId}/payments
GET  /api/payments/{paymentId}
POST /api/payments/callback
```

Flow:

``` text
BOOKING
→ PAYMENT
→ Mock provider
→ success/fail
→ THANH_TOAN
→ BOOKING status
→ DOI_SOAT_GIAO_DICH
```

Callback phải kiểm tra amount, transaction, trạng thái và idempotency.

Thiết kế provider abstraction để sau này có thể thay bằng
VNPay/MoMo/ZaloPay/bank transfer.

------------------------------------------------------------------------

# 15. CANCELLATION / REFUND

## Cancellation

``` text
POST /api/bookings/{bookingId}/cancel
GET  /api/bookings/{bookingId}/cancellation-policy
GET  /api/bookings/{bookingId}/cancellation
```

Chính sách lấy từ:

`CHINH_SACH_HUY` + `QUY_TAC_HUY`.

Tỷ lệ hoàn dựa trên số ngày trước departure. Không hard-code trong FE.

## Refund

``` text
GET  /api/bookings/{bookingId}/refund
POST /api/bookings/{bookingId}/refund
```

Cơ bản:

``` text
refund = paidAmount - cancellationFee
```

Phải phân biệt khách tự hủy và công ty hủy departure.

------------------------------------------------------------------------

# 16. EMPLOYEE

``` text
GET  /api/admin/employees
GET  /api/admin/employees/{employeeId}
PUT  /api/admin/employees/{employeeId}
POST /api/admin/employees/{employeeId}/departments
PUT  /api/admin/employees/{employeeId}/departments/{banId}
DELETE /api/admin/employees/{employeeId}/departments/{banId}
GET  /api/admin/employees/{employeeId}/departments
GET  /api/admin/employees/{employeeId}/specializations
POST /api/admin/employees/{employeeId}/specializations
DELETE /api/admin/employees/{employeeId}/specializations/{id}
GET  /api/admin/employees/{employeeId}/languages
POST /api/admin/employees/{employeeId}/languages
DELETE /api/admin/employees/{employeeId}/languages/{id}
GET  /api/employees/guides
```

Rules: - Employee có thể thuộc nhiều ban. - HDV có nhiều chuyên môn/ngôn
ngữ. - Employee inactive không nhận assignment mới. - Không hard delete
có lịch sử.

------------------------------------------------------------------------

# 17. DEPARTMENT / BAN

``` text
GET  /api/departments
GET  /api/departments/{banId}
POST /api/admin/departments
PUT  /api/admin/departments/{banId}
PUT  /api/admin/departments/{banId}/activate
PUT  /api/admin/departments/{banId}/deactivate
GET  /api/departments/{banId}/employees
GET  /api/departments/{banId}/manager
```

Rules: - Ban linh hoạt theo nhu cầu. - Một trưởng ban active. - Trưởng
ban phải là thành viên ban. - Ban inactive không nhận nghiệp vụ mới. -
Không có `BAN_QUOC_GIA`.

------------------------------------------------------------------------

# 18. CUSTOM TOUR

Flow:

``` text
Customer request
→ Quản lý tổng
→ phân công các ban liên quan
→ Trưởng ban xử lý
→ đề xuất lịch/điểm/HDV
→ Quản lý tổng tổng hợp
→ quotation
→ customer confirm
→ tạo TOUR riêng + DOT_KHOI_HANH riêng
```

API:

``` text
POST /api/custom-tour-requests
GET  /api/custom-tour-requests/me
GET  /api/manager/custom-tour-requests
GET  /api/manager/custom-tour-requests/{id}
POST /api/manager/custom-tour-requests/{id}/assign-departments
POST /api/department-manager/custom-tour-requests/{id}/process
POST /api/manager/custom-tour-requests/{id}/quotation
GET  /api/custom-tour-quotations/{id}
POST /api/custom-tour-quotations/{id}/confirm
```

Không nhét toàn bộ custom data vào BOOKING.

------------------------------------------------------------------------

# 19. BUDGET / EXPENSE

## Budget

``` text
GET  /api/manager/departures/{departureId}/budget
POST /api/manager/departures/{departureId}/budget
PUT  /api/manager/departures/{departureId}/budget
```

DB: `NGAN_SACH_DOT`, `CHI_TIET_NGAN_SACH`.

## Expense

``` text
POST /api/manager/departures/{departureId}/expenses
GET  /api/manager/departures/{departureId}/expenses
GET  /api/manager/expenses/{expenseId}
PUT  /api/manager/expenses/{expenseId}
POST /api/manager/expenses/{expenseId}/submit
POST /api/manager/expenses/{expenseId}/approve
POST /api/manager/expenses/{expenseId}/reject
```

DB: `CHI_PHI`, `CHUNG_TU_CHI_PHI`, `DUYET_CHI_PHI`.

------------------------------------------------------------------------

# 20. INCIDENT / SCHEDULE CHANGE

## Incident

``` text
POST /api/guides/departures/{departureId}/incidents
GET  /api/manager/departures/{departureId}/incidents
GET  /api/manager/incidents/{id}
PUT  /api/manager/incidents/{id}
POST /api/manager/incidents/{id}/resolve
```

DB: `SU_CO_TOUR`, `CHUNG_TU_SU_CO`.

## Schedule change

``` text
POST /api/manager/departures/{departureId}/schedule-changes
GET  /api/manager/departures/{departureId}/schedule-changes
GET  /api/customers/me/bookings/{bookingId}/schedule-changes
POST /api/customers/me/bookings/{bookingId}/schedule-changes/{id}/accept
POST /api/customers/me/bookings/{bookingId}/schedule-changes/{id}/reject
```

DB: `THAY_DOI_LICH_TRINH`, `PHAN_HOI_THAY_DOI`.

Thay đổi quan trọng phải có customer response theo nghiệp vụ; không sửa
lịch sử trực tiếp.

------------------------------------------------------------------------

# 21. REVIEW / FAVORITE / NOTIFICATION / REPORT / AUDIT / CONTACT

## Review

``` text
POST /api/bookings/{bookingId}/review
GET  /api/tours/{tourId}/reviews
GET  /api/customers/me/reviews
```

Chỉ booking hoàn thành; mỗi booking một review.

## Favorite

``` text
GET    /api/customers/me/favorites
POST   /api/customers/me/favorites/{tourId}
DELETE /api/customers/me/favorites/{tourId}
```

## Notification

``` text
GET /api/notifications
GET /api/notifications/unread-count
PUT /api/notifications/{id}/read
PUT /api/notifications/read-all
```

## Report

``` text
GET /api/admin/reports/overview
GET /api/admin/reports/revenue
GET /api/admin/reports/bookings
GET /api/admin/reports/tours
GET /api/admin/reports/departures
GET /api/admin/reports/expenses
```

Không xử lý thuế.

## Audit

DB `NHAT_KY_HE_THONG`; ghi
login/logout/create/update/approve/reject/assign/payment/cancel/refund/role
change. Không log password/token.

## Contact

``` text
POST /api/contacts
GET  /api/admin/contacts
GET  /api/admin/contacts/{id}
PUT  /api/admin/contacts/{id}/process
```

------------------------------------------------------------------------

# 22. BACKEND STRUCTURE

``` text
src/
├── Controllers/
├── Services/
├── Repositories/
├── Entities/
├── DTOs/
├── Data/
│   └── ApplicationDbContext.cs
├── Middleware/
├── Authentication/
├── Helpers/
└── Program.cs
```

Controller chỉ nhận request, gọi service, trả response.

Service chứa business logic, authorization nghiệp vụ, transaction và
tính toán.

EF Core/Repository xử lý persistence.

------------------------------------------------------------------------

# 23. FRONTEND STRUCTURE

``` text
src/
├── pages/
│   ├── auth/
│   ├── user/
│   ├── admin/
│   ├── manager/
│   ├── department-manager/
│   └── guide/
├── components/
├── layouts/
├── services/
├── api/
├── hooks/
├── contexts/
├── routes/
├── utils/
└── constants/
```

Frontend không tự quyết định: - giá cuối; - capacity; - permission
thật; - status nghiệp vụ; - refund amount.

Frontend hiển thị kết quả Backend.

------------------------------------------------------------------------

# 24. PAGES ĐÃ THỐNG NHẤT

## User

`[user]TrangChu`, `[user]DanhSachTour`, `[user]ChiTietTour`,
`[user]DatTour`, `[user]ThanhToan`, `[user]KetQuaDatTour`,
`[user]DonDatCuaToi`, `[user]ChiTietDonDat`, `[user]YeuCauHuyTour`,
`[user]YeuCauTourRieng`, `[user]YeuCauTourRiengCuaToi`,
`[user]ThongTinCaNhan`, `[user]DoiMatKhau`.

## Auth

`[auth]DangNhap`, `[auth]DangKy`, `[auth]QuenMatKhau`,
`[auth]DatLaiMatKhau`.

## Admin

`[admin]TongQuan`, `[admin]QuanLyTaiKhoan`, `[admin]ChiTietTaiKhoan`,
`[admin]QuanLyPhongBan`, `[admin]ChiTietPhongBan`,
`[admin]QuanLyDanhMuc`, `[admin]BaoCaoTongQuan`.

## Manager

`[manager]TongQuan`, `[manager]QuanLyTour`, `[manager]TaoTour`,
`[manager]ChiTietTour`, `[manager]QuanLyDotKhoiHanh`,
`[manager]TaoDotKhoiHanh`, `[manager]ChiTietDotKhoiHanh`,
`[manager]PhanCongHDV`, `[manager]QuanLyYeuCauTourRieng`,
`[manager]ChiTietYeuCauTourRieng`, `[manager]XuLySuCo`.

## Department Manager

`[department-manager]TongQuan`, `[department-manager]YeuCauCanXuLy`,
`[department-manager]ChiTietYeuCau`,
`[department-manager]QuanLyNhanSuPhong`.

## Guide

`[guide]TongQuan`, `[guide]TourDuocPhanCong`,
`[guide]ChiTietTourDuocPhanCong`, `[guide]CapNhatTienDo`,
`[guide]BaoCaoSuCo`.

------------------------------------------------------------------------

# 25. FRONTEND AUTH FLOW

``` text
Login
→ POST /api/auth/login
→ access + refresh
→ GET /api/auth/me
→ load user/roles
→ route theo role
```

Axios interceptor attach access token.

401 → refresh → retry.

Refresh thất bại → clear auth → login.

------------------------------------------------------------------------

# 26. TRANSACTION BẮT BUỘC

### Register

`TAI_KHOAN + ROLE + KHACH_HANG`

### Create employee account

`TAI_KHOAN + NHAN_VIEN + ROLE + ROLE HISTORY`

### Booking

`BOOKING + HANH_KHACH + capacity update`

### Payment

`THANH_TOAN + BOOKING + DOI_SOAT_GIAO_DICH`

### Refund

`HOAN_TIEN + booking/payment status`

### Role change

`TAI_KHOAN_VAI_TRO + LICH_SU_VAI_TRO`

------------------------------------------------------------------------

# 27. QA CRITICAL TESTS

Mỗi API:

``` text
success
validation
401
403
404
409
ownership
duplicate
invalid status
transaction rollback
```

Booking phải test concurrency:

``` text
1 chỗ còn lại
2 request đồng thời
→ chỉ 1 thành công
→ capacity không vượt giới hạn
```

Security:

``` text
JWT expired
JWT giả
refresh token giả
account locked/deactivated
customer truy cập booking người khác
customer gọi admin API
guide gọi manager API
```

------------------------------------------------------------------------

# 28. DEFINITION OF DONE

## Backend

``` text
[ ] Entity/DB mapping
[ ] Request DTO
[ ] Response DTO
[ ] Controller
[ ] Service
[ ] EF/Repository
[ ] Authorization
[ ] Validation
[ ] Business rules
[ ] Transaction
[ ] Error handling
[ ] Swagger
[ ] API test
[ ] Logging
```

## Frontend

``` text
[ ] Page
[ ] Route
[ ] API service
[ ] Request/response mapping
[ ] Loading
[ ] Empty
[ ] Error
[ ] Success
[ ] Permission
[ ] Form validation
[ ] Navigation
[ ] Auth refresh
```

## QA

``` text
[ ] Functional
[ ] Validation
[ ] Permission
[ ] Ownership
[ ] Boundary
[ ] Concurrency
[ ] Regression
[ ] API response
[ ] DB consistency
```

------------------------------------------------------------------------

# 29. DEVELOPMENT PRIORITY

## Phase 1 --- Core

`AUTH → ACCOUNT → CUSTOMER → MASTER DATA → TOUR → DEPARTURE`

## Phase 2 --- Selling

`BOOKING → PASSENGER → PAYMENT MOCK → CANCELLATION → REFUND`

## Phase 3 --- Internal

`EMPLOYEE → DEPARTMENT → GUIDE ASSIGNMENT → TOUR PROGRESS`

## Phase 4 --- Custom

`CUSTOM TOUR → department processing → guide proposal → quotation → confirmation → dedicated TOUR + DEPARTURE`

## Phase 5 --- Operation

`BUDGET → EXPENSE → INCIDENT → SCHEDULE CHANGE`

## Phase 6 --- Supporting

`REVIEW → FAVORITE → NOTIFICATION → REPORT → AUDIT → CONTACT`

------------------------------------------------------------------------

# 30. CORE USER FLOW

``` text
Đăng ký
→ Đăng nhập
→ Xem tour
→ Xem departure
→ Đặt tour
→ Nhập passenger
→ Tạo booking
→ Mock payment
→ Booking xác nhận
→ Theo dõi booking
→ Hủy/hoàn tiền nếu đủ điều kiện
→ Hoàn thành
→ Review
```

Internal:

``` text
Admin → account/role/master data
Quản lý tổng → tour/departure/operation
Trưởng ban → xử lý nghiệp vụ thuộc ban
HDV → assigned tour/progress/incident
Customer → booking/payment/cancel/review
```

------------------------------------------------------------------------

# 31. TRACEABILITY MATRIX

Team duy trì:

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  Page                   Function   API          Method   Role       DB                            Rule        FE        BE               QA
  ---------------------- ---------- ------------ -------- ---------- ----------------------------- ----------- --------- ---------------- -------------
  `[auth]DangNhap`       Login      AUTH-01      POST     Public     Account/Role/Session          BCrypt      Login     AuthService      Login tests
                                                                                                               form                       

  `[user]DanhSachTour`   List tour  TOUR-01      GET      Public     TOUR                          Published   Tour list TourService      Filter
                                                                                                   only                                   

  `[user]DatTour`        Booking    BOOKING-01   POST     Customer   Booking/Passenger/Departure   Atomic      Booking   BookingService   Concurrency
                                                                                                   capacity    form                       

  `[user]ThanhToan`      Payment    PAYMENT-01   POST     Customer   Payment                       Amount      Payment   PaymentService   Payment tests
                                                                                                   verified    UI                         
  -----------------------------------------------------------------------------------------------------------------------------------------------------

Mọi API mới phải được thêm vào matrix.

------------------------------------------------------------------------

# 32. START NOW --- BACKEND CHECKLIST

``` text
[ ] Clone repository
[ ] Run DPV_TourDuLich_FINAL.sql
[ ] Verify 56 tables
[ ] Configure MySQL connection
[ ] Configure EF Core
[ ] Create entities
[ ] Create DbContext
[ ] Configure JWT
[ ] Configure BCrypt
[ ] Global exception handler
[ ] Standard error response
[ ] Swagger
[ ] AUTH
[ ] ACCOUNT
[ ] CUSTOMER
[ ] MASTER DATA
[ ] TOUR
[ ] DEPARTURE
[ ] BOOKING
[ ] Mock PAYMENT
[ ] CANCEL
[ ] REFUND
```

## Quy tắc cuối cùng

**Database Final + tài liệu này + UX/UI document là bộ tài liệu nền.**

Dev không cần chờ BA giải thích lại từng API. Khi code phát hiện mâu
thuẫn thật sự, phải ghi rõ điểm mâu thuẫn và cập nhật contract; không tự
ý sửa nghiệp vụ trong code.

**END**

# FINAL STATE CONTRACT

## Departure
`MOI_TAO → MO_DANG_KY → (DA_DAY | DONG_DANG_KY) → DA_KHOI_HANH → DANG_DI → DA_HOAN_THANH`

Hủy trước khởi hành: `MOI_TAO / MO_DANG_KY / DA_DAY / DONG_DANG_KY → DA_HUY`.
`DA_DAY` là tự động khi `so_cho_da_dat = so_cho_toi_da`; `DONG_DANG_KY` là đóng đăng ký theo nghiệp vụ/thời hạn.

## Booking
`CHO_THANH_TOAN → DA_THANH_TOAN → DA_XAC_NHAN → HOAN_THANH`; nhánh hủy `CHO_THANH_TOAN / DA_THANH_TOAN / DA_XAC_NHAN → DA_HUY`; booking quá hạn chưa hoàn tất dùng `HET_HAN`.

## Payment
`CHO_THANH_TOAN → DANG_XU_LY → THANH_CONG`; lỗi `DANG_XU_LY → THAT_BAI`. Không dùng `CHUA_THANH_TOAN`.

## Custom Tour Request
`MOI_TAO → DA_TIEP_NHAN → DANG_XU_LY → CHO_BAO_GIA → DA_BAO_GIA → KHACH_DANG_XEM → KHACH_DA_XAC_NHAN → HOAN_TAT`; nhánh `KHACH_TU_CHOI` và `HUY` theo Flow/State Spec.

