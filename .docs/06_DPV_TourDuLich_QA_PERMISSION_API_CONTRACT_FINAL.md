# DPV TourDuLich — QA / PERMISSION / API CONTRACT

**Version:** 1.0  
**System:** DPV TourDuLich  
**Document:** File 06 — QA / Permission / API Contract  
**Audience:** BA/PM, Backend, Frontend, Designer, QA/Tester

---

## 1. Mục đích

File 06 là tài liệu gộp của ba nhóm tài liệu trước đây dự kiến tách riêng:

1. **Permission / Role Matrix** — ai được làm gì, trong phạm vi nào.
2. **Data Dictionary / API Contract** — dữ liệu, API, request/response và quy ước lỗi.
3. **QA / Test Matrix** — kiểm thử chức năng, API, quyền, state, transaction, security và dữ liệu.

Tài liệu này bổ sung cho:

- **File 01 — Database / ERD**: dữ liệu nào tồn tại.
- **File 02 — Developer / API Handoff**: backend/frontend phải triển khai thế nào.
- **File 03 — UX/UI Master Spec**: thiết kế màn hình nào.
- **File 04 — User & Function Spec**: ai làm gì.
- **File 05 — Flow / State Spec**: nghiệp vụ chuyển trạng thái ra sao.

Luồng chuẩn của toàn hệ thống:

```text
ROLE
→ PAGE
→ FUNCTION
→ ACTION
→ PERMISSION
→ CONDITION
→ API
→ DATABASE
→ STATE
→ RESULT
→ NEXT PAGE / STATE
→ TEST
```

> **Nguyên tắc:** File 06 không tự tạo nghiệp vụ mới. Những gì đã có trong File 01–05 là nguồn tham chiếu chính. Nếu một trạng thái, field hoặc endpoint chưa được chốt trong các contract trước thì phải đánh dấu **TBD / cần chốt**, không tự coi là final.

---

# PHẦN A — PERMISSION / ROLE MATRIX

# 2. Role hệ thống

## 2.1. ADMIN

Phạm vi chính:

```text
Tài khoản
Role / Permission
Phòng / Ban
Master Data
Duyệt / publish tour
Báo cáo
Audit
```

## 2.2. QUAN_LY_TONG

Phạm vi chính:

```text
Tour
Departure
HDV
Booking vận hành
Tour riêng
Sự cố
Ngân sách
Chi phí
```

## 2.3. TRUONG_BAN

Phạm vi chính:

```text
Nghiệp vụ thuộc Ban
Xử lý yêu cầu tour riêng thuộc phạm vi
Đề xuất / phân công HDV theo phạm vi
Quản lý nhân sự trong Ban theo quyền được cấp
```

## 2.4. HDV

Phạm vi chính:

```text
Tour được phân công
Departure được phân công
Lịch trình
Hành khách
Tiến độ tour
Sự cố
Ảnh / chứng từ vận hành nếu được phép
```

## 2.5. NHAN_VIEN

Quyền thực tế không suy ra chỉ từ tên role. Quyền lấy theo:

```text
TAI_KHOAN
→ TAI_KHOAN_VAI_TRO
→ VAI_TRO
→ VAI_TRO_QUYEN
→ QUYEN
```

## 2.6. KHACH_HANG

Phạm vi chính:

```text
Xem tour
Xem departure công khai
Đặt tour
Quản lý passenger
Thanh toán
Xem booking của mình
Hủy / yêu cầu hoàn tiền theo điều kiện
Yêu cầu tour riêng
Xem báo giá
Xác nhận báo giá
Review
Favorite
Notification
Hồ sơ
```

---

# 3. Permission levels

| Level | Ý nghĩa |
|---|---|
| `PUBLIC` | Không cần đăng nhập |
| `AUTHENTICATED` | Phải đăng nhập |
| `OWNER` | Chỉ được truy cập tài nguyên của chính user |
| `ROLE` | Phải có role phù hợp |
| `DEPARTMENT_SCOPE` | Chỉ trong phạm vi Ban được phép |
| `ADMIN_ONLY` | Chỉ ADMIN |

FE có thể ẩn / hiện UI theo quyền nhưng **BE luôn phải kiểm tra permission**.

---

# 4. Nguyên tắc Authorization

Mỗi request cần được kiểm tra theo thứ tự:

```text
1. Authentication
2. Account status
3. Role
4. Permission
5. Ownership
6. Department Scope
7. Resource State
8. Business Rule
9. Transaction
10. Database
```

Không được coi việc FE ẩn nút là cơ chế bảo mật.

Ví dụ:

```text
Customer mở booking
→ JWT
→ lấy KHACH_HANG
→ kiểm tra BOOKING.khach_hang_id
→ đúng owner
→ cho phép
```

Nếu không đúng owner thì không được trả dữ liệu booking của người khác.

---

# 5. Role → phạm vi chức năng

