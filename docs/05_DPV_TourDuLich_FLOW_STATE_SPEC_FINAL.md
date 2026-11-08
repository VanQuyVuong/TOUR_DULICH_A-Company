# DPV TourDuLich --- FLOW / STATE SPECIFICATION

**Version:** 1.0\
**System:** DPV TourDuLich\
**Document:** File 05 --- Flow / State Specification\
**Audience:** BA/PM, Backend, Frontend, Designer, QA/Tester

------------------------------------------------------------------------

## 1. Mục đích

File 05 chuẩn hóa **luồng nghiệp vụ (Flow)** và **trạng thái (State)**
của DPV TourDuLich để BA, BE, FE, Designer và QA hiểu cùng một contract.

Luồng chuẩn:

``` text
ROLE → PAGE → FUNCTION → ACTION → CONDITION → PERMISSION
→ API → DATABASE → STATE TRANSITION → RESULT → NEXT PAGE/STATE → TEST
```

Tài liệu này bổ sung cho:

-   File 01 --- Database / ERD
-   File 02 --- Developer / API Handoff
-   File 03 --- UX/UI Master Spec
-   File 04 --- User & Function Spec

File 05 tập trung trả lời: nghiệp vụ bắt đầu ở đâu, ai thực hiện, điều
kiện nào, state hiện tại là gì, action nào được phép, state sau action
là gì, DB nào thay đổi, lỗi xử lý thế nào và người dùng đi đâu tiếp
theo.

------------------------------------------------------------------------

## 2. Nguyên tắc Flow / State

### 2.1 Backend là nguồn quyết định state

FE chỉ hiển thị và gọi API. BE phải quyết định:

``` text
Authentication
→ Permission
→ Ownership
→ Department Scope
→ State
→ Business Rule
→ Transaction
→ Database
→ Final State
```

Không được để FE tự quyết định trạng thái cuối cùng.

### 2.2 State transition luôn có điều kiện

``` text
CURRENT STATE
+ ACTOR
+ PERMISSION
+ CONDITION
+ ACTION
→ NEXT STATE
```

Ví dụ:

``` text
TOUR = NHAP
+ Manager có quyền
+ dữ liệu hợp lệ
+ Submit
→ CHO_DUYET
```

### 2.3 Transaction

Các nghiệp vụ nhiều bảng phải transaction. Nếu một bước thất bại thì
rollback toàn bộ; không được tạo dữ liệu một phần.

------------------------------------------------------------------------

# 3. AUTHENTICATION FLOWS

## 3.1 Đăng ký

``` text
Trang đăng ký
→ nhập họ tên/email/số điện thoại/mật khẩu
→ POST /api/auth/register
→ validate
→ TAI_KHOAN
→ KHACH_HANG
→ TAI_KHOAN_VAI_TRO = KHACH_HANG
→ COMMIT
→ Đăng ký thành công
→ Login
```

Transaction gồm account + customer + role. Email không được trùng. Mật
khẩu phải được BCrypt; không lưu plaintext.

Nếu lỗi ở bất kỳ bước nào: `ROLLBACK`.

## 3.2 Đăng nhập

``` text
Login
→ POST /api/auth/login
→ tìm account
→ kiểm tra active/lock
→ BCrypt verify
→ lấy role
→ access token
→ refresh session
→ /api/auth/me
→ điều hướng theo role
```

Refresh session nằm trong `PHIEN_DANG_NHAP`. Không trả password/hash.

## 3.3 Refresh token

``` text
Access token hết hạn
→ POST /api/auth/refresh-token
→ validate session/token/expiry/logout
→ cấp access token mới
→ retry request
```

Nếu refresh thất bại: clear auth state → Login.

## 3.4 Logout

``` text
POST /api/auth/logout
→ invalidate refresh session
→ FE clear auth
→ Login/Home
```

Không chỉ xóa token phía FE.

## 3.5 Quên/đặt lại mật khẩu

``` text
Forgot password
→ tạo reset token hash
→ gửi hướng dẫn
→ Reset password
→ validate token + expiry + single-use
→ BCrypt password mới
→ mark token used
→ có thể invalidate session cũ
```

Không tiết lộ email có tồn tại hay không. Token reset dùng một lần.

------------------------------------------------------------------------

# 4. ACCOUNT / ROLE FLOW

## 4.1 Tạo account nhân viên

``` text
ADMIN
→ Create account
→ TAI_KHOAN
→ NHAN_VIEN
→ TAI_KHOAN_VAI_TRO
→ LICH_SU_VAI_TRO
→ COMMIT
```

## 4.2 Đổi role

``` text
ADMIN
→ chọn account
→ chọn role
→ validate
→ update TAI_KHOAN_VAI_TRO
→ insert LICH_SU_VAI_TRO
→ COMMIT
```

Role change bắt buộc có history.

## 4.3 Lock / unlock / deactivate

Lock phải invalidate session. Account inactive/locked không được đăng
nhập hoặc thực hiện nghiệp vụ cần account active.

