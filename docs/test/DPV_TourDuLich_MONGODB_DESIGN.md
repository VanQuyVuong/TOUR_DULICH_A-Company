# DPV_TourDuLich — Thiết kế cơ sở dữ liệu MongoDB (bản chuyển đổi ban đầu)

- **Database chính thức dự kiến:** `DPV_TourDuLich`
- **Database engine:** MongoDB
- **Nguồn đối chiếu nghiệp vụ:** `DPV_TourDuLich_FINAL.sql` (MySQL cũ, chỉ dùng để đối chiếu nghiệp vụ và dữ liệu; không tiếp tục phát triển schema MySQL).
- **Trạng thái:** Bản thiết kế chuyển đổi ban đầu. Chưa phải schema đã nghiệm thu cuối cùng và chưa phải script di chuyển dữ liệu.
- **Script khởi tạo:** `DPV_TourDuLich_MONGODB_INIT.js`

## 1. Quyết định chuyển đổi

Từ thời điểm chốt tài liệu này, mọi phát triển mới của DPV_TourDuLich phải dùng MongoDB làm cơ sở dữ liệu chính. Không tạo thêm migration SQL, DbContext EF Core cho MySQL, hoặc truy vấn MySQL cho chức năng mới. Backend cần chọn driver MongoDB phù hợp với phiên bản .NET đang dùng; không mặc định rằng mô hình EF Core/MySQL cũ có thể dùng nguyên trạng.

API và nghiệp vụ không tự động thay đổi chỉ vì đổi database. Giữ nguyên endpoint và quy tắc nghiệp vụ hiện hành nếu không có lý do nghiệp vụ rõ ràng để sửa.

## 2. Quy ước document

- Mỗi document dùng `_id: ObjectId` làm định danh nội bộ.
- Các trường tham chiếu dùng `...Id: ObjectId`, ví dụ `customerId`, `tourId`, `departureId`, `bookingId`, `accountId`. Tham chiếu không tự tạo ra ràng buộc khóa ngoại; Service phải kiểm tra quyền tồn tại, tính hợp lệ và phạm vi truy cập.
- Mã nghiệp vụ hiển thị cho người dùng như `tourCode`, `departureCode`, `bookingCode`, `employeeCode` vẫn là chuỗi riêng và cần unique index khi nghiệp vụ yêu cầu.
- Ngày giờ lưu bằng BSON Date theo UTC; quy đổi múi giờ tại tầng ứng dụng và giao diện.
- Tiền tệ dùng `Decimal128` hoặc kiểu tiền tệ chính xác tương đương; không dùng số thực nhị phân (`double`) cho tiền.
- Mật khẩu chỉ lưu BCrypt hash; refresh token và token đặt lại mật khẩu chỉ lưu hash, không lưu token nguyên bản.
- Dùng trạng thái nghiệp vụ đã thống nhất trong tài liệu hiện hành; không tự tạo enum mới khi chưa phân tích.
- Không nhúng document con không giới hạn kích thước hoặc có lịch sử tăng liên tục vào một document gốc.

## 3. Quy tắc nhúng và tham chiếu

**Nên nhúng (embedded) khi dữ liệu nhỏ, thuộc quyền sở hữu của document cha và thường đọc/cập nhật cùng nhau:**
- `bookings.passengers[]`: hành khách thuộc một booking, nếu số lượng hành khách được giới hạn bởi nghiệp vụ.
- `tours.destinations[]`: thứ tự điểm đến mang tính mô tả của tour mẫu.
- `departures.itinerary[]`: lịch trình riêng của một đợt khởi hành, nếu mỗi đợt có lịch trình riêng và không cần quản lý lịch trình như thực thể độc lập ở nhiều nơi.
- `customTourRequests.requestedLocations[]` và `customTourQuotations.items[]`: danh sách điểm đến/chi tiết báo giá gắn chặt với yêu cầu/báo giá.
- Các cấu hình nhỏ, ổn định như điều khoản chính sách hủy có thể nhúng snapshot vào booking khi khách đặt, để thay đổi chính sách sau này không làm thay đổi điều kiện lịch sử.

**Nên giữ collection riêng và tham chiếu khi dữ liệu có vòng đời riêng, tăng trưởng lớn, được truy vấn độc lập hoặc cần ghi nhận lịch sử:**
- `accounts`, `employees`, `customers`, `departments`, `tours`, `departures`, `bookings`, `payments`, `refunds`, `expenses`, `tourIncidents`, `notifications`, `systemLogs`, `loginSessions`.
- Lịch sử thay đổi lịch trình, sự cố, thanh toán, hoàn tiền và phân quyền nên là các bản ghi riêng để không làm document cha tăng vô hạn.

Đây là đề xuất ban đầu; cần xác nhận qua truy vấn thực tế và API contract trước khi khóa schema.

