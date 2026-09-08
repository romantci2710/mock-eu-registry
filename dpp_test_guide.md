# 🇪🇺 Kịch Bản Thử Nghiệm DPP Registry
## Hướng dẫn step-by-step cho người dùng — 100% trên giao diện web

---

## 📋 Thông tin chung

| Mục | Chi tiết |
|-----|----------|
| **Hệ thống** | Mock EU Digital Product Passport Registry |
| **Dashboard URL** | `http://localhost:3333/dpp-test-dashboard.html` |
| **Thời gian ước tính** | 15-20 phút |
| **Yêu cầu** | Docker đang chạy, trình duyệt Chrome/Edge |

---

## 🚀 Chuẩn bị trước khi test

Đảm bảo hệ thống đã khởi động bằng cách mở PowerShell và chạy:
```
docker compose up -d
```
Sau đó mở trình duyệt và truy cập: **http://localhost:3333/dpp-test-dashboard.html**

---

## Bước 1: Kiểm tra hệ thống

> **Mục đích:** Xác nhận tất cả dịch vụ (API, Database, Keycloak) đang hoạt động

**Thao tác:**
1. Mở Dashboard — hệ thống tự động kiểm tra
2. Nhấn nút **"Kiem tra tat ca"** nếu cần
3. Kiểm tra kết quả:
   - ✅ **API Server**: phải hiện `UP`
   - ✅ **JWKS**: phải hiện số keys
   - ✅ **Keycloak**: phải hiện `Realm=dpp-registry`

**Kết quả mong đợi:** Tất cả 3 mục hiện **OK** (màu xanh)