------------------------------------------------------------------------

# 5. TOUR STATE MACHINE

Lifecycle chuẩn:

``` text
NHAP
  ↓
CHO_DUYET
  ↓
DA_DUYET
  ↓
CONG_KHAI
  ↓
NGUNG_BAN
```

Nhánh từ chối:

``` text
CHO_DUYET
  ↓
TU_CHOI
  ↓
NHAP
```

Ý nghĩa:

  State         Ý nghĩa
  ------------- ------------------------------
  `NHAP`        Tour đang tạo/chỉnh sửa
  `CHO_DUYET`   Đã gửi Admin duyệt
  `DA_DUYET`    Admin đã duyệt
  `TU_CHOI`     Admin từ chối; cần chỉnh sửa
  `CONG_KHAI`   Tour được phép hiển thị bán
  `NGUNG_BAN`   Không nhận booking mới

`LOAI_TOUR` là master data, **không phải lifecycle status**.

## 5.1 Tạo tour

``` text
Manager
→ nhập thông tin
→ chọn LOAI_TOUR
→ chọn địa điểm
→ Save
→ TOUR = NHAP
```

DB: `TOUR`, `TOUR_DIA_DIEM`.

## 5.2 Gửi duyệt

Điều kiện: `TOUR = NHAP`, đúng permission, dữ liệu bắt buộc hợp lệ.

``` text
Submit
→ POST /api/manager/tours/{tourId}/submit
→ CHO_DUYET
→ audit
→ notification Admin
```

## 5.3 Admin duyệt

``` text
CHO_DUYET + ADMIN + Approve
→ DA_DUYET
```

## 5.4 Admin từ chối

``` text
CHO_DUYET + ADMIN + lý do
→ TU_CHOI
→ lưu lý do
→ notification Manager
```

Sau đó:

``` text
TU_CHOI → NHAP
```

để sửa và gửi lại.

## 5.5 Publish / Stop selling

``` text
DA_DUYET + Publish → CONG_KHAI
CONG_KHAI + Stop selling → NGUNG_BAN
```

Không hard-delete tour có dữ liệu liên quan.

------------------------------------------------------------------------

# 6. TOUR ≠ DEPARTURE

Đây là rule bắt buộc:

``` text
TOUR
= sản phẩm / nội dung tour

DOT_KHOI_HANH
= một lần khởi hành cụ thể
```

Một TOUR có nhiều departure. Mỗi departure có dữ liệu vận hành độc lập:
thời gian, capacity, giá bán thực tế, state và itinerary.

Ví dụ:

``` text
Tour Đà Nẵng → Bangkok 4N3Đ
├─ Departure 10/10
├─ Departure 20/10
└─ Departure 05/11
```

------------------------------------------------------------------------

# 7. DEPARTURE FLOW

## 7.1 Tạo departure

Preconditions:

-   Tour tồn tại.
-   User có quyền.
-   Tour ở trạng thái cho phép.
-   Ngày đi/về hợp lệ.
-   Capacity \> 0.
-   Giá \> 0.

``` text
Manager
→ Create Departure
→ nhập ngày/capacity/giá
→ tạo DOT_KHOI_HANH
```

Giá departure là giá dùng để tính booking.

## 7.2 Departure state

### FINAL — Departure State Contract

Bộ state chính thức dùng thống nhất cho DB/API/BE/FE/QA:

``` text
MOI_TAO
  ↓
MO_DANG_KY
  ├──────────────→ DA_DAY  (tự động khi số chỗ đã đặt = sức chứa)
  │                   │
  │                   └────→ DA_KHOI_HANH (đến thời điểm khởi hành)
  ↓
DONG_DANG_KY
  ↓
DA_KHOI_HANH
  ↓
DANG_DI
  ↓
DA_HOAN_THANH
```

Nhánh hủy trước khi khởi hành:

``` text
MOI_TAO / MO_DANG_KY / DA_DAY / DONG_DANG_KY
→ DA_HUY
```

Quy tắc:
- `MOI_TAO`: departure vừa được tạo, chưa mở bán.
- `MO_DANG_KY`: đang nhận booking.
- `DA_DAY`: đã đủ chỗ; không nhận booking mới.
- `DONG_DANG_KY`: đã đóng đăng ký theo nghiệp vụ/thời hạn; không nhận booking mới.
- `DA_KHOI_HANH`: đã tới thời điểm khởi hành; khóa booking mới.
- `DANG_DI`: tour đang diễn ra.
- `DA_HOAN_THANH`: tour đã kết thúc.
- `DA_HUY`: departure bị hủy; phải xử lý booking/refund bị ảnh hưởng theo policy.

Không tạo thêm tên enum departure khác trong FE/BE/QA.

## 7.3 Mở/đóng đăng ký

``` text
MOI_TAO → MO_DANG_KY
MO_DANG_KY → DONG_DANG_KY
```