## 4. Danh sách collection đề xuất

| Collection | Thay thế nhóm bảng MySQL | Ghi chú mô hình |
|---|---|---|
| `accounts` | `TAI_KHOAN` | Tài khoản, email, username, password hash, trạng thái |
| `roles` | `VAI_TRO` | Danh mục vai trò |
| `permissions` | `QUYEN` | Danh mục quyền |
| `accountRoles` | `TAI_KHOAN_VAI_TRO` | Gán vai trò cho tài khoản; unique theo `accountId + roleId` |
| `rolePermissions` | `VAI_TRO_QUYEN` | Gán quyền cho vai trò; unique theo `roleId + permissionId` |
| `employees` | `NHAN_VIEN` | Hồ sơ nhân viên, tham chiếu `accountId` |
| `departments` | `BAN` | Danh mục phòng ban |
| `employeeDepartments` | `NHAN_VIEN_BAN` | Quan hệ nhân viên - phòng ban; giữ riêng để hỗ trợ thay đổi phân công |
| `employeeLanguages` | `NHAN_VIEN_NGON_NGU` | Quan hệ nhân viên - ngôn ngữ |
| `customers` | `KHACH_HANG` | Hồ sơ khách hàng, tham chiếu `accountId` |
| `guideSpecialties` | `CHUYEN_MON_HDV` | Chuyên môn của hướng dẫn viên |
| `languages` | `NGON_NGU` | Danh mục ngôn ngữ |
| `countries` | `QUOC_GIA` | Danh mục quốc gia |
| `provinces` | `TINH_THANH` | Tỉnh/thành, tham chiếu `countryId` nếu mô hình hiện hành yêu cầu |
| `locations` | `DIA_DIEM` | Địa điểm, tham chiếu tỉnh/thành/quốc gia theo thiết kế chi tiết |
| `tourTypes` | `LOAI_TOUR` | Danh mục loại tour |
| `tours` | `TOUR`, `TOUR_DIA_DIEM` | Thông tin tour; cân nhắc nhúng danh sách điểm đến có thứ tự |
| `departures` | `DOT_KHOI_HANH`, `LICH_TRINH` | Đợt khởi hành và lịch trình riêng của đợt; cân nhắc nhúng `itinerary[]` |
| `guideAssignments` | `PHAN_CONG_HDV` | Phân công HDV theo đợt khởi hành |
| `tourProgress` | `TIEN_TRINH_TOUR`, `HINH_ANH_TIEN_TRINH` | Cập nhật tiến trình và hình ảnh; ảnh/tệp lớn lưu object storage, document chỉ lưu metadata/URL |
| `cancellationPolicies` | `CHINH_SACH_HUY`, `QUY_TAC_HUY` | Chính sách và quy tắc hủy; cần xác định snapshot trong booking |
| `bookings` | `BOOKING`, `HANH_KHACH` | Booking; có thể nhúng `passengers[]` và snapshot giá/chính sách |
| `payments` | `THANH_TOAN` | Một booking có thể có nhiều giao dịch/thử thanh toán |
| `paymentReconciliations` | `DOI_SOAT_GIAO_DICH` | Lịch sử đối soát riêng |
| `bookingCancellations` | `HUY_BOOKING` | Yêu cầu/lịch sử hủy booking |
| `refunds` | `HOAN_TIEN` | Theo dõi hoàn tiền độc lập |
| `customTourRequests` | `YEU_CAU_TOUR_RIENG`, `YEU_CAU_TOUR_DIA_DIEM` | Yêu cầu tour riêng; có thể nhúng điểm đến |
| `customTourAssignments` | `PHAN_CONG_YEU_CAU_TOUR` | Phân công xử lý yêu cầu tour riêng |
| `customTourQuotations` | `BAO_GIA_TOUR_RIENG`, `CHI_TIET_BAO_GIA` | Báo giá và `items[]` |
| `customTours` | `TOUR_TU_YEU_CAU` | Tour được hình thành từ yêu cầu đã chốt |
| `departureBudgets` | `NGAN_SACH_DOT`, `CHI_TIET_NGAN_SACH` | Ngân sách đợt và các hạng mục chi tiết; có thể nhúng các dòng chi tiết có giới hạn |
| `expenses` | `CHI_PHI`, `CHUNG_TU_CHI_PHI`, `DUYET_CHI_PHI` | Chi phí; chứng từ/duyệt có thể là subdocument nếu vòng đời phù hợp, nếu không tách collection ở bước thiết kế chi tiết |
| `tourIncidents` | `SU_CO_TOUR`, `CHUNG_TU_SU_CO` | Sự cố và metadata chứng từ |
| `scheduleChangeRequests` | `THAY_DOI_LICH_TRINH`, `PHAN_HOI_THAY_DOI` | Yêu cầu đổi lịch và phản hồi; giữ lịch sử |
| `departureCancellations` | `HUY_DOT_KHOI_HANH` | Hủy đợt khởi hành và phương án xử lý |
| `bookingTransfers` | `CHUYEN_BOOKING` | Chuyển booking/đợt theo quy tắc nghiệp vụ |
| `tourReviews` | `DANH_GIA_TOUR` | Đánh giá; unique theo booking nếu quy tắc hiện hành yêu cầu |
| `favoriteTours` | `TOUR_YEU_THICH` | Quan hệ khách hàng - tour yêu thích |
| `notifications` | `THONG_BAO` | Thông báo, trạng thái đã đọc |
| `systemLogs` | `NHAT_KY_HE_THONG` | Nhật ký hệ thống; kiểm soát quyền đọc và chính sách lưu trữ |
| `contactMessages` | `LIEN_HE` | Liên hệ/gửi tin nhắn |
| `loginSessions` | `PHIEN_DANG_NHAP` | Phiên đăng nhập, refresh token hash, thời hạn/thu hồi |
| `passwordResetTokens` | `DAT_LAI_MAT_KHAU` | Token reset dạng hash; TTL chỉ dùng sau khi xác nhận chính sách lưu trữ |
| `roleHistory` | `LICH_SU_VAI_TRO` | Lịch sử thay đổi vai trò; lưu riêng để giữ dấu vết kiểm toán |

