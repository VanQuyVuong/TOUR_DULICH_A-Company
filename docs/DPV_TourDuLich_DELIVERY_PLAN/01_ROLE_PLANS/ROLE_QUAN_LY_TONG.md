# KẾ HOẠCH TRIỂN KHAI ROLE QUẢN LÝ TỔNG

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `QUAN_LY_TONG`
- **Nền tảng:** Desktop App
- **Số page được liệt kê trong Role → Page Matrix:** **11** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Dashboard vận hành; tạo/sửa tour và điểm đến; gửi duyệt; quản lý các đợt khởi hành và lịch trình riêng theo departure; xem sức chứa; phân công HDV chính/phụ và kiểm tra lịch; tổng hợp/xử lý yêu cầu tour riêng, tạo báo giá; xử lý sự cố; theo dõi booking vận hành; quản lý ngân sách/chi phí theo scope và contract.

## 2. Danh sách trang

- `DPVDESKManagerTongQuan`
- `DPVDESKManagerQuanLyTour`
- `DPVDESKManagerTaoTour`
- `DPVDESKManagerChiTietTour`
- `DPVDESKManagerQuanLyDotKhoiHanh`
- `DPVDESKManagerTaoDotKhoiHanh`
- `DPVDESKManagerChiTietDotKhoiHanh`
- `DPVDESKManagerPhanCongHDV`
- `DPVDESKManagerQuanLyYeuCauTourRieng`
- `DPVDESKManagerChiTietYeuCauTourRieng`
- `DPVDESKManagerXuLySuCo`

## 3. API liên quan trong contract hiện có

- `GET /api/tours`
- `GET /api/tours/{tourId}`
- `POST /api/manager/tours`
- `PUT /api/manager/tours/{tourId}`
- `POST /api/manager/tours/{tourId}/locations`
- `DELETE /api/manager/tours/{tourId}/locations/{locationId}`
- `POST /api/manager/tours/{tourId}/submit`
- `GET /api/tours/{tourId}/departures`
- `GET /api/departures/{departureId}`
- `POST /api/manager/tours/{tourId}/departures`
- `PUT /api/manager/departures/{departureId}`
- `PUT /api/manager/departures/{departureId}/open`
- `PUT /api/manager/departures/{departureId}/close`
- `PUT /api/manager/departures/{departureId}/cancel`
- `GET /api/departures/{departureId}/availability`
- `GET /api/manager/departures/{departureId}/available-guides`
- `GET /api/manager/departures/{departureId}/guides`
- `POST /api/manager/departures/{departureId}/guides`
- `PUT /api/manager/departures/{departureId}/guides/{employeeId}`
- `DELETE /api/manager/departures/{departureId}/guides/{employeeId}`
- `GET /api/manager/custom-tour-requests`
- `GET /api/manager/custom-tour-requests/{id}`
- `POST /api/manager/custom-tour-requests/{id}/assign-departments`
- `POST /api/manager/custom-tour-requests/{id}/quotation`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## API bổ sung trong Developer Handoff

- `GET /api/manager/bookings`
- `GET /api/manager/bookings/{bookingId}`
- `GET /api/manager/departures/{departureId}/budget`
- `POST /api/manager/departures/{departureId}/budget`
- `PUT /api/manager/departures/{departureId}/budget`
- `POST /api/manager/departures/{departureId}/expenses`
- `GET /api/manager/departures/{departureId}/expenses`
- `GET /api/manager/expenses/{expenseId}`
- `PUT /api/manager/expenses/{expenseId}`
- `POST /api/manager/expenses/{expenseId}/submit`
- `POST /api/manager/expenses/{expenseId}/approve`
- `POST /api/manager/expenses/{expenseId}/reject`
- `GET /api/manager/departures/{departureId}/incidents`
- `GET /api/manager/incidents/{id}`
- `PUT /api/manager/incidents/{id}`
- `POST /api/manager/incidents/{id}/resolve`
- `POST /api/manager/departures/{departureId}/schedule-changes`
- `GET /api/manager/departures/{departureId}/schedule-changes`

## 4. Backend/module cần triển khai

- `TourService` + `TourApprovalWorkflow` (submit only; approval belongs Admin)
- `DepartureService` + `ItineraryService`
- `GuideAssignmentService` (availability, conflict check, one primary guide)
- `CustomTourOrchestrationService` + quotation
- `IncidentService`, `ScheduleChangeService`
- `BudgetExpenseService`
- FE desktop manager dashboard, tour/departure forms and assignment views

## 5. Bảng dữ liệu liên quan

`TOUR`, `TOUR_DIA_DIEM`, `DOT_KHOI_HANH`, `LICH_TRINH`, `PHAN_CONG_HDV`, `NHAN_VIEN`, `NHAN_VIEN_BAN`, `CHUYEN_MON_HDV`, `NHAN_VIEN_NGON_NGU`, `YEU_CAU_TOUR_RIENG`, `YEU_CAU_TOUR_DIA_DIEM`, `PHAN_CONG_YEU_CAU_TOUR`, `BAO_GIA_TOUR_RIENG`, `CHI_TIET_BAO_GIA`, `TOUR_TU_YEU_CAU`, `NGAN_SACH_DOT`, `CHI_TIET_NGAN_SACH`, `CHI_PHI`, `CHUNG_TU_CHI_PHI`, `DUYET_CHI_PHI`, `SU_CO_TOUR`, `CHUNG_TU_SU_CO`, `THAY_DOI_LICH_TRINH`, `PHAN_HOI_THAY_DOI`, `BOOKING`

## 6. Phụ thuộc

- Database + Auth/Authorization.
- Tour before Departure.
- Departure before guide assignment and operational itinerary.
- Custom Tour coordination depends on Department Manager workflow.
- Booking/Payment/Refund modules are dependencies for operational dashboards.

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

Có 11 trang QUAN_LY_TONG trong Page Matrix. Kiểm tra state transition theo File 05, không cho Manager bypass bước duyệt tour của Admin.