Lý do đóng có thể là đủ khách, đến hạn chốt hoặc nghiệp vụ khác theo
contract.

## 7.4 Hủy departure

``` text
Manager/Admin
→ Cancel
→ validate
→ HUY_DOT_KHOI_HANH
→ xử lý booking/refund affected theo policy
→ DA_HUY
→ notification khách
```

Không chỉ đổi state mà bỏ qua booking/refund.

------------------------------------------------------------------------

# 8. ITINERARY FLOW

`LICH_TRINH` gắn với `DOT_KHOI_HANH`.

``` text
Departure A → Itinerary A
Departure B → Itinerary B
```

Khi thay đổi lịch trình ảnh hưởng khách:

``` text
Đề xuất thay đổi
→ THAY_DOI_LICH_TRINH
→ xác định booking affected
→ gửi phản hồi nếu cần
→ PHAN_HOI_THAY_DOI
```

Không sửa âm thầm lịch trình đã có tác động tới khách.

------------------------------------------------------------------------

# 9. GUIDE ASSIGNMENT FLOW

Preconditions:

``` text
Departure tồn tại
+ HDV active
+ có role HDV
+ đúng Department scope
+ không conflict lịch
+ specialization/language phù hợp nếu rule yêu cầu
```

Flow:

``` text
Manager
→ Available Guides
→ chọn HDV
→ chọn HDV_CHINH / HDV_PHU
→ POST assignment
→ validate
→ PHAN_CONG_HDV
→ notification HDV
```

Một departure có thể có nhiều HDV nhưng chỉ một `HDV_CHINH`.

Conflict:

``` text
startA <= endB
AND
endA >= startB
```

Nếu conflict không được phép: reject, không tạo assignment.

Thay HDV:

``` text
Manager
→ chọn assignment
→ chọn HDV mới
→ validate
→ update
→ audit
→ notification
```

------------------------------------------------------------------------

# 10. BOOKING FLOW

Flow chuẩn:

``` text
Customer
→ Tour
→ Departure
→ availability
→ nhập hành khách
→ Confirm
→ POST /api/bookings
→ validate
→ lock/check capacity
→ calculate price
→ snapshot price
→ create BOOKING
→ create HANH_KHACH
→ update capacity
→ COMMIT
→ Payment
```

## 10.1 Preconditions

1.  Customer authenticated.
2.  Departure tồn tại.
3.  Departure cho phép booking.
4.  Tour cho phép bán.
5.  Departure chưa quá hạn.
6.  Passenger data hợp lệ.
7.  Capacity đủ.
8.  Giá hợp lệ.

## 10.2 Giá

``` text
TOUR = base/reference price
DOT_KHOI_HANH = actual selling price
BOOKING = snapshot price
```

Giá snapshot không tự đổi khi Manager sửa giá departure sau đó.

## 10.3 Transaction

``` text
BEGIN
→ validate
→ lock/check capacity
→ calculate
→ create BOOKING
→ create HANH_KHACH
→ update capacity
→ COMMIT
```

Lỗi ở bất kỳ bước nào → `ROLLBACK`.

## 10.4 Concurrency

Ví dụ capacity = 1, hai request cùng đặt 1 chỗ:

``` text
Một request thành công
Một request thất bại vì hết chỗ
capacity không vượt maximum
```

Đây là QA critical test.

------------------------------------------------------------------------

# 11. BOOKING STATE MACHINE

Theo contract hiện tại:

``` text
CHO_THANH_TOAN
   ↓
DA_THANH_TOAN
   ↓
DA_XAC_NHAN
   ↓
HOAN_THANH
```

Nhánh hủy:

``` text
CHO_THANH_TOAN → DA_HUY
DA_THANH_TOAN / DA_XAC_NHAN → DA_HUY
```

Nghiệp vụ tiền có thể dẫn tới:

``` text
DA_HUY → HOAN_TIEN
```

`HET_HAN` dùng khi booking/payment chưa hoàn tất trong thời hạn cho
phép.

Không đổi state nếu điều kiện nghiệp vụ chưa đạt.

------------------------------------------------------------------------

# 12. PAYMENT FLOW

Mock payment trước; kiến trúc provider abstraction để sau có thể tích
hợp VNPay/MoMo/ZaloPay/bank transfer.

``` text
Booking
→ Thanh toán
→ tạo THANH_TOAN
→ Mock/provider
→ callback/result
→ verify
→ update THANH_TOAN
→ update BOOKING
→ update DOI_SOAT_GIAO_DICH
→ COMMIT
```

### FINAL — Payment State Contract

Bộ state chính thức:

``` text
CHO_THANH_TOAN
→ DANG_XU_LY
→ THANH_CONG
```

Nhánh lỗi:

``` text
DANG_XU_LY → THAT_BAI
```