> Danh sách trên là ánh xạ logic từ 56 bảng SQL sang các collection đề xuất. Một số bảng quan hệ được gộp thành mảng nhúng hoặc gom vào collection nghiệp vụ. Không thể coi đây là phép chuyển đổi 1-1; cần kiểm tra từng trường và từng ràng buộc trong SQL trước khi tạo schema cuối cùng.

## 5. Index ban đầu

Script `DPV_TourDuLich_MONGODB_INIT.js` tạo các collection và một bộ index nền tảng cho username/email/mã nghiệp vụ, tra cứu tour/đợt, booking theo khách hàng và đợt, giao dịch thanh toán, thông báo, phiên đăng nhập và token reset.

Index phải được rà soát lại với truy vấn thực tế. Không tạo index tràn lan vì index làm tăng chi phí ghi và dung lượng. Unique index cần kiểm tra dữ liệu trước khi triển khai trên môi trường có dữ liệu.

## 6. Các quy tắc nghiệp vụ bắt buộc phải giữ

1. Backend phải xác minh quyền theo vai trò, quyền sở hữu dữ liệu và phạm vi phòng ban; không dựa vào việc frontend ẩn nút.
2. Đặt tour phải chống đặt vượt số chỗ khi nhiều request đồng thời. Cần thiết kế cập nhật có điều kiện hoặc transaction phù hợp với topology MongoDB; không chỉ đọc số chỗ rồi ghi lại.
3. Thanh toán callback phải idempotent: xử lý lặp không được ghi nhận tiền hai lần hoặc chuyển trạng thái sai.
4. Cập nhật nhiều document liên quan (ví dụ booking, số chỗ, payment/refund) phải xác định rõ ranh giới nhất quán. MongoDB hỗ trợ transaction đa document trên replica set/sharded cluster phù hợp; môi trường local standalone không đủ để kiểm thử transaction đa document như production.
5. Không xóa cứng tài khoản/danh mục đã được tham chiếu nếu nghiệp vụ yêu cầu bảo toàn lịch sử; dùng trạng thái vô hiệu hóa.
6. Lưu snapshot giá, số lượng, thông tin hành khách và điều kiện hủy tại thời điểm đặt để bảo toàn lịch sử giao dịch.
7. Chỉ dùng BCrypt cho password hash; không ghi mật khẩu, token nguyên bản hoặc dữ liệu thanh toán nhạy cảm vào log.
8. Xác định retention cho `systemLogs`, `loginSessions`, `passwordResetTokens`, ảnh/chứng từ và dữ liệu cá nhân trước khi bật TTL hoặc xóa tự động.

## 7. Cấu trúc document minh họa

### `tours`
```javascript
{
  _id: ObjectId("..."),
  tourCode: "TOUR-...",
  name: "...",
  shortDescription: "...",
  description: "...",
  duration: { days: 4, nights: 3 },
  tourTypeId: ObjectId("..."),
  destinations: [
    { locationId: ObjectId("..."), order: 1, note: "..." }
  ],
  basePrices: {
    adult: Decimal128("0.00"),
    child: Decimal128("0.00"),
    infant: Decimal128("0.00")
  },
  status: "NHAP",
  createdByEmployeeId: ObjectId("..."),
  approvedByEmployeeId: null,
  createdAt: ISODate("2026-01-01T00:00:00Z"),
  approvedAt: null
}
```

