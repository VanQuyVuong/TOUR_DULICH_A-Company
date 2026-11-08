# STATE DISPLAY SOURCE OF TRUTH

UI hiển thị state theo contract FINAL của `05_DPV_TourDuLich_FLOW_STATE_SPEC(1).md`. FE không tự đặt tên trạng thái khác với API. Label tiếng Việt có thể khác enum kỹ thuật nhưng phải map 1-1.

# DPV TourDuLich — UX/UI MASTER SPEC v2
## Web + Desktop App + Mobile App

> **Mục đích:** Đây là tài liệu nguồn để **Designer + AI Stitch** thiết kế UX/UI trước, sau đó **Frontend Developer** có thể build FE bằng Mock Data rồi thay bằng API thật.
>
> Tài liệu này tổng hợp từ các quyết định đã phân tích của hệ thống: **CSDL → nghiệp vụ → API → Page → FE → QA**.
>
> **Không tự thêm nghiệp vụ ngoài tài liệu này.**

---

# 1. MỤC TIÊU TRIỂN KHAI

Hệ thống có **3 nền tảng**:

| Nền tảng | Mục đích chính |
|---|---|
| Web | Khách hàng sử dụng hệ thống đặt tour; có thể responsive |
| Desktop App | Nhân sự nội bộ vận hành hệ thống |
| Mobile App | Khách hàng và/hoặc HDV sử dụng các chức năng cần thao tác khi di chuyển |

Nguyên tắc:

```text
CSDL
 ↓
Business Rules
 ↓
API Contract
 ↓
UX/UI
 ↓
FE Mock Data
 ↓
API thật
 ↓
QA
```

Mục tiêu:

```text
Design trước
    ↓
FE build trước bằng Mock Data
    ↓
BE hoàn thành API
    ↓
FE đổi Mock Service → Real API
```

Không để việc Backend chưa xong làm chậm việc thiết kế và build Frontend.

---

# 2. QUY TẮC ĐẶT TÊN UX/UI — BẮT BUỘC

## 2.1. Công thức mới

Bắt buộc thể hiện **nền tảng + role/user + tên trang**.

```text
DPV + PLATFORM + USER/ROLE + TÊN TRANG
```

### Viết tắt nền tảng

| Viết tắt | Nền tảng |
|---|---|
| `WEB` | Web |
| `DESK` | Desktop App |
| `MOB` | Mobile App |

### Ví dụ

```text
DPVWEBUserTrangChu
DPVWEBUserDanhSachTour
DPVWEBUserChiTietTour

DPVDESKAdminTongQuan
DPVDESKAdminQuanLyTaiKhoan
DPVDESKManagerQuanLyTour

DPVMOBUserTrangChu
DPVMOBUserChiTietTour
DPVMOBUserDonDatCuaToi

DPVDESKGuideTongQuan
DPVMOBGuideCapNhatTienDo
```

> **Không dùng:** `[user]TrangChu`, `UserTrangChu`, `DesktopTrangChu`.
>
> **Tên trên Figma/Stitch nên giống tên Page/Component trong FE** để Designer và Developer không phải quy đổi tên.

---

# 3. PHÂN LOẠI NỀN TẢNG

## 3.1. WEB

Web ưu tiên:

```text
Khách hàng
```

Chức năng chính:

```text
Xem tour
Tìm kiếm tour
Lọc tour
Xem chi tiết
Đặt tour
Thanh toán
Quản lý booking
Hủy booking
Yêu cầu tour riêng
Quản lý hồ sơ
Đánh giá
Yêu thích
Thông báo
```

Responsive:

```text
Desktop
Tablet
Mobile Web
```

---

# 4. DESKTOP APP

Desktop App ưu tiên cho nghiệp vụ nội bộ:

```text
ADMIN
QUAN_LY_TONG
TRUONG_BAN
NHAN_VIEN
HDV
```

Desktop-first.

Các nghiệp vụ chính:

```text
Dashboard
Quản lý tài khoản
Quản lý nhân viên
Quản lý Ban
Quản lý danh mục
Quản lý Tour
Quản lý Đợt khởi hành
Phân công HDV
Quản lý Booking
Thanh toán
Hủy / Hoàn tiền
Tour riêng
Ngân sách
Chi phí
Sự cố
Thay đổi lịch trình
Báo cáo
Thông báo
Audit Log
Liên hệ
```

---

# 5. MOBILE APP

Mobile ưu tiên các thao tác cần thực hiện nhanh.

## 5.1. Khách hàng

```text
Đăng nhập
Xem tour
Tìm tour
Chi tiết tour
Đặt tour
Thanh toán
Booking của tôi
Chi tiết booking
Hủy tour
Tour riêng
Thông báo
Hồ sơ
```

## 5.2. HDV

```text
Dashboard
Tour được phân công
Chi tiết tour
Lịch trình
Hành khách
Cập nhật tiến độ
Báo cáo sự cố
Thông báo
```

> Không ép toàn bộ nghiệp vụ quản trị Desktop lên Mobile.

---

# 6. ROLE

Các role hệ thống:

```text
ADMIN
QUAN_LY_TONG
TRUONG_BAN
HDV
NHAN_VIEN
KHACH_HANG
```

Lưu ý:

```text
Role hệ thống
≠
Vị trí của nhân viên trong Ban
```

---

# 7. BRAND & VISUAL DIRECTION

## 7.1. Phong cách

```text
Modern Travel
+
Technology
+
Professional
```

Ưu tiên:

- Sạch.
- Hiện đại.
- Tin cậy.
- Dễ đọc.
- Dễ thao tác.
- Có cảm giác du lịch nhưng vẫn chuyên nghiệp.
- Không lạm dụng gradient/glow.

## 7.2. Màu

