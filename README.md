<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Riverpod-3.x-red?logo=dart" alt="Riverpod">
  <img src="https://img.shields.io/badge/GoRouter-17.x-green?logo=dart" alt="GoRouter">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</div>

<br/>

<div align="center">
  <h1>HELMO — Helmet Shop Mobile App</h1>
  <p>Ứng dụng mua mũ bảo hiểm trực tuyến, xây dựng bằng Flutter + Riverpod, với ngôn ngữ thiết kế <b>light · classic</b>.</p>
</div>

---

## 📸 Giao diện

Thiết kế mới theo phong cách **classic**: nền giấy ngà ivory, đường kẻ hairline thay cho
đổ bóng, chữ serif (Playfair Display) cho tiêu đề và giá, chữ sans (Inter) cho nội dung,
màu nhấn **burgundy** đậm và điểm nhấn **antique gold**. Ảnh sản phẩm được **vẽ bằng
code** (CustomPainter) nên luôn hiển thị đúng, kể cả khi offline.

| | |
|---|---|
| 🎨 Bảng màu | Burgundy `#7C2233` · Gold `#B08D57` · Ivory `#FBF8F4` · Ink `#2B2723` |
| 🔤 Chữ | Playfair Display (serif) + Inter (sans) — **bundle sẵn** trong `assets/fonts` |
| 📏 Quy cách | Hairline 1px, bo góc 2–4px, nút in hoa + letter-spacing |
| 🎬 Chuyển động | Fade-rise cho route, reveal so lech nhau, marker vàng ở bottom nav |

---

## ✨ Tính năng

### 🟢 Đã hoàn thành

| Tính năng | Mô tả |
|-----------|-------|
| 🏠 **Trang chủ** | Banner tự chạy, danh mục nổi bật, sản phẩm bán chạy, ưu đãi, footer |
| 📱 **Chi tiết sản phẩm** | Chọn kích cỡ, màu sắc, số lượng, thêm giỏ hàng, mua ngay |
| 🛒 **Giỏ hàng** | Thêm/xóa/sửa sản phẩm, số lượng, tạm tính, xác nhận xóa tất cả |
| 📁 **Danh mục & Bộ lọc** | Lọc theo danh mục, thương hiệu, màu sắc, khoảng giá + sắp xếp |
| 🔍 **Tìm kiếm** | Debounce 300ms, gợi ý, lịch sử tìm kiếm, kết quả dạng lưới |
| ❤️ **Yêu thích** | Lưu sản phẩm, badge và màn hình riêng |
| 👤 **Tài khoản** | Hồ sơ, menu tài khoản, nhóm đơn hàng / hỗ trợ |
| 🗂 **Menu kéo** | Drawer với danh mục và lối vào nhanh |
| 🔔 **Badge giỏ hàng** | Số lượng hiển thị trên bottom nav và app bar |

### 🔵 Đang phát triển

- 💳 **Thanh toán (Checkout)** — địa chỉ, phương thức thanh toán
- ✅ **Xác nhận đơn hàng** — animation success + thông tin đơn
- 🔑 **Đăng nhập / Đăng ký** — form validate + JWT token (đã có khung route + nơi gắn token)

### 🟣 Kế hoạch tương lai

- ⭐ Đánh giá sản phẩm · 🎫 Mã giảm giá · 🌙 Dark mode · 🔔 Push notification

---

## 🏗 Kiến trúc

```
UI Layer (Screens / Widgets)
    ↓  ref.watch() / ref.read()
Provider Layer (Riverpod)
    ↓  gọi
Repository Layer
    ↓  gọi
Service Layer (Dio)
    ↓  gọi
API / Local DB
```

**Nguyên tắc:** Screen → Provider → Repository → Service → API

### Công nghệ sử dụng

| Layer | Công nghệ |
|-------|-----------|
| **State Management** | Riverpod 3.x (Notifier, NotifierProvider, FutureProvider) |
| **Navigation** | GoRouter 17.x (ShellRoute cho BottomNav, fade-rise cho page) |
| **Networking** | Dio 5.x (Interceptor, timeout) — chưa nối API |
| **Local Storage** | Hive + Flutter Secure Storage (khai báo, chưa dùng) |
| **Code Generation** | Freezed + JsonSerializable (khai báo, chưa dùng) |
| **Typography** | Playfair Display + Inter — bundle tại `assets/fonts` |
| **Artwork** | CustomPainter tự vẽ (`lib/widgets/common/product_artwork.dart`) |

> Hiện tại app chạy trên **mock data** (`lib/providers/home_provider.dart`,
> `lib/repositories/product_repository.dart`) — không cần mạng để chạy.

---

## 📁 Cấu trúc thương mục