| Module | ADMIN | QUAN_LY_TONG | TRUONG_BAN | HDV | NHAN_VIEN | KHACH_HANG |
|---|---:|---:|---:|---:|---:|---:|
| Authentication | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Account / Role | ✓ | Theo quyền | Theo quyền | — | Theo quyền | Hồ sơ mình |
| Department | ✓ | Theo quyền | Phạm vi Ban | — | Theo quyền | — |
| Master Data | ✓ | Theo quyền | Theo quyền | — | Theo quyền | Đọc |
| Tour | ✓ | ✓ | Theo phạm vi | Đọc tour được phân công | Theo quyền | Đọc công khai |
| Departure | ✓ | ✓ | Theo phạm vi | Đọc tour được phân công | Theo quyền | Đọc công khai |
| Guide Assignment | ✓ | ✓ | Theo phạm vi | Xem phân công mình | Theo quyền | — |
| Booking | Xem / vận hành | ✓ | Theo phạm vi | Chỉ dữ liệu cần cho tour | Theo quyền | Của mình |
| Payment | Theo quyền | Theo quyền | Theo quyền | — | Theo quyền | Của mình |
| Cancellation | Theo quyền | ✓ | Theo phạm vi | — | Theo quyền | Booking mình |
| Refund | Theo quyền | ✓ | Theo phạm vi | — | Theo quyền | Booking mình |
| Custom Tour | Theo quyền | ✓ | Theo Ban | Phối hợp khi được giao | Theo quyền | Của mình |
| Budget | Báo cáo / theo quyền | ✓ | Theo phạm vi | — | Theo quyền | — |
| Expense | Theo quyền | ✓ | Theo phạm vi | Theo quyền nếu được giao | Theo quyền | — |
| Incident | Xem / theo quyền | ✓ | Theo phạm vi | Báo cáo | Theo quyền | Nhận thông tin nếu ảnh hưởng |
| Review | Quản lý | Quản lý | Theo quyền | — | — | Của mình |
| Favorite | — | — | — | — | — | Của mình |
| Notification | Quản lý / hệ thống | Nhận / xử lý | Nhận / xử lý | Nhận / xử lý | Nhận / xử lý | Của mình |
| Report | ✓ | ✓ | Theo phạm vi | — | Theo quyền | — |
| Audit | ✓ | Theo quyền | Theo quyền | — | Theo quyền | — |
| Contact | ✓ | ✓ | Theo quyền | — | Theo quyền | Gửi / xem phản hồi |

> Bảng trên là matrix định hướng. Quyền thực tế phải được biểu diễn bằng `QUYEN` và `VAI_TRO_QUYEN`, không hard-code quyền theo tên role ở FE.

---

# 6. Ownership / Department Scope

## 6.1. Ownership

Customer chỉ được thao tác trên tài nguyên của chính mình:

```text
JWT
→ TAI_KHOAN
→ KHACH_HANG
→ BOOKING.khach_hang_id
```

Các tài nguyên có ownership tương tự phải được kiểm tra ở backend.

## 6.2. Department Scope

Nhân sự nội bộ chỉ được thao tác trong phạm vi Ban nếu nghiệp vụ yêu cầu scope.

```text
User
→ NHAN_VIEN
→ NHAN_VIEN_BAN
→ BAN
→ Resource thuộc phạm vi
```

Không được dùng `BAN_QUOC_GIA`; database hiện không có bảng này.

---

# PHẦN B — DATA DICTIONARY / API CONTRACT

# 7. Nguyên tắc Data Contract

API là hợp đồng giữa FE và BE.

Không tự ý thay đổi:

```text
Endpoint
HTTP Method
Request field
Response field
Status
Permission
Business Rule
```

Nếu phải thay đổi:

```text
Cập nhật API Contract
→ cập nhật Function Spec
→ cập nhật UX/UI nếu ảnh hưởng
→ cập nhật Flow/State nếu ảnh hưởng
→ cập nhật QA
```

---

# 8. Database source of truth

Database chuẩn duy nhất là `DPV_TourDuLich_FINAL.sql`, MySQL 8.0+, gồm 56 bảng. Không dùng bản SQL 52 bảng cũ để triển khai.

Các nhóm chính:

```text
ACCOUNT / SECURITY
TAI_KHOAN
VAI_TRO
QUYEN
TAI_KHOAN_VAI_TRO
VAI_TRO_QUYEN
PHIEN_DANG_NHAP
DAT_LAI_MAT_KHAU
LICH_SU_VAI_TRO

EMPLOYEE / DEPARTMENT
NHAN_VIEN
BAN
NHAN_VIEN_BAN
CHUYEN_MON_HDV
NGON_NGU
NHAN_VIEN_NGON_NGU

CUSTOMER
KHACH_HANG

MASTER
QUOC_GIA
TINH_THANH
DIA_DIEM
LOAI_TOUR

TOUR OPERATION
TOUR
TOUR_DIA_DIEM
DOT_KHOI_HANH
LICH_TRINH
PHAN_CONG_HDV
TIEN_TRINH_TOUR
HINH_ANH_TIEN_TRINH

BOOKING / PAYMENT
CHINH_SACH_HUY
QUY_TAC_HUY
BOOKING
HANH_KHACH
THANH_TOAN
DOI_SOAT_GIAO_DICH
HUY_BOOKING
HOAN_TIEN

CUSTOM TOUR
YEU_CAU_TOUR_RIENG
YEU_CAU_TOUR_DIA_DIEM
PHAN_CONG_YEU_CAU_TOUR
BAO_GIA_TOUR_RIENG
CHI_TIET_BAO_GIA
TOUR_TU_YEU_CAU

BUDGET / EXPENSE
NGAN_SACH_DOT
CHI_TIET_NGAN_SACH
CHI_PHI
CHUNG_TU_CHI_PHI
DUYET_CHI_PHI

INCIDENT / SCHEDULE
SU_CO_TOUR
CHUNG_TU_SU_CO
THAY_DOI_LICH_TRINH
PHAN_HOI_THAY_DOI
HUY_DOT_KHOI_HANH

SUPPORTING
CHUYEN_BOOKING
DANH_GIA_TOUR
TOUR_YEU_THICH
THONG_BAO
NHAT_KY_HE_THONG
LIEN_HE
```