Quy tắc:
- `CHO_THANH_TOAN`: giao dịch đã tạo nhưng chưa thanh toán.
- `DANG_XU_LY`: đang chờ provider/callback xử lý.
- `THANH_CONG`: đã verify thành công.
- `THAT_BAI`: provider/callback xác nhận thất bại.
- Không dùng `CHUA_THANH_TOAN` để tránh trùng nghĩa với `CHO_THANH_TOAN`.
- Trạng thái hoàn tiền được quản lý tại `HOAN_TIEN`, không tạo thêm payment state `HOAN_TIEN`.

## 12.1 Callback

Callback phải verify transaction, amount, booking/payment mapping,
provider response và signature nếu provider thật yêu cầu.

Không tin amount do FE gửi.

Callback phải idempotent:

``` text
Callback 1 → success
Callback 2 giống callback 1 → không tạo giao dịch thành công thứ hai
```

------------------------------------------------------------------------

# 13. CANCELLATION FLOW

``` text
Customer
→ Chi tiết booking
→ Yêu cầu hủy
→ kiểm tra CHINH_SACH_HUY + QUY_TAC_HUY
→ tính phí/hoàn dự kiến
→ confirm
→ POST /api/bookings/{bookingId}/cancel
→ HUY_BOOKING
→ update BOOKING
→ refund nếu đủ điều kiện
```

Customer chỉ được hủy booking của chính mình.

Không hard-code mức phí hủy ở FE. Backend tính dựa trên policy và thời
điểm so với departure.

------------------------------------------------------------------------

# 14. REFUND FLOW

Công thức cơ bản:

``` text
Refund = Paid Amount - Cancellation Fee
```

Flow:

``` text
Booking eligible
→ HOAN_TIEN
→ refund provider/mock
→ update payment
→ update booking
→ COMMIT
```

Refund provider thất bại không được đánh dấu thành công giả; phải lưu
trạng thái thực tế để retry/reconcile.

Nếu công ty hủy departure:

``` text
Departure → DA_HUY
→ tìm booking affected
→ company cancellation policy
→ refund
→ notification
```

Không áp dụng máy móc phí hủy của khách.

------------------------------------------------------------------------

# 15. CUSTOM TOUR FLOW

Custom tour không tạo BOOKING ngay từ request đầu tiên.

``` text
Customer Request
→ Manager tiếp nhận
→ Department liên quan
→ Department xử lý
→ đề xuất/điều phối HDV
→ Manager tổng hợp
→ Quotation
→ Customer review
→ Customer confirm
→ tạo TOUR
→ tạo DOT_KHOI_HANH
→ operation
```

DB chính:

``` text
YEU_CAU_TOUR_RIENG
YEU_CAU_TOUR_DIA_DIEM
PHAN_CONG_YEU_CAU_TOUR
BAO_GIA_TOUR_RIENG
CHI_TIET_BAO_GIA
TOUR_TU_YEU_CAU
```

## 15.1 Custom request state

### FINAL — Custom Tour Request State Contract

Bộ state chính thức của `YEU_CAU_TOUR_RIENG`:

``` text
MOI_TAO
→ DA_TIEP_NHAN
→ DANG_XU_LY
→ CHO_BAO_GIA
→ DA_BAO_GIA
→ KHACH_DANG_XEM
→ KHACH_DA_XAC_NHAN
→ HOAN_TAT
```

Nhánh từ chối/hủy:

``` text
KHACH_DANG_XEM → KHACH_TU_CHOI
DA_TIEP_NHAN / DANG_XU_LY / CHO_BAO_GIA → HUY
```

Quy tắc:
- `YEU_CAU_TOUR_RIENG.trang_thai` dùng đúng bộ state trên.
- `PHAN_CONG_YEU_CAU_TOUR.trang_thai` và `BAO_GIA_TOUR_RIENG.trang_thai` là state của bản ghi con, không thay thế state của yêu cầu.
- Khi khách xác nhận báo giá hợp lệ: request → `KHACH_DA_XAC_NHAN`, sau đó hệ thống tạo `TOUR_TU_YEU_CAU` và `DOT_KHOI_HANH`; khi toàn bộ bước tạo tour hoàn tất thì request → `HOAN_TAT`.
- Không tạo thêm enum custom request khác.

## 15.2 Customer request

``` text
Customer
→ nhập thời gian/số khách/địa điểm/yêu cầu
→ POST request
→ YEU_CAU_TOUR_RIENG
→ YEU_CAU_TOUR_DIA_DIEM
→ MOI_TAO
```

## 15.3 Manager receive

``` text
Manager
→ xem request
→ tiếp nhận
→ DA_TIEP_NHAN
→ phân Department
```

## 15.4 Department process

``` text
Department Manager
→ request thuộc scope
→ xem địa điểm/yêu cầu
→ đề xuất HDV
→ PHAN_CONG_YEU_CAU_TOUR
→ trả kết quả Manager
```

## 15.5 Quotation

``` text
Manager
→ tổng hợp
→ BAO_GIA_TOUR_RIENG
→ CHI_TIET_BAO_GIA
→ gửi Customer
→ DA_BAO_GIA / KHACH_DANG_XEM
```

