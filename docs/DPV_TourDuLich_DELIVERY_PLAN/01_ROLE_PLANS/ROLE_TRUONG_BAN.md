# KẾ HOẠCH TRIỂN KHAI ROLE TRƯỞNG BAN

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `TRUONG_BAN`
- **Nền tảng:** Desktop App
- **Số page được liệt kê trong Role → Page Matrix:** **4** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Xem dashboard trong phạm vi Ban; nhận danh sách yêu cầu tour riêng được phân công; xem chi tiết; xử lý yêu cầu thuộc Ban; đề xuất/phối hợp HDV và quản lý nhân sự thuộc Ban. Không được truy cập dữ liệu ngoài department scope.

## 2. Danh sách trang

- `DPVDESKDepartmentManagerTongQuan`
- `DPVDESKDepartmentManagerYeuCauCanXuLy`
- `DPVDESKDepartmentManagerChiTietYeuCau`
- `DPVDESKDepartmentManagerQuanLyNhanSuPhong`

## 3. API liên quan trong contract hiện có

- `GET /api/departments/{banId}/employees`
- `GET /api/departments/{banId}/manager`
- `GET /api/manager/custom-tour-requests`
- `GET /api/manager/custom-tour-requests/{id}`
- `POST /api/department-manager/custom-tour-requests/{id}/process`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## 4. Backend/module cần triển khai

- `DepartmentScopeAuthorization` dùng chung, không chỉ lọc dữ liệu ở FE.
- `DepartmentEmployeeService`
- `DepartmentCustomTourProcessingService`
- Frontend department dashboard, inbox/detail, team members

## 5. Bảng dữ liệu liên quan

`BAN`, `NHAN_VIEN`, `NHAN_VIEN_BAN`, `TAI_KHOAN`, `YEU_CAU_TOUR_RIENG`, `YEU_CAU_TOUR_DIA_DIEM`, `PHAN_CONG_YEU_CAU_TOUR`, `BAO_GIA_TOUR_RIENG`, `CHI_TIET_BAO_GIA`, `CHUYEN_MON_HDV`, `NHAN_VIEN_NGON_NGU`

## 6. Phụ thuộc

- Department module và account/employee module.
- Custom Tour Request module.
- Overall Manager phân công Ban trước khi Trưởng Ban xử lý.

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

Có 4 trang trong Page Matrix. Cần test truy cập chéo Ban: Trưởng Ban Ban A không xem/sửa yêu cầu của Ban B.