| Thành phần | Màu |
|---|---|
| Primary Blue | `#0066FF` |
| Dark Blue | `#0052CC` |
| Light Blue | `#EAF3FF` |
| Cyan Accent | `#00C7E6` |
| White | `#FFFFFF` |
| Background | `#F7F9FC` |
| Text | `#172033` |
| Secondary Text | `#667085` |
| Border | `#E5EAF2` |
| Success | `#16A34A` |
| Warning | `#F59E0B` |
| Error | `#DC2626` |

Visual:

```text
White / Light Background
        +
Ocean Blue CTA
        +
Light Blue Information Area
        +
Cyan Accent vừa phải
```

## 7.3. Logo

Dùng logo DPV được cung cấp làm nhận diện chính.

Trên nền sáng:

- Ưu tiên logo xanh/cyan.
- Không bóp méo.
- Không đổi tỷ lệ.
- Không thêm hiệu ứng quá mạnh.
- Header/Login/Home dùng logo đầy đủ.
- Sidebar có thể dùng logo rút gọn.

Prompt:

```text
Use the provided DPV logo as the main brand reference.
Create a clean light-background treatment for a modern travel web,
desktop and mobile application.
Use ocean blue and cyan accents.
Keep the original DPV symbol recognizable.
Do not distort or redesign the original symbol.
```

## 7.4. Slogan

### “Khám phá hành trình, kết nối trải nghiệm.”

Có thể dùng:

> **DPV TourDuLich — Mỗi hành trình, một trải nghiệm đáng nhớ.**

Không cần xuất hiện trên mọi màn hình.

---

# 8. DESIGN SYSTEM DÙNG CHUNG

Thiết kế Design System trước.

## Components

```text
Button
Input
Select
MultiSelect
DatePicker
DateRange
Search
Textarea
Checkbox
Radio
Switch

Card
TourCard
DepartureCard
BookingCard
PriceCard
KpiCard

StatusBadge
Table
Pagination
Tabs
Modal
Drawer
ConfirmDialog
Toast
Alert

Avatar
Breadcrumb
Stepper
Timeline
Progress
Chart

Loading Skeleton
Empty State
Error State
File Upload
Image Upload

Navbar
Sidebar
Footer
Bottom Navigation
```

## Typography

```text
Inter
hoặc
Be Vietnam Pro
```

## Border Radius

```text
Card: 12–16px
Button/Input: 8–10px
Modal: 16px
Badge: 999px
```

---

# 9. RESPONSIVE / PLATFORM RULES

## WEB

```text
Desktop ≥ 1200
Tablet 768–1199
Mobile < 768
```

## DESKTOP

Ưu tiên:

```text
1280px+
```

Layout:

```text
Sidebar
+
Topbar
+
Main Content
```

Có thể dùng:

```text
Table
Multi-column Form
Dashboard
Charts
Drawer
Modal
```

## MOBILE

Ưu tiên:

```text
Bottom Navigation
Cards
Accordion
Bottom Sheet
Full-screen Form
Sticky CTA
```

Không nhồi bảng dữ liệu lớn.

---

# 10. TRẠNG THÁI BẮT BUỘC

Mỗi page quan trọng phải có:

```text
Default
Loading
Empty
Error
Success
Disabled
```

Form:

```text
Default
Focus
Validation Error
Submitting
Success
Failed
```

Table:

```text
Loading
Has Data
Empty
Error
Pagination
```

---

# 11. QUY TẮC NGHIỆP VỤ UI CỐT LÕI

## 11.1. TOUR ≠ ĐỢT KHỞI HÀNH

### TOUR

Là sản phẩm:

```text
Tên
Loại tour
Mô tả
Thời lượng
Điểm đến
Giá tham chiếu
Hình ảnh
Chính sách hủy
```

### ĐỢT KHỞI HÀNH

Là một lần tổ chức:

```text
Ngày đi
Ngày về
Sức chứa
Đã đặt
Còn chỗ
Giá bán
Lịch trình riêng
HDV
Tiến độ
Chi phí
Sự cố
```

UI:

```text
TOUR
 ↓
CÁC ĐỢT KHỞI HÀNH
 ↓
BOOKING
 ↓
HÀNH KHÁCH
```

Không gộp Tour và Departure.

---

# 12. GIÁ

```text
TOUR
→ Giá tham chiếu

ĐỢT KHỞI HÀNH
→ Giá bán thực tế

BOOKING
→ Snapshot giá tại thời điểm đặt
```

FE không tự quyết định giá cuối.

---

# 13. BOOKING ≠ PAYMENT

## Booking

```text
CHO_THANH_TOAN
DA_THANH_TOAN
DA_XAC_NHAN
DA_HUY
HOAN_TIEN
HOAN_THANH
HET_HAN
```

## Payment

```text
CHUA_THANH_TOAN
DANG_XU_LY
THANH_CONG
THAT_BAI
```

Chi tiết booking:

```text
Booking Status: Đã thanh toán
Payment Status: Thành công
```

---

# 14. TOUR TYPE ≠ TOUR STATUS

## Tour Type

Lấy từ:

```text
LOAI_TOUR
```

Ví dụ:

```text
Trong nước
Quốc tế
Gia đình
...
```

## Tour Lifecycle

```text
NHAP
CHO_DUYET
DA_DUYET
CONG_KHAI
TU_CHOI
NGUNG_BAN
```

Flow:

```text
NHAP
 ↓
CHO_DUYET
 ↓
DA_DUYET
 ↓
CONG_KHAI
 ↓
NGUNG_BAN

CHO_DUYET
 ↓
TU_CHOI
 ↓
NHAP
```

---

# 15. MASTER DATA

Admin quản lý:

```text
QUOC_GIA
TINH_THANH
DIA_DIEM
LOAI_TOUR
NGON_NGU
CHUYEN_MON_HDV
```

Actions:

```text
Thêm
Sửa
Active
Inactive
```

Ưu tiên Inactive thay vì Hard Delete khi dữ liệu đã được tham chiếu.

---

# 16. PLATFORM PAGE MATRIX

Đây là bảng quan trọng để Designer biết **màn hình nào thuộc nền tảng nào**.

