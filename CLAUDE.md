# Blockchain VIP - Marketplace E-commerce

## Mục tiêu dự án

Xây dựng một sàn thương mại điện tử (marketplace) phi tập trung trên nền tảng blockchain Ethereum. Người mua và người bán giao dịch trực tiếp thông qua smart contract với cơ chế escrow bảo vệ cả hai bên.

**MVP nhắm tới:** Demo hoạt động trên mobile (Android/iOS) kết nối Ethereum Sepolia testnet.

## Kiến trúc

```
Blockchain_vip/
├── contracts/          # Smart contract Solidity + Hardhat
│   └── contracts/Marketplace.sol
├── blockchain_flutter/ # Mobile app Flutter
│   └── lib/
│       ├── main.dart
│       ├── marketplace_service.dart
│       ├── marketplace_abi.dart
│       └── config.dart
└── docs/               # Specs và plans
```

### Smart Contract (Solidity)

- **Framework:** Hardhat 3 + hardhat-toolbox-viem
- **Solidity:** 0.8.28 với optimizer
- **Network:** Localhost (dev), Sepolia (testnet)
- **Chức năng chính:**
  - `createProduct` - Seller tạo sản phẩm với metadataURI + giá ETH
  - `buyProduct` - Buyer mua sản phẩm, ETH giữ trong escrow
  - `markShipped` - Seller xác nhận đã gửi hàng
  - `completeOrder` - Buyer xác nhận nhận hàng, giải phóng escrow
  - `withdraw` - Seller rút tiền đã được giải phóng

### Mobile App (Flutter)

- **Framework:** Flutter (Dart SDK ^3.11.5)
- **State management:** flutter_riverpod
- **Blockchain:** web3dart
- **Kết nối:** HTTP RPC tới Hardhat localhost node
- **Giao diện:** Dark theme, Material Design

## Lệnh thường dùng

```bash
# Smart contract
cd contracts
npm run compile          # Compile Solidity
npm run test             # Chạy contract tests
npm run deploy:local     # Deploy lên localhost
npm run deploy:sepolia   # Deploy lên Sepolia testnet

# Flutter app
cd blockchain_flutter
flutter run              # Chạy app
flutter test             # Chạy tests
```

## Luồng hoạt động chính

1. **Seller tạo listing:** Kết nối ví → Nhập metadata URI + giá → Gọi `createProduct`
2. **Buyer mua hàng:** Xem marketplace → Chọn sản phẩm → Gọi `buyProduct` (ETH vào escrow)
3. **Hoàn tất đơn hàng:** Seller `markShipped` → Buyer `completeOrder` → Seller `withdraw`

## Quy ước

- Contract sử dụng custom errors thay vì require strings
- Metadata sản phẩm (ảnh, mô tả) lưu off-chain qua URI (IPFS hoặc URL)
- Dev mode dùng private keys từ Hardhat accounts (không dùng cho production)
- Order status flow: Paid → Shipped → Completed (không quay lại)

## Phạm vi MVP

**Bao gồm:**
- Kết nối ví (dev mode: private key trực tiếp)
- Marketplace feed hiển thị sản phẩm
- Tạo listing, mua hàng, quản lý đơn hàng
- Escrow đơn giản

**Không bao gồm:**
- Thanh toán fiat
- Deploy mainnet
- Ví custody trong app
- Admin dashboard
- Tích hợp vận chuyển
- Lưu trữ file on-chain
