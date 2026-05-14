<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Riverpod-3.x-red?logo=dart" alt="Riverpod">
  <img src="https://img.shields.io/badge/GoRouter-17.x-green?logo=dart" alt="GoRouter">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</div>

<br/>

<div align="center">
  <h1>HELMO — Helmet Shop Mobile App</h1>
  <p>Ứng dụng di động bán mũ bảo hiểm trực tuyến, được xây dựng bằng Flutter với kiến trúc Clean Architecture + Riverpod.</p>
</div>

---

## ✨ Tính năng

### 🟢 Đã hoàn thành (MVP)

| Tính năng | Mô tả |
|-----------|-------|
| 🏠 **Trang chủ** | Banner slider, danh mục, sản phẩm nổi bật, khuyến mãi |
| 📱 **Chi tiết sản phẩm** | Chọn kích cỡ, màu sắc, số lượng, thêm giỏ hàng, mua ngay |
| 🛒 **Giỏ hàng** | Thêm/xóa/sửa sản phẩm, cập nhật số lượng, tổng tiền |
| 📁 **Danh mục & Bộ lọc** | Lọc theo danh mục, thương hiệu, màu sắc, khoảng giá |
| 🔍 **Tìm kiếm** | Debounce 300ms, gợi ý, lịch sử, kết quả dạng lưới |
| 🔃 **Sắp xếp** | Mới nhất, giá tăng/giảm, bán chạy |
| 🔑 **Xác thực** | Splash screen kiểm tra token (sẵn sàng kết nối API) |

### 🔵 Đang phát triển

- 💳 **Thanh toán (Checkout)** — Địa chỉ, phương thức thanh toán
- ✅ **Xác nhận đơn hàng** — Animation success + thông tin đơn
- 🔑 **Đăng nhập / Đăng ký** — Form validate + JWT token

### 🟣 Kế hoạch tương lai

- ❤️ Yêu thích (Wishlist)
- ⭐ Đánh giá sản phẩm
- 🎫 Mã giảm giá
- 🌙 Dark Mode
- 🔔 Push Notification

---

## 🏗 Kiến trúc

```
UI Layer (Screens / Widgets)
    ↓  ref.watch() / ref.read()
Provider Layer (Riverpod)
    ↓  gọi
Repository Layer
    ↓  gọi
Service Layer (Dio / Hive)
    ↓  gọi
API / Local DB
```

**Nguyên tắc:** Screen → Provider → Repository → Service → API

### Công nghệ sử dụng

| Layer | Công nghệ |
|-------|-----------|
| **State Management** | Riverpod 3.x (Notifier, FutureProvider, Provider) |
| **Navigation** | GoRouter 17.x (ShellRoute cho BottomNav) |
| **Networking** | Dio 5.x (Interceptor, timeout, retry) |
| **Local Storage** | Hive + Flutter Secure Storage |
| **Image Caching** | CachedNetworkImage |
| **Code Generation** | Freezed + JsonSerializable |
| **Loading** | Shimmer effect |

---

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart                        # Entry point + ProviderScope
├── config/
│   ├── app_config.dart              # Hằng số, API URL, timeout
│   ├── app_theme.dart               # Colors, TextStyles, Spacing
│   └── router.dart                  # GoRouter + ShellRoute
├── models/                          # Data models (Product, CartItem)
├── services/
│   └── api_service.dart             # Dio HTTP client
├── repositories/
│   └── product_repository.dart      # Data operations (filter, sort, search)
├── providers/
│   ├── home_provider.dart           # Mock data + Riverpod providers
│   ├── cart_provider.dart           # Cart state (Notifier)
│   ├── filter_provider.dart         # Filter criteria
│   └── search_provider.dart         # Search with debounce
├── screens/
│   ├── splash/                      # Splash screen
│   ├── home/                        # Trang chủ
│   ├── product/                     # Chi tiết sản phẩm
│   ├── cart/                        # Giỏ hàng
│   ├── category/                    # Danh mục + bộ lọc
│   └── search/                      # Tìm kiếm
└── widgets/
    └── common/
        └── badge_icon.dart          # Icon kèm badge
```

---

## 🚀 Hướng dẫn chạy

### Yêu cầu

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5

### Cài đặt

```bash
# Clone repository
git clone https://github.com/ldchinh2114/HelmetMobileApp.git
cd HelmetMobileApp

# Cài đặt dependencies
flutter pub get

# Kiểm tra lỗi
dart analyze

# Chạy ứng dụng
flutter run
```

### Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📱 Màn hình

| Màn hình | Route | Mô tả |
|----------|-------|-------|
| Splash | `/splash` | Logo + loading → tự động chuyển Home |
| Trang chủ | `/home` | Banner, danh mục, sản phẩm, khuyến mãi |
| Danh mục | `/category` | Chip danh mục + sort + bộ lọc + grid |
| Giỏ hàng | `/cart` | Danh sách, số lượng, tổng tiền |
| Tìm kiếm | `/search` | Debounce, gợi ý, lịch sử, kết quả |
| Chi tiết SP | `/product/:id` | Size/màu, số lượng, thêm giỏ, mua ngay |

### Bottom Navigation

| Tab | Route | Icon |
|-----|-------|------|
| Trang chủ | `/home` | 🏠 |
| Danh mục | `/category` | 📁 |
| Giỏ hàng | `/cart` | 🛒 |
| Yêu thích | `/wishlist` | ❤️ |
| Tài khoản | `/profile` | 👤 |

---

## 🧪 Kiểm thử

```bash
# Chạy tất cả test
flutter test

# Kiểm tra phân tích code
dart analyze
```

---

##  Giấy phép

Dự án được phân phối dưới giấy phép MIT. Xem [LICENSE](LICENSE) để biết thêm chi tiết.