Không có:

```text
BAN_QUOC_GIA
PHUONG_TIEN
```

Thuế nằm ngoài scope.

---

# 9. Security Data Rules

## 9.1. Password

```text
TAI_KHOAN.password_hash
```

- Dùng BCrypt.
- Không lưu plaintext.
- Không trả password/hash trong API response.

## 9.2. Refresh Token

Quản lý qua `PHIEN_DANG_NHAP`.

## 9.3. Reset Password

Quản lý qua `DAT_LAI_MAT_KHAU`.

Token phải:

```text
Có hạn sử dụng
Dùng một lần
Không trả hash token nhạy cảm ra response
```

## 9.4. Role History

Thay đổi role phải ghi `LICH_SU_VAI_TRO`.

---

# 10. Core API Contract

## 10.1. Authentication

| API | Method | Mục đích | Scope |
|---|---|---|---|
| `/api/auth/login` | POST | Đăng nhập | PUBLIC |
| `/api/auth/register` | POST | Đăng ký | PUBLIC |
| `/api/auth/logout` | POST | Đăng xuất | AUTHENTICATED |
| `/api/auth/forgot-password` | POST | Yêu cầu reset | PUBLIC |
| `/api/auth/reset-password` | POST | Đặt lại mật khẩu | PUBLIC + token |
| `/api/auth/refresh-token` | POST | Refresh access token | Session |
| `/api/auth/me` | GET | Thông tin user hiện tại | AUTHENTICATED |

Login request mẫu:

```json
{
  "email": "user@example.com",
  "matKhau": "********"
}
```

Login thành công trả access token + refresh token và role cần thiết cho FE.

---

# 11. Customer API Contract

| API | Method | Mục đích |
|---|---|---|
| `/api/customers/me` | GET | Hồ sơ của mình |
| `/api/customers/me` | PUT | Cập nhật hồ sơ |
| `/api/customers/me/bookings` | GET | Danh sách booking của mình |
| `/api/customers/me/bookings/{bookingId}` | GET | Chi tiết booking của mình |
| `/api/customers/me/bookings/{bookingId}/passengers` | GET | Passenger |
| `/api/customers/me/bookings/{bookingId}/passengers/{passengerId}` | PUT | Sửa passenger |

Ownership bắt buộc.

---

# 12. Account / Role API Contract

```text
GET  /api/admin/accounts
GET  /api/admin/accounts/{id}
POST /api/admin/accounts
POST /api/admin/accounts/{id}/roles
PUT  /api/admin/accounts/{id}/roles
PUT  /api/admin/accounts/{id}/lock
PUT  /api/admin/accounts/{id}/unlock
PUT  /api/admin/accounts/{id}/deactivate
GET  /api/admin/roles
GET  /api/admin/permissions
PUT  /api/admin/roles/{id}/permissions
```

Không hard-delete account.

---

# 13. Master Data API Contract

## Country

```text
GET  /api/countries
GET  /api/countries/{id}
POST /api/admin/countries
PUT  /api/admin/countries/{id}
PUT  /api/admin/countries/{id}/deactivate
```

## Province / Tỉnh thành

```text
GET  /api/provinces?countryId={id}
GET  /api/provinces/{id}
POST /api/admin/provinces
PUT  /api/admin/provinces/{id}
PUT  /api/admin/provinces/{id}/deactivate
```

## Location

```text
GET  /api/locations?provinceId={id}
GET  /api/locations/{id}
POST /api/admin/locations
PUT  /api/admin/locations/{id}
PUT  /api/admin/locations/{id}/deactivate
```

## Tour Type

```text
GET  /api/tour-types
POST /api/admin/tour-types
PUT  /api/admin/tour-types/{id}
PUT  /api/admin/tour-types/{id}/deactivate
```

## Language

```text
GET  /api/languages
POST /api/admin/languages
PUT  /api/admin/languages/{id}
PUT  /api/admin/languages/{id}/deactivate
```

Master data đã được tham chiếu không hard-delete.

---

# 14. Tour API Contract

Tour và departure là hai entity khác nhau.

Tour lifecycle đã chốt:

```text
NHAP
→ CHO_DUYET
→ DA_DUYET
→ CONG_KHAI
→ NGUNG_BAN
```

Nhánh từ chối:

```text
CHO_DUYET
→ TU_CHOI
→ NHAP
```

API:

```text
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

Rules:

```text
TOUR.loai_tour_id → LOAI_TOUR.id
TOUR_DIA_DIEM → thứ tự địa điểm
Giá TOUR → giá tham chiếu
Giá DEPARTURE → giá bán thực tế
Giá BOOKING → snapshot
```

---

# 15. Departure API Contract

Departure là một lần khởi hành cụ thể, có dữ liệu vận hành độc lập.

Các nhóm API chính:

```text
GET  /api/departures
GET  /api/departures/{departureId}
POST /api/manager/tours/{tourId}/departures
PUT  /api/manager/departures/{departureId}
GET  /api/manager/departures/{departureId}/itinerary
POST /api/manager/departures/{departureId}/itinerary
PUT  /api/manager/departures/{departureId}/itinerary/{id}
```

> Departure state đã được freeze trong File 05: `MOI_TAO`, `MO_DANG_KY`, `DA_DAY`, `DONG_DANG_KY`, `DA_KHOI_HANH`, `DANG_DI`, `DA_HOAN_THANH`, `DA_HUY`. API phải sử dụng đúng các state này; endpoint phải theo Developer Handoff/API Contract.

---

# 16. Guide Assignment API Contract

```text
GET  /api/manager/departures/{departureId}/guides
POST /api/manager/departures/{departureId}/guides
PUT  /api/manager/departures/{departureId}/guides/{assignmentId}
DELETE /api/manager/departures/{departureId}/guides/{assignmentId}
```

Backend phải kiểm tra:

```text
HDV tồn tại
HDV active
Phạm vi Ban
Không conflict lịch
Role / chuyên môn nếu nghiệp vụ yêu cầu
```

---

# 17. Booking API Contract

Core:

```text
POST /api/bookings
GET  /api/bookings/{bookingId}
GET  /api/customers/me/bookings
POST /api/bookings/{bookingId}/cancel
```

Create booking phải xử lý transaction:

```text
BOOKING
+
HANH_KHACH
+
capacity update
```

Phải chống overbooking bằng cơ chế transaction / locking phù hợp.

Ví dụ:

```text
Còn 1 chỗ
2 request đồng thời
→ chỉ 1 request thành công
→ sức chứa không vượt giới hạn
```

Booking status và payment status phải tách riêng.

---

# 18. Payment API Contract

```text
POST /api/bookings/{bookingId}/payments
GET  /api/payments/{paymentId}
POST /api/payments/{paymentId}/callback
```

Giai đoạn đầu dùng Mock Payment.

Thiết kế phải có khả năng mở rộng provider sau này như VNPay/MoMo/ZaloPay/bank transfer theo contract của hệ thống.

Transaction chính:

```text
THANH_TOAN
+
BOOKING
+
DOI_SOAT_GIAO_DICH
```

Callback phải có tính **idempotent**: cùng một giao dịch không được ghi nhận thành công nhiều lần.

---

# 19. Cancellation / Refund API Contract

Cancellation:

```text
POST /api/bookings/{bookingId}/cancel
GET  /api/bookings/{bookingId}/cancellation-policy
```

Refund:

```text
GET  /api/bookings/{bookingId}/refund
POST /api/bookings/{bookingId}/refund
```

Backend quyết định:

```text
Có được hủy không?
Phí hủy?
Tỷ lệ hoàn?
Có được hoàn tiền không?
Số tiền hoàn?
```

FE chỉ hiển thị kết quả từ BE.

---

# 20. Custom Tour API Contract

Luồng tổng quát:

```text
Customer request
→ Overall Manager
→ Department
→ Guide / proposal
→ Quotation
→ Customer confirm
→ Dedicated Tour + Departure
```

Các nhóm API:

```text
POST /api/custom-tour-requests
GET  /api/custom-tour-requests/{id}
GET  /api/manager/custom-tour-requests
POST /api/manager/custom-tour-requests/{id}/assign
POST /api/manager/custom-tour-requests/{id}/quotation
GET  /api/custom-tour-requests/{id}/quotation
POST /api/custom-tour-requests/{id}/confirm
```

> State chi tiết của custom tour phải thống nhất với File 05 và enum thực tế của backend trước khi freeze contract.

---

# 21. Operation API Contract

Các nhóm API:

```text
BUDGET
EXPENSE
INCIDENT
SCHEDULE CHANGE
TOUR PROGRESS
```

Ví dụ:

```text
GET  /api/manager/departures/{departureId}/budget
POST /api/manager/departures/{departureId}/budget
POST /api/manager/departures/{departureId}/expenses
POST /api/guide/departures/{departureId}/incidents
POST /api/manager/departures/{departureId}/schedule-changes
POST /api/guide/departures/{departureId}/progress
```

Endpoint cụ thể phải được giữ đồng bộ với File 02 nếu backend thay đổi.

---

# 22. Common Response Contract

Backend nên thống nhất response để FE dễ xử lý.

## Success

```json
{
  "success": true,
  "data": {},
  "message": "Thành công"
}
```

## Error

```json
{
  "success": false,
  "code": "BOOKING_CAPACITY_EXCEEDED",
  "message": "Departure không còn đủ chỗ",
  "errors": []
}
```

Tên field cụ thể có thể được backend chuẩn hóa, nhưng sau khi chốt phải áp dụng thống nhất toàn API.

---

# 23. HTTP Status Matrix

| HTTP | Ý nghĩa QA cần kiểm tra |
|---|---|
| `200` | Request thành công |
| `201` | Tạo resource thành công |
| `400` | Request không hợp lệ |
| `401` | Chưa xác thực / token không hợp lệ |
| `403` | Có đăng nhập nhưng không có quyền |
| `404` | Resource không tồn tại hoặc không được phép tiết lộ |
| `409` | Conflict / duplicate / state conflict |
| `422` | Validation nghiệp vụ nếu backend dùng |
| `500` | Lỗi server không mong muốn |

Không bắt buộc mọi endpoint phải dùng tất cả mã trên; phải thống nhất theo API contract thực tế.

---

# PHẦN C — QA / TEST MATRIX

# 24. Mục tiêu QA

QA phải kiểm tra theo chuỗi:

```text
PAGE
→ FUNCTION
→ API
→ PERMISSION
→ BUSINESS RULE
→ DATABASE
→ STATE
→ RESULT
```

Không chỉ kiểm tra giao diện có hiển thị đúng.

---

# 25. Test Levels

## 25.1. UI Test

Kiểm tra:

```text
Page
Route
Form
Validation
Loading
Empty
Error
Success
Disabled
Navigation
Responsive
```

## 25.2. API Test

Kiểm tra:

```text
Success
Validation
401
403
404
409
Ownership
Scope
Duplicate
Invalid State
```

## 25.3. Integration / DB Test

Kiểm tra:

```text
FK
Unique
CHECK
Transaction
Rollback
Data consistency
```

## 25.4. Security Test

Kiểm tra:

```text
JWT expired
JWT giả
Refresh token giả
Account locked
Account deactivated
Customer gọi admin API
Customer truy cập booking người khác
Guide gọi manager API
IDOR / ownership bypass
```

## 25.5. Concurrency Test

Đặc biệt quan trọng với booking.

---

# 26. Generic API Test Matrix

| Test | Expected |
|---|---|
| Request hợp lệ | Success |
| Thiếu field bắt buộc | 400/422 |
| Field sai format | 400/422 |
| Không đăng nhập | 401 |
| Sai role | 403 |
| Sai department scope | 403 |
| Không sở hữu resource | 403 hoặc 404 theo contract |
| Resource không tồn tại | 404 |
| Duplicate | 409 |
| State không cho phép action | 409/422 |
| DB failure | Transaction rollback |
| Token hết hạn | 401 |
| Refresh token không hợp lệ | 401 |

---

# 27. Authentication Test Matrix

| ID | Scenario | Expected |
|---|---|---|
| AUTH-001 | Register hợp lệ | Tạo account + customer + role |
| AUTH-002 | Email trùng | Không tạo account mới |
| AUTH-003 | Password không hợp lệ | Validation |
| AUTH-004 | Login đúng | Access + refresh |
| AUTH-005 | Login sai password | Không đăng nhập |
| AUTH-006 | Account locked | Từ chối login |
| AUTH-007 | Account deactivated | Từ chối login |
| AUTH-008 | Access token hết hạn | 401 |
| AUTH-009 | Refresh hợp lệ | Cấp access mới |
| AUTH-010 | Refresh giả | Từ chối |
| AUTH-011 | Logout | Session bị vô hiệu hóa |
| AUTH-012 | Forgot password | Không leak account existence |
| AUTH-013 | Reset token hết hạn | Từ chối |
| AUTH-014 | Reset token dùng lại | Từ chối |

---

# 28. Account / Role Test Matrix

```text
[ ] Admin xem account
[ ] Admin tạo account
[ ] Admin gán role
[ ] Admin đổi role
[ ] Role change ghi LICH_SU_VAI_TRO
[ ] Lock account
[ ] Unlock account
[ ] Deactivate account
[ ] Không hard-delete account
[ ] User không tự nâng role
[ ] Customer không gọi admin API
[ ] FE ẩn UI nhưng BE vẫn enforce permission
```

---

# 29. Customer Test Matrix

```text
[ ] Xem profile của mình
[ ] Sửa profile của mình
[ ] Xem booking của mình
[ ] Không xem booking người khác
[ ] Không sửa passenger của booking người khác
[ ] Ownership được kiểm tra ở BE
```

---

# 30. Master Data Test Matrix

```text
[ ] Admin tạo master data
[ ] Admin sửa master data
[ ] Admin deactivate master data
[ ] Dữ liệu active xuất hiện ở FE
[ ] Dữ liệu inactive không xuất hiện ở luồng tạo mới
[ ] Master data đã được tham chiếu không hard-delete
[ ] Không hard-code danh mục trong FE
```

Các master chính:

```text
QUOC_GIA
TINH_THANH
DIA_DIEM
LOAI_TOUR
NGON_NGU
CHUYEN_MON_HDV
```

---

# 31. Tour Test Matrix

```text
[ ] Tạo tour hợp lệ
[ ] Thiếu field bắt buộc
[ ] Giá âm bị từ chối
[ ] Số ngày không hợp lệ bị từ chối
[ ] Submit NHAP → CHO_DUYET
[ ] Approve CHO_DUYET → DA_DUYET
[ ] Reject CHO_DUYET → TU_CHOI
[ ] TU_CHOI → NHAP
[ ] Publish chỉ khi đủ điều kiện
[ ] Stop-selling đúng quyền
[ ] Không cho action sai state
[ ] TOUR ≠ DOT_KHOI_HANH
[ ] LOAI_TOUR ≠ TOUR STATUS
```

---

# 32. Departure Test Matrix

```text
[ ] Tạo departure thuộc đúng tour
[ ] Giá departure độc lập với giá tour
[ ] Capacity hợp lệ
[ ] Capacity không âm
[ ] Booked <= capacity
[ ] Lịch trình thuộc đúng departure
[ ] Departure vận hành độc lập
[ ] Không để booking vượt capacity
[ ] Không cho sửa state trái business rule
```

Nếu enum departure chưa được backend chốt, QA không tự coi các state minh họa trong File 05 là enum final.

---

# 33. Guide Assignment Test Matrix

```text
[ ] Assign HDV hợp lệ
[ ] HDV tồn tại
[ ] HDV active
[ ] Đúng scope Ban
[ ] Không conflict lịch nếu rule yêu cầu
[ ] Replace HDV đúng quyền
[ ] HDV chỉ thấy tour được phân công
[ ] HDV không tự xem dữ liệu nội bộ ngoài scope
```

---

# 34. Booking Test Matrix

## Functional

```text
[ ] Customer chọn departure
[ ] Nhập passenger
[ ] Tạo booking
[ ] Snapshot giá
[ ] Booking status đúng
[ ] Payment status tách riêng
```

## Boundary

```text
[ ] 1 người
[ ] Nhiều người
[ ] Đúng capacity
[ ] Vượt capacity
[ ] Departure hết chỗ
[ ] Departure không còn mở bán
```

## Ownership

```text
[ ] Customer xem booking mình
[ ] Customer không xem booking người khác
[ ] Customer không sửa booking người khác
```

## Concurrency

```text
Capacity = 1
Request A + Request B đồng thời
→ chỉ 1 success
→ 1 request conflict/fail
→ capacity không vượt giới hạn
```

---

# 35. Payment Test Matrix

```text
[ ] Payment hợp lệ
[ ] Payment thất bại
[ ] Amount mismatch
[ ] Booking không tồn tại
[ ] Booking không đúng state
[ ] Callback thành công
[ ] Callback lặp lại
[ ] Callback giả
[ ] Transaction rollback
[ ] DOI_SOAT_GIAO_DICH được ghi đúng
[ ] Không cập nhật booking thành paid nếu callback không hợp lệ
```

### Idempotency

```text
Same transaction callback x2
→ chỉ ghi nhận thành công một lần
```

---

# 36. Cancellation / Refund Test Matrix

```text
[ ] Booking đủ điều kiện hủy
[ ] Booking không đủ điều kiện hủy
[ ] Sai thời gian hủy
[ ] Tính phí hủy đúng rule
[ ] Tính refund đúng rule
[ ] Refund không vượt số tiền được phép
[ ] Không refund hai lần
[ ] Không refund booking không hợp lệ
[ ] Status booking/payment/refund nhất quán
```

---

# 37. Custom Tour Test Matrix

```text
[ ] Customer tạo request
[ ] Request được tiếp nhận
[ ] Phân công đúng Ban
[ ] Department xử lý đúng scope
[ ] Guide/proposal được ghi nhận
[ ] Tạo quotation
[ ] Customer xem quotation
[ ] Customer confirm
[ ] Customer reject
[ ] Tạo Tour + Departure sau khi đủ điều kiện
[ ] Không tạo dữ liệu một phần khi transaction fail
```

State cuối cùng phải khớp File 05/backend enum.

---

# 38. Budget / Expense Test Matrix

```text
[ ] Tạo ngân sách cho departure
[ ] Không vượt rule ngân sách
[ ] Tạo expense
[ ] Amount >= 0
[ ] Upload chứng từ nếu cần
[ ] Duyệt expense đúng quyền
[ ] Sai scope bị từ chối
[ ] DB consistency
```

---

# 39. Incident Test Matrix

```text
[ ] HDV tạo incident cho tour được phân công
[ ] Upload evidence nếu có
[ ] Manager nhận incident
[ ] Manager xử lý
[ ] Incident ảnh hưởng lịch trình
[ ] Customer được thông báo khi booking bị ảnh hưởng
[ ] Audit action
```

---

# 40. Schedule Change Test Matrix

```text
[ ] Tạo yêu cầu thay đổi
[ ] Kiểm tra departure
[ ] Kiểm tra booking bị ảnh hưởng
[ ] Gửi phản hồi khách nếu cần
[ ] Customer approve/reject theo flow
[ ] Update lịch đúng transaction
[ ] Audit
[ ] Notification
```

---

# 41. Review / Favorite / Notification / Contact

## Review

```text
[ ] Chỉ user đủ điều kiện review
[ ] Rating 1–5
[ ] Không review duplicate nếu rule không cho phép
[ ] Review gắn đúng booking/tour
```

## Favorite

```text
[ ] Add favorite
[ ] Remove favorite
[ ] Không duplicate favorite
[ ] Chỉ thao tác favorite của mình
```

## Notification

```text
[ ] Đúng người nhận
[ ] Đúng event
[ ] Read/unread
[ ] Không leak notification người khác
```

## Contact

```text
[ ] Customer gửi liên hệ
[ ] Nhân sự có quyền xem
[ ] Trạng thái xử lý đúng
[ ] Audit nếu nghiệp vụ yêu cầu
```

---

# 42. Transaction Test Matrix

Các nghiệp vụ bắt buộc kiểm tra rollback:

| Transaction | Thành phần |
|---|---|
| Register | `TAI_KHOAN + KHACH_HANG + ROLE` |
| Create employee | `TAI_KHOAN + NHAN_VIEN + ROLE + ROLE HISTORY` |
| Booking | `BOOKING + HANH_KHACH + capacity` |
| Payment | `THANH_TOAN + BOOKING + DOI_SOAT_GIAO_DICH` |
| Refund | `HOAN_TIEN + booking/payment status` |
| Role change | `TAI_KHOAN_VAI_TRO + LICH_SU_VAI_TRO` |
| Custom tour confirm | Request/quotation + Tour/Departure theo flow |

Test nguyên tắc:

```text
Step A success
Step B success
Step C fail
→ A + B phải rollback nếu cùng transaction
```

---

# 43. Database Integrity Test

Kiểm tra:

```text
[ ] Primary Key
[ ] Foreign Key
[ ] Unique
[ ] CHECK constraint
[ ] NULL / NOT NULL
[ ] Numeric boundary
[ ] Date boundary
[ ] Duplicate
[ ] Orphan record
[ ] Cascade / Restrict đúng thiết kế
```

Một số constraint quan trọng trong database:

```text
TOUR.so_ngay > 0
TOUR.so_dem >= 0
TOUR.gia_nguoi_lon >= 0