### `departures`
```javascript
{
  _id: ObjectId("..."),
  departureCode: "DOT-...",
  tourId: ObjectId("..."),
  startAt: ISODate("2026-12-01T00:00:00Z"),
  endAt: ISODate("2026-12-04T00:00:00Z"),
  capacity: { total: 20, booked: 0 },
  prices: {
    adult: Decimal128("0.00"),
    child: Decimal128("0.00"),
    infant: Decimal128("0.00")
  },
  status: "MO_DANG_KY",
  itinerary: [
    { day: 1, order: 1, title: "...", content: "...", locationId: null, startTime: "08:00", endTime: "10:00" }
  ],
  createdAt: ISODate("2026-01-01T00:00:00Z")
}
```

### `bookings`
```javascript
{
  _id: ObjectId("..."),
  bookingCode: "BOOK-...",
  customerId: ObjectId("..."),
  departureId: ObjectId("..."),
  cancellationPolicySnapshot: { /* điều khoản tại thời điểm đặt */ },
  passengers: [
    { fullName: "...", birthDate: null, passengerType: "NGUOI_LON", documentNumber: null, isContact: true }
  ],
  priceSnapshot: {
    adultPrice: Decimal128("0.00"),
    childPrice: Decimal128("0.00"),
    infantPrice: Decimal128("0.00"),
    totalAmount: Decimal128("0.00"),
    currency: "VND"
  },
  passengerCounts: { adult: 1, child: 0, infant: 0, total: 1 },
  status: "CHO_THANH_TOAN",
  holdExpiresAt: ISODate("2026-12-01T00:00:00Z"),
  createdAt: ISODate("2026-01-01T00:00:00Z"),
  updatedAt: ISODate("2026-01-01T00:00:00Z")
}
```

> Đây là ví dụ hình dạng document, không phải dữ liệu thật. Các enum, tên trường và điều kiện bắt buộc phải được thống nhất trong API Master Contract trước khi code.

## 8. Các việc còn thiếu trước khi xem là sẵn sàng code hàng loạt

- [ ] Đọc đầy đủ 56 bảng và ánh xạ từng cột SQL sang kiểu BSON, trường document và quy tắc null/required.
- [ ] Chốt collection nào nhúng dữ liệu, collection nào tham chiếu; đặc biệt `bookings`, `departures`, `expenses`, `customTourRequests`, `roleHistory`.
- [ ] Chốt naming convention, enum/status, kiểu tiền và UTC trong toàn hệ thống.
- [ ] Thiết kế JSON Schema validator cho các collection quan trọng.
- [ ] Chốt MongoDB .NET driver và kiến trúc Repository/Service.
- [ ] Chốt transaction, concurrency/seat reservation, idempotency thanh toán và hoàn tiền.
- [ ] Hoàn thiện API Master Contract, Project Rules và AI Agent Rules.
- [ ] Thiết kế test database/fixtures và kiểm thử integration trên replica set cho transaction.
- [ ] Viết migration/import script nếu cần chuyển dữ liệu đang có; script init hiện tại không chuyển dữ liệu SQL.
- [ ] Cập nhật Developer Handoff, kế hoạch giao việc, README, CI/CD và tài liệu môi trường để loại bỏ hướng dẫn MySQL/EF Core MySQL cũ.

## 9. Lệnh chạy script khởi tạo

1. Cài MongoDB Server và MongoDB Shell (`mongosh`) nếu máy chưa có.
2. Lưu `DPV_TourDuLich_MONGODB_INIT.js` vào thư mục làm việc.
3. Mở terminal tại thư mục đó và chạy:

```bash
mongosh "mongodb://127.0.0.1:27017" DPV_TourDuLich --file DPV_TourDuLich_MONGODB_INIT.js
```

Nếu MongoDB yêu cầu tài khoản/mật khẩu hoặc đang chạy ở máy chủ khác, thay connection string bằng thông tin môi trường của bạn; không ghi thông tin bí mật trực tiếp vào file chia sẻ với team.

## 10. Quy tắc cho team và AI từ thời điểm này

- Database đích là MongoDB, database name `DPV_TourDuLich`.
- File SQL FINAL chỉ là nguồn đối chiếu nghiệp vụ cũ, không dùng làm script khởi tạo database mới.
- Không tự động chuyển từng bảng thành collection 1-1 nếu chưa xem xét nhúng/tham chiếu.
- Không tự suy diễn API, trạng thái hoặc quyền. Nếu tài liệu chưa quy định, ghi rõ câu hỏi/chỗ thiếu và đề xuất để người phụ trách duyệt.
- Không tuyên bố module hoàn thành chỉ vì code biên dịch; phải có kiểm thử và bằng chứng nghiệm thu.
