# Hướng dẫn chạy MongoDB cho DPV TourDuLich

## Mục đích

Tài liệu này hướng dẫn cả team khởi tạo cùng một database phát triển MongoDB cho DPV TourDuLich.

Database chính cho mô hình MongoDB là:

```text
DPV_TourDuLich_Mongo
```

Database này tách riêng khỏi `DPV_TourDuLich` cũ đang có các collection viết hoa được chuyển đổi trực tiếp từ bảng MySQL. Không chạy lẫn hai mô hình trong cùng một database.

## File phải chạy

```text
DPV.Analysis/DPV_TourDuLich_MONGODB_COMPASS_BOOTSTRAP.js
```

Script tạo 44 collection, 56 index nền tảng và 6 role hệ thống đã được xác nhận. Script an toàn để chạy lại: không xóa database, không xóa collection và không ghi đè role đã được chỉnh sửa. `tourTypes` được tạo collection nhưng chưa seed dữ liệu cho tới khi danh mục được nghiệp vụ chốt.

## Chuẩn bị

1. Cài MongoDB Community Server trên máy.
2. Cài MongoDB Compass.
3. Đảm bảo dịch vụ MongoDB đang chạy.
4. Mở MongoDB Compass và kết nối local:

```text
mongodb://localhost:27017
```

## Chạy bằng MongoDB Compass

Phiên bản Compass hiện tại của team có thể hiển thị tab **Mongosh** thay vì **Playgrounds**. Cả hai đều chạy được JavaScript MongoDB; ưu tiên tab Mongosh nếu có.

1. Trong Compass, mở tab có biểu tượng `>_ mongosh`.
2. Ở dấu nhắc lệnh, dán lệnh sau rồi nhấn Enter:

```javascript
load("D:/Csharp/TOUR_DULICH/DPV.Analysis/DPV_TourDuLich_MONGODB_COMPASS_BOOTSTRAP.js")
```

3. Chờ thông báo:

```text
MongoDB bootstrap completed for: DPV_TourDuLich_Mongo
```

4. Kiểm tra dữ liệu bằng các lệnh:

```javascript
use DPV_TourDuLich_Mongo
db.getCollectionNames().sort()
db.roles.find({}, { _id: 0, code: 1, name: 1 })
```

Kết quả mong đợi: có 44 collection và `roles` có 6 document.

## Nếu Compass có Playground

1. Mở **Playgrounds** → **New Playground**.
2. Mở file bootstrap, sao chép toàn bộ nội dung vào Playground.
3. Bấm **Run**.
4. Refresh danh sách database và kiểm tra `DPV_TourDuLich_Mongo`.

Không dùng chức năng **Import Data** cho bootstrap này. Import Data chỉ nhận JSON/CSV cho một collection tại một thời điểm; nó không thể tạo nhiều collection, index và seed data trong cùng một thao tác.

## Quy tắc dữ liệu quan trọng

- Không lưu password, refresh token hoặc reset token dạng plaintext. Backend phải hash các giá trị này.
- Dùng `ObjectId` cho tham chiếu document; dùng mã nghiệp vụ riêng như `tourCode`, `departureCode`, `bookingCode` để hiển thị và tra cứu.
- Tiền dùng `Decimal128`, không dùng `double`.
- Thời gian lưu UTC và đổi sang múi giờ ở Backend/Frontend.
- Không tự tạo lại mô hình "một bảng SQL = một collection". Các danh sách nhỏ thuộc document cha được nhúng, ví dụ `bookings.passengers` và `departures.itinerary`.
- Register phải tạo đồng thời `accounts` + `customers` + `accountRoles` cho role `KHACH_HANG`.
- Booking, thanh toán và hoàn tiền là các luồng nhiều document; cần transaction và kiểm tra concurrency tại Backend.

## Lưu ý cho Backend

Backend hiện tại vẫn có cấu hình EF Core/MySQL cũ. Sau khi team thống nhất MongoDB, cần chuyển sang `MongoDB.Driver`; không tiếp tục dùng `UseMySql`, Pomelo hoặc `AppDbContext` cho chức năng mới.

Cấu hình đích dự kiến cho môi trường development là:

```json
{
  "MongoDb": {
    "ConnectionString": "mongodb://localhost:27017",
    "DatabaseName": "DPV_TourDuLich_Mongo"
  }
}
```

Đây là cấu hình định hướng; chỉ thêm vào Backend khi bắt đầu task chuyển driver MongoDB.

## Transaction local

MongoDB transaction nhiều document cần replica set. MongoDB chạy standalone vẫn đủ để mở Compass, tạo collection và xem seed data, nhưng chưa đủ để test đúng các luồng Register/Booking/Payment có transaction.

Khi bắt đầu code Auth và Booking, team cần chạy MongoDB local ở chế độ replica set hoặc dùng MongoDB Atlas/development cluster có replica set.

## Xử lý lỗi thường gặp

| Triệu chứng | Cách xử lý |
|---|---|
| `connect ECONNREFUSED 127.0.0.1:27017` | Khởi động MongoDB Server/service rồi kết nối lại Compass. |
| `load is not defined` | Mở tab Mongosh, không phải ô Filter của collection. Với Playground, dán toàn bộ nội dung file thay vì gọi `load`. |
| Không tìm thấy file bootstrap | Kiểm tra đúng đường dẫn `D:/Csharp/TOUR_DULICH/...`; không dùng dấu `\\` trong chuỗi JavaScript. |
| Database không thấy trong Compass | Bấm Refresh ở danh sách databases sau khi script chạy xong. |
| Muốn chạy lại script | Có thể chạy lại bình thường; script không drop database. |

## Reset database development

Chỉ dùng khi chắc chắn muốn xóa toàn bộ dữ liệu local development:

```javascript
use DPV_TourDuLich_Mongo
db.dropDatabase()
```

Sau đó chạy lại bootstrap. Không dùng lệnh này trên database dùng chung, staging hoặc production.

## Checklist trước khi báo hoàn thành

- [ ] Compass kết nối được MongoDB.
- [ ] `DPV_TourDuLich_Mongo` xuất hiện trong danh sách database.
- [ ] Có 44 collections.
- [ ] `roles` có 6 role: `ADMIN`, `QUAN_LY_TONG`, `TRUONG_BAN`, `HDV`, `NHAN_VIEN`, `KHACH_HANG`.
- [ ] `tourTypes` được tạo nhưng chưa có seed data nếu danh mục chưa được nghiệp vụ chốt.
- [ ] Không dùng database `DPV_TourDuLich` cũ cho code MongoDB mới.
