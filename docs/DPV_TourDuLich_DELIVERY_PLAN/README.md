# DPV_TourDuLich — Delivery Plan Package

## Nội dung

- `01_ROLE_PLANS/`: kế hoạch theo 6 role hệ thống + module Auth dùng chung.
- `02_MASTER_PLAN/DPV_TourDuLich_MASTER_IMPLEMENTATION_PLAN.md`: kế hoạch tổng thể, dependency và Definition of Done.
- `02_MASTER_PLAN/MASTER_TRACKER.csv`: bảng tiến độ mở bằng Excel/Google Sheets, cập nhật Owner/Status/Evidence.
- `03_AUTOMATED_TESTS/README.md`: chiến lược test tự động và cách tổ chức test.
- `03_AUTOMATED_TESTS/features/`: test cases Gherkin theo module.

## Role/page count theo User & Function Spec

| Role | Page count trong matrix |
|---|---:|
| KHACH_HANG | 26 (13 WEB + 13 MOB) |
| ADMIN | 7 DESK |
| QUAN_LY_TONG | 11 DESK |
| TRUONG_BAN | 4 DESK |
| HDV | 10 (5 DESK + 5 MOB) |
| NHAN_VIEN | Chưa xác định page riêng trong nguồn |
| Shared Auth | 5 trang |

Đếm theo danh sách trong Role → Page Matrix, không phải số lượng màn hình cuối cùng sau UX review.

## Lưu ý quan trọng

Các API trong role plan là những endpoint liên quan được liệt kê trong nguồn. Một số nghiệp vụ có thể còn endpoint chi tiết trong Developer Handoff/API contract; trước khi implement từng task phải kiểm tra tài liệu API chuẩn. Test `.feature` là test case specification, chưa phải test suite runnable cho tới khi viết step definitions/fixtures và cấu hình runner.
