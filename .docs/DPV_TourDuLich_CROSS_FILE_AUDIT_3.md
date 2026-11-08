# DPV_TourDuLich — CROSS-FILE AUDIT LẦN 3

**Mục tiêu:** xác nhận các lỗi contract còn lại sau Audit lần 2 đã được sửa đồng bộ trước khi chuyển sang TODO / Project Rules / AI Agent Task Plan.

**Nguồn kiểm tra:**
- `DPV_TourDuLich_FINAL.sql`
- `DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`
- `04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`
- `05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md`
- `DPV_TourDuLich_UX_UI_MASTER_SPEC_FINAL.md`
- `06_DPV_TourDuLich_QA_PERMISSION_API_CONTRACT_FINAL.md`

---

## 1. Kết quả tổng quan

### ✅ AUDIT 3 — PASS

Các blocker của Audit lần 2 đã được xử lý:

| Mã | Vấn đề Audit 2 | Kết quả Audit 3 |
|---|---|---|
| AUDIT2-001 | Payment dùng `CHUA_THANH_TOAN` không đồng bộ với state final `CHO_THANH_TOAN` | ✅ Đã sửa |
| AUDIT2-002 | Custom Tour API giữa Developer Handoff và QA/API Contract khác nhau | ✅ Đã chuẩn hóa |
| AUDIT2-003 | Department API chưa có đầy đủ trong QA/API Contract | ✅ Đã bổ sung |
| AUDIT2-004 | Departure API giữa Developer Handoff và QA/API Contract chưa đồng bộ | ✅ Đã chuẩn hóa |
| Duplicate approve path | Function có `{id}` và `{tourId}` | ✅ Chỉ còn `{tourId}` |

---

## 2. Payment State — PASS

Canonical payment state:

```text
CHO_THANH_TOAN
→ DANG_XU_LY
→ THANH_CONG

DANG_XU_LY
→ THAT_BAI
```

`CHUA_THANH_TOAN` không còn được sử dụng như một payment state trong Function, UX/UI và QA/API Contract.

File Developer Handoff và Flow/State vẫn có thể nhắc `CHUA_THANH_TOAN` trong câu giải thích kiểu “không dùng”; đây là câu phủ định, không phải state hợp lệ.

---

## 3. Custom Tour API — PASS

Canonical contract đã thống nhất:

```text
POST /api/custom-tour-requests
GET  /api/custom-tour-requests/me
GET  /api/manager/custom-tour-requests
GET  /api/manager/custom-tour-requests/{id}
POST /api/manager/custom-tour-requests/{id}/assign-departments
POST /api/department-manager/custom-tour-requests/{id}/process
POST /api/manager/custom-tour-requests/{id}/quotation
GET  /api/custom-tour-quotations/{id}
POST /api/custom-tour-quotations/{id}/confirm
```

Ý nghĩa chính:

```text
Customer
→ Overall Manager
→ assign-departments
→ Department Manager process
→ Quotation
→ Customer confirm quotation
```

Không còn dùng các path cũ:

```text
POST /api/manager/custom-tour-requests/{id}/assign
GET  /api/custom-tour-requests/{id}/quotation
POST /api/custom-tour-requests/{id}/confirm
```

---

## 4. Department API — PASS

Canonical contract:

```text
GET  /api/departments
GET  /api/departments/{banId}
POST /api/admin/departments
PUT  /api/admin/departments/{banId}
PUT  /api/admin/departments/{banId}/activate
PUT  /api/admin/departments/{banId}/deactivate
GET  /api/departments/{banId}/employees
GET  /api/departments/{banId}/manager
```

Developer Handoff, User & Function và QA/API Contract cùng sử dụng nhóm API này.

---

## 5. Departure API — PASS

Canonical contract trong QA/API Contract đã bao phủ:

```text
GET  /api/departures
GET  /api/departures/{departureId}
POST /api/manager/tours/{tourId}/departures
PUT  /api/manager/departures/{departureId}
GET  /api/departures/{departureId}/availability
GET  /api/departures/{departureId}/booking-availability
GET  /api/manager/departures/{departureId}/itinerary
POST /api/manager/departures/{departureId}/itinerary
PUT  /api/manager/departures/{departureId}/itinerary/{id}
```

Trong đó:
- `availability`: kiểm tra tình trạng chỗ/trạng thái phục vụ chung.
- `booking-availability`: kiểm tra khả năng nhận booking trước khi tạo booking.

Không dùng hai endpoint này thay thế lẫn nhau trong FE/QA.

---

## 6. Tour Approve API — PASS

Canonical path:

```text
POST /api/admin/tours/{tourId}/approve
```

Không còn path `{id}` trong Function.

---

## 7. Database Source of Truth — PASS

`DPV_TourDuLich_FINAL.sql` hiện có:

```text
56 CREATE TABLE
```

Các contract đã được kiểm tra theo SQL final, không quay lại SQL cũ 52 bảng.

---

## 8. State Contract — PASS

Departure state:

```text
MOI_TAO
→ MO_DANG_KY
→ DA_DAY / DONG_DANG_KY
→ DA_KHOI_HANH
→ DANG_DI
→ DA_HOAN_THANH
```

Cancellation branch:

```text
MOI_TAO / MO_DANG_KY / DA_DAY / DONG_DANG_KY
→ DA_HUY
```

Booking state:

```text
CHO_THANH_TOAN
DA_THANH_TOAN
DA_XAC_NHAN
DA_HUY
HOAN_TIEN
HOAN_THANH
HET_HAN
```

Payment state:

```text
CHO_THANH_TOAN
DANG_XU_LY
THANH_CONG
THAT_BAI
```

Custom Tour Request state:

```text
MOI_TAO
→ DA_TIEP_NHAN
→ DANG_XU_LY
→ CHO_BAO_GIA
→ DA_BAO_GIA
→ KHACH_DANG_XEM
→ KHACH_DA_XAC_NHAN
→ HOAN_TAT
```

Branch:

```text
KHACH_DANG_XEM → KHACH_TU_CHOI
DA_TIEP_NHAN / DANG_XU_LY / CHO_BAO_GIA → HUY
```

---

## 9. Audit 3 Conclusion

### 🟢 Có thể chuyển sang bước tiếp theo

Audit 3 không còn blocker thuộc 4 nhóm của Audit 2.

**Trạng thái:**

```text
AUDIT 1 → PASS sau đồng bộ nền
AUDIT 2 → FAIL, còn 4 nhóm contract
AUDIT 3 → PASS
```

### Bước tiếp theo đề xuất

Chuyển sang xây dựng:

```text
project-rules/
TODO/
AI Agent Task Plan
Coding Rules
Testing Rules
Definition of Done
Context Loading Rules
```

Mục tiêu là để Dev/AI Agent làm theo từng task, tự kiểm tra, test, cập nhật TODO và không tự ý thay đổi business contract.