DOT_KHOI_HANH.so_cho_toi_da > 0
DOT_KHOI_HANH.so_cho_da_dat >= 0
DOT_KHOI_HANH.so_cho_da_dat <= so_cho_toi_da

BOOKING.tong_so_nguoi > 0
DANH_GIA_TOUR.so_sao BETWEEN 1 AND 5
QUY_TAC_HUY.phan_tram_hoan BETWEEN 0 AND 100
CHI_PHI.so_tien >= 0
```

---

# 44. State Transition Test Matrix

Mọi state machine phải test ba nhóm:

```text
1. Transition hợp lệ
2. Transition không hợp lệ
3. Actor không có quyền transition
```

Ví dụ Tour:

| Current | Action | Expected |
|---|---|---|
| `NHAP` | Submit | `CHO_DUYET` |
| `CHO_DUYET` | Approve | `DA_DUYET` |
| `CHO_DUYET` | Reject | `TU_CHOI` |
| `TU_CHOI` | Edit / resubmit theo flow | `NHAP` / flow tương ứng |
| State khác | Action không hợp lệ | Reject |

Backend là nguồn quyết định state cuối cùng.

---

# 45. Audit Test Matrix

Các action quan trọng phải được xem xét ghi `NHAT_KY_HE_THONG`:

```text
Login / security event nếu thiết kế yêu cầu
Role change
Account lock/deactivate
Tour approve/reject/publish/stop-selling
Booking action quan trọng
Payment
Refund
Expense approval
Incident handling
Schedule change
Custom tour approval/confirmation
```

QA kiểm tra:

```text
Actor
Action
Resource
Time
Result
```

---

# 46. Notification Test Matrix

Notification phải gắn với event nghiệp vụ, ví dụ:

```text
Tour approved
Tour rejected
Booking created
Payment success/failure
Booking cancelled
Refund processed
Schedule changed
Incident affects booking
Custom tour quotation ready
Custom tour confirmed
```

Kiểm tra:

```text
[ ] Đúng recipient
[ ] Đúng nội dung
[ ] Đúng thời điểm
[ ] Không gửi nhầm user
[ ] Read/unread đúng
```

---

# 47. Critical Regression Set

Trước mỗi release phải chạy tối thiểu:

```text
REG-01 Register
REG-02 Login
REG-03 Refresh token
REG-04 Tour list
REG-05 Tour detail
REG-06 Departure selection
REG-07 Booking
REG-08 Passenger
REG-09 Payment
REG-10 Booking detail
REG-11 Cancellation
REG-12 Refund
REG-13 Admin account
REG-14 Role permission
REG-15 Master data
REG-16 Tour approval
REG-17 Departure
REG-18 Guide assignment
REG-19 Tour progress
REG-20 Incident
REG-21 Custom tour
REG-22 Quotation confirmation
REG-23 Review
REG-24 Favorite
REG-25 Notification
REG-26 Audit
```

---

# 48. Traceability Matrix

Mỗi chức năng quan trọng phải trace được:

| Page | Function | API | Role | Permission | DB | Rule | State | QA |
|---|---|---|---|---|---|---|---|---|
| `DPVWEBUserDanhSachTour` | List tour | `GET /api/tours` | Public | `PUBLIC` | `TOUR` | Chỉ tour phù hợp điều kiện công khai | — | Filter / pagination |
| `DPVWEBUserDatTour` | Booking | `POST /api/bookings` | KHACH_HANG | `AUTHENTICATED/BOOKING_CREATE` | `BOOKING`, `HANH_KHACH`, `DOT_KHOI_HANH` | Atomic capacity | Booking state | Concurrency |
| `DPVWEBUserThanhToan` | Payment | Payment API | KHACH_HANG | Owner | `THANH_TOAN`, `BOOKING`, `DOI_SOAT_GIAO_DICH` | Amount verified | Payment state | Idempotency |
| `DPVDESKAdminQuanLyTaiKhoan` | Role change | Role API | ADMIN | `ROLE_MANAGE` | `TAI_KHOAN_VAI_TRO`, `LICH_SU_VAI_TRO` | Audit | — | Permission |
| `DPVDESKManagerQuanLyTour` | Submit tour | Tour API | QUAN_LY_TONG | Tour permission/scope | `TOUR` | Valid data | `NHAP → CHO_DUYET` | State test |

> Matrix này phải được mở rộng khi team thêm chức năng/API mới.

---

# 49. QA Definition of Done

Một chức năng chỉ được xem là hoàn thành khi:

```text
[ ] UI hoàn thành
[ ] Function đúng spec
[ ] API đúng contract
[ ] Permission đúng
[ ] Ownership đúng
[ ] Department Scope đúng
[ ] Validation đúng
[ ] Business Rule đúng
[ ] State transition đúng
[ ] DB data đúng
[ ] Transaction đúng
[ ] Error handling đúng
[ ] Loading / Empty / Error / Success có xử lý
[ ] Security test pass
[ ] Boundary test pass
[ ] Concurrency test nếu cần
[ ] Regression test pass
[ ] Audit / Notification nếu có yêu cầu
```

---

# 50. Release Checklist

## Backend

```text
[ ] DB migration / SQL verified
[ ] Entity mapping
[ ] DTO
[ ] Controller
[ ] Service
[ ] Repository
[ ] Authorization
[ ] Validation
[ ] Business rules
[ ] Transaction
[ ] Error handling
[ ] Swagger
[ ] Logging
[ ] API tests
```

## Frontend

```text
[ ] Page
[ ] Route
[ ] API service
[ ] Request mapping
[ ] Response mapping
[ ] Loading
[ ] Empty
[ ] Error
[ ] Success
[ ] Permission UI
[ ] Form validation
[ ] Navigation
[ ] Auth refresh
```

## QA

```text
[ ] Functional
[ ] API
[ ] Permission
[ ] Ownership
[ ] Scope
[ ] Boundary
[ ] Concurrency
[ ] Transaction
[ ] Security
[ ] DB consistency
[ ] Regression
```

---

# 51. Rules không được phá vỡ

```text
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
21. Backend là nguồn quyết định state
22. Payment status và Booking status tách riêng
23. API là contract giữa FE và BE
24. Không tự ý thay đổi endpoint/field/status mà không cập nhật tài liệu
```

---

# 52. Cách sử dụng File 06 cùng 5 file còn lại

```text
01 DATABASE / ERD
→ Dữ liệu nào tồn tại?

