# DPV_TourDuLich — KẾ HOẠCH TRIỂN KHAI TỔNG THỂ

> Dùng làm bảng điều phối và cập nhật tiến độ toàn nhóm. Các role plan chi tiết nằm trong `01_ROLE_PLANS/`.

## 1. Quy tắc nguồn chuẩn

1. Database: `DPV_TourDuLich_FINAL.sql` (56 bảng). Không dùng `DPV.CSDL(1).sql` cũ.
2. API/kiến trúc: `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`.
3. Role/page/function: `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`.
4. Flow/state: `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md`.
5. UX/page naming: `DPV_TourDuLich_UX_UI_MASTER_SPEC_FINAL.md`.
6. QA/permission/API: `06_DPV_TourDuLich_QA_PERMISSION_API_CONTRACT_FINAL.md`.

Nếu một endpoint, state, field hoặc business rule xung đột giữa tài liệu: dừng task, đánh `BLOCKED`, báo Team Lead; không tự chọn một cách hiểu.

## 2. Trạng thái

- `TODO`: chưa bắt đầu.
- `IN_PROGRESS`: đang làm.
- `BLOCKED`: bị chặn bởi dependency/thiếu quyết định.
- `IN_REVIEW`: code xong, chờ review.
- `TESTING`: đang test tích hợp.
- `DONE`: Acceptance Criteria đạt, test pass và code đã review/merge.

## 3. Master task board