| Page | Web | Desktop | Mobile | Role |
|---|---:|---:|---:|---|
| Trang chủ | ✓ | - | ✓ | User |
| Danh sách Tour | ✓ | - | ✓ | User |
| Chi tiết Tour | ✓ | - | ✓ | User |
| Đặt Tour | ✓ | - | ✓ | User |
| Thanh toán | ✓ | - | ✓ | User |
| Kết quả đặt | ✓ | - | ✓ | User |
| Đơn đặt của tôi | ✓ | - | ✓ | User |
| Chi tiết đơn | ✓ | - | ✓ | User |
| Yêu cầu hủy | ✓ | - | ✓ | User |
| Tour riêng | ✓ | - | ✓ | User |
| Hồ sơ | ✓ | - | ✓ | User |
| Đổi mật khẩu | ✓ | ✓ | ✓ | All |
| Đăng nhập | ✓ | ✓ | ✓ | All |
| Đăng ký | ✓ | - | ✓ | User |
| Quên mật khẩu | ✓ | ✓ | ✓ | All |
| Đặt lại mật khẩu | ✓ | ✓ | ✓ | All |
| Admin Dashboard | - | ✓ | - | Admin |
| Quản lý tài khoản | - | ✓ | - | Admin |
| Quản lý phòng/Ban | - | ✓ | - | Admin |
| Quản lý danh mục | - | ✓ | - | Admin |
| Báo cáo | - | ✓ | - | Admin |
| Manager Dashboard | - | ✓ | - | Manager |
| Quản lý Tour | - | ✓ | - | Manager |
| Tạo Tour | - | ✓ | - | Manager |
| Chi tiết Tour | - | ✓ | - | Manager |
| Quản lý Departure | - | ✓ | - | Manager |
| Tạo Departure | - | ✓ | - | Manager |
| Chi tiết Departure | - | ✓ | - | Manager |
| Phân công HDV | - | ✓ | - | Manager |
| Tour riêng | - | ✓ | - | Manager |
| Xử lý sự cố | - | ✓ | - | Manager |
| Department Dashboard | - | ✓ | - | Trưởng Ban |
| Yêu cầu cần xử lý | - | ✓ | - | Trưởng Ban |
| Chi tiết yêu cầu | - | ✓ | - | Trưởng Ban |
| Nhân sự Ban | - | ✓ | - | Trưởng Ban |
| Guide Dashboard | - | ✓ | ✓ | HDV |
| Tour được phân công | - | ✓ | ✓ | HDV |
| Chi tiết tour phân công | - | ✓ | ✓ | HDV |
| Cập nhật tiến độ | - | ✓ | ✓ | HDV |
| Báo cáo sự cố | - | ✓ | ✓ | HDV |

---

# 17. CUSTOMER — WEB

# DPVWEBUserTrangChu

## Chức năng

```text
Xem trang chủ
Tìm kiếm tour
Đi tới danh sách tour
Xem tour nổi bật
Xem điểm đến nổi bật
Xem tour sắp khởi hành
Đi tới yêu cầu Tour riêng
Đăng nhập / Đăng ký
```

## Layout

```text
Navbar
↓
Hero + Search
↓
Tour nổi bật
↓
Điểm đến nổi bật
↓
Tour sắp khởi hành
↓
Lý do chọn DPV
↓
CTA Tour riêng
↓
Footer
```

---

# DPVWEBUserDanhSachTour

## Chức năng

```text
Tìm kiếm
Lọc
Sắp xếp
Xem Tour
Phân trang
Yêu thích
```

## Filter

```text
Quốc gia
Tỉnh/Thành
Địa điểm
Loại tour
Ngày khởi hành
Khoảng giá
```

## Tour Card

```text
Ảnh
Tên
Điểm đến
Thời lượng
Ngày khởi hành gần nhất
Giá từ
Còn chỗ
Yêu thích
Xem chi tiết
```

API:

```text
GET /api/tours
```

---

# DPVWEBUserChiTietTour

## Chức năng

```text
Xem thông tin tour
Xem gallery
Xem điểm đến
Xem lịch trình
Xem chính sách hủy
Xem đánh giá
Xem các Departure
Chọn Departure
Yêu thích
```

## UI

```text
Gallery
↓
Tên + thông tin
↓
Mô tả
↓
Các Departure
↓
Lịch trình
↓
Điểm đến
↓
Chính sách hủy
↓
Đánh giá
```

Departure Card:

```text
Ngày đi
Ngày về
Giá
Còn chỗ
Status
[Chọn đợt]
```

API:

```text
GET /api/tours/{tourId}
```

---

# DPVWEBUserDatTour

## Chức năng

```text
Xác nhận Departure
Nhập người đặt
Thêm hành khách
Sửa hành khách
Xem giá
Xác nhận booking
Đi tới thanh toán
```

Stepper:

```text
1 Thông tin
2 Hành khách
3 Xác nhận
4 Thanh toán
```

API:

```text
POST /api/bookings
PUT /api/customers/me/bookings/{bookingId}/passengers/{passengerId}
```

---

# DPVWEBUserThanhToan

## Chức năng

```text
Xem booking
Xem hành khách
Xem tổng tiền
Chọn phương thức
Thanh toán
Xem trạng thái thanh toán
```

Phương thức có thể mở rộng:

```text
Mock Payment
VNPay
MoMo
ZaloPay
Chuyển khoản
```

API:

```text
POST /api/bookings/{bookingId}/payments
GET /api/bookings/{bookingId}/payments/{paymentId}
```

---

# DPVWEBUserKetQuaDatTour

## Thành công

```text
✓ Đặt tour thành công
Mã booking
Tour
Departure
Số khách
Tổng tiền
Booking Status
Payment Status
[Xem đơn]
```

## Thất bại

```text
Thanh toán chưa thành công
[Thử lại]
```

---

# DPVWEBUserDonDatCuaToi

## Chức năng

```text
Xem danh sách booking
Tìm booking
Lọc status
Lọc thời gian
Xem chi tiết
```

