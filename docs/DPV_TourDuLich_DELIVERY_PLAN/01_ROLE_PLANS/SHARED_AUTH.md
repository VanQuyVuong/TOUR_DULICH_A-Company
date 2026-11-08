# KẾ HOẠCH MODULE DÙNG CHUNG AUTHENTICATION

> Tài liệu phân công theo role cho DPV_TourDuLich. Dựa trên `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`, `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`, `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md` và `DPV_TourDuLich_FINAL.sql`.

- **Role:** `SHARED_AUTH`
- **Nền tảng:** Web + Desktop + Mobile
- **Số page được liệt kê trong Role → Page Matrix:** **5** (không tính trang Auth dùng chung).
- **Trạng thái:** `TODO`
- **Người phụ trách:** Chưa phân công

## 1. Phạm vi chức năng

Đăng ký khách hàng; đăng nhập; lấy user hiện tại; refresh token; logout; quên mật khẩu; reset mật khẩu. Điều hướng theo role sau khi xác thực.

## 2. Danh sách trang

- `DPVWEBAuthDangNhap`
- `DPVDESKAuthDangNhap`
- `DPVMOBAuthDangNhap`
- `DPVWEBAuthDangKy`
- `DPVMOBAuthDangKy`

## 3. API liên quan trong contract hiện có

- `POST /api/auth/login`
- `POST /api/auth/register`
- `POST /api/auth/logout`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`
- `POST /api/auth/refresh-token`
- `GET /api/auth/me`

> Danh sách trên là endpoint được tìm thấy trong tài liệu nguồn và có liên quan trực tiếp đến role. Trước khi code, đối chiếu API Master/Developer Handoff; không tự suy ra endpoint mới từ tên chức năng.

## 4. Backend/module cần triển khai

- `AuthController`
- `AuthService`
- `PasswordHasher` (BCrypt)
- `RefreshSessionService`
- `PasswordResetService`
- `CurrentUser/Claims` utilities and role-based routing

## 5. Bảng dữ liệu liên quan

`TAI_KHOAN`, `TAI_KHOAN_VAI_TRO`, `VAI_TRO`, `VAI_TRO_QUYEN`, `QUYEN`, `KHACH_HANG`, `NHAN_VIEN`, `PHIEN_DANG_NHAP`, `DAT_LAI_MAT_KHAU`, `LICH_SU_VAI_TRO`

## 6. Phụ thuộc

Không phụ thuộc các module nghiệp vụ; là dependency nền cho toàn bộ role có đăng nhập.

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

5 trang Auth dùng chung. Reset token và refresh token phải được hash/lưu theo Developer Handoff; không trả password/hash trong response.
