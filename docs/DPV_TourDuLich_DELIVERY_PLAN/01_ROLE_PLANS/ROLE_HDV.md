# KẾ HOẠCH TRIỂN KHAI ROLE HƯỚNG DẪN VIÊN

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `HDV`
- **Nền tảng:** Desktop App + Mobile App
- **Số page được liệt kê trong Role → Page Matrix:** **10** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Xem dashboard cá nhân; xem tour/đợt được phân công; xem lịch trình và hành khách phù hợp quyền; cập nhật tiến độ tour; gửi báo cáo sự cố và chứng từ; hỗ trợ thông tin đề xuất cho tour riêng khi được giao qua workflow.

## 2. Danh sách trang

- `DPVDESKGuideTongQuan`
- `DPVDESKGuideTourDuocPhanCong`
- `DPVDESKGuideChiTietTourDuocPhanCong`
- `DPVDESKGuideCapNhatTienDo`
- `DPVDESKGuideBaoCaoSuCo`
- `DPVMOBGuideTongQuan`
- `DPVMOBGuideTourDuocPhanCong`
- `DPVMOBGuideChiTietTourDuocPhanCong`
- `DPVMOBGuideCapNhatTienDo`
- `DPVMOBGuideBaoCaoSuCo`

## 3. API liên quan trong contract hiện có

- `GET /api/employees/{employeeId}/assignments`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## API bổ sung trong Developer Handoff

- `POST /api/guides/departures/{departureId}/incidents`

## 4. Backend/module cần triển khai

- `GuideAssignmentQueryService`
- `TourProgressService`
- `IncidentService` + evidence upload/storage adapter if the repo supports uploads
- `ScheduleChangeResponseService` if enabled by contract
- Desktop/mobile FE pages for guide tasks

## 5. Bảng dữ liệu liên quan

`NHAN_VIEN`, `NHAN_VIEN_BAN`, `PHAN_CONG_HDV`, `DOT_KHOI_HANH`, `LICH_TRINH`, `BOOKING`, `HANH_KHACH`, `TIEN_TRINH_TOUR`, `HINH_ANH_TIEN_TRINH`, `SU_CO_TOUR`, `CHUNG_TU_SU_CO`, `THAY_DOI_LICH_TRINH`, `PHAN_HOI_THAY_DOI`, `YEU_CAU_TOUR_RIENG`, `PHAN_CONG_YEU_CAU_TOUR`

## 6. Phụ thuộc

- Auth/Authorization + Employee/Assignment module.
- Departure/Itinerary module.
- Incident and progress modules.
- Mobile offline/retry behavior should not be invented unless separately agreed.

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

Có 5 trang DESKTOP + 5 trang MOBILE = 10 trang HDV. Hầu hết API thao tác tiến độ/sự cố phải lấy từ Developer Handoff master; không coi endpoint assignments là API duy nhất của HDV.
