# KẾ HOẠCH TRIỂN KHAI ROLE ADMIN

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `ADMIN`
- **Nền tảng:** Desktop App
- **Số page được liệt kê trong Role → Page Matrix:** **7** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Dashboard/KPI; quản lý tài khoản; tạo account nhân viên; gán/đổi role; khóa/mở khóa/deactivate; xem role/permission; quản lý phòng ban và thành viên; quản lý master data (quốc gia, tỉnh/thành, địa điểm, loại tour, ngôn ngữ, chuyên môn HDV); duyệt/từ chối/publish/ngừng bán tour; báo cáo tổng quan; audit theo quyền trong contract.

## 2. Danh sách trang

- `DPVDESKAdminTongQuan`
- `DPVDESKAdminQuanLyTaiKhoan`
- `DPVDESKAdminChiTietTaiKhoan`
- `DPVDESKAdminQuanLyPhongBan`
- `DPVDESKAdminChiTietPhongBan`
- `DPVDESKAdminQuanLyDanhMuc`
- `DPVDESKAdminBaoCaoTongQuan`

## 3. API liên quan trong contract hiện có

- `GET /api/admin/accounts`
- `GET /api/admin/accounts/{id}`
- `POST /api/admin/accounts`
- `POST /api/admin/accounts/{id}/roles`
- `PUT /api/admin/accounts/{id}/roles`
- `PUT /api/admin/accounts/{id}/lock`
- `PUT /api/admin/accounts/{id}/unlock`
- `PUT /api/admin/accounts/{id}/deactivate`
- `GET /api/admin/roles`
- `GET /api/admin/permissions`
- `PUT /api/admin/roles/{id}/permissions`
- `GET /api/departments`
- `GET /api/departments/{banId}`
- `POST /api/admin/departments`
- `PUT /api/admin/departments/{banId}`
- `PUT /api/admin/departments/{banId}/activate`
- `PUT /api/admin/departments/{banId}/deactivate`
- `GET /api/departments/{banId}/employees`
- `GET /api/departments/{banId}/manager`
- `GET /api/countries`
- `GET /api/countries/{id}`
- `POST /api/admin/countries`
- `PUT /api/admin/countries/{id}`
- `PUT /api/admin/countries/{id}/deactivate`
- `GET /api/provinces?countryId={id}`
- `GET /api/provinces/{id}`
- `POST /api/admin/provinces`
- `PUT /api/admin/provinces/{id}`
- `PUT /api/admin/provinces/{id}/deactivate`
- `GET /api/locations?provinceId={id}`
- `GET /api/locations/{id}`
- `POST /api/admin/locations`
- `PUT /api/admin/locations/{id}`
- `PUT /api/admin/locations/{id}/deactivate`
- `GET /api/tour-types`
- `POST /api/admin/tour-types`
- `PUT /api/admin/tour-types/{id}`
- `PUT /api/admin/tour-types/{id}/deactivate`
- `GET /api/languages`
- `POST /api/admin/languages`
- `PUT /api/admin/languages/{id}`
- `PUT /api/admin/languages/{id}/deactivate`
- `POST /api/admin/tours/{tourId}/approve`
- `POST /api/admin/tours/{tourId}/reject`
- `POST /api/admin/tours/{tourId}/publish`
- `POST /api/admin/tours/{tourId}/stop-selling`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## API bổ sung trong Developer Handoff

- `GET /api/admin/employees`
- `GET /api/admin/employees/{employeeId}`
- `PUT /api/admin/employees/{employeeId}`
- `POST /api/admin/employees/{employeeId}/departments`
- `PUT /api/admin/employees/{employeeId}/departments/{banId}`
- `DELETE /api/admin/employees/{employeeId}/departments/{banId}`
- `GET /api/admin/employees/{employeeId}/departments`
- `GET /api/admin/employees/{employeeId}/specializations`
- `POST /api/admin/employees/{employeeId}/specializations`
- `DELETE /api/admin/employees/{employeeId}/specializations/{id}`
- `GET /api/admin/employees/{employeeId}/languages`
- `POST /api/admin/employees/{employeeId}/languages`
- `DELETE /api/admin/employees/{employeeId}/languages/{id}`
- `GET /api/employees/guides`
- `GET /api/admin/reports/overview`
- `GET /api/admin/reports/revenue`
- `GET /api/admin/reports/bookings`
- `GET /api/admin/reports/tours`
- `GET /api/admin/reports/departures`
- `GET /api/admin/reports/expenses`
- `GET /api/admin/contacts`
- `GET /api/admin/contacts/{id}`
- `PUT /api/admin/contacts/{id}/process`

## 4. Backend/module cần triển khai

- `AccountController/Service` + `RolePermissionService`
- `DepartmentController/Service`
- `MasterDataController/Service`
- `TourApprovalService`
- `AdminReportService` và audit query theo contract
- Frontend desktop admin pages + API services

## 5. Bảng dữ liệu liên quan

`TAI_KHOAN`, `VAI_TRO`, `QUYEN`, `TAI_KHOAN_VAI_TRO`, `VAI_TRO_QUYEN`, `LICH_SU_VAI_TRO`, `PHIEN_DANG_NHAP`, `NHAN_VIEN`, `BAN`, `NHAN_VIEN_BAN`, `QUOC_GIA`, `TINH_THANH`, `DIA_DIEM`, `LOAI_TOUR`, `NGON_NGU`, `CHUYEN_MON_HDV`, `TOUR`, `BOOKING`, `THANH_TOAN`, `CHI_PHI`, `NHAT_KY_HE_THONG`

## 6. Phụ thuộc

- Setup, Database, Auth, Authorization trước khi triển khai thao tác quản trị.
- Department cần employee/account management.
- Tour approval cần Tour module.
- Dashboard/report phụ thuộc dữ liệu module tương ứng.

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

Có 7 trang ADMIN trong Role → Page Matrix. Dashboard/report API chi tiết cần đối chiếu phần báo cáo trong Developer Handoff trước khi chia task endpoint nhỏ.
