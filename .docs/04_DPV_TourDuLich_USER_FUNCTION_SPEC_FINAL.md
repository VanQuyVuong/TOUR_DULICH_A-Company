# STATE SOURCE OF TRUTH

Các state nghiệp vụ chính thức phải lấy từ `05_DPV_TourDuLich_FLOW_STATE_SPEC(1).md` bản FINAL và `DPV_TourDuLich_FINAL.sql`. File này không tự định nghĩa một bộ enum khác.

# DPV TourDuLich --- USER & FUNCTION SPECIFICATION

**Version:** 1.0

## 1. Mục đích

Tài liệu này là bản đồ chức năng của DPV TourDuLich, dùng chung cho BA,
Designer, Frontend, Backend và QA.

Luồng chuẩn:

`ROLE → PAGE → FUNCTION → ACTION → PERMISSION → API → DATABASE → RESULT → NEXT PAGE/STATE → TEST`

Tài liệu này bổ sung cho: - Database / ERD - Developer / API Handoff -
UX/UI Master Spec

------------------------------------------------------------------------

## 2. Nền tảng và quy tắc tên

  Mã       Nền tảng
  -------- -------------
  `WEB`    Web
  `DESK`   Desktop App
  `MOB`    Mobile App

Tên page:

`DPV + PLATFORM + USER/ROLE + TÊN TRANG`

Ví dụ:

``` text
DPVWEBUserTrangChu
DPVWEBUserDanhSachTour
DPVDESKAdminTongQuan
DPVDESKManagerQuanLyTour
DPVMOBUserTrangChu
DPVMOBGuideCapNhatTienDo
```

------------------------------------------------------------------------

## 3. Role hệ thống

### ADMIN

Quản trị tài khoản, role/permission, phòng ban, master data,
duyệt/publish tour, báo cáo và audit.

### QUAN_LY_TONG

Điều hành tour, departure, HDV, booking vận hành, tour riêng, sự cố,
ngân sách và chi phí.

### TRUONG_BAN

Xử lý yêu cầu thuộc Ban, đề xuất HDV và quản lý nhân sự trong Ban.

### HDV

Xem tour được phân công, lịch trình, hành khách, cập nhật tiến độ và báo
cáo sự cố.

### NHAN_VIEN

Quyền thực tế lấy từ:

``` text
TAI_KHOAN
→ TAI_KHOAN_VAI_TRO
→ VAI_TRO
→ VAI_TRO_QUYEN
→ QUYEN
```

### KHACH_HANG

Xem tour, đặt tour, thanh toán, quản lý booking, hủy/hoàn tiền, tour
riêng, review, favorite, notification và hồ sơ.

------------------------------------------------------------------------

## 4. Permission

  Permission           Ý nghĩa
  -------------------- -------------------------------
  `PUBLIC`             Không cần đăng nhập
  `AUTHENTICATED`      Phải đăng nhập
  `OWNER`              Chỉ tài nguyên của chính user
  `ROLE`               Đúng role
  `DEPARTMENT_SCOPE`   Trong phạm vi Ban
  `ADMIN_ONLY`         Chỉ Admin

FE có thể ẩn/hiện UI theo quyền, nhưng BE luôn phải kiểm tra permission
và scope.

------------------------------------------------------------------------

## 5. Role → Page Matrix

### KHACH_HANG --- WEB

``` text
DPVWEBUserTrangChu
DPVWEBUserDanhSachTour
DPVWEBUserChiTietTour
DPVWEBUserDatTour
DPVWEBUserThanhToan
DPVWEBUserKetQuaDatTour
DPVWEBUserDonDatCuaToi
DPVWEBUserChiTietDonDat
DPVWEBUserYeuCauHuyTour
DPVWEBUserYeuCauTourRieng
DPVWEBUserYeuCauTourRiengCuaToi
DPVWEBUserThongTinCaNhan
DPVWEBUserDoiMatKhau
```

### KHACH_HANG --- MOBILE

``` text
DPVMOBUserTrangChu
DPVMOBUserDanhSachTour
DPVMOBUserChiTietTour
DPVMOBUserDatTour
DPVMOBUserThanhToan
DPVMOBUserKetQuaDatTour
DPVMOBUserDonDatCuaToi
DPVMOBUserChiTietDonDat
DPVMOBUserYeuCauHuyTour
DPVMOBUserYeuCauTourRieng
DPVMOBUserYeuCauTourRiengCuaToi
DPVMOBUserThongTinCaNhan
DPVMOBUserDoiMatKhau
```

### ADMIN --- DESKTOP

``` text
DPVDESKAdminTongQuan
DPVDESKAdminQuanLyTaiKhoan
DPVDESKAdminChiTietTaiKhoan
DPVDESKAdminQuanLyPhongBan
DPVDESKAdminChiTietPhongBan
DPVDESKAdminQuanLyDanhMuc
DPVDESKAdminBaoCaoTongQuan
```

### QUAN_LY_TONG --- DESKTOP

``` text
DPVDESKManagerTongQuan
DPVDESKManagerQuanLyTour
DPVDESKManagerTaoTour
DPVDESKManagerChiTietTour
DPVDESKManagerQuanLyDotKhoiHanh
DPVDESKManagerTaoDotKhoiHanh
DPVDESKManagerChiTietDotKhoiHanh
DPVDESKManagerPhanCongHDV
DPVDESKManagerQuanLyYeuCauTourRieng
DPVDESKManagerChiTietYeuCauTourRieng
DPVDESKManagerXuLySuCo
```

### TRUONG_BAN --- DESKTOP

``` text
DPVDESKDepartmentManagerTongQuan
DPVDESKDepartmentManagerYeuCauCanXuLy
DPVDESKDepartmentManagerChiTietYeuCau
DPVDESKDepartmentManagerQuanLyNhanSuPhong
```