Hiển thị:

```text
Mã
Tour
Departure
Số khách
Tổng tiền
Booking Status
Payment Status
Ngày đặt
```

API:

```text
GET /api/customers/me/bookings
```

---

# DPVWEBUserChiTietDonDat

Tabs:

```text
Tổng quan
Hành khách
Thanh toán
Hủy / Hoàn tiền
```

Chức năng:

```text
Xem booking
Xem hành khách
Cập nhật hành khách nếu được phép
Xem payment
Yêu cầu hủy
Xem refund
```

API:

```text
GET /api/customers/me/bookings/{bookingId}
GET /api/customers/me/bookings/{bookingId}/passengers
```

Ownership bắt buộc.

---

# DPVWEBUserYeuCauHuyTour

Hiển thị:

```text
Booking
Tour
Departure
Ngày đi
Chính sách hủy
Phí hủy dự kiến
Tiền hoàn dự kiến
```

Chức năng:

```text
Nhập lý do
Gửi yêu cầu
Xác nhận
```

API:

```text
POST /api/bookings/{bookingId}/cancel
```

---

# DPVWEBUserYeuCauTourRieng

## Chức năng

```text
Tạo yêu cầu tour riêng
Thêm nhiều địa điểm
Nhập ngày
Nhập số khách
Nhập ngân sách
Nhập yêu cầu đặc biệt
Gửi yêu cầu
```

Form:

```text
Số khách
Ngày bắt đầu
Ngày kết thúc
Quốc gia
Tỉnh/Thành
Địa điểm
Ngân sách
Yêu cầu đặc biệt
Ghi chú
```

---

# DPVWEBUserYeuCauTourRiengCuaToi

```text
Xem yêu cầu
Xem status
Xem phản hồi
Xem báo giá
Xác nhận báo giá
```

Flow:

```text
Gửi yêu cầu
→ Đang xử lý
→ Được báo giá
→ Khách xác nhận
→ Tạo Tour + Departure
```

---

# DPVWEBUserThongTinCaNhan

```text
Xem hồ sơ
Sửa họ tên
Sửa số điện thoại
Xem email
```

---

# DPVWEBUserDoiMatKhau

```text
Mật khẩu hiện tại
Mật khẩu mới
Xác nhận
```

---

# 18. CUSTOMER — MOBILE

Mobile dùng cùng nghiệp vụ Customer Web nhưng tối ưu thao tác cảm ứng.

## DPVMOBUserTrangChu

```text
Header
Search
Tour nổi bật
Tour sắp khởi hành
Điểm đến
CTA Tour riêng
Bottom Navigation
```

Bottom Navigation:

```text
Trang chủ
Tour
Booking
Thông báo
Tài khoản
```

## DPVMOBUserDanhSachTour

Dùng:

```text
Search
Filter Bottom Sheet
Tour Card
Sort
```

Không dùng bảng.

## DPVMOBUserChiTietTour

```text
Image Gallery
Thông tin
Departure
Lịch trình Accordion
Chính sách
Đánh giá
Sticky CTA: Đặt tour
```

## DPVMOBUserDatTour

Dùng Stepper mobile:

```text
Thông tin
→ Hành khách
→ Xác nhận
→ Thanh toán
```

## DPVMOBUserThanhToan

Ưu tiên:

```text
Order Summary
Payment Method
Sticky Pay Button
```

## DPVMOBUserKetQuaDatTour

```text
Success
Mã booking
Thông tin tour
[Xem đơn]
```

## DPVMOBUserDonDatCuaToi

Dùng Booking Card thay Table.

## DPVMOBUserChiTietDonDat

Dùng:

```text
Summary
Tabs/Segmented Control
Accordion
```

## DPVMOBUserYeuCauHuyTour

```text
Booking
Policy
Estimated refund
Reason
Confirm
```

## DPVMOBUserYeuCauTourRieng

Form full-screen:

```text
Ngày
Số khách
Điểm đến
Ngân sách
Yêu cầu
```

## DPVMOBUserYeuCauTourRiengCuaToi

```text
Request Card
Status Timeline
Quotation
Confirm
```

## DPVMOBUserThongTinCaNhan

```text
Avatar
Họ tên
Email
Số điện thoại
```

---

# 19. AUTH — WEB / DESKTOP / MOBILE

Các page:

```text
DPVWEBAuthDangNhap
DPVWEBAuthDangKy
DPVWEBAuthQuenMatKhau
DPVWEBAuthDatLaiMatKhau

DPVDESKAuthDangNhap
DPVDESKAuthQuenMatKhau
DPVDESKAuthDatLaiMatKhau

DPVMOBAuthDangNhap
DPVMOBAuthDangKy
DPVMOBAuthQuenMatKhau
DPVMOBAuthDatLaiMatKhau
```

## Đăng nhập

```text
Email
Mật khẩu
Đăng nhập
Quên mật khẩu
```

API:

```text
POST /api/auth/login
```

## Đăng ký

```text
Họ tên
Email
Số điện thoại
Mật khẩu
Xác nhận
```

API:

```text
POST /api/auth/register
```

## Quên mật khẩu

```text
Email
Gửi yêu cầu
```

Không tiết lộ email tồn tại hay không.

API:

```text
POST /api/auth/forgot-password
```

## Đặt lại mật khẩu

```text
Token
Mật khẩu mới
Xác nhận
```

API:

```text
POST /api/auth/reset-password
```

---

# 20. DESKTOP — ADMIN

# DPVDESKAdminTongQuan

## Chức năng

```text
Xem KPI
Xem tour chờ duyệt
Xem booking mới
Xem doanh thu
Xem hoạt động
Xem biểu đồ
```

KPI:

```text
Tài khoản
Tour
Booking
Doanh thu
```

---

# DPVDESKAdminQuanLyTaiKhoan

## Chức năng

```text
Tìm kiếm
Lọc
Xem
Khóa
Mở khóa
Deactivate
Đổi role
```

Columns:

```text
Username
Email
Họ tên
Role
Status
Ngày tạo
Action
```

Không Hard Delete Account.

API:

```text
GET /api/admin/accounts
GET /api/admin/accounts/{id}
PUT /api/admin/accounts/{id}/lock
PUT /api/admin/accounts/{id}/unlock
PUT /api/admin/accounts/{id}/deactivate
POST /api/admin/accounts/{id}/roles
PUT /api/admin/accounts/{id}/roles
```

---

# DPVDESKAdminChiTietTaiKhoan

```text
Thông tin
Role
Nhân viên
Trạng thái
Lịch sử role
```

Không hiển thị password/hash.

---

# DPVDESKAdminQuanLyPhongBan

```text
Tên Ban
Trưởng Ban
Số thành viên
Status
Action
```

Chức năng:

```text
Tạo
Sửa
Active
Inactive
Xem
```

---

# DPVDESKAdminChiTietPhongBan

```text
Thông tin Ban
Trưởng Ban
Thành viên
Status
```

---

# DPVDESKAdminQuanLyDanhMuc

Tabs:

```text
Quốc gia
Tỉnh/Thành
Địa điểm
Loại tour
Ngôn ngữ
Chuyên môn HDV
```

Actions:

```text
Thêm
Sửa
Active
Inactive
```

---

# DPVDESKAdminBaoCaoTongQuan

Filter:

```text
Ngày
Quý
Năm
```

KPI:

```text
Doanh thu
Booking
Tour
Departure
Chi phí
```

Không có module thuế.

---

# 21. DESKTOP — MANAGER

# DPVDESKManagerTongQuan

Dashboard:

```text
Tour
Departure
Booking
Tour riêng
Sự cố
Chi phí
```

Work Queue:

```text
Tour chờ xử lý
Departure sắp chạy
Booking mới
Tour riêng
Sự cố
```

---

# DPVDESKManagerQuanLyTour

## Chức năng

```text
Tìm
Lọc
Xem
Tạo
Sửa
Gửi duyệt
```

Columns:

```text
Tên
Loại tour
Điểm đến
Giá tham chiếu
Status
Updated
```

---

# DPVDESKManagerTaoTour

Form:

```text
Tên tour
Loại tour
Mô tả
Thời lượng
Điểm đến
Giá tham chiếu
Chính sách hủy
Ảnh
```

Actions:

```text
Lưu nháp
Gửi duyệt
```

---

# DPVDESKManagerChiTietTour

Tabs:

```text
Thông tin
Điểm đến
Lịch trình
Chính sách
Departure
```

---

# DPVDESKManagerQuanLyDotKhoiHanh

Columns:

```text
Tour
Ngày đi
Ngày về
Sức chứa
Đã đặt
Còn chỗ
Giá
Status
```

Actions:

```text
Tạo
Xem
Sửa
Mở bán
Đóng
Hủy
```

---

# DPVDESKManagerTaoDotKhoiHanh

Form:

```text
Ngày đi
Ngày về
Sức chứa
Giá người lớn
Giá trẻ em
Giá em bé
Lịch trình
```

---

# DPVDESKManagerChiTietDotKhoiHanh

Tabs:

```text
Tổng quan
Lịch trình
Hành khách
HDV
Tiến độ
Chi phí
Sự cố
```

Đây là màn hình vận hành trọng tâm.

---

# DPVDESKManagerPhanCongHDV

## Chức năng

```text
Xem HDV khả dụng
Tìm kiếm
Lọc
Xem lịch
Phân công HDV chính
Phân công HDV phụ
Đổi HDV
Xóa phân công
```

Candidate:

```text
HDV
Ban
Chuyên môn
Ngôn ngữ
Lịch làm việc
```

Quy tắc:

```text
Chỉ 1 HDV_CHINH
Có thể nhiều HDV_PHU
HDV phải active
Không trùng lịch
Phù hợp nghiệp vụ
```

---

# DPVDESKManagerQuanLyYeuCauTourRieng

```text
Mã
Khách hàng
Điểm đến
Ngày
Ngân sách
Status
```

Actions:

```text
Xem
Phân công Ban
Theo dõi
```

---

# DPVDESKManagerChiTietYeuCauTourRieng

Flow:

```text
Nhu cầu khách
↓
Địa điểm
↓
Phản hồi Ban
↓
Đề xuất HDV
↓
Tổng hợp
↓
Báo giá
```

---

# DPVDESKManagerXuLySuCo

```text
Danh sách sự cố
Mã
Departure
Loại
Mức độ
Thời gian
Status
```

Chi tiết:

```text
Mô tả
Chứng từ
Ảnh
Phương án
Thay đổi lịch
```

---

# 22. DESKTOP — DEPARTMENT MANAGER

# DPVDESKDepartmentManagerTongQuan

```text
Yêu cầu chờ xử lý
Công việc Ban
Thành viên
HDV
```

# DPVDESKDepartmentManagerYeuCauCanXuLy

```text
Mã
Deadline
Điểm đến
Status
Action
```

# DPVDESKDepartmentManagerChiTietYeuCau

```text
Nhu cầu khách
Điểm đến
Ngày
Ngân sách
HDV phù hợp
```

Actions:

```text
Đề xuất HDV
Gửi phản hồi
```

# DPVDESKDepartmentManagerQuanLyNhanSuPhong

```text
Nhân viên
Vị trí
Chuyên môn
Ngôn ngữ
Status
```

---

# 23. GUIDE — DESKTOP + MOBILE

## DPVDESKGuideTongQuan

```text
Tour sắp chạy
Tour đang chạy
Công việc cần cập nhật
Sự cố
```

## DPVMOBGuideTongQuan

Mobile:

```text
Tour hôm nay
Tour sắp tới
Việc cần làm
Sự cố
Thông báo
```

---

# DPVDESKGuideTourDuocPhanCong

```text
Tour
Departure
Ngày
Vai trò
Status
```

# DPVMOBGuideTourDuocPhanCong

