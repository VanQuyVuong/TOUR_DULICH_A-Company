# DPV_TourDuLich — Automated Test Plan

## Mục đích

Thư mục này là bộ **test case tự động hóa ở dạng Gherkin `.feature`** cho các luồng nghiệp vụ cốt lõi. Đây là test specification có cấu trúc; nó chưa tự chạy được cho tới khi repo có test runner, step definitions, test database/fixtures và app configuration. Không được hiểu các file `.feature` là bằng chứng test đã pass.

## Stack đề xuất phù hợp tài liệu hiện có

- Backend: **xUnit + ASP.NET Core `WebApplicationFactory`** cho API integration tests.
- Database integration: MySQL test instance riêng; có thể dùng Testcontainers nếu máy/CI hỗ trợ Docker. Không chạy test phá dữ liệu trên database dev/prod.
- Frontend E2E: **Playwright** cho các luồng trình duyệt quan trọng.
- Gherkin runner: chọn SpecFlow/Reqnroll hoặc chuyển các scenario thành test method thuần xUnit; chốt một lựa chọn trong repo trước khi viết bindings.

## Test layers

1. Unit: state transitions, giá/phí theo policy, validators, authorization helpers.
2. API integration: HTTP status/body, persistence, transaction, ownership, scope, idempotency.
3. E2E: luồng từ trang tới API; mock payment ban đầu.
4. Regression: chạy toàn bộ suite trước merge/release.

## Chạy test (sau khi repo test được khởi tạo)

```bash
dotnet test
# Nếu tạo riêng thư mục FE E2E:
npm ci
npx playwright install
npx playwright test
```

Các lệnh trên là mẫu; cần điều chỉnh theo solution/repo thực tế.

## Quy tắc test data

- Dùng database/test schema riêng, seed dữ liệu có định danh rõ ràng và cleanup sau test.
- Không dùng tài khoản/mật khẩu thật.
- Không phụ thuộc thứ tự chạy test.
- Test concurrency booking phải chạy song song trên DB engine tương ứng; không chỉ mock repository.
- Mọi test quyền phải có ít nhất: đúng role, sai role, tài nguyên của chính mình, tài nguyên người khác; department scope phải có Ban A/B.
- Không test payment gateway thật khi chưa được cấu hình an toàn; dùng Mock Payment.

## Quy ước đặt tên

`{Module}_{Scenario}_{ExpectedResult}`. Ví dụ `Booking_WhenDepartureFull_ReturnsConflict`.

## Definition of Done cho test

- Test có assertion rõ ràng, không chỉ gọi endpoint.
- Có positive + negative + boundary cases cho nghiệp vụ trọng yếu.
- Test chạy trong CI/local theo documented command.
- Khi fail, log đủ request/correlation ID nhưng không log token/password/PII nhạy cảm.
- Báo cáo test pass/fail được đính kèm PR/task.