## 15.6 Customer confirm

``` text
Customer
→ xem quotation
→ confirm
→ validate quotation còn hiệu lực
→ KHACH_DA_XAC_NHAN
→ tạo TOUR/TourTuYeuCau
→ tạo Departure
→ operation
```

Quotation hết hạn → không được confirm.

------------------------------------------------------------------------

# 16. TOUR PROGRESS / INCIDENT

## 16.1 Progress

HDV chỉ cập nhật departure được phân công:

``` text
Assigned Guide
→ Tour Detail
→ cập nhật mốc
→ TIEN_TRINH_TOUR
→ upload nếu có
→ HINH_ANH_TIEN_TRINH
```

Progress không tự động cho phép HDV thay đổi business state của booking.

## 16.2 Incident

``` text
HDV
→ Báo sự cố
→ loại/mức độ/mô tả/thời gian
→ SU_CO_TOUR
→ CHUNG_TU_SU_CO
→ notification Manager
```

HDV không tự ý đổi cam kết với khách nếu không có quyền.

Manager xử lý:

``` text
Manager
→ incident detail
→ xử lý
→ update
→ audit
→ notification
```

Nếu ảnh hưởng lịch trình → Schedule Change flow.

------------------------------------------------------------------------

# 17. SCHEDULE CHANGE FLOW

``` text
Manager
→ tạo THAY_DOI_LICH_TRINH
→ xác định booking affected
→ gửi customer
→ PHAN_HOI_THAY_DOI
→ tiếp tục / xử lý hủy-refund theo policy
```

Thay đổi có ảnh hưởng khách phải được ghi nhận.

------------------------------------------------------------------------

# 18. BUDGET / EXPENSE FLOW

## Budget

``` text
Manager
→ chọn Departure
→ NGAN_SACH_DOT
→ CHI_TIET_NGAN_SACH
→ save
```

Ngân sách gắn đúng departure.

## Expense

``` text
Employee/Manager
→ CHI_PHI
→ CHUNG_TU_CHI_PHI
→ submit
→ DUYET_CHI_PHI
→ approve/reject
```

Expense bị reject không được coi là approved expense. Thao tác tiền/chi
phí cần confirmation và audit.

------------------------------------------------------------------------

# 19. REVIEW / FAVORITE / NOTIFICATION / CONTACT

## Review

Điều kiện:

``` text
Customer owner
+ booking = HOAN_THANH
```

Mỗi booking một review theo rule hiện tại.

## Favorite

``` text
Customer → Favorite → TOUR_YEU_THICH
```

Unique customer + tour; không tạo duplicate.

## Notification

Business event → `THONG_BAO` → recipient → unread → user mở → read.

Các event chính: tour approval/rejection, guide assignment, booking,
payment, cancellation, refund, custom quotation/confirmation, incident,
schedule change.

## Contact

``` text
Guest/Customer
→ Contact
→ POST /api/contact
→ LIEN_HE
→ Admin process
```

------------------------------------------------------------------------

# 20. MASTER DATA FLOW

Master data chính:

``` text
QUOC_GIA
TINH_THANH
DIA_DIEM
LOAI_TOUR
NGON_NGU
```

Admin:

``` text
Create → Active
Update → Active
Deactivate → Inactive
```

Master đã được tham chiếu không hard-delete.

------------------------------------------------------------------------

# 21. OWNERSHIP / DEPARTMENT SCOPE

## Ownership

Customer chỉ được truy cập resource của mình.

``` text
booking.khach_hang_id == currentUser.customerId
```

Nếu không thuộc owner: không trả dữ liệu; có thể dùng `404` để hạn chế
resource enumeration theo security contract.

## Department scope

``` text
Current User
→ Employee
→ Department membership
→ Resource scope
```

Trưởng ban không xử lý request ngoài Department nếu permission không cho
phép.

------------------------------------------------------------------------

# 22. PERMISSION DECISION FLOW

Mọi protected API:

``` text
Request
→ Authentication
→ Account active?
→ Role?
→ Permission?
→ Owner?
→ Department scope?
→ Resource exists?
→ State valid?
→ Business validation
→ Execute
```

Không được chỉ kiểm tra role rồi bỏ qua ownership/scope/state.

------------------------------------------------------------------------

# 23. GENERIC ACTION FLOW

Một action quan trọng:

``` text
User click
→ FE basic validation
→ Loading
→ API
→ BE authentication
→ BE permission
→ BE ownership/scope
→ BE state validation
→ business validation
→ transaction
→ DB
→ audit
→ notification nếu cần
→ response
→ FE update
→ next page/state
```

------------------------------------------------------------------------

# 24. UI STATE / ERROR FLOW

Mọi màn hình API cần:

``` text
LOADING
SUCCESS
EMPTY
ERROR
DISABLED
```

HTTP contract:

-   `400`: request/validation sai → giữ form, hiển thị field error.
-   `401`: chưa xác thực/hết access token → refresh nếu có thể, sau đó
    Login.