### HDV --- DESKTOP

``` text
DPVDESKGuideTongQuan
DPVDESKGuideTourDuocPhanCong
DPVDESKGuideChiTietTourDuocPhanCong
DPVDESKGuideCapNhatTienDo
DPVDESKGuideBaoCaoSuCo
```

### HDV --- MOBILE

``` text
DPVMOBGuideTongQuan
DPVMOBGuideTourDuocPhanCong
DPVMOBGuideChiTietTourDuocPhanCong
DPVMOBGuideCapNhatTienDo
DPVMOBGuideBaoCaoSuCo
```

------------------------------------------------------------------------

## 6. Authentication

### Đăng nhập

Pages:

``` text
DPVWEBAuthDangNhap
DPVDESKAuthDangNhap
DPVMOBAuthDangNhap
```

API:

``` text
POST /api/auth/login
```

Input:

``` text
email
matKhau
```

Success:

``` text
Access Token
Refresh Token
Roles
→ /api/auth/me
→ route theo role
```

Không trả password/hash.

### Đăng ký

Pages:

``` text
DPVWEBAuthDangKy
DPVMOBAuthDangKy
```

API:

``` text
POST /api/auth/register
```

Transaction:

``` text
TAI_KHOAN
+
KHACH_HANG
+
TAI_KHOAN_VAI_TRO
```

Password dùng BCrypt.

### Refresh / Logout

``` text
POST /api/auth/refresh-token
POST /api/auth/logout
```

DB:

``` text
PHIEN_DANG_NHAP
```

### Quên / Reset password

``` text
POST /api/auth/forgot-password
POST /api/auth/reset-password
```

DB:

``` text
DAT_LAI_MAT_KHAU
```

Token phải có hạn và dùng một lần. Không tiết lộ email có tồn tại hay
không.

------------------------------------------------------------------------

## 7. KHACH_HANG --- Trang chủ

Pages:

``` text
DPVWEBUserTrangChu
DPVMOBUserTrangChu
```

Functions:

``` text
USER-HOME-01 Xem trang chủ
USER-HOME-02 Tìm kiếm Tour
USER-HOME-03 Xem Tour nổi bật
USER-HOME-04 Xem điểm đến
USER-HOME-05 Xem Tour sắp khởi hành
USER-HOME-06 Đi đến danh sách Tour
USER-HOME-07 Đi đến Tour riêng
USER-HOME-08 Đăng nhập/Đăng ký
```

Permission: `PUBLIC`

Navigation:

``` text
Trang chủ
→ Danh sách Tour
→ Chi tiết Tour
→ Đặt Tour
→ Thanh toán
→ Kết quả
→ Chi tiết Booking
```

------------------------------------------------------------------------

## 8. KHACH_HANG --- Danh sách Tour

Pages:

``` text
DPVWEBUserDanhSachTour
DPVMOBUserDanhSachTour
```

Functions:

``` text
TOUR-LIST-01 Xem danh sách
TOUR-LIST-02 Tìm kiếm
TOUR-LIST-03 Lọc
TOUR-LIST-04 Sắp xếp
TOUR-LIST-05 Xem chi tiết
TOUR-LIST-06 Yêu thích
```

API:

``` text
GET /api/tours
```

Filter:

``` text
Quốc gia
Tỉnh/Thành
Địa điểm
Loại Tour
Ngày khởi hành
Khoảng giá
```

Favorite dùng `TOUR_YEU_THICH`.

------------------------------------------------------------------------

## 9. KHACH_HANG --- Chi tiết Tour

Pages:

``` text
DPVWEBUserChiTietTour
DPVMOBUserChiTietTour
```

Functions:

``` text
TOUR-DETAIL-01 Xem thông tin
TOUR-DETAIL-02 Xem gallery
TOUR-DETAIL-03 Xem điểm đến
TOUR-DETAIL-04 Xem lịch trình
TOUR-DETAIL-05 Xem chính sách hủy
TOUR-DETAIL-06 Xem đánh giá
TOUR-DETAIL-07 Xem Departure
TOUR-DETAIL-08 Chọn Departure
TOUR-DETAIL-09 Yêu thích
```

API:

``` text
GET /api/tours/{tourId}
```

Quy tắc:

``` text
TOUR ≠ DOT_KHOI_HANH
```

------------------------------------------------------------------------

## 10. KHACH_HANG --- Đặt Tour

Pages:

``` text
DPVWEBUserDatTour
DPVMOBUserDatTour
```

Functions:

``` text
BKG-01 Xác nhận Departure
BKG-02 Nhập thông tin người đặt
BKG-03 Thêm hành khách
BKG-04 Sửa hành khách
BKG-05 Xóa hành khách
BKG-06 Xem tổng tiền
BKG-07 Xác nhận Booking
```

API:

``` text
POST /api/bookings
```

DB:

``` text
BOOKING
HANH_KHACH
DOT_KHOI_HANH
```

Interaction:

``` text
User bấm Xác nhận
→ FE validate
→ Loading
→ POST /api/bookings
→ Success → DPVWEBUserThanhToan
→ Error → giữ form + hiển thị lỗi
```

Critical rule:

``` text
Booking phải atomic/locked để chống overbooking.
```

------------------------------------------------------------------------

## 11. KHACH_HANG --- Thanh toán

Pages:

``` text
DPVWEBUserThanhToan
DPVMOBUserThanhToan
```

Functions:

``` text
PAY-01 Xem Booking
PAY-02 Xem hành khách
PAY-03 Xem tổng tiền
PAY-04 Chọn phương thức
PAY-05 Thanh toán
PAY-06 Xem trạng thái
```