```
lib/
├── main.dart                        # ProviderScope, MaterialApp.router, theme
├── config/
│   ├── app_config.dart              # API URL, timeout, designRevision
│   ├── app_motion.dart              # AppMotion: durations + curves
│   ├── app_theme.dart               # AppColors / AppTextStyles / Spacing / Radius / Borders
│   └── router.dart                  # GoRouter + AppShell + ClassicBottomNav
├── models/                          # Product, ProductCategory, BannerItem, CartItem
├── providers/                       # home, cart, filter, search, wishlist
├── repositories/                    # product_repository.dart (lọc / sắp xếp / tìm kiếm)
├── services/                        # api_service.dart (Dio client)
├── utils/                           # formatters.dart (formatCurrency, formatSoldCount)
├── screens/
│   ├── splash/  home/  category/  product/  cart/  search/  wishlist/  profile/
└── widgets/common/
    ├── badge_icon.dart              # Icon kèm badge
    ├── classic_ui.dart              # Bộ component dùng chung (Hairline, Eyebrow, Reveal…)
    └── product_artwork.dart         # Vẽ hình mũ bảo hiểm bằng CustomPainter

docs/                                # Tài liệu cho agent & developer
├── architecture.md  design-system.md  development.md
├── testing.md       troubleshooting.md  conventions.md
AGENTS.md                             # Hợp đồng làm việc cho AI agent
test/widget_test.dart
assets/fonts/                        # PlayfairDisplay.ttf, Inter.ttf
```

---

## 🚀 Hướng dẫn chạy

### Yêu cầu

- Flutter SDK ≥ 3.47 (pubspec yêu cầu Dart `^3.11.5`)
- Dart SDK ≥ 3.11.5

### Cài đặt

```bash
git clone https://github.com/ldchinh2114/HelmetMobileApp.git
cd HelmetMobileApp

flutter pub get
flutter analyze      # kỳ vọng: No issues found!
flutter test         # kỳ vọng: All tests passed!
flutter run
```

### Xem trên trình duyệt (nhanh nhất để kiểm tra giao diện)

```bash
flutter build web --release
python -m http.server 8099 --directory build/web
```

Mở `http://localhost:8099/?r=1#/home` — **nhớ đổi `?r=` sau mỗi lần build**, vì đổi
mỗi `#hash` sẽ không tải lại trang (xem `docs/troubleshooting.md`).

### Build

```bash
flutter build apk --release      # Android
flutter build ios --release      # iOS
flutter build web --release      # Web
```

---

## 📱 Màn hình

| Màn hình | Route | Mô tả |
|----------|-------|-------|
| Splash | `/splash` | Mark mũ + wordmark + progress → `/home` |
| Trang chủ | `/home` | Banner, tiện ích, danh mục, sản phẩm, ưu đãi, footer |
| Danh mục | `/category` | Chip danh mục + sort + bộ lọc + grid |
| Giỏ hàng | `/cart` | Danh sách, số lượng, tạm tính, thanh toán |
| Yêu thích | `/wishlist` | Sản phẩm đã lưu |
| Tài khoản | `/profile` | Hồ sơ + menu |
| Tìm kiếm | `/search` | Debounce, gợi ý, lịch sử, kết quả |
| Chi tiết SP | `/product/:id` | Size/màu, số lượng, thêm giỏ, mua ngay |
| Thanh toán | `/checkout` | Khung sẵn |
| Đăng nhập / Đăng ký | `/login`, `/register` | Khung sẵn |

### Bottom Navigation

| Tab | Route | Icon |
|-----|-------|------|
| Trang chủ | `/home` | 🏠 |
| Danh mục | `/category` | ▦ |
| Giỏ hàng | `/cart` | 🛒 (có badge) |
| Yêu thích | `/wishlist` | ♡ |
| Tài khoản | `/profile` | 👤 |

---

## 🧪 Kiểm thử

```bash
flutter test          # toàn bộ test
flutter analyze      # kiểm tra static analysis
```

Ngoài ra, mỗi thay đổi giao diện nên được **kiểm tra bằng mắt** trên bản build web —
xem checklist trong [`docs/testing.md`](docs/testing.md).

---

## 📚 Tài liệu

| Tài liệu | Nội dung |
|-----------|----------|
| [`AGENTS.md`](AGENTS.md) | Quy tắc làm việc bắt buộc cho AI agent |
| [`docs/architecture.md`](docs/architecture.md) | Kiến trúc, provider, routing, cách thêm màn hình |
| [`docs/design-system.md`](docs/design-system.md) | Màu, chữ, spacing, motion, component recipes |
| [`docs/development.md`](docs/development.md) | Cài đặt, chạy, build, xem trên trình duyệt |
| [`docs/testing.md`](docs/testing.md) | Chiến lược test + checklist kiểm tra thủ công |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | Các lỗi đã gặp và cách xử lý |
| [`docs/conventions.md`](docs/conventions.md) | Quy ước đặt tên, format, copy, commit |

---

## 📄 Giấy phép

Dự án được phân phối dưới giấy phép MIT. Xem [LICENSE](LICENSE) để biết thêm chi tiết.

> Fonts **Playfair Display** và **Inter** theo giấy phép SIL Open Font License 1.1.