Dùng:

```text
Tour Card
Departure
Ngày
Vai trò
Status
```

---

# DPVDESKGuideChiTietTourDuocPhanCong

Tabs:

```text
Thông tin
Lịch trình
Hành khách
Tiến độ
Sự cố
```

# DPVMOBGuideChiTietTourDuocPhanCong

Dùng:

```text
Tour Header
Ngày / địa điểm
Lịch trình Accordion
Danh sách hành khách
Progress
Incident CTA
```

---

# DPVDESKGuideCapNhatTienDo

Timeline:

```text
Mốc 1 ✓
Mốc 2 ✓
Mốc 3 → Đang thực hiện
Mốc 4 ○
```

Cho phép:

```text
Cập nhật trạng thái
Ghi chú
Thời gian
Ảnh
```

# DPVMOBGuideCapNhatTienDo

Ưu tiên:

```text
Current Step
[Hoàn thành]
[Đang thực hiện]
[Thêm ghi chú]
[Thêm ảnh]
```

CTA lớn, dễ thao tác khi đang di chuyển.

---

# DPVDESKGuideBaoCaoSuCo

```text
Loại
Mức độ
Thời gian
Vị trí
Mô tả
Ảnh / chứng từ
```

# DPVMOBGuideBaoCaoSuCo

Form mobile:

```text
Loại sự cố
Mức độ
Vị trí
Mô tả
Camera/Gallery
[ Gửi báo cáo ]
```

Ưu tiên thao tác nhanh.

---

# 24. BOOKING — DESKTOP INTERNAL

Các màn hình cần có cho vận hành:

```text
DPVDESKManagerQuanLyBooking
DPVDESKManagerChiTietBooking
```

> Nếu Designer cần mở rộng màn hình Booking nội bộ, dùng chính dữ liệu và API Booking đã phân tích, không tạo nghiệp vụ mới.

Thông tin:

```text
Mã booking
Khách hàng
Tour
Departure
Hành khách
Tổng tiền
Booking Status
Payment Status
Ngày đặt
```

Actions tùy quyền:

```text
Xem
Xác nhận
Theo dõi thanh toán
Xem hủy
Xem hoàn tiền
```

---

# 25. PAYMENT — DESKTOP

UI cần tách:

```text
Booking
Payment
Reconciliation
```

Hiển thị:

```text
Mã giao dịch
Booking
Số tiền
Phương thức
Trạng thái
Thời gian
```

Callback/payment failure phải có trạng thái rõ ràng.

---

# 26. CUSTOM TOUR — TOÀN HỆ THỐNG

Flow:

```text
KHÁCH HÀNG
↓
Tạo yêu cầu
↓
QUẢN LÝ TỔNG
↓
Phân công Ban liên quan
↓
TRƯỞNG BAN
↓
Đề xuất phương án / HDV
↓
QUẢN LÝ TỔNG
↓
Tổng hợp
↓
Báo giá
↓
KHÁCH HÀNG
↓
Xác nhận
↓
Tạo TOUR + DEPARTURE
```

Không cho khách:

```text
Tự chọn Ban nội bộ
Tự phân công HDV
```

---

# 27. INCIDENT / SỰ CỐ

Flow:

```text
HDV báo
↓
Quản lý nhận
↓
Đánh giá
↓
Phương án
↓
Có thể thay đổi lịch trình
↓
Khách phản hồi nếu bị ảnh hưởng
```

UI:

```text
Mức độ
Mô tả
Thời gian
Địa điểm
Ảnh/chứng từ
Phương án
Status
```

---

# 28. THAY ĐỔI LỊCH TRÌNH

Nếu ảnh hưởng khách:

```text
Đề xuất
↓
Khách nhận thông báo
↓
Khách phản hồi
↓
Chấp nhận / Từ chối
```

UI bắt buộc:

```text
LỊCH CŨ
vs
LỊCH MỚI
```

---

# 29. NOTIFICATION

## Web/Mobile

Notification Center:

```text
Tiêu đề
Nội dung
Thời gian
Read / Unread
Đi tới nghiệp vụ
```

## Desktop

Notification Center trên Topbar.

---

# 30. REVIEW & FAVORITE

## Review

Sau khi tour hoàn thành theo nghiệp vụ:

```text
Rating
Comment
```

## Favorite

Tour Card:

```text
♡ Chưa yêu thích
♥ Đã yêu thích
```

---

# 31. API → UX/UI MAPPING

| UX/UI | API chính |
|---|---|
| DPVWEBUserDanhSachTour | `GET /api/tours` |
| DPVWEBUserChiTietTour | `GET /api/tours/{tourId}` |
| DPVWEBUserDatTour | `POST /api/bookings` |
| DPVWEBUserThanhToan | `POST /api/bookings/{bookingId}/payments` |
| DPVWEBUserDonDatCuaToi | `GET /api/customers/me/bookings` |
| DPVWEBUserChiTietDonDat | `GET /api/customers/me/bookings/{bookingId}` |
| DPVWEBUserYeuCauHuyTour | `POST /api/bookings/{bookingId}/cancel` |
| DPVWEBUserYeuCauTourRieng | `POST /api/custom-tour-requests` |
| DPVDESKAdminQuanLyTaiKhoan | `GET /api/admin/accounts` |
| DPVDESKAdminQuanLyDanhMuc | Master Data APIs |
| DPVDESKManagerQuanLyTour | Manager Tour APIs |
| DPVDESKManagerTaoTour | `POST /api/manager/tours` |
| DPVDESKManagerQuanLyDotKhoiHanh | Manager Departure APIs |
| DPVDESKManagerPhanCongHDV | `/api/manager/departures/{departureId}/guides` |
| DPVDESKManagerQuanLyYeuCauTourRieng | Custom Tour APIs |
| DPVDESKManagerXuLySuCo | Incident APIs |
| DPVMOBGuideCapNhatTienDo | Tour Progress APIs |
| DPVMOBGuideBaoCaoSuCo | Incident APIs |