-   `403`: không có quyền.
-   `404`: resource không tồn tại/không được expose.
-   `409`: conflict như duplicate, capacity, state, assignment.
-   `500`: lỗi hệ thống; không hiển thị stack trace.

------------------------------------------------------------------------

# 25. TRANSACTION FLOW

Các transaction bắt buộc/quan trọng:

  Nghiệp vụ          Transaction
  ------------------ ---------------------------------------------
  Register           TAI_KHOAN + KHACH_HANG + role
  Employee account   TAI_KHOAN + NHAN_VIEN + role + role history
  Booking            BOOKING + HANH_KHACH + capacity
  Payment            THANH_TOAN + BOOKING + DOI_SOAT_GIAO_DICH
  Refund             HOAN_TIEN + payment + booking
  Role change        TAI_KHOAN_VAI_TRO + LICH_SU_VAI_TRO

Transaction failure → rollback.

------------------------------------------------------------------------

# 26. AUDIT FLOW

Các action quan trọng ghi `NHAT_KY_HE_THONG`:

``` text
Login security event
Role change
Account lock/unlock
Department change
Tour create/update/status
Departure create/update/cancel
Guide assignment
Booking
Payment result
Cancellation
Refund
Expense approval
Incident processing
Schedule change
```

Không ghi password/hash/refresh token/reset token vào audit log.

------------------------------------------------------------------------

# 27. END-TO-END FLOWS

## Customer

``` text
Đăng ký
→ Đăng nhập
→ Trang chủ
→ Danh sách tour
→ Chi tiết tour
→ Departure
→ Đặt tour
→ Hành khách
→ Booking
→ Thanh toán
→ Booking xác nhận
→ Theo dõi
→ Hủy/refund nếu đủ điều kiện
→ Hoàn thành
→ Review
```

## Manager

``` text
Login
→ Dashboard
→ Tour
→ Submit
→ Admin approval
→ Publish
→ Departure
→ Itinerary
→ Guide assignment
→ Booking operation
→ Incident/Schedule Change
→ Budget/Expense
→ Report
```

## Admin

``` text
Login
→ Dashboard
→ Account
→ Role/Permission
→ Department
→ Master Data
→ Review tour
→ Approve/Reject
→ Publish
→ Report
→ Audit
```

## Guide

``` text
Login
→ Assigned Tours
→ Detail
→ Passenger/Itinerary
→ Progress
→ Incident nếu có
→ Finish
```

## Custom Tour

``` text
Customer Request
→ Manager
→ Department
→ Guide proposal
→ Manager aggregate
→ Quotation
→ Customer review
→ Confirm
→ Tour
→ Departure
→ Operation
```

------------------------------------------------------------------------

# 28. FLOW MATRIX

  ------------------------------------------------------------------------------------------------------
  Flow        Actor               Start            Action      End                 Main DB
  ----------- ------------------- ---------------- ----------- ------------------- ---------------------
  Register    Guest               chưa có account  Register    account active      TAI_KHOAN, KHACH_HANG

  Login       User                active           Login       authenticated       TAI_KHOAN,
                                                                                   PHIEN_DANG_NHAP

  Submit Tour Manager             NHAP             Submit      CHO_DUYET           TOUR

  Approve     Admin               CHO_DUYET        Approve     DA_DUYET            TOUR
  Tour                                                                             

  Reject Tour Admin               CHO_DUYET        Reject      TU_CHOI             TOUR

  Publish     Admin               DA_DUYET         Publish     CONG_KHAI           TOUR
  Tour                                                                             

  Stop        Admin               CONG_KHAI        Stop        NGUNG_BAN           TOUR
  Selling                                                                          

  Create      Customer            available        Book        CHO_THANH_TOAN      BOOKING, HANH_KHACH,
  Booking                                                                          DOT_KHOI_HANH

  Payment     Customer/Provider   CHO_THANH_TOAN   Pay         DA_THANH_TOAN       THANH_TOAN, BOOKING

  Cancel      Customer            eligible         Cancel      DA_HUY              HUY_BOOKING, BOOKING
  Booking                                                                          

  Refund      System/Staff        eligible         Refund      HOAN_TIEN           HOAN_TIEN,
                                                                                   THANH_TOAN, BOOKING

  Assign      Manager             departure valid  Assign      assigned            PHAN_CONG_HDV
  Guide                                                                            

  Incident    Guide               assigned         Report      incident created    SU_CO_TOUR

  Review      Customer            HOAN_THANH       Review      review created      DANH_GIA_TOUR

  Custom      Customer            new              Submit      MOI_TAO             YEU_CAU_TOUR_RIENG
  Request                                                                          

  Quotation   Manager             processing       Quote       DA_BAO_GIA          BAO_GIA_TOUR_RIENG

  Custom      Customer            quotation valid  Confirm     KHACH_DA_XAC_NHAN   BAO_GIA_TOUR_RIENG,
  Confirm                                                                          TOUR_TU_YEU_CAU
  ------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# 29. STATE INVARIANTS

