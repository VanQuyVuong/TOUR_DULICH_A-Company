# DPV Travel - Nền tảng Quản lý & Đặt Tour Du lịch Trực tuyến (DPV Company)

Dự án **DPV Travel** là hệ thống quản lý và đặt tour du lịch đa nền tảng (Web, Desktop, Mobile) dành riêng cho **Công ty Du lịch DPV**. Hệ thống đột phá với mô hình đặt tour linh hoạt lấy **Hướng dẫn viên (HDV)** làm trung tâm, giúp tối ưu hóa công tác điều hành nhân sự, nâng cao trải nghiệm khách hàng và quản lý toàn bộ quy trình vận hành du lịch khép kín.

Dự án được xây dựng theo kiến trúc **Monorepo** bao gồm toàn bộ các ứng dụng client (Web, Desktop, Mobile), Backend API và cơ sở dữ liệu.

---

## 🎯 Điểm Sáng Nghiệp Vụ: 3 Mô Hình Chọn Tour & HDV

Hệ thống hỗ trợ 3 mô hình chọn tour linh hoạt đáp ứng đa dạng nhu cầu của khách hàng và tối ưu lịch làm việc của HDV:

1. **Mô hình 1 (Tour cố định HDV):** Áp dụng cho các tour đặc thù/VIP. HDV được Admin ấn định cố định ngay khi tạo lịch khởi hành.
2. **Mô hình 2 (Tour chọn HDV linh hoạt):** Áp dụng cho các tour phổ thông. Khách chọn Tour → Xem danh sách HDV được đề xuất cho tour đó → Lựa chọn HDV ưa thích.
3. **Mô hình 3 (Guide-First - Đặt tour theo HDV):** Khách chọn HDV ưa thích trước → Xem danh sách các Tour sắp khởi hành do HDV đó dẫn → Tiến hành đặt lịch.

---

## 🚀 Công nghệ sử dụng

Tất cả các công nghệ, framework và thư viện được sử dụng trong dự án đều cập nhật các phiên bản mới nhất:

* **Backend API:** .NET 10.0 (C# ASP.NET Core Web API), Entity Framework Core 9.0, JWT Authentication, AutoMapper, FluentValidation, SignalR (Real-time notifications & GPS).
* **Frontend Web (Client & Dashboard):** React 19 (Vite), Tailwind CSS v4, React Router v7, Lucide React / React Icons, TanStack Query (React Query v5), Axios.
* **Desktop App (Điều hành & Quản trị nội bộ):** WPF (.NET 10.0 / C#), MaterialDesignInXamlToolkit, CommunityToolkit.Mvvm.
* **Mobile App (Dành cho Khách hàng & HDV):** React Native (Expo SDK 52+ / CLI), React Navigation v7, Tailwind CSS (NativeWind v4).
* **Database:** MySQL 8.4 LTS / 9.x.

---

## 📁 Cấu trúc thư mục (Monorepo)

```text
DPV-Travel-Project/
├── DPV.Backend/           # ASP.NET Core Web API 9.0 (C#)
├── DPV.Web/               # Web Portal & Admin Dashboard (React + Tailwind CSS)
├── DPV.Desktop/           # App Quản trị & Điều hành nội bộ (WPF .NET 9)
├── DPV.Mobile/            # Mobile App cho Khách hàng & HDV (React Native)
├── *.sql                  # Scripts khởi tạo CSDL và Seed Data ở thư mục gốc
└── README.md              # Tài liệu hướng dẫn dự án
```

---
📦 Hướng dẫn Khởi chạy Ứng dụng
1. Chạy Backend API (.NET 10.0)
Cấu hình chuỗi kết nối MySQL trong DPV.Backend/appsettings.json:
```text
JSON
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=DPV_Travel_DB;User=root;Password=your_password;"
}
```
Truy cập thư mục backend và khởi chạy:
```text
Bash
cd DPV.Backend
dotnet restore
dotnet run
```
API Server sẽ chạy mặc định tại https://localhost:7123 hoặc http://localhost:5123 (xem Swagger UI tại /swagger).

2. Chạy Web App (React + Tailwind CSS)
Truy cập thư mục Web App và cài đặt dependencies:
```text
Bash
cd DPV.Web
npm install
```
Khởi chạy Server Dev:

```text
Bash
npm run dev
```
3. Chạy Mobile App (React Native)
Tất cả các bước bên dưới bạn sẽ thực hiện trong VS Code tại thư mục DPV.Mobile.

🛠️ Bước 1: Kiểm tra môi trường (Node.js)
Trước tiên, máy bạn cần có Node.js.

Mở VS Code -> Chọn File -> Open Folder... -> Chọn thư mục DPV.Mobile.

Mở Terminal trong VS Code bằng phím tắt Ctrl + ~ (hoặc vào menu Terminal -> New Terminal).

Gõ lệnh sau để kiểm tra:
```text
Bash
node -v
```
Nếu hiển thị phiên bản (ví dụ v18.x.x hoặc v20.x.x) là OK.

Nếu báo lỗi không tìm thấy command, bạn hãy tải và cài đặt Node.js LTS tại: nodejs.org.

🚀 Bước 2: Khởi tạo dự án Expo
Ngay tại Terminal của folder DPV.Mobile trong VS Code, bạn chạy lệnh:
```text
Bash
npx create-expo-app@latest .
```
Lưu ý: Dấu chấm . ở cuối lệnh có nghĩa là khởi tạo dự án ngay tại thư mục hiện tại (DPV.Mobile) chứ không tạo thêm một thư mục con mới.

Nếu hệ thống hỏi Ok to proceed? (y), bạn gõ y rồi ấn Enter.

Chờ khoảng 1 - 2 phút để Expo tự động tải và cài đặt các thư viện cần thiết.

📱 Bước 3: Chạy thử ứng dụng (Run App)
Sau khi cài đặt xong, tại Terminal bạn gõ lệnh:
```text
Bash
npx expo start
```
Trên Terminal sẽ xuất hiện một mã QR Code lớn màu đen trắng.
4. Chạy Desktop App (WPF)
Mở giải pháp DPV.sln bằng Visual Studio 2022 (đã cài workload .NET Desktop Development).

Set project DPV.Desktop làm Startup Project và bấm F5 để Build & Run.

🔌 Danh Sách Phân Công API Endpoints
Dưới đây là danh sách phân chia các API Endpoints cho hệ thống DPV Travel dựa trên vai trò (Roles) cụ thể.

🔑 1. Auth & Shared (API Chung)
```text
Các API cơ bản liên quan đến xác thực và thông tin tài khoản dùng chung.

POST /api/auth/register: Đăng ký tài khoản Khách hàng.

POST /api/auth/login: Đăng nhập hệ thống (Cấp JWT Token).

POST /api/auth/logout: Đăng xuất (Blacklist token).

POST /api/auth/forgot-password & /api/auth/reset-password: Quên và khôi phục mật khẩu.

GET / PUT /api/users/profile: Xem và cập nhật hồ sơ cá nhân.

PUT /api/users/change-password: Đổi mật khẩu.

POST /api/upload/image: API dùng chung upload hình ảnh (Avatar, ảnh Tour, Chứng chỉ HDV).
```
🧳 2. Customer - Khách Hàng (Web / Mobile)
```text
Các tính năng đặt tour linh hoạt theo 3 mô hình chọn Tour & HDV.

GET /api/tours/search: Tìm kiếm & Lọc tour (Địa điểm, ngân sách, ngày đi, loại hình tour).

GET /api/tours/:id: Xem chi tiết Tour & Lịch trình từng ngày.

GET /api/tours/:id/schedules: Lấy danh sách Lịch khởi hành khả dụng của Tour.

GET /api/guides: Xem danh sách Hướng dẫn viên (Lọc theo kinh nghiệm, ngôn ngữ, đánh giá).

GET /api/guides/:id/upcoming-tours: [Mô hình Guide-First] Lấy danh sách Tour gần nhất mà HDV đó chuẩn bị dẫn.

POST /api/bookings: Tạo đơn đặt tour mới (chọn Mô hình HDV cố định hoặc chọn HDV từ danh sách đề xuất).

GET /api/bookings/my-bookings: Xem lịch sử và danh sách tour đã đặt.

GET /api/bookings/:id: Chi tiết đơn đặt vé (Xem Vé điện tử, Mã QR check-in).

PUT /api/bookings/:id/cancel: Yêu cầu hủy tour (tính phí theo quy định).

POST /api/payments/vietqr/create: Tạo mã VietQR động chứa mã đặt tour và số tiền tự động.

POST /api/payments/callback: Webhook cập nhật tự động trạng thái thanh toán.

POST /api/reviews: Đánh giá & Viết bình luận về Tour và HDV sau chuyến đi.
```
🚩 3. Tour Guide - Hướng Dẫn Viên (Mobile / Web)
```text
Nghiệp vụ dành cho HDV quản lý lịch làm việc và đăng ký nhận tour tự do.

GET /api/guide/my-schedules: Xem lịch trình các tour được phân công/đã được duyệt dẫn.

GET /api/guide/available-schedules: Xem danh sách các tour đang trống HDV trong thời gian rảnh.

POST /api/guide/schedules/:id/apply: Gửi yêu cầu đăng ký nhận dẫn tour (chờ Admin duyệt).

GET /api/guide/schedules/:id/passengers: Xem danh sách và thông tin liên hệ khách hàng trong đoàn.

POST /api/guide/schedules/:id/check-in: Quét mã QR code để điểm danh khách hàng lên xe/đoàn.

PUT /api/guide/schedules/:id/status: Cập nhật trạng thái chuyến đi (Bắt đầu, Đến điểm tham quan, Hoàn thành).
```
🏢 4. Admin & Điều Hành (WPF Desktop / React Dashboard)
```text
Quản trị toàn diện thông tin Tour, phân công HDV và báo cáo vận hành công ty.

POST / PUT / DELETE /api/admin/tours: Quản lý danh mục Tour, thông tin chi tiết và lịch trình từng ngày.

POST / PUT / DELETE /api/admin/schedules: Tạo Lịch khởi hành, thiết lập mô hình gán HDV (Fixed Guide / Flex Guide Pool).

GET /api/admin/guide-requests: Xem danh sách yêu cầu đăng ký tour của các HDV.

PUT /api/admin/guide-requests/:id/approve: Phê duyệt hoặc từ chối yêu cầu đăng ký tour của HDV.

PUT /api/admin/schedules/:id/assign-guide: Phân công/Đổi HDV trực tiếp cho Lịch khởi hành.

GET / PUT /api/admin/users: Quản lý người dùng, phân quyền (Customer, Guide, Admin).

GET /api/admin/analytics/revenue: Báo cáo doanh thu theo tháng/quý/năm.

GET /api/admin/analytics/guides: Thống kê hiệu suất, số lượng tour và đánh giá chất lượng HDV.
```
```text
Phát triển bởi: DPV Team | Cập nhật lần cuối: Tháng 07/2026
```