02 DEVELOPER / API HANDOFF
→ API và backend/business rule thế nào?

03 UX/UI MASTER SPEC
→ Thiết kế màn hình nào?

04 USER & FUNCTION SPEC
→ Ai làm gì, ở đâu, bằng cách nào?

05 FLOW / STATE SPEC
→ Nghiệp vụ chuyển trạng thái ra sao?

06 QA / PERMISSION / API CONTRACT
→ Ai được làm, contract cụ thể là gì và kiểm thử thế nào?
```

Luồng triển khai:

```text
DATABASE
   ↓
BUSINESS RULE
   ↓
API CONTRACT
   ↓
USER & FUNCTION
   ↓
FLOW / STATE
   ↓
UX/UI
   ↓
FE + BE
   ↓
QA
```

---

# 53. Khi nghiệp vụ thay đổi

Không sửa riêng một file.

Quy trình:

```text
Xác định thay đổi
        ↓
File 01 nếu DB thay đổi
        ↓
File 02 nếu API / backend thay đổi
        ↓
File 03 nếu UI thay đổi
        ↓
File 04 nếu role / function thay đổi
        ↓
File 05 nếu flow / state thay đổi
        ↓
File 06 nếu permission / contract / test thay đổi
        ↓
Regression Test
```

Sau thay đổi phải tìm lại các điểm liên quan để tránh contract lệch giữa các file.

---

# 54. Thứ tự triển khai đề xuất

## Phase 1 — Core

```text
AUTH
→ ACCOUNT
→ CUSTOMER
→ MASTER DATA
→ TOUR
→ DEPARTURE
```

## Phase 2 — Selling

```text
BOOKING
→ PASSENGER
→ PAYMENT MOCK
→ CANCELLATION
→ REFUND
```

## Phase 3 — Internal

```text
EMPLOYEE
→ DEPARTMENT
→ GUIDE ASSIGNMENT
→ TOUR PROGRESS
```

## Phase 4 — Custom Tour

```text
CUSTOM TOUR
→ Department processing
→ Guide proposal
→ Quotation
→ Customer confirmation
→ Dedicated TOUR + DEPARTURE
```

## Phase 5 — Operation

```text
BUDGET
→ EXPENSE
→ INCIDENT
→ SCHEDULE CHANGE
```

## Phase 6 — Supporting

```text
REVIEW
→ FAVORITE
→ NOTIFICATION
→ REPORT
→ AUDIT
→ CONTACT
```

---

# 55. Tình trạng contract và nguyên tắc Freeze

Trước khi team bắt đầu code toàn bộ, cần thực hiện một vòng **Consistency Check** trên 6 file.

Đặc biệt kiểm tra:

```text
[ ] Tên table
[ ] Tên column
[ ] Tên role
[ ] Tên permission
[ ] Tên page
[ ] Tên function
[ ] Endpoint
[ ] HTTP method
[ ] Request field
[ ] Response field
[ ] Enum / state
[ ] Permission
[ ] Ownership
[ ] Department Scope
[ ] Transaction
[ ] Notification
[ ] Audit
```

Các điểm chưa được DB/API chốt rõ mới được đánh dấu:

```text
TBD — TO BE DEFINED
```

Không tự biến nội dung minh họa thành contract final. Các state đã freeze trong File 05 không còn là TBD.

---

# 56. Kết luận

Bộ tài liệu cuối cùng của DPV TourDuLich gồm **6 file lõi**:

```text
01 — DATABASE / ERD
02 — DEVELOPER / API HANDOFF
03 — UX/UI MASTER SPEC
04 — USER & FUNCTION SPEC
05 — FLOW / STATE SPEC
06 — QA / PERMISSION / API CONTRACT
```

File 06 đóng vai trò lớp kiểm soát cuối giữa:

```text
ROLE
↔ PERMISSION
↔ API
↔ DATABASE
↔ STATE
↔ TEST
```

Mục tiêu cuối cùng:

```text
Designer
→ biết thiết kế gì

Frontend
→ biết build gì và gọi API nào

Backend
→ biết contract nào phải giữ

QA
→ biết phải test gì

BA/PM
→ biết điểm nào cần cập nhật khi nghiệp vụ thay đổi
```

**END OF FILE 06**