1.  `TOUR = CONG_KHAI` mới có thể xuất hiện trong public discovery theo
    contract.
2.  Tour public không đồng nghĩa mọi departure còn chỗ.
3.  `capacity_available <= capacity_max` và không âm.
4.  Booking price là snapshot.
5.  Payment success phải được backend xác minh.
6.  Customer A không xem booking của Customer B.
7.  Guide inactive không nhận assignment mới.
8.  Master data đã tham chiếu không hard-delete.
9.  FE không quyết định final state.
10. Callback payment phải idempotent.
11. Transaction lỗi phải rollback.
12. Guide không được nhận assignment conflict.

------------------------------------------------------------------------

# 30. STATE VALIDATION MATRIX

  Resource          Action              Điều kiện
  ----------------- ------------------- -------------------------
  TOUR              Submit              NHAP
  TOUR              Reject              CHO_DUYET
  TOUR              Approve             CHO_DUYET
  TOUR              Publish             DA_DUYET
  TOUR              Stop selling        CONG_KHAI
  BOOKING           Pay                 CHO_THANH_TOAN
  BOOKING           Cancel              State + policy cho phép
  BOOKING           Review              HOAN_THANH
  DEPARTURE         Book                State mở đăng ký
  DEPARTURE         Cancel              State cho phép
  CUSTOM TOUR       Quote               Request đang xử lý
  CUSTOM TOUR       Confirm             Quotation còn hiệu lực
  EXPENSE           Approve             Expense đã submit
  SCHEDULE CHANGE   Customer response   Đang chờ phản hồi

State không hợp lệ → `409 Conflict` hoặc error code theo API contract.

------------------------------------------------------------------------

# 31. NAVIGATION RESULT

FE không tự đoán next state từ text message.

Các kết quả chính:

``` text
Register → Login
Login → Dashboard/Home
Create Booking → Payment
Payment success → Booking Result/Detail
Submit Tour → Tour Detail/List
Approve Tour → Tour Detail/List
Reject Tour → Tour Detail/Edit
Cancel Booking → Booking Detail
Custom Request → My Custom Requests
Quotation Confirm → Request Detail / Tour Detail
```

API response phải cung cấp state/dữ liệu cần để FE quyết định UI tiếp
theo.

------------------------------------------------------------------------

# 32. FE VS BE RESPONSIBILITY

## FE

``` text
Form validation
UI state
Loading
Disable button
Hide/show UI theo quyền đã biết
Navigation
Display backend state
```

## BE

``` text
Authentication
Authorization
Ownership
Department scope
State validation
Business rule
Price calculation
Capacity/concurrency
Transaction
Refund calculation
Audit
Final status
```

> FE hỗ trợ UX; BE quyết định nghiệp vụ.

------------------------------------------------------------------------

# 33. NOTIFICATION TRIGGER MATRIX

  Event                     Recipient
  ------------------------- ---------------------
  Tour submitted            Admin
  Tour approved             Manager
  Tour rejected             Manager
  Guide assigned            Guide
  Booking created           Customer / internal
  Payment success/fail      Customer
  Booking cancelled         Customer / internal
  Refund processed          Customer
  Custom request received   Manager
  Department assigned       Department Manager
  Quotation ready           Customer
  Quotation confirmed       Manager
  Incident reported         Manager
  Schedule changed          Affected customers

------------------------------------------------------------------------

# 34. AUDIT TRIGGER MATRIX

  Action                           Audit
  -------------------------------- -------
  Login/security event             Yes
  Role change                      Yes
  Account lock/unlock              Yes
  Department change                Yes
  Tour create/update/status        Yes
  Departure create/update/cancel   Yes
  Guide assignment                 Yes
  Booking                          Yes
  Payment result                   Yes
  Cancellation                     Yes
  Refund                           Yes
  Expense approval                 Yes
  Incident processing              Yes
  Schedule change                  Yes

Secret data không audit: password, password hash, refresh token, reset
token.

------------------------------------------------------------------------

# 35. QA FLOW TESTING MODEL

Mỗi transition phải test:

``` text
Happy path
Invalid input
401
403
404
Wrong owner
Wrong department
Invalid state
Duplicate
Concurrency
Rollback
Idempotency
Audit
Notification
```

Critical examples:

### Booking concurrency

``` text
Capacity = 1
A đặt 1
B đặt 1
→ chỉ một success
→ một conflict
→ capacity <= max
```

### Payment callback duplicate

``` text
Callback giống nhau 2 lần
→ một payment success
→ không duplicate reconciliation
→ không duplicate state transition
```

### Ownership

``` text
Customer A → Booking B
→ không được leak data
```

### Guide conflict

``` text
Guide A đã assigned Departure A
→ assign vào Departure B bị overlap
→ reject
```

### Tour approval

``` text
TOUR = NHAP
→ Admin Approve
→ reject vì state không hợp lệ
```