| ID | Phase | Hạng mục | Owner | Depends on | Status | Evidence/PR |
|---|---|---|---|---|---|---|
| SETUP-001 | 0 | Repo, solution/project structure, configuration mẫu, secrets ngoài Git | TBD | — | TODO | |
| SETUP-002 | 0 | CI build + format/lint + test command | TBD | SETUP-001 | TODO | |
| DB-001 | 1 | Import SQL FINAL và xác nhận 56 bảng/FK/index | TBD | SETUP-001 | TODO | |
| DB-002 | 1 | EF Core provider/configuration, DbContext/entities mapping | TBD | DB-001 | TODO | |
| CORE-001 | 2 | Global exception handler + response/error contract + Swagger | TBD | SETUP-001 | TODO | |
| AUTH-001 | 3 | Register/login, BCrypt, JWT/access token, refresh session | TBD | DB-002, CORE-001 | TODO | |
| AUTH-002 | 3 | Logout, refresh, forgot/reset password, single-use token | TBD | AUTH-001 | TODO | |
| AUTHZ-001 | 4 | Role/permission policies, ownership, department scope | TBD | AUTH-001 | TODO | |
| ADMIN-001 | 5 | Account/role/permission administration | TBD | AUTHZ-001 | TODO | |
| DEPT-001 | 5 | Department + employee membership and manager scope | TBD | AUTHZ-001 | TODO | |
| MASTER-001 | 5 | Country/province/location/tour type/language/guide specialty | TBD | DB-002, AUTHZ-001 | TODO | |
| TOUR-001 | 6 | Public tour list/detail + filter/sort/pagination per contract | TBD | MASTER-001 | TODO | |
| TOUR-002 | 6 | Manager create/update tour + locations + submit | TBD | TOUR-001, AUTHZ-001 | TODO | |
| TOUR-003 | 6 | Admin approve/reject/publish/stop selling | TBD | TOUR-002 | TODO | |
| DEP-001 | 7 | Departure CRUD/open/close/cancel/availability | TBD | TOUR-003 | TODO | |
| ITIN-001 | 7 | Itinerary per departure | TBD | DEP-001 | TODO | |
| GUIDE-001 | 8 | Guide availability and assignment; primary/assistant rules | TBD | DEP-001, DEPT-001 | TODO | |
| GUIDE-002 | 8 | Guide assigned tours, progress and incident reporting | TBD | GUIDE-001, ITIN-001 | TODO | |
| BOOK-001 | 9 | Booking + passengers; transaction/locking/capacity protection | TBD | DEP-001, AUTHZ-001 | TODO | |
| PAY-001 | 10 | Mock Payment, idempotency, payment state separate from booking state | TBD | BOOK-001 | TODO | |
| CANCEL-001 | 10 | Cancellation policy, cancellation request, refund lifecycle | TBD | PAY-001 | TODO | |
| CUSTOM-001 | 11 | Customer custom-tour request and own-request tracking | TBD | AUTHZ-001 | TODO | |
| CUSTOM-002 | 11 | Overall manager routes to departments; department manager processes | TBD | CUSTOM-001, DEPT-001 | TODO | |
| CUSTOM-003 | 11 | Quotation, customer view/confirm, convert to tour/departure | TBD | CUSTOM-002, TOUR-002, DEP-001 | TODO | |
| OPS-001 | 12 | Schedule change request/response and consent path | TBD | DEP-001, GUIDE-001 | TODO | |
| OPS-002 | 12 | Incident handling/evidence and departure cancellation workflow | TBD | DEP-001, GUIDE-002 | TODO | |
| COST-001 | 13 | Departure budget, expenses, evidence, approval | TBD | DEP-001, AUTHZ-001 | TODO | |
| SOCIAL-001 | 14 | Review and favorite per contract | TBD | BOOK-001, AUTHZ-001 | TODO | |
| NOTIFY-001 | 15 | Notifications: persistence, read/unread, target permissions | TBD | relevant business modules | TODO | |
| REPORT-001 | 16 | Admin/manager dashboard and reports; exclude tax scope | TBD | booking/payment/expense modules | TODO | |
| AUDIT-001 | 16 | System audit log for critical actions | TBD | CORE-001, AUTHZ-001 | TODO | |
| FE-001 | 17 | Shared UI kit, route guards, API client, loading/error patterns | TBD | SETUP-001, UX/UI spec | TODO | |
| FE-002 | 17 | Customer web pages with mock then real API | TBD | FE-001, TOUR-001 | TODO | |
| FE-003 | 17 | Customer mobile pages with mock then real API | TBD | FE-001, TOUR-001 | TODO | |
| FE-004 | 17 | Admin/Manager/Department Manager desktop pages | TBD | FE-001, module APIs | TODO | |
| FE-005 | 17 | Guide desktop/mobile pages | TBD | FE-001, GUIDE-002 | TODO | |
| QA-001 | 18 | Unit tests for services/domain rules | TBD | module implementation | TODO | |
| QA-002 | 18 | API integration tests + DB test strategy | TBD | module implementation | TODO | |
| QA-003 | 18 | Playwright E2E critical user journeys | TBD | FE+BE integrated | TODO | |
| QA-004 | 18 | Security/permission/ownership/department scope tests | TBD | AUTHZ-001 + modules | TODO | |
| REL-001 | 19 | Environment configuration, migrations/release checklist, backup/rollback plan | TBD | QA-001..QA-004 | TODO | |

## 4. Definition of Done chung

- [ ] Code đúng kiến trúc Controller → Service → Repository/data access.
- [ ] Không đổi API/schema/state khi chưa cập nhật contract và được duyệt.
- [ ] Validation và error response theo chuẩn.
- [ ] Có test phù hợp: unit + integration; E2E cho luồng người dùng chính.
- [ ] Kiểm tra permission, owner, department scope ở Backend.
- [ ] Không lộ mật khẩu/hash/refresh token.
- [ ] Test command chạy qua; ghi log kết quả.
- [ ] PR được review/merge; cập nhật status và link bằng chứng.

## 5. Cập nhật tiến độ

- Cập nhật bảng này và `MASTER_TRACKER.csv` cùng lúc.
- Chỉ một người làm owner chính cho mỗi task; có thể ghi reviewer riêng trong PR.
- Không đánh `DONE` chỉ vì code đã viết.
- Task bị thiếu contract phải là `BLOCKED`, ghi rõ câu hỏi và tài liệu liên quan.