---

# 32. MOCK DATA CHO FE

## Tour

```json
{
  "id": 1,
  "tenTour": "Khám phá Đà Nẵng - Hội An",
  "loaiTour": "Trong nước",
  "thoiLuong": "3 ngày 2 đêm",
  "giaThamChieu": 3290000,
  "trangThai": "CONG_KHAI"
}
```

## Departure

```json
{
  "id": 101,
  "tourId": 1,
  "ngayKhoiHanh": "2026-10-10",
  "ngayKetThuc": "2026-10-12",
  "sucChua": 30,
  "daDat": 18,
  "conCho": 12,
  "giaNguoiLon": 3490000
}
```

## Booking

```json
{
  "maBooking": "DPV-2026-00001",
  "soKhach": 2,
  "tongTien": 6980000,
  "bookingStatus": "CHO_THANH_TOAN",
  "paymentStatus": "CHUA_THANH_TOAN"
}
```

Mock Data chỉ phục vụ UI/FE.

Backend vẫn quyết định:

```text
Giá
Quyền
Trạng thái
Sức chứa
Refund
```

---

# 33. CẤU TRÚC FE

```text
src/
├── assets/
├── components/
├── layouts/
├── pages/
│   ├── web/
│   ├── desktop/
│   ├── mobile/
│   ├── auth/
│   ├── user/
│   ├── admin/
│   ├── manager/
│   ├── department-manager/
│   └── guide/
├── services/
├── mocks/
├── hooks/
├── contexts/
├── routes/
├── utils/
└── constants/
```

Ví dụ:

```text
src/pages/web/user/DPVWEBUserDanhSachTour/
    DPVWEBUserDanhSachTour.jsx

src/pages/desktop/admin/DPVDESKAdminTongQuan/
    DPVDESKAdminTongQuan.jsx

src/pages/mobile/guide/DPVMOBGuideCapNhatTienDo/
    DPVMOBGuideCapNhatTienDo.jsx
```

---

# 34. QUY TẮC FE

FE được phép:

```text
Hiển thị
Validate cơ bản
Loading
UX interaction
Mock Data
Form state
Navigation
```

FE không được tự quyết định:

```text
Giá cuối
Capacity cuối
Permission
Refund cuối
Booking status cuối
Payment success cuối
```

---

# 35. THỨ TỰ DESIGN NHANH NHẤT

## Phase 1 — Design System

```text
Colors
Typography
Button
Input
Card
Badge
Table
Modal
Toast
Navbar
Sidebar
Bottom Navigation
```

## Phase 2 — Web Customer

```text
DPVWEBUserTrangChu
DPVWEBUserDanhSachTour
DPVWEBUserChiTietTour
DPVWEBUserDatTour
DPVWEBUserThanhToan
DPVWEBUserKetQuaDatTour
DPVWEBUserDonDatCuaToi
DPVWEBUserChiTietDonDat
```

## Phase 3 — Mobile Customer

```text
DPVMOBUserTrangChu
DPVMOBUserDanhSachTour
DPVMOBUserChiTietTour
DPVMOBUserDatTour
DPVMOBUserThanhToan
DPVMOBUserKetQuaDatTour
DPVMOBUserDonDatCuaToi
DPVMOBUserChiTietDonDat
```

## Phase 4 — Auth

```text
DPVWEBAuth...
DPVDESKAuth...
DPVMOBAuth...
```

## Phase 5 — Desktop Admin

```text
DPVDESKAdminTongQuan
DPVDESKAdminQuanLyTaiKhoan
DPVDESKAdminChiTietTaiKhoan
DPVDESKAdminQuanLyPhongBan
DPVDESKAdminChiTietPhongBan
DPVDESKAdminQuanLyDanhMuc
DPVDESKAdminBaoCaoTongQuan
```

## Phase 6 — Desktop Manager

```text
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

## Phase 7 — Desktop Department Manager

```text
DPVDESKDepartmentManagerTongQuan
DPVDESKDepartmentManagerYeuCauCanXuLy
DPVDESKDepartmentManagerChiTietYeuCau
DPVDESKDepartmentManagerQuanLyNhanSuPhong
```

## Phase 8 — Guide Desktop + Mobile

```text
DPVDESKGuideTongQuan
DPVDESKGuideTourDuocPhanCong
DPVDESKGuideChiTietTourDuocPhanCong
DPVDESKGuideCapNhatTienDo
DPVDESKGuideBaoCaoSuCo

DPVMOBGuideTongQuan
DPVMOBGuideTourDuocPhanCong
DPVMOBGuideChiTietTourDuocPhanCong
DPVMOBGuideCapNhatTienDo
DPVMOBGuideBaoCaoSuCo
```

---

# 36. MASTER PROMPT CHO AI STITCH

Copy phần này vào AI Stitch:

```text
Create a production-oriented UX/UI system for DPV TourDuLich.

The product has THREE platforms:
1. WEB
2. DESKTOP APP
3. MOBILE APP

MANDATORY NAMING:
DPV + PLATFORM + USER/ROLE + PAGE NAME

Platform abbreviations:
WEB = Web
DESK = Desktop App
MOB = Mobile App

Examples:
DPVWEBUserTrangChu
DPVWEBUserDanhSachTour
DPVDESKAdminTongQuan
DPVDESKManagerQuanLyTour
DPVMOBUserTrangChu
DPVMOBGuideCapNhatTienDo

Brand:
- DPV TourDuLich
- Primary color: ocean blue
- White-based interface
- Primary blue: #0066FF
- Dark blue: #0052CC
- Light blue: #EAF3FF
- Cyan: #00C7E6
- Background: #F7F9FC
- Text: #172033
- Secondary text: #667085
- Border: #E5EAF2
- Font: Inter or Be Vietnam Pro
- Style: modern travel + technology + professional

Slogan:
“Khám phá hành trình, kết nối trải nghiệm.”

Use the provided DPV logo as the brand reference.
Use a clean light-background treatment.
Keep the original DPV symbol recognizable.
Do not distort the logo.