![Screenshot hệ thống kiểm tra](file:///C:/Users/Welcome/.gemini/antigravity-ide/brain/c2e05827-29c1-427e-b37a-1e419abe4d86/step1_system_check_1788770723973.png)

---

## Bước 2: Đăng nhập (Lấy Access Token)

> **Mục đích:** Xác thực danh tính qua Keycloak OIDC — mô phỏng Economic Operator đăng nhập

**Thao tác:**
1. Nhấn **"Dang nhap (Token)"** ở thanh bên trái
2. Chọn tài khoản **"Economic Operator (eo-user)"** (đã chọn sẵn)
3. Nhấn nút **"Dang nhap"**

**Kết quả mong đợi:**
- Góc phải header hiện **"eo-user (OK)"** với chấm 🟢
- Kết quả hiện: User, Name, Email, Roles (`registry-eo`), Token expiry

![Screenshot đăng nhập thành công](file:///C:/Users/Welcome/.gemini/antigravity-ide/brain/c2e05827-29c1-427e-b37a-1e419abe4d86/step2_login_1788770774249.png)

> [!TIP]
> **3 loại tài khoản có thể thử:**
> - `eo-user` (Economic Operator): đăng ký/cập nhật DPP
> - `admin-user` (Admin): toàn quyền
> - `eu-user` (End User): chỉ đọc

---

## Bước 3: Xem JSON Schema *(tùy chọn)*

> **Mục đích:** Xem cấu trúc dữ liệu DPP — các trường bắt buộc khi đăng ký

**Thao tác:**
1. Nhấn **"Xem JSON Schema"** ở thanh bên
2. Nhấn nút **"Xem Schema"**

**Kết quả mong đợi:**
- Hiện JSON Schema với `title`, `required` fields
- Các trường bắt buộc: `upi, reoId, facilitiesId, liveURL, backupURL, commodityCode, granularityLevel`

> [!NOTE]
> Schema endpoint yêu cầu role **ADMIN** hoặc **EU**. Nếu đăng nhập với `eo-user`, bước này sẽ trả lỗi 403 — đây là hành vi đúng theo phân quyền.

---

## Bước 4: Đăng ký MODEL DPP ⭐

> **Mục đích:** Đăng ký cấp cao nhất — đại diện cho một dòng sản phẩm

**Thao tác:**
1. Nhấn **"Dang ky MODEL DPP"** ở thanh bên
2. Các trường đã điền sẵn dữ liệu mẫu:
   - **UPI**: `urn:epc:id:sgtin:0614141.107346.MODEL001`
   - **REO ID**: `LEI-529900T8BM49AURSDO55` (mã nhà sản xuất)
   - **Commodity Code**: `85176200` (mã hàng hóa HS)
3. Nhấn nút **"Dang ky MODEL"**

**Kết quả mong đợi:**
- Khung kết quả **màu xanh** hiện thông tin:
  - `Registry ID`: UUID duy nhất (ví dụ: `544d4dff-aa94-...`)
  - `Created`: timestamp
  - `DPP Hash`: SHA-256 hash

> [!IMPORTANT]
> **Ghi nhớ Registry ID** — cần dùng cho bước tra cứu và lấy Proof!

---

## Bước 5: Đăng ký BATCH DPP

> **Mục đích:** Đăng ký cấp lô hàng — liên kết với MODEL đã đăng ký

**Thao tác:**
1. Nhấn **"Dang ky BATCH DPP"** ở thanh bên
2. Kiểm tra **Model UPI** trùng với MODEL đã đăng ký ở Bước 4
3. Nhấn nút **"Dang ky BATCH"**

**Kết quả mong đợi:** Tương tự Bước 4 — hiện Registry ID mới cho BATCH

---

## Bước 6: Đăng ký ITEM DPP

> **Mục đích:** Đăng ký cấp đơn vị sản phẩm — liên kết với cả MODEL và BATCH

**Thao tác:**
1. Nhấn **"Dang ky ITEM DPP"** ở thanh bên
2. Kiểm tra:
   - **Model UPI** trùng với Bước 4
   - **Batch UPI** trùng với Bước 5
   - **Deactivated**: "Khong — Dang hoat dong"
3. Nhấn nút **"Dang ky ITEM"**

**Kết quả mong đợi:** Registry ID mới + DPP Hash cho ITEM

> [!NOTE]
> Sau 3 bước đăng ký, hệ thống đã tạo cấu trúc phân cấp:
> ```
> MODEL (dòng sản phẩm)
>   └── BATCH (lô hàng)
>       └── ITEM (sản phẩm đơn lẻ)
> ```

---

## Bước 7: Tra cứu DPP đã đăng ký

> **Mục đích:** Xác nhận dữ liệu đã lưu đúng trong database

**Thao tác:**
1. Nhấn **"Tra cuu DPP"** ở thanh bên
2. **Cách 1:** Nhấn **"Xem tat ca DPP"** — liệt kê toàn bộ 3 entries
3. **Cách 2:** Nhập Registry ID → nhấn **"Tra cuu"** — xem chi tiết 1 entry

**Kết quả mong đợi:**
- Bảng hiện 3 entries: MODEL, BATCH, ITEM
- Mỗi entry có Registry ID và trạng thái "Registered"

---

## Bước 8: Lấy Proof of Registration

> **Mục đích:** Lấy chứng nhận đăng ký — JWT được ký bằng private key của registry

**Thao tác:**
1. Nhấn **"Proof of Registration"** ở thanh bên
2. Registry ID đã được tự động điền từ bước trước
3. Nhấn **"Lay Proof"**
4. *(Tùy chọn)* Nhấn **"Xem JWKS Public Key"** để xem public key verify

**Kết quả mong đợi:**
- **JWT Header**: algorithm (RS256), key ID
- **JWT Payload**: issuer, registryId, registeredAt, commodityCode, dppHash
- **Expiry**: 10 năm từ ngày đăng ký

> [!TIP]
> Proof JWT có thể được verify bởi bất kỳ ai qua public key tại `http://localhost:8080/.well-known/jwks.json` — không cần đăng nhập!

---

## Bước 9: Cập nhật DPP (Update)

> **Mục đích:** Kiểm tra chức năng cập nhật — gửi lại cùng UPI sẽ update entry

**Thao tác:**
1. Nhấn **"Cap nhat DPP"** ở thanh bên
2. UPI giữ nguyên MODEL UPI
3. **Thay đổi Commodity Code** từ `85176200` → `85176299`
4. Nhấn **"Cap nhat DPP"**

**Kết quả mong đợi:**
- Cùng Registry ID nhưng **modifiedAt** thay đổi
- **DPP Hash** mới (vì dữ liệu đã thay đổi)

---

## Bước 10: Tổng kết

> **Mục đích:** Xem báo cáo tổng hợp toàn bộ kết quả thử nghiệm

**Thao tác:**
1. Nhấn **"Tong ket"** ở thanh bên
2. Nhấn **"Tao bao cao"**

**Kết quả mong đợi:**
- Báo cáo hiện **10/10 bước** hoàn thành (100%)
- Danh sách 3 DPP đã đăng ký (MODEL, BATCH, ITEM) với Registry ID

![Screenshot báo cáo tổng kết](file:///C:/Users/Welcome/.gemini/antigravity-ide/brain/c2e05827-29c1-427e-b37a-1e419abe4d86/step10_report_generated_1788771116698.png)

---

## 🎥 Video Demo

![Video demo toàn bộ workflow](file:///C:/Users/Welcome/.gemini/antigravity-ide/brain/c2e05827-29c1-427e-b37a-1e419abe4d86/dpp_full_demo_1788770703432.webp)

---

## ✅ Checklist Kết quả

| # | Bước | Kết quả mong đợi |
|---|------|-------------------|
| 1 | Kiểm tra hệ thống | 3/3 dịch vụ OK |
| 2 | Đăng nhập | Token + roles hiển thị |
| 3 | Xem Schema | JSON Schema với required fields |
| 4 | Đăng ký MODEL | Registry ID + DPP Hash |
| 5 | Đăng ký BATCH | Registry ID (liên kết MODEL) |
| 6 | Đăng ký ITEM | Registry ID (liên kết MODEL + BATCH) |
| 7 | Tra cứu | 3 entries hiển thị đúng |
| 8 | Proof | JWT với header + payload |
| 9 | Cập nhật | modifiedAt thay đổi |
| 10 | Tổng kết | 10/10 bước hoàn thành |
