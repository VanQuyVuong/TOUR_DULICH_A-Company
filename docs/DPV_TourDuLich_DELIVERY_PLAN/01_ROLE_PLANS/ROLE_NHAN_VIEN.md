# KẾ HOẠCH TRIỂN KHAI ROLE NHÂN VIÊN

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `NHAN_VIEN`
- **Nền tảng:** Theo quyền được gán; chưa có portal riêng trong Page Matrix
- **Số page được liệt kê trong Role → Page Matrix:** **0** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

`NHAN_VIEN` là role nền có quyền thực tế được xác định qua `TAI_KHOAN → TAI_KHOAN_VAI_TRO → VAI_TRO → VAI_TRO_QUYEN → QUYEN`. Tài liệu hiện không xác định bộ trang riêng hoặc nhóm chức năng độc lập cho role này. Chỉ implement chức năng được cấp quyền cụ thể; không tự thiết kế portal hay cấp quyền mặc định.

## 2. Danh sách trang

- Chưa có trang riêng được đặc tả trong User & Function Spec; không tự tạo trang mới.

## 3. API liên quan trong contract hiện có

- API cụ thể phụ thuộc quyền được gán qua `VAI_TRO_QUYEN`; không tự tạo endpoint riêng khi chưa có contract.

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## 4. Backend/module cần triển khai

- Tái sử dụng Authentication/Authorization.
- Resolve permissions từ database/claims theo contract.
- Audit việc gán role/quyền.
- Chưa tạo Controller/page riêng cho `NHAN_VIEN` nếu chưa có chức năng cụ thể được phê duyệt.

## 5. Bảng dữ liệu liên quan

`TAI_KHOAN`, `VAI_TRO`, `QUYEN`, `TAI_KHOAN_VAI_TRO`, `VAI_TRO_QUYEN`, `NHAN_VIEN`, `BAN`, `NHAN_VIEN_BAN`, `LICH_SU_VAI_TRO`

## 6. Phụ thuộc

- Auth, account, role/permission, employee, department.
- Cần Team Lead xác nhận các quyền thực tế cho từng loại nhân viên nếu muốn phân công module nghiệp vụ riêng.

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

**BLOCKED FOR PAGE ESTIMATION:** nguồn hiện không quy định số trang riêng cho NHAN_VIEN. Không tính là 0 chức năng; đây là role có quyền động, cần map theo quyền thực tế.