------------------------------------------------------------------------

# 36. IMPLEMENTATION ORDER

## Phase 1 --- Core

``` text
AUTH → ACCOUNT → CUSTOMER → MASTER DATA → TOUR → DEPARTURE
```

## Phase 2 --- Booking

``` text
BOOKING → HANH_KHACH → PAYMENT → CANCELLATION → REFUND
```

## Phase 3 --- Internal Operation

``` text
EMPLOYEE → DEPARTMENT → GUIDE → GUIDE ASSIGNMENT → PROGRESS → INCIDENT → SCHEDULE CHANGE
```

## Phase 4 --- Custom Tour

``` text
CUSTOMER REQUEST → MANAGER → DEPARTMENT → GUIDE → QUOTATION → CUSTOMER CONFIRM → TOUR + DEPARTURE
```

## Phase 5 --- Supporting

``` text
BUDGET → EXPENSE → REVIEW → FAVORITE → NOTIFICATION → REPORT → AUDIT → CONTACT
```

------------------------------------------------------------------------

# 37. FLOW DEFINITION OF DONE

Một flow hoàn thành khi:

``` text
[ ] Actor xác định
[ ] Permission xác định
[ ] Preconditions xác định
[ ] Current state xác định
[ ] Action xác định
[ ] API xác định
[ ] Database affected xác định
[ ] Transaction xác định nếu cần
[ ] Next state xác định
[ ] Success result xác định
[ ] Error result xác định
[ ] Next page xác định
[ ] Notification xác định nếu cần
[ ] Audit xác định nếu cần
[ ] QA cases xác định
```

------------------------------------------------------------------------

# 38. MASTER TRACEABILITY

Mọi nghiệp vụ quan trọng phải truy được:

``` text
ROLE
→ PAGE
→ FUNCTION
→ ACTION
→ API
→ SERVICE
→ TABLE
→ STATE
→ NOTIFICATION
→ AUDIT
→ QA TEST
```

Ví dụ Booking:

``` text
KHACH_HANG
→ DPVWEBUserDatTour
→ F-BOOKING-CREATE
→ Confirm Booking
→ POST /api/bookings
→ BookingService
→ BOOKING + HANH_KHACH + DOT_KHOI_HANH
→ CHO_THANH_TOAN
→ Notification
→ Audit
→ Concurrency Test
```

------------------------------------------------------------------------

# 39. RULES KHÔNG ĐƯỢC PHÁ VỠ

``` text
1. TOUR ≠ DOT_KHOI_HANH
2. LOAI_TOUR ≠ TOUR lifecycle status
3. BOOKING ≠ PAYMENT
4. Giá TOUR ≠ Giá DEPARTURE ≠ Snapshot BOOKING
5. Customer chỉ xem dữ liệu của chính mình
6. FE không quyết định permission
7. BE luôn kiểm tra permission
8. BE luôn kiểm tra Department Scope khi nghiệp vụ yêu cầu
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
21. Không cập nhật state chỉ ở FE
22. Callback payment phải được verify và idempotent
23. Transaction thất bại phải rollback
24. Customer không được truy cập booking của người khác
25. Guide không được nhận assignment conflict
```

------------------------------------------------------------------------

# 40. QUAN HỆ GIỮA 5 FILE NỀN

``` text
01 DATABASE / ERD
→ Dữ liệu nào tồn tại?

02 DEVELOPER / API HANDOFF
→ API và business rule thế nào?

03 UX/UI MASTER SPEC
→ Thiết kế màn hình nào?

04 USER & FUNCTION SPEC
→ Ai làm gì, ở đâu, bằng cách nào?

05 FLOW / STATE SPEC
→ Nghiệp vụ chạy như thế nào và state chuyển ra sao?
```

Luồng đồng bộ:

``` text
DATABASE
   ↓
BUSINESS RULE
   ↓
FLOW / STATE
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

Nếu thay đổi state/business flow:

``` text
Update File 05
→ kiểm tra File 02 API
→ kiểm tra File 04 Function
→ kiểm tra File 03 UX/UI
→ cập nhật FE
→ cập nhật QA
```

------------------------------------------------------------------------

# 41. KẾT LUẬN

File 05 là **bản đồ vận hành nghiệp vụ** của DPV TourDuLich.

Nó không thay thế Database, API hay UX/UI; nó kết nối các tài liệu bằng
cách mô tả:

``` text
AI
→ LÀM GÌ
→ KHI NÀO
→ Ở STATE NÀO
→ BẰNG ACTION NÀO
→ API NÀO
→ ĐỔI DỮ LIỆU GÌ
→ SANG STATE NÀO
→ THÔNG BÁO AI
→ GHI AUDIT GÌ
→ TEST NHƯ THẾ NÀO
```

Mọi chức năng mới làm thay đổi business state hoặc business flow nên
được bổ sung vào File 05 trước khi triển khai và sau đó đồng bộ sang
File 02, File 03, File 04 và QA.

**END OF FILE 05**