APIs:

``` text
POST /api/bookings/{bookingId}/payments
GET /api/bookings/{bookingId}/payments/{paymentId}
```

Ban đầu dùng Mock Payment.

Có thể mở rộng:

``` text
VNPay
MoMo
ZaloPay
Bank Transfer
```

Bắt buộc tách:

``` text
Booking Status
≠
Payment Status
```

------------------------------------------------------------------------

## 12. KHACH_HANG --- Kết quả đặt Tour

Pages:

``` text
DPVWEBUserKetQuaDatTour
DPVMOBUserKetQuaDatTour
```

Success hiển thị:

``` text
Mã Booking
Tour
Departure
Số khách
Tổng tiền
Booking Status
Payment Status
```

Failure:

``` text
Lý do
Thử lại
Quay lại
```

------------------------------------------------------------------------

## 13. KHACH_HANG --- Booking

Pages:

``` text
DPVWEBUserDonDatCuaToi
DPVMOBUserDonDatCuaToi
DPVWEBUserChiTietDonDat
DPVMOBUserChiTietDonDat
```

Functions:

``` text
BKG-LIST-01 Xem danh sách
BKG-LIST-02 Tìm Booking
BKG-LIST-03 Lọc trạng thái
BKG-LIST-04 Lọc thời gian
BKG-LIST-05 Xem chi tiết

BKG-DETAIL-01 Xem tổng quan
BKG-DETAIL-02 Xem hành khách
BKG-DETAIL-03 Cập nhật hành khách nếu được phép
BKG-DETAIL-04 Xem Payment
BKG-DETAIL-05 Yêu cầu hủy
BKG-DETAIL-06 Xem Refund
```

APIs:

``` text
GET /api/customers/me/bookings
GET /api/customers/me/bookings/{bookingId}
GET /api/customers/me/bookings/{bookingId}/passengers
PUT /api/customers/me/bookings/{bookingId}/passengers/{passengerId}
```

Permission:

``` text
AUTHENTICATED + OWNER
```

Không được xem Booking của khách khác.

------------------------------------------------------------------------

## 14. KHACH_HANG --- Hủy / Refund

Page:

``` text
DPVWEBUserYeuCauHuyTour
DPVMOBUserYeuCauHuyTour
```

Functions:

``` text
CANCEL-01 Xem chính sách
CANCEL-02 Xem phí hủy dự kiến
CANCEL-03 Xem tiền hoàn dự kiến
CANCEL-04 Nhập lý do
CANCEL-05 Gửi yêu cầu
```

API:

``` text
POST /api/bookings/{bookingId}/cancel
```

DB:

``` text
CHINH_SACH_HUY
QUY_TAC_HUY
HUY_BOOKING
HOAN_TIEN
BOOKING
```

Phí hủy dựa trên chính sách và số ngày trước Departure.

------------------------------------------------------------------------

## 15. KHACH_HANG --- Tour riêng

Pages:

``` text
DPVWEBUserYeuCauTourRieng
DPVMOBUserYeuCauTourRieng
DPVWEBUserYeuCauTourRiengCuaToi
DPVMOBUserYeuCauTourRiengCuaToi
```

Functions tạo yêu cầu:

``` text
CUSTOM-01 Tạo yêu cầu
CUSTOM-02 Nhập số khách
CUSTOM-03 Chọn ngày
CUSTOM-04 Thêm địa điểm
CUSTOM-05 Nhập ngân sách
CUSTOM-06 Nhập yêu cầu đặc biệt
CUSTOM-07 Gửi
```

Theo dõi:

``` text
CUSTOM-10 Xem yêu cầu
CUSTOM-11 Xem trạng thái
CUSTOM-12 Xem phản hồi
CUSTOM-13 Xem báo giá
CUSTOM-14 Xem chi tiết báo giá
CUSTOM-15 Xác nhận báo giá
```

DB:

``` text
YEU_CAU_TOUR_RIENG
YEU_CAU_TOUR_DIA_DIEM
BAO_GIA_TOUR_RIENG
CHI_TIET_BAO_GIA
TOUR_TU_YEU_CAU
```

Flow:

``` text
Customer
→ Overall Manager
→ Department
→ Department Manager
→ Guide/proposal
→ Overall Manager aggregates
→ Quotation
→ Customer confirms
→ TOUR + DEPARTURE
```

------------------------------------------------------------------------

## 16. KHACH_HANG --- Hồ sơ

Pages:

``` text
DPVWEBUserThongTinCaNhan
DPVMOBUserThongTinCaNhan
DPVWEBUserDoiMatKhau
DPVMOBUserDoiMatKhau
```

API:

``` text
GET /api/customers/me
PUT /api/customers/me
```

Functions:

``` text
PROFILE-01 Xem hồ sơ
PROFILE-02 Sửa họ tên
PROFILE-03 Sửa số điện thoại
PROFILE-04 Xem email
PROFILE-05 Đổi mật khẩu
```

------------------------------------------------------------------------

## 17. ADMIN --- Dashboard

Page:

``` text
DPVDESKAdminTongQuan
```

Functions:

``` text
ADMIN-DASH-01 Xem KPI
ADMIN-DASH-02 Tour chờ duyệt
ADMIN-DASH-03 Booking
ADMIN-DASH-04 Doanh thu
ADMIN-DASH-05 Hoạt động
ADMIN-DASH-06 Biểu đồ
```

Data:

``` text
TAI_KHOAN
TOUR
BOOKING
THANH_TOAN
CHI_PHI
```

------------------------------------------------------------------------

## 18. ADMIN --- Tài khoản / Role

Pages:

``` text
DPVDESKAdminQuanLyTaiKhoan
DPVDESKAdminChiTietTaiKhoan
```

Functions:

``` text
ACCOUNT-01 Xem
ACCOUNT-02 Tìm
ACCOUNT-03 Lọc
ACCOUNT-04 Chi tiết
ACCOUNT-05 Tạo tài khoản
ACCOUNT-06 Gán role
ACCOUNT-07 Đổi role
ACCOUNT-08 Khóa
ACCOUNT-09 Mở khóa
ACCOUNT-10 Deactivate
ACCOUNT-11 Xem lịch sử role
```

APIs:

``` text
GET /api/admin/accounts
GET /api/admin/accounts/{id}
POST /api/admin/accounts
POST /api/admin/accounts/{id}/roles
PUT /api/admin/accounts/{id}/roles
PUT /api/admin/accounts/{id}/lock
PUT /api/admin/accounts/{id}/unlock
PUT /api/admin/accounts/{id}/deactivate
GET /api/admin/roles
GET /api/admin/permissions
```

DB:

``` text
TAI_KHOAN
VAI_TRO
QUYEN
TAI_KHOAN_VAI_TRO
VAI_TRO_QUYEN
NHAN_VIEN
LICH_SU_VAI_TRO
PHIEN_DANG_NHAP
```

Không Hard Delete Account.

------------------------------------------------------------------------

## 19. ADMIN --- Phòng/Ban

Pages:

``` text
DPVDESKAdminQuanLyPhongBan
DPVDESKAdminChiTietPhongBan
```

Functions:

``` text
DEPT-01 Xem
DEPT-02 Tạo
DEPT-03 Sửa
DEPT-04 Active
DEPT-05 Inactive
DEPT-06 Xem thành viên
DEPT-07 Xem Trưởng Ban
```

APIs:

``` text
GET /api/departments
GET /api/departments/{banId}
POST /api/admin/departments
PUT /api/admin/departments/{banId}
PUT /api/admin/departments/{banId}/activate
PUT /api/admin/departments/{banId}/deactivate
GET /api/departments/{banId}/employees
GET /api/departments/{banId}/manager
```

Rule:

``` text
Một Ban tối đa một Trưởng Ban active.
```

Không có `BAN_QUOC_GIA`.

------------------------------------------------------------------------

## 20. ADMIN --- Master Data

Page:

``` text
DPVDESKAdminQuanLyDanhMuc
```

Quản lý:

``` text
QUOC_GIA
TINH_THANH
DIA_DIEM
LOAI_TOUR
NGON_NGU
CHUYEN_MON_HDV
```

Functions:

``` text
MASTER-01 Xem
MASTER-02 Tìm
MASTER-03 Thêm
MASTER-04 Sửa
MASTER-05 Active
MASTER-06 Inactive
```

Không Hard Delete dữ liệu đã được tham chiếu.

------------------------------------------------------------------------

## 21. ADMIN --- Báo cáo

Page:

``` text
DPVDESKAdminBaoCaoTongQuan
```

Functions:

``` text
REPORT-01 Lọc thời gian
REPORT-02 Doanh thu
REPORT-03 Booking
REPORT-04 Tour
REPORT-05 Departure
REPORT-06 Chi phí
```

Thuế nằm ngoài scope.

------------------------------------------------------------------------

## 22. MANAGER --- Dashboard

Page:

``` text
DPVDESKManagerTongQuan
```

Functions:

``` text
MGR-DASH-01 Tour
MGR-DASH-02 Departure
MGR-DASH-03 Booking
MGR-DASH-04 Tour riêng
MGR-DASH-05 Sự cố
MGR-DASH-06 Chi phí
```

------------------------------------------------------------------------

## 23. MANAGER --- Tour

Pages:

``` text
DPVDESKManagerQuanLyTour
DPVDESKManagerTaoTour
DPVDESKManagerChiTietTour
```

Functions:

``` text
TOUR-MGR-01 Xem
TOUR-MGR-02 Tìm
TOUR-MGR-03 Lọc
TOUR-MGR-04 Tạo
TOUR-MGR-05 Sửa
TOUR-MGR-06 Thêm địa điểm
TOUR-MGR-07 Xóa địa điểm
TOUR-MGR-08 Gửi duyệt
```

APIs:

``` text
GET /api/tours
GET /api/tours/{tourId}
POST /api/manager/tours
PUT /api/manager/tours/{tourId}
POST /api/manager/tours/{tourId}/locations
DELETE /api/manager/tours/{tourId}/locations/{locationId}
POST /api/manager/tours/{tourId}/submit
```

Lifecycle:

``` text
NHAP
→ CHO_DUYET
→ DA_DUYET
→ CONG_KHAI
→ NGUNG_BAN
```

Reject:

``` text
CHO_DUYET
→ TU_CHOI
→ NHAP
```

------------------------------------------------------------------------

## 24. ADMIN --- Duyệt Tour

Functions:

``` text
TOUR-ADMIN-01 Approve
TOUR-ADMIN-02 Reject
TOUR-ADMIN-03 Publish
TOUR-ADMIN-04 Stop Selling
```

APIs:

``` text
POST /api/admin/tours/{tourId}/approve
POST /api/admin/tours/{tourId}/reject
POST /api/admin/tours/{tourId}/publish
POST /api/admin/tours/{tourId}/stop-selling
```

Permission:

``` text
ADMIN_ONLY
```

------------------------------------------------------------------------

## 25. MANAGER --- Departure

Pages:

``` text
DPVDESKManagerQuanLyDotKhoiHanh
DPVDESKManagerTaoDotKhoiHanh
DPVDESKManagerChiTietDotKhoiHanh
```

Functions:

``` text
DEP-01 Xem
DEP-02 Chi tiết
DEP-03 Tạo
DEP-04 Sửa
DEP-05 Mở bán
DEP-06 Đóng bán
DEP-07 Hủy
DEP-08 Xem Booking
DEP-09 Xem HDV
DEP-10 Xem tiến độ
DEP-11 Xem chi phí
DEP-12 Xem sự cố
```

Input:

``` text
Ngày đi
Ngày về
Sức chứa
Giá người lớn
Giá trẻ em
Giá em bé
Lịch trình
```

Rules:

``` text
Ngày hợp lệ
Sức chứa > 0
Giá > 0
Không nhận Booking khi full/closed/cancelled
```

Mỗi Departure có dữ liệu vận hành độc lập.

------------------------------------------------------------------------

## 26. MANAGER --- Phân công HDV

Page:

``` text
DPVDESKManagerPhanCongHDV
```

Functions:

``` text
GUIDE-01 Xem HDV khả dụng
GUIDE-02 Tìm
GUIDE-03 Lọc
GUIDE-04 Xem lịch
GUIDE-05 Phân công HDV chính
GUIDE-06 Phân công HDV phụ
GUIDE-07 Đổi HDV
GUIDE-08 Xóa phân công
```

APIs:

``` text
GET /api/manager/departures/{departureId}/available-guides
GET /api/manager/departures/{departureId}/guides
POST /api/manager/departures/{departureId}/guides
PUT /api/manager/departures/{departureId}/guides/{employeeId}
DELETE /api/manager/departures/{departureId}/guides/{employeeId}
```

Rules:

``` text
HDV active
+
Đúng role
+
Đúng phạm vi Ban
+
Phù hợp chuyên môn
+
Phù hợp ngôn ngữ
+
Không trùng lịch
```

``` text
HDV_CHINH: tối đa 1
HDV_PHU: có thể nhiều
```

------------------------------------------------------------------------

## 27. MANAGER --- Booking nội bộ

Functions:

``` text
BKG-MGR-01 Xem Booking
BKG-MGR-02 Xem chi tiết
BKG-MGR-03 Xem hành khách
BKG-MGR-04 Xem Payment
BKG-MGR-05 Theo dõi hủy
BKG-MGR-06 Theo dõi Refund
```

Thông tin:

``` text
Mã Booking
Khách hàng
Tour
Departure
Hành khách
Tổng tiền
Booking Status
Payment Status
Ngày đặt
```

------------------------------------------------------------------------

## 28. MANAGER --- Tour riêng

Pages:

``` text
DPVDESKManagerQuanLyYeuCauTourRieng
DPVDESKManagerChiTietYeuCauTourRieng
```

Functions:

``` text
CUSTOM-MGR-01 Xem yêu cầu
CUSTOM-MGR-02 Chi tiết
CUSTOM-MGR-03 Phân công Ban
CUSTOM-MGR-04 Xem phản hồi Ban
CUSTOM-MGR-05 Tổng hợp
CUSTOM-MGR-06 Tạo báo giá
CUSTOM-MGR-07 Gửi báo giá
```

Flow:

``` text
KHÁCH
→ QUẢN LÝ TỔNG
→ BAN LIÊN QUAN
→ TRƯỞNG BAN
→ QUẢN LÝ TỔNG
→ BÁO GIÁ
→ KHÁCH XÁC NHẬN
→ TOUR + DEPARTURE
```

------------------------------------------------------------------------

## 29. MANAGER --- Sự cố

Page:

``` text
DPVDESKManagerXuLySuCo
```

Functions:

``` text
INCIDENT-01 Xem
INCIDENT-02 Chi tiết
INCIDENT-03 Xem chứng từ
INCIDENT-04 Đánh giá
INCIDENT-05 Đưa phương án
INCIDENT-06 Xử lý
INCIDENT-07 Tạo thay đổi lịch trình nếu cần
```

DB:

``` text
SU_CO_TOUR
CHUNG_TU_SU_CO
THAY_DOI_LICH_TRINH
PHAN_HOI_THAY_DOI
```

------------------------------------------------------------------------

## 30. TRUONG_BAN

### DPVDESKDepartmentManagerTongQuan

``` text
DEPT-DASH-01 Xem yêu cầu
DEPT-DASH-02 Xem công việc Ban
DEPT-DASH-03 Xem nhân sự
DEPT-DASH-04 Xem HDV
```

### DPVDESKDepartmentManagerYeuCauCanXuLy

``` text
DEPT-REQ-01 Xem yêu cầu
DEPT-REQ-02 Lọc
DEPT-REQ-03 Xem chi tiết
DEPT-REQ-04 Đề xuất HDV
DEPT-REQ-05 Gửi phản hồi
```

Permission:

``` text
ROLE + DEPARTMENT_SCOPE
```

### DPVDESKDepartmentManagerChiTietYeuCau

Hiển thị:

``` text
Nhu cầu khách
Điểm đến
Ngày
Ngân sách
Phương án
HDV phù hợp
```

### DPVDESKDepartmentManagerQuanLyNhanSuPhong

``` text
DEPT-HR-01 Xem thành viên
DEPT-HR-02 Xem chuyên môn
DEPT-HR-03 Xem ngôn ngữ
DEPT-HR-04 Xem trạng thái
```

------------------------------------------------------------------------

## 31. HDV --- Dashboard

Pages:

``` text
DPVDESKGuideTongQuan
DPVMOBGuideTongQuan
```

Functions:

``` text
GUIDE-DASH-01 Tour hôm nay
GUIDE-DASH-02 Tour sắp tới
GUIDE-DASH-03 Công việc
GUIDE-DASH-04 Sự cố
GUIDE-DASH-05 Thông báo
```

