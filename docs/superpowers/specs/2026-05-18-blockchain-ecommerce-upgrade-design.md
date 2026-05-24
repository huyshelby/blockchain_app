# Blockchain E-commerce Platform — Upgrade Design Spec

## Overview

Nâng cấp hệ thống thương mại điện tử blockchain từ prototype (contract + mobile app cơ bản) thành hệ thống hoàn chỉnh với:
- Smart Contract nâng cao (escrow, events, IPFS metadata)
- Flutter mobile app cho buyer
- React web dashboard cho seller
- IPFS decentralized storage cho hình ảnh/metadata sản phẩm

**Mục tiêu:** Đồ án tốt nghiệp chuyên ngành CNPM — đáp ứng tiêu chí "ứng dụng công nghệ mới (Blockchain)" + "sản phẩm ứng dụng thực tế".

---

## Architecture

```
┌─────────────────────┐           ┌────────────────────────────┐
│  Buyer (Flutter)     │           │ Seller (React Vite + wagmi) │
│  WalletConnect/      │           │ MetaMask Extension /        │
│  MetaMask Mobile     │           │ WalletConnect               │
└──────────┬──────────┘           └─────────────┬──────────────┘
           │                                    │
           ▼                                    ▼
      ┌──────────────────────────────────────────────┐
      │         Smart Contract (Solidity)              │
      │  - Product listings (IPFS URI + price)         │
      │  - Purchase → Escrow (hold ETH)                │
      │  - Ship → Complete → Release funds             │
      │  - Withdraw (pull pattern)                     │
      │  - Events for indexing                         │
      └──────────────────────┬───────────────────────┘
                             │
                             ▼
                       ┌───────────┐
                       │   IPFS    │
                       │ (Pinata/  │
                       │  other)   │
                       └───────────┘
```

---

## Component 1: Smart Contract (Solidity)

**Status:** Đã implement cơ bản (Tasks 1-5 hoàn thành).

**Hiện có:**
- `createProduct(metadataURI, price)` — tạo sản phẩm
- `buyProduct(productId)` — mua, giữ ETH trong escrow
- `markShipped(orderId)` — seller đánh dấu đã gửi
- `completeOrder(orderId)` — buyer xác nhận nhận hàng
- `withdraw()` — seller rút tiền
- Events: ProductCreated, ProductPurchased, OrderShipped, OrderCompleted, SellerWithdrawal

**Nâng cấp (phase sau):**
- Dispute/refund mechanism (admin phân xử)
- ERC-20 token payment support
- On-chain rating system
- Product deactivation by seller

---

## Component 2: Flutter Mobile App (Buyer)

**Mục đích:** App cho người mua — duyệt sản phẩm, mua hàng, theo dõi đơn.

**Tech stack:**
- Flutter 3.x + Dart
- WalletConnect (web3modal_flutter)
- HTTP package cho IPFS metadata fetch

**Screens:**

### HomeScreen
- Danh sách sản phẩm đang bán (đọc từ contract events)
- Card hiển thị: hình ảnh (từ IPFS), tên, giá ETH
- Pull-to-refresh

### ProductDetailsScreen
- Hình ảnh lớn, mô tả đầy đủ (từ IPFS metadata)
- Giá, seller address (truncated)
- Nút "Buy with ETH" → gọi `buyProduct()`
- Hiển thị transaction hash sau khi mua

### OrdersScreen
- Danh sách đơn hàng của buyer (filter by buyer address từ events)
- Trạng thái: Paid → Shipped → Completed
- Nút "Confirm Received" → gọi `completeOrder()`

### WalletScreen
- Kết nối/ngắt ví MetaMask Mobile
- Hiển thị address, chain, balance
- Cảnh báo nếu không đúng network (Sepolia)

**Data flow:**
1. App đọc `ProductCreated` events từ contract → lấy danh sách productId
2. Với mỗi product, gọi `getProduct(id)` → lấy metadataURI
3. Fetch metadataURI từ IPFS → lấy name, description, image URL
4. Hiển thị cho user

---

## Component 3: Seller Dashboard (React Web)

**Mục đích:** Web app cho người bán — đăng sản phẩm, quản lý đơn hàng, rút tiền.

**Tech stack:**
- React 18+ (Vite)
- Tailwind CSS
- wagmi v2 + viem (wallet connection: MetaMask extension + WalletConnect)
- React Query (cache blockchain reads)
- Recharts hoặc Chart.js (thống kê)

**Pages:**

### Dashboard (trang chủ)
- Tổng quan: số sản phẩm, đơn hàng mới, doanh thu, số dư rút được
- Biểu đồ đơn hàng theo thời gian (từ events)
- Quick actions: tạo sản phẩm, rút tiền

### Products (quản lý sản phẩm)
- Bảng danh sách sản phẩm của seller
- Nút "Create Product" → form upload hình lên IPFS + đặt giá → gọi `createProduct()`
- Toggle active/inactive (contract cần thêm function)
- Edit metadata (upload lại IPFS, update URI on-chain nếu cần)

### Orders (quản lý đơn hàng)
- Bảng đơn hàng: orderId, buyer, amount, status, timestamp
- Filter theo status (Paid, Shipped, Completed)
- Nút "Mark Shipped" → gọi `markShipped()`
- Timeline chi tiết cho mỗi đơn (từ events)

