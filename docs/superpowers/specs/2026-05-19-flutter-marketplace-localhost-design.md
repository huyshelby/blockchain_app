# Flutter Marketplace App — Hardhat Localhost Design

## Goal

Build a Flutter mobile app that connects to the existing Marketplace smart contract running on Hardhat localhost network. Uses private keys directly from Hardhat node for development — no WalletConnect or MetaMask needed.

## Scope

**Included:**
- Direct connection to Hardhat node at `http://10.0.2.2:8545` (Android emulator) / `http://127.0.0.1:8545` (iOS sim/desktop)
- Hardhat account switching (seller/buyer) via built-in private keys
- Marketplace feed showing active products
- Create product listing
- Buy product with escrow
- Order lifecycle: mark shipped, complete order, withdraw funds
- Contract ABI generated from Hardhat artifacts

**Excluded:**
- WalletConnect / MetaMask integration (future phase)
- Mainnet or testnet deployment
- IPFS metadata resolution (use static demo metadata)
- Image upload
- Push notifications

## Architecture

```
Flutter App
  ├── Screens (UI)
  ├── State (Riverpod providers)
  └── MarketplaceService (web3dart)
        │
        │ JSON-RPC
        ▼
  Hardhat Node (localhost)
  └── Marketplace.sol deployed
```

## Tech Stack

- **Flutter** (existing `blockchain_flutter/` project)
- **web3dart** — Ethereum client for Dart
- **http** — HTTP client for JSON-RPC
- **flutter_riverpod** — state management
- **Hardhat** — local blockchain + contract deployment

## Screens

### 1. Home (Marketplace Feed)
- Lists all active products from contract
- Shows name, price (ETH), category
- Tap to view details

### 2. Create Listing
- Input: metadata URI, price in ETH
- Calls `createProduct(metadataURI, price)` with seller account
- Shows transaction hash on success

### 3. Product Detail
- Shows product info + seller address
- "Buy" button calls `buyProduct(productId)` with buyer account
- Shows transaction status

### 4. Orders
- Input order ID to load order details
- Action buttons: Mark Shipped, Complete Order, Withdraw
- Each calls the respective contract function

### 5. Settings / Account Switcher
- Toggle between Hardhat accounts (account #0 = seller, account #1 = buyer)
- Shows current address and ETH balance
- Displays connected contract address

## Data Flow

### Seller creates listing
1. User selects seller account in Settings
2. Opens Create Listing, enters metadata URI + price
3. App calls `createProduct()` via web3dart with seller private key
4. Contract emits `ProductCreated` event
5. Home screen refreshes product list

### Buyer purchases
1. User switches to buyer account
2. Opens product detail, taps Buy
3. App calls `buyProduct()` with exact ETH value
4. Contract creates order in `Paid` status, holds ETH in escrow

### Escrow completion
1. Seller calls `markShipped(orderId)` → status becomes `Shipped`
2. Buyer calls `completeOrder(orderId)` → status becomes `Completed`, seller balance credited
3. Seller calls `withdraw()` → receives ETH

## Configuration

Hardhat default accounts used for dev:
- Account #0 (seller): first private key from `npx hardhat node` output
- Account #1 (buyer): second private key from `npx hardhat node` output
- RPC URL: `http://10.0.2.2:8545` (Android) or `http://127.0.0.1:8545` (desktop/iOS)
- Contract address: set after running deploy script

## Error Handling

- RPC connection failure → show "Cannot connect to Hardhat node" message
- Transaction revert → parse custom error name from contract and display
- Invalid input (empty URI, zero price) → client-side validation before sending tx

## Testing Strategy

- Contract tests already exist (Hardhat test suite)
- Flutter app tested manually against running Hardhat node
- Golden path: deploy → create listing → buy → ship → complete → withdraw

## Dependencies to Add

```yaml
dependencies:
  web3dart: ^2.7.3
  http: ^1.2.0
  flutter_riverpod: ^2.5.0

dev_dependencies:
  build_runner: ^2.4.0
```
