# Blockchain Mobile E-commerce Marketplace Design

## Goal

Build a cross-platform mobile e-commerce marketplace that uses Ethereum Sepolia smart contracts for marketplace state, purchases, and escrow. The first version targets a working demo on Android and iOS through Expo, with MetaMask Mobile handling wallet connection and transaction approval.

## Scope

The MVP includes:

- Buyer and seller wallet connection through MetaMask Mobile.
- Marketplace feed showing active products.
- Product detail screen.
- Seller flow for creating listings.
- Buyer checkout flow using Sepolia ETH.
- Buyer and seller order views.
- Simple escrow: buyer payment is held in the contract until order completion.

The MVP excludes:

- Real fiat payments.
- Production mainnet deployment.
- In-app wallet custody.
- Admin dashboards.
- Complex shipping carrier integrations.
- Full image/file storage on-chain.

## Architecture

### Mobile app

Use React Native with Expo so one codebase supports Android and iOS. The app connects to MetaMask Mobile through WalletConnect/AppKit and reads/writes blockchain data through an Ethereum RPC provider.

Primary screens:

- Home marketplace feed.
- Product details.
- Create listing.
- Wallet/account.
- Checkout confirmation.
- My purchases.
- My sales.

### Smart contract

Use Solidity for a Sepolia marketplace contract. The contract stores marketplace records and controls escrowed ETH.

Core entities:

- Seller profile: wallet address and optional metadata URI.
- Product: ID, seller, metadata URI, ETH price, active status.
- Order: ID, product ID, buyer, seller, paid amount, and status.

Order statuses:

- `Paid`: buyer has paid and funds are escrowed.
- `Shipped`: seller marked the item shipped.
- `Completed`: buyer confirmed completion and seller can withdraw.
- `Cancelled`: supported only before shipment if added during implementation.

### Off-chain metadata

Product images and longer descriptions are not stored directly on-chain. Each product stores a metadata URI that points to JSON metadata hosted on IPFS or a normal URL during local development.

Example metadata fields:

- name
- description
- image
- category

## Data flow

### Seller creates listing

1. Seller opens the mobile app.
2. Seller connects MetaMask Mobile.
3. Seller enters product information and image/metadata URI.
4. App sends `createProduct(metadataURI, price)` to the marketplace contract.
5. Contract stores the product and emits a product-created event.
6. App refreshes the marketplace feed from contract reads/events.

### Buyer purchases product

1. Buyer connects MetaMask Mobile.
2. Buyer opens a product detail screen.
3. Buyer confirms checkout.
4. App sends `buyProduct(productId)` with the required Sepolia ETH value.
5. Contract creates an order, marks it `Paid`, and keeps funds in escrow.
6. Product/order state appears in buyer and seller order screens.

### Escrow completion

1. Seller marks the order shipped.
2. Buyer marks the order completed after receiving the item.
3. Contract marks the order `Completed`.
4. Seller withdraws escrowed funds.

## Error handling

The app should handle these user-visible states:

- Wallet not connected.
- Wrong network; ask user to switch to Sepolia.
- User rejects wallet signature or transaction.
- Transaction pending.
- Transaction failed or reverted.
- RPC/network read failure.
- Metadata URI missing or invalid.

Smart contract errors should use clear custom errors where practical, such as unauthorized seller actions, wrong payment amount, inactive product, or invalid order status transition.

## Testing strategy

### Contract tests

Use contract tests first for:

- Creating a product.
- Buying a product with exact payment.
- Rejecting wrong payment amounts.
- Preventing sellers from buying their own products.
- Marking orders shipped.
- Completing orders.
- Withdrawing seller funds.
- Blocking invalid status transitions.

### Mobile tests/manual verification

Verify the golden path on emulator or device:

1. Connect MetaMask Mobile.
2. Switch to Sepolia.
3. Create a product listing.
4. View the listing in the marketplace feed.
5. Buy the product with a second wallet.
6. Mark shipped as seller.
7. Mark completed as buyer.
8. Withdraw seller funds.

## Recommended implementation stack

- Expo + React Native + TypeScript.
- WalletConnect/AppKit React Native integration.
- Ethers for contract calls.
- Solidity smart contracts.
- Hardhat for local contract development, tests, and Sepolia deployment.
- IPFS-compatible metadata later; static URLs are acceptable for the first local demo.