------------------------------------------------------------------------

## 32. HDV --- Tour được phân công

Pages:

``` text
DPVDESKGuideTourDuocPhanCong
DPVMOBGuideTourDuocPhanCong
```

Functions:

``` text
GUIDE-TOUR-01 Xem danh sách
GUIDE-TOUR-02 Xem Departure
GUIDE-TOUR-03 Xem vai trò
GUIDE-TOUR-04 Xem lịch
```

Permission:

``` text
HDV + assignment của chính HDV
```

------------------------------------------------------------------------

## 33. HDV --- Chi tiết Tour

Pages:

``` text
DPVDESKGuideChiTietTourDuocPhanCong
DPVMOBGuideChiTietTourDuocPhanCong
```

Functions:

``` text
GUIDE-DETAIL-01 Xem Tour
GUIDE-DETAIL-02 Xem Departure
GUIDE-DETAIL-03 Xem lịch trình
GUIDE-DETAIL-04 Xem hành khách
GUIDE-DETAIL-05 Xem tiến độ
GUIDE-DETAIL-06 Báo sự cố
```

------------------------------------------------------------------------

## 34. HDV --- Cập nhật tiến độ

Pages:

``` text
DPVDESKGuideCapNhatTienDo
DPVMOBGuideCapNhatTienDo
```

Functions:

``` text
PROGRESS-01 Xem mốc
PROGRESS-02 Cập nhật trạng thái
PROGRESS-03 Thêm ghi chú
PROGRESS-04 Thêm hình ảnh
PROGRESS-05 Hoàn thành mốc
```

DB:

``` text
TIEN_TRINH_TOUR
HINH_ANH_TIEN_TRINH
```

Mobile ưu tiên thao tác nhanh:

``` text
Current Step
→ Update
→ Note
→ Photo
```

------------------------------------------------------------------------

## 35. HDV --- Báo cáo sự cố

Pages:

``` text
DPVDESKGuideBaoCaoSuCo
DPVMOBGuideBaoCaoSuCo
```

Functions:

``` text
INCIDENT-GUIDE-01 Tạo báo cáo
INCIDENT-GUIDE-02 Chọn loại
INCIDENT-GUIDE-03 Chọn mức độ
INCIDENT-GUIDE-04 Nhập thời gian
INCIDENT-GUIDE-05 Nhập vị trí
INCIDENT-GUIDE-06 Nhập mô tả
INCIDENT-GUIDE-07 Upload ảnh/chứng từ
INCIDENT-GUIDE-08 Gửi
```

DB:

``` text
SU_CO_TOUR
CHUNG_TU_SU_CO
```

------------------------------------------------------------------------

## 36. Chức năng hỗ trợ

### Notification

``` text
Danh sách
Đọc
Đánh dấu đã đọc
Đọc tất cả
Đi đến nghiệp vụ
```

DB:

``` text
THONG_BAO
```

### Review

Chỉ review khi Booking/tour đạt điều kiện hoàn thành.

DB:

``` text
DANH_GIA_TOUR
```

### Favorite

DB:

``` text
TOUR_YEU_THICH
```

### Contact

Customer:

``` text
Gửi liên hệ
```

Admin:

``` text
Xem
Xử lý
Cập nhật trạng thái
```

DB:

``` text
LIEN_HE
```

------------------------------------------------------------------------

## 37. Navigation Core

### Customer

``` text
DPVWEBUserTrangChu
 ↓
DPVWEBUserDanhSachTour
 ↓
DPVWEBUserChiTietTour
 ↓
DPVWEBUserDatTour
 ↓
DPVWEBUserThanhToan
 ↓
DPVWEBUserKetQuaDatTour
 ↓
DPVWEBUserChiTietDonDat
```

### Customer Tour riêng

``` text
Trang chủ
 ↓
Yêu cầu Tour riêng
 ↓
Yêu cầu của tôi
 ↓
Báo giá
 ↓
Xác nhận
 ↓
Tour + Departure
```

### Manager

``` text
DPVDESKManagerTongQuan
 ↓
DPVDESKManagerQuanLyTour
 ↓
DPVDESKManagerChiTietTour
 ↓
DPVDESKManagerQuanLyDotKhoiHanh
 ↓
DPVDESKManagerChiTietDotKhoiHanh
 ↓
DPVDESKManagerPhanCongHDV
```

### Guide

``` text
DPVMOBGuideTongQuan
 ↓
DPVMOBGuideTourDuocPhanCong
 ↓
DPVMOBGuideChiTietTourDuocPhanCong
 ↓
DPVMOBGuideCapNhatTienDo
```

Incident:

``` text
Chi tiết Tour
 ↓
Báo cáo sự cố
 ↓
Submit
 ↓
Manager xử lý
```

------------------------------------------------------------------------

## 38. State / Action Rules

### Tour

``` text
NHAP
→ CHO_DUYET
→ DA_DUYET
→ CONG_KHAI
→ NGUNG_BAN
```

Reject:

``` text
CHO_DUYET
→ TU_CHOI
→ NHAP
```

### Booking

``` text
CHO_THANH_TOAN
DA_THANH_TOAN
DA_XAC_NHAN
DA_HUY
HOAN_TIEN
HOAN_THANH
HET_HAN
```

### Payment

``` text
CHUA_THANH_TOAN
→ DANG_XU_LY
→ THANH_CONG

DANG_XU_LY
→ THAT_BAI
```

UI luôn phân biệt Booking Status và Payment Status.

------------------------------------------------------------------------

## 39. Action Result Standard

Mỗi action phải xử lý:

``` text
SUCCESS
VALIDATION ERROR
401
403
404
409
500
```

Success:

``` text
Toast/Success State
Update UI
Navigation nếu cần
```

Validation:

``` text
Field-level error
```

401:

``` text
Refresh token → retry
hoặc Login
```

403:

``` text
Không có quyền
```

404:

``` text
Không tìm thấy dữ liệu
```

409:

``` text
Departure đã đầy
HDV trùng lịch
Resource đã thay đổi
Booking conflict
```

500:

``` text
Lỗi hệ thống
Không hiển thị stack trace
```

------------------------------------------------------------------------

## 40. Ownership Rule

Customer chỉ xem dữ liệu của chính mình:

``` text
Booking
Passenger
Custom Tour Request
Favorite
Review
Profile
```

Ví dụ:

``` text
GET /api/customers/me/bookings/{bookingId}
```

BE phải kiểm tra:

``` text
booking.customer_id == currentUser.customer_id
```

Không được chỉ dựa vào frontend.

------------------------------------------------------------------------

## 41. Department Scope

``` text
Current User
 ↓
Employee
 ↓
Department Membership
 ↓
Resource Department
```

BE phải kiểm tra scope. FE không được tự quyết định scope.

------------------------------------------------------------------------

## 42. Function → API → Database

  ---------------------------------------------------------------------------------------
  Function                API                                    Database chính
  ----------------------- -------------------------------------- ------------------------
  Đăng nhập               `POST /api/auth/login`                 TAI_KHOAN, VAI_TRO,
                                                                 TAI_KHOAN_VAI_TRO

  Đăng ký                 `POST /api/auth/register`              TAI_KHOAN, KHACH_HANG,
                                                                 TAI_KHOAN_VAI_TRO

  Refresh                 `POST /api/auth/refresh-token`         PHIEN_DANG_NHAP

  Reset password          `POST /api/auth/reset-password`        DAT_LAI_MAT_KHAU,
                                                                 TAI_KHOAN

  Danh sách Tour          `GET /api/tours`                       TOUR, LOAI_TOUR

  Chi tiết Tour           `GET /api/tours/{id}`                  TOUR, TOUR_DIA_DIEM,
                                                                 DIA_DIEM, DOT_KHOI_HANH

  Tạo Tour                `POST /api/manager/tours`              TOUR

  Duyệt Tour              `POST /api/admin/tours/{id}/approve`   TOUR

  Tạo Departure           Departure APIs                         DOT_KHOI_HANH,
                                                                 LICH_TRINH

  Phân công HDV           Departure guide APIs                   PHAN_CONG_HDV, NHAN_VIEN

  Đặt Booking             `POST /api/bookings`                   BOOKING, HANH_KHACH,
                                                                 DOT_KHOI_HANH

  Thanh toán              Payment APIs                           THANH_TOAN,
                                                                 DOI_SOAT_GIAO_DICH,
                                                                 BOOKING

  Hủy                     `POST /api/bookings/{id}/cancel`       HUY_BOOKING, BOOKING

  Hoàn tiền               Refund APIs                            HOAN_TIEN, THANH_TOAN,
                                                                 BOOKING

  Tour riêng              Custom Tour APIs                       YEU_CAU_TOUR_RIENG,
                                                                 YEU_CAU_TOUR_DIA_DIEM,
                                                                 BAO_GIA_TOUR_RIENG

  Tiến độ                 Progress APIs                          TIEN_TRINH_TOUR,
                                                                 HINH_ANH_TIEN_TRINH

  Sự cố                   Incident APIs                          SU_CO_TOUR,
                                                                 CHUNG_TU_SU_CO

  Đổi role                Role APIs                              TAI_KHOAN_VAI_TRO,
                                                                 LICH_SU_VAI_TRO
  ---------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 43. FE Implementation Rule

``` text
Page
 ↓
Component
 ↓
Function
 ↓
State
 ↓
API Service
```

Khi BE chưa xong:

``` text
Page
 ↓
Mock Service
 ↓
Mock Data
```

Khi BE hoàn thành:

``` text
Page
 ↓
Real Service
 ↓
API
```

FE xử lý:

``` text
Form state
Format validation
Loading
Empty
Error
Success
Navigation
UX interaction
```

FE không quyết định:

``` text
Giá cuối
Capacity cuối
Permission
Refund cuối
Booking status cuối
Payment success cuối
```

------------------------------------------------------------------------

## 44. Designer Handoff

Designer cần:

``` text
Role
→ Page
→ Function
→ Action
→ State
→ Navigation
```

Ví dụ:

``` text
Page:
DPVWEBUserChiTietTour

Role:
KHACH_HANG

Functions:
- Xem thông tin
- Xem Departure
- Xem lịch trình
- Xem chính sách
- Chọn Departure
- Favorite

Next:
DPVWEBUserDatTour

States:
Loading
Success
Empty Departure
Error
```

------------------------------------------------------------------------

## 45. FE Developer Handoff

Mỗi Page phải có:

``` text
Page Name
Platform
Role
Functions
Permission
API
Mock Data
Navigation
States
```

FE không phải đoán nghiệp vụ từ ảnh UI.

------------------------------------------------------------------------

## 46. QA Handoff

QA lấy Function ID làm đơn vị kiểm thử.

Ví dụ:

``` text
BKG-07 — Xác nhận Booking
```

Test tối thiểu:

``` text
✓ Booking hợp lệ
✓ Departure còn chỗ
✓ Passenger hợp lệ
✓ Chưa đăng nhập
✓ Departure full
✓ Departure cancelled
✓ Booking conflict
✓ Ownership
✓ API error
✓ Transaction rollback
```

------------------------------------------------------------------------

## 47. Definition of Done cho Function

