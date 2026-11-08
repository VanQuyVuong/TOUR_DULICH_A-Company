# KẾ HOẠCH TRIỂN KHAI ROLE KHÁCH HÀNG

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `KHACH_HANG`
- **Nền tảng:** Web + Mobile
- **Số page được liệt kê trong Role → Page Matrix:** **26** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Khám phá/tìm kiếm tour; xem chi tiết tour và departure; yêu thích; tạo booking và hành khách; thanh toán Mock Payment; xem kết quả; xem danh sách/chi tiết booking; yêu cầu hủy và theo dõi refund; tạo/theo dõi yêu cầu tour riêng và báo giá; xem/sửa hồ sơ. Phần đăng ký/đăng nhập nằm trong module Auth dùng chung.

## 2. Danh sách trang

- `DPVWEBUserTrangChu`
- `DPVWEBUserDanhSachTour`
- `DPVWEBUserChiTietTour`
- `DPVWEBUserDatTour`
- `DPVWEBUserThanhToan`
- `DPVWEBUserKetQuaDatTour`
- `DPVWEBUserDonDatCuaToi`
- `DPVWEBUserChiTietDonDat`
- `DPVWEBUserYeuCauHuyTour`
- `DPVWEBUserYeuCauTourRieng`
- `DPVWEBUserYeuCauTourRiengCuaToi`
- `DPVWEBUserThongTinCaNhan`
- `DPVWEBUserDoiMatKhau`
- `DPVMOBUserTrangChu`
- `DPVMOBUserDanhSachTour`
- `DPVMOBUserChiTietTour`
- `DPVMOBUserDatTour`
- `DPVMOBUserThanhToan`
- `DPVMOBUserKetQuaDatTour`
- `DPVMOBUserDonDatCuaToi`
- `DPVMOBUserChiTietDonDat`
- `DPVMOBUserYeuCauHuyTour`
- `DPVMOBUserYeuCauTourRieng`
- `DPVMOBUserYeuCauTourRiengCuaToi`
- `DPVMOBUserThongTinCaNhan`
- `DPVMOBUserDoiMatKhau`

## 3. API liên quan trong contract hiện có

- `GET /api/tours`
- `GET /api/tours/{tourId}`
- `POST /api/bookings`
- `POST /api/bookings/{bookingId}/payments`
- `GET /api/bookings/{bookingId}/payments/{paymentId}`
- `GET /api/customers/me/bookings`
- `GET /api/customers/me/bookings/{bookingId}`
- `GET /api/customers/me/bookings/{bookingId}/passengers`
- `PUT /api/customers/me/bookings/{bookingId}/passengers/{passengerId}`
- `POST /api/bookings/{bookingId}/cancel`
- `GET /api/customers/me`
- `PUT /api/customers/me`
- `POST /api/custom-tour-requests`
- `GET /api/custom-tour-requests/me`
- `GET /api/custom-tour-quotations/{id}`
- `POST /api/custom-tour-quotations/{id}/confirm`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## API bổ sung trong Developer Handoff

- `GET /api/bookings/{bookingId}/cancellation-policy`
- `GET /api/bookings/{bookingId}/cancellation`
- `GET /api/bookings/{bookingId}/refund`
- `POST /api/bookings/{bookingId}/refund`
- `GET /api/bookings/{bookingId}/payments`
- `GET /api/payments/{paymentId}`
- `POST /api/bookings/{bookingId}/review`
- `GET /api/tours/{tourId}/reviews`
- `GET /api/customers/me/reviews`
- `GET /api/customers/me/favorites`
- `POST /api/customers/me/favorites/{tourId}`
- `DELETE /api/customers/me/favorites/{tourId}`
- `GET /api/notifications`
- `GET /api/notifications/unread-count`
- `PUT /api/notifications/{id}/read`
- `PUT /api/notifications/read-all`
- `GET /api/customers/me/bookings/{bookingId}/schedule-changes`
- `POST /api/customers/me/bookings/{bookingId}/schedule-changes/{id}/accept`
- `POST /api/customers/me/bookings/{bookingId}/schedule-changes/{id}/reject`

## 4. Backend/module cần triển khai

- `TourController` / `TourService` (đọc public tour & details)
- `BookingController` / `BookingService` (atomic transaction, khóa/kiểm tra sức chứa)
- `PaymentController` / `PaymentService` (Mock Payment; không tin trạng thái do FE gửi)
- `Cancellation/Refund` service theo policy/state contract
- `CustomerController` / `CustomerService` (chỉ profile của JWT user)
- `CustomTourRequest` và `Quotation` service
- FE services/API client + route guards + form validation

## 5. Bảng dữ liệu liên quan

`KHACH_HANG`, `TAI_KHOAN`, `TAI_KHOAN_VAI_TRO`, `TOUR`, `TOUR_DIA_DIEM`, `DOT_KHOI_HANH`, `LICH_TRINH`, `BOOKING`, `HANH_KHACH`, `THANH_TOAN`, `HUY_BOOKING`, `HOAN_TIEN`, `CHINH_SACH_HUY`, `QUY_TAC_HUY`, `YEU_CAU_TOUR_RIENG`, `YEU_CAU_TOUR_DIA_DIEM`, `BAO_GIA_TOUR_RIENG`, `CHI_TIET_BAO_GIA`, `TOUR_TU_YEU_CAU`, `TOUR_YEU_THICH`, `DANH_GIA_TOUR`, `THONG_BAO`

## 6. Phụ thuộc

- SETUP + Database + Auth trước khi tích hợp endpoint cần đăng nhập.
- Tour/master data có thể phát triển song song với Mock Data.
- Booking phụ thuộc Departure/availability.
- Payment phụ thuộc Booking.
- Cancellation/refund phụ thuộc Booking + policy + Payment.
- Custom Tour phụ thuộc Department/Manager/Department Manager workflow.

## 7. Tiêu chí nghiệm thu (Acceptance Criteria)

- [ ] Tất cả trang trong phạm vi role được implement hoặc ghi rõ lý do chưa làm.
- [ ] Mọi action trên trang gọi đúng API contract đã chốt.
- [ ] Backend kiểm tra role, permission, ownership và department scope phù hợp.
- [ ] Trạng thái và chuyển trạng thái khớp File 05; FE không tự quyết định trạng thái cuối.
- [ ] Loading, empty, validation error, server error và success state được xử lý.
- [ ] Unit/integration tests cho nghiệp vụ BE liên quan đã chạy qua.
- [ ] E2E smoke test cho luồng chính đã chạy qua khi FE tích hợp.
- [ ] Không trả password/hash/token bí mật hoặc dữ liệu ngoài phạm vi quyền.
- [ ] Cập nhật master tracker và ghi commit/PR liên quan.

## 8. Definition of Done

Chỉ đổi trạng thái task thành `DONE` khi tiêu chí nghiệm thu đạt, test có bằng chứng, code đã review/merge theo quy tắc nhóm. Nếu thiếu API/schema/nghiệp vụ trong tài liệu, đánh dấu `BLOCKED` và nêu câu hỏi; không tự bịa.

## 9. Ghi chú

Page matrix có 13 trang WEB + 13 trang MOBILE = 26 trang KHACH_HANG. Cùng một nghiệp vụ có thể dùng chung contract nhưng phải kiểm tra layout responsive/mobile.