### Finance (tài chính)
- Số dư withdrawable hiện tại
- Nút "Withdraw" → gọi `withdraw()`
- Lịch sử rút tiền (từ SellerWithdrawal events)
- Tổng doanh thu tích lũy

### Settings
- Hiển thị wallet address, network
- Link tới Etherscan profile

**Wallet connection flow:**
1. Seller mở web dashboard
2. Click "Connect Wallet" → wagmi modal (MetaMask extension hoặc WalletConnect QR)
3. Dashboard filter dữ liệu theo connected address (chỉ hiện sản phẩm/đơn của seller đó)

---

## Component 4: IPFS Integration

**Mục đích:** Lưu trữ phi tập trung cho metadata và hình ảnh sản phẩm.

**Provider:** Chọn sau (Pinata recommended).

**Metadata schema (JSON trên IPFS):**
```json
{
  "name": "Verified Smartphone",
  "description": "Brand new smartphone with warranty.",
  "image": "ipfs://QmImageHash...",
  "category": "Electronics",
  "attributes": {
    "condition": "New",
    "warranty": "12 months"
  }
}
```

**Flow upload (từ Seller Dashboard):**
1. Seller chọn hình ảnh → upload lên IPFS → nhận image CID
2. Tạo metadata JSON (bao gồm image CID) → upload lên IPFS → nhận metadata CID
3. Gọi `createProduct("ipfs://<metadataCID>", price)` on-chain

**Flow đọc (từ Buyer App):**
1. Đọc `metadataURI` từ contract
2. Fetch JSON từ IPFS gateway (ipfs.io hoặc Pinata gateway)
3. Parse name, description, image
4. Fetch image từ IPFS gateway
5. Hiển thị

---

## File Structure (dự kiến)

```
Blockchain_vip/
├── contracts/                    # Đã có
│   ├── contracts/Marketplace.sol
│   ├── test/Marketplace.ts
│   ├── scripts/deploy.ts
│   └── hardhat.config.ts
│
├── mobile/                       # Giữ lại (Expo) hoặc migrate
│   └── ...
│
├── blockchain_flutter/           # Flutter buyer app (mới/nâng cấp)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   │   └── product.dart
│   │   │   └── order.dart
│   │   ├── services/
│   │   │   └── marketplace_service.dart
│   │   │   └── ipfs_service.dart
│   │   │   └── wallet_service.dart
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   │   └── product_details_screen.dart
│   │   │   └── orders_screen.dart
│   │   │   └── wallet_screen.dart
│   │   └── widgets/
│   │       └── product_card.dart
│   │       └── order_tile.dart
│   └── pubspec.yaml
│
├── seller-dashboard/             # React web app (mới)
│   ├── src/
│   │   ├── main.tsx
│   │   ├── App.tsx
│   │   ├── config/
│   │   │   └── wagmi.ts
│   │   │   └── contract.ts
│   │   ├── hooks/
│   │   │   └── useProducts.ts
│   │   │   └── useOrders.ts
│   │   │   └── useBalance.ts
│   │   ├── pages/
│   │   │   └── DashboardPage.tsx
│   │   │   └── ProductsPage.tsx
│   │   │   └── OrdersPage.tsx
│   │   │   └── FinancePage.tsx
│   │   ├── components/
│   │   │   └── Layout.tsx
│   │   │   └── ProductForm.tsx
│   │   │   └── OrderTable.tsx
│   │   │   └── StatsCard.tsx
│   │   │   └── RevenueChart.tsx
│   │   └── lib/
│   │       └── ipfs.ts
│   │       └── abi.ts
│   ├── index.html
│   ├── tailwind.config.js
│   ├── vite.config.ts
│   ├── tsconfig.json
│   └── package.json
│
└── docs/
    └── superpowers/
        └── specs/
            └── 2026-05-18-blockchain-ecommerce-upgrade-design.md
```

---

## Implementation Order

1. **Phase 1: Contract hoàn thiện** — chạy tests pass, deploy Sepolia, verify trên Etherscan
2. **Phase 2: Seller Dashboard** — scaffold React Vite, wagmi setup, connect contract, CRUD products, manage orders, finance
3. **Phase 3: Flutter Buyer App** — migrate/rewrite từ Expo sang Flutter, WalletConnect, đọc products/orders từ contract
4. **Phase 4: IPFS Integration** — chọn provider, upload flow trong seller dashboard, fetch flow trong Flutter app
5. **Phase 5 (sau): Dispute/Refund** — thêm contract logic, admin role, UI cho dispute

---

## Out of Scope (làm sau hoặc không làm)

- Dispute/refund mechanism
- ERC-20 multi-token payment
- On-chain rating/review system
- Push notifications
- Backend API / database indexer
- Admin system-level dashboard
- Multi-language support

---

## Success Criteria

- [ ] Contract tests pass (10+ test cases)
- [ ] Contract deployed trên Sepolia, verified trên Etherscan
- [ ] Seller Dashboard: connect wallet, tạo sản phẩm, xem đơn, mark shipped, withdraw
- [ ] Flutter App: connect wallet, xem sản phẩm, mua, xem đơn, confirm received
- [ ] IPFS: upload hình + metadata từ seller dashboard, hiển thị trong Flutter app
- [ ] End-to-end flow demo: seller tạo → buyer mua → seller ship → buyer confirm → seller withdraw