``` text
[ ] Có Function ID
[ ] Có Role
[ ] Có Platform
[ ] Có Page
[ ] Có Permission
[ ] Có Condition
[ ] Có API
[ ] Có Database
[ ] Có Success
[ ] Có Error
[ ] Có Next Page/State
[ ] Designer hiểu UI
[ ] FE hiểu cách build
[ ] BE hiểu API cần xử lý
[ ] QA biết cách test
```

------------------------------------------------------------------------

## 48. Master Traceability Table

  ----------------------------------------------------------------------------------------------------------------------------------
  ID                  Platform   Role    Page            Function   Permission   API               DB                Next
  ------------------- ---------- ------- --------------- ---------- ------------ ----------------- ----------------- ---------------
  BKG-07              WEB        KH      DatTour         Xác nhận   Auth/Owner   POST              BOOKING,          ThanhToan
                                                         Booking                 `/api/bookings`   HANH_KHACH,       
                                                                                                   DOT_KHOI_HANH     

  PAY-05              WEB        KH      ThanhToan       Thanh toán Auth/Owner   POST payments     THANH_TOAN,       KetQua
                                                                                                   BOOKING           

  CANCEL-05           WEB        KH      HuyTour         Gửi hủy    Auth/Owner   POST cancel       HUY_BOOKING,      BookingDetail
                                                                                                   BOOKING           

  TOUR-MGR-04         DESK       QLT     QuanLyTour      Tạo Tour   Role/Scope   POST tours        TOUR              ChiTietTour

  TOUR-ADMIN-01       DESK       ADMIN   Admin           Approve    Admin        POST approve      TOUR              Tour

  GUIDE-05            DESK       QLT     PhanCongHDV     HDV chính  Role/Scope   POST guides       PHAN_CONG_HDV     Departure

  PROGRESS-05         MOB        HDV     CapNhatTienDo   Hoàn thành Assignment   Progress API      TIEN_TRINH_TOUR   ChiTietTour
                                                         mốc                                                         

  INCIDENT-GUIDE-08   MOB        HDV     BaoCaoSuCo      Gửi sự cố  Assignment   Incident API      SU_CO_TOUR        ChiTietTour
  ----------------------------------------------------------------------------------------------------------------------------------

Đây là bảng sống. Khi nghiệp vụ thay đổi:

``` text
Cập nhật Function Spec
→ cập nhật API
→ cập nhật UX/UI
→ cập nhật FE
→ cập nhật QA
```

------------------------------------------------------------------------

## 49. Rules không được phá vỡ

``` text
1. TOUR ≠ DOT_KHOI_HANH
2. LOAI_TOUR ≠ TOUR STATUS
3. BOOKING ≠ PAYMENT
4. Giá TOUR ≠ Giá DEPARTURE ≠ Snapshot BOOKING
5. Customer chỉ xem dữ liệu của chính mình
6. FE không quyết định permission
7. BE phải kiểm tra permission
8. BE phải kiểm tra Department Scope
9. Booking phải chống overbooking
10. Password dùng BCrypt
11. Không trả password/hash ra API
12. Refresh Token quản lý bằng session
13. Reset Password Token dùng một lần
14. Role change ghi lịch sử
15. Không hard-delete Account
16. Master Data đã tham chiếu không hard-delete
17. Tax ngoài scope
18. Không có BAN_QUOC_GIA
19. Không có PHUONG_TIEN master-data riêng
20. Departure có dữ liệu vận hành độc lập
```

------------------------------------------------------------------------

## 50. Thứ tự triển khai

### Phase 1 --- Customer Core

``` text
Auth
→ Home
→ Tour List
→ Tour Detail
→ Departure
→ Booking
→ Payment
→ Booking Detail
```

### Phase 2 --- Internal Core

``` text
Admin
→ Account
→ Department
→ Master Data
→ Manager
→ Tour
→ Departure
→ Guide Assignment
```

### Phase 3 --- Operation

``` text
Guide
→ Progress
→ Incident
→ Schedule Change
```

### Phase 4 --- Custom Tour

``` text
Customer Request
→ Manager
→ Department
→ Quotation
→ Customer Confirm
→ Tour + Departure
```

### Phase 5 --- Supporting

``` text
Review
Favorite
Notification
Report
Audit
Contact
Budget
Expense
Refund
```

------------------------------------------------------------------------

## 51. Cách dùng 4 file lõi

``` text
01 DATABASE / ERD
→ Dữ liệu nào tồn tại?

02 DEVELOPER / API HANDOFF
→ API và business rule thế nào?

03 UX/UI MASTER SPEC
→ Thiết kế màn hình nào?

04 USER & FUNCTION SPEC
→ Ai làm gì, ở đâu, bằng cách nào?
```

Luồng:

``` text
DATABASE
   ↓
BUSINESS RULE
   ↓
API
   ↓
USER & FUNCTION
   ↓
UX/UI
   ↓
FE
   ↓
QA
```

------------------------------------------------------------------------

## 52. Kết luận

Đây là **bản đồ chức năng của DPV TourDuLich**.

Mỗi chức năng mới phải được xác định theo:

``` text
ROLE
→ PAGE
→ FUNCTION
→ ACTION
→ PERMISSION
→ CONDITION
→ API
→ DATABASE
→ RESULT
→ NEXT PAGE/STATE
→ TEST
```

Mục tiêu:

``` text
Designer:
Biết phải thiết kế gì.

FE:
Biết phải build gì.

BE:
Biết API phải xử lý gì.

QA:
Biết phải test gì.

BA/PM:
Biết nghiệp vụ đang ở đâu.
```

Tài liệu này là tài liệu **sống**: mọi thay đổi nghiệp vụ phải cập nhật
ở đây trước khi đồng bộ sang API, UX/UI, FE và QA.