IMPORTANT PLATFORM RULES:

WEB:
Focus on customer travel discovery and booking.
Responsive for desktop, tablet and mobile web.

DESKTOP:
Focus on internal business operations.
Desktop-first.
Use sidebar, topbar, tables, dashboards, charts, forms and data management layouts.

MOBILE:
Focus on quick customer and guide operations.
Use cards, bottom navigation, bottom sheets, accordion, sticky CTA and large touch targets.
Do not copy large desktop tables into mobile.

IMPORTANT BUSINESS RULES:

1. TOUR and DEPARTURE are different entities.
2. TOUR is the tour product.
3. DEPARTURE is a specific scheduled occurrence with its own date, capacity, selling price, itinerary, guides, progress, costs and incidents.
4. Booking Status and Payment Status must be displayed separately.
5. Tour Type and Tour Lifecycle Status must be separate.
6. Do not create tax management UI.
7. Do not create BAN_QUOC_GIA UI.
8. Do not create a separate PHUONG_TIEN master-data UI.
9. Master data is managed by Admin.
10. Do not hard-delete referenced master data.
11. Do not invent business functions outside the specification.
12. Every important page needs Loading, Empty, Error, Success and Disabled states.
13. Forms need validation and submitting states.
14. Use realistic mock data.
15. UI must be easy for React developers to implement.
16. UI must remain compatible when Mock API is replaced by real API.
17. Use reusable components and consistent Design System.

Customer Web/Mobile functions:
- Discover tours
- Search/filter/sort tours
- View tour details
- Select departure
- Book tour
- Manage passengers
- Payment
- View booking
- Cancel booking
- Refund information
- Request private/custom tour
- View quotation
- Confirm quotation
- Profile
- Change password
- Notifications
- Favorite
- Review

Desktop internal functions:
- Admin account management
- Role management
- Department management
- Master data
- Tour management
- Tour approval
- Departure management
- Guide assignment
- Booking operations
- Payment monitoring
- Cancellation/refund
- Custom tour processing
- Budget
- Expense
- Incident
- Schedule changes
- Reports
- Audit
- Contact

Guide Mobile/Desktop functions:
- View assigned tours
- View departure
- View itinerary
- View passengers
- Update tour progress
- Report incidents
- Upload evidence/photos
- Receive notifications

CUSTOM TOUR FLOW:
Customer request
→ Overall Manager
→ Assign relevant Departments
→ Department Manager
→ Guide/proposal
→ Overall Manager aggregates
→ Quotation
→ Customer confirms
→ Create dedicated Tour + Departure

INCIDENT FLOW:
Guide reports
→ Manager reviews
→ Manager proposes handling
→ Schedule may change
→ Customer response if booking is affected

Create UI that is production-oriented, consistent, accessible and realistic.
Prioritize usability and implementation feasibility over decorative visuals.
```

---

# 37. CHECKLIST DESIGN → FE

Mỗi màn hình phải kiểm tra:

```text
[ ] Đúng tên DPV + PLATFORM + ROLE + PAGE
[ ] Đúng nền tảng
[ ] Đúng role
[ ] Đúng chức năng
[ ] Đúng API
[ ] Đúng nghiệp vụ
[ ] Tour / Departure tách rõ
[ ] Booking / Payment tách rõ
[ ] Tour Type / Tour Status tách rõ
[ ] Loading
[ ] Empty
[ ] Error
[ ] Success
[ ] Disabled
[ ] Validation
[ ] Confirmation
[ ] Mock Data
[ ] Navigation
[ ] Responsive nếu là Web/Mobile
[ ] Desktop-first nếu là Desktop
[ ] Không thêm module ngoài scope
```

---

# 38. CHECKLIST FE DEVELOPER

Designer bàn giao cho FE:

```text
1. Figma/Stitch Screen
2. Page Name
3. Platform
4. Role
5. Chức năng
6. Component
7. State
8. Mock Data
9. API cần dùng
10. Navigation
```

Ví dụ:

```text
Page:
DPVWEBUserChiTietTour

Platform:
WEB

Role:
KHACH_HANG

Functions:
- Xem tour
- Xem Departure
- Xem lịch trình
- Xem chính sách
- Chọn Departure
- Yêu thích

API:
GET /api/tours/{tourId}

States:
Loading
Success
Empty Departure
Error

CTA:
Chọn Departure
```

---

# 39. DEFINITION OF DONE CHO MỘT UX/UI PAGE

Một Page chỉ được xem là hoàn thành khi:

```text
[ ] Có Desktop/Web/Mobile version nếu Page thuộc nhiều nền tảng
[ ] Đúng tên
[ ] Đúng role
[ ] Có mục đích rõ
[ ] Có đầy đủ chức năng
[ ] Có API mapping
[ ] Có mock data
[ ] Có loading
[ ] Có empty
[ ] Có error
[ ] Có success
[ ] Có validation nếu có form
[ ] Có navigation
[ ] Có responsive nếu cần
[ ] FE developer hiểu được cách build mà không phải hỏi lại BA về UI
```

---

# 40. KẾT QUẢ CUỐI CÙNG

Team không làm:

```text
Chờ Backend
→ mới Design
→ mới FE
```

Team làm song song:

```text
                 ┌──→ UX/UI
CSDL + API ──────┤
                 └──→ FE Mock Data

UX/UI
  ↓
FE
  ↓
Real API
  ↓
QA
```

### Mục tiêu:

```text
DESIGN
→ tạo UX/UI bằng AI Stitch

FE
→ build Web/Desktop/Mobile bằng Mock Data

BE
→ hoàn thiện API

FE
→ thay Mock API bằng API thật

QA
→ test Page → Function → API → Business Rule → Database
```

**Kết quả mong muốn:** khi Backend hoàn thành, Frontend không phải thiết kế lại giao diện; chỉ cần kết nối API thật, xử lý state thực tế và hoàn thiện validation/business response.
