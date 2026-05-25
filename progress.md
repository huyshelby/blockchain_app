# Progress

## Goal

Move the Flutter mobile app from hardcoded marketplace mock data to blockchain-backed data served through a local API.

The target MVP flow is:

1. Seed product listings on the local Ethereum chain through `Marketplace.createProduct`.
2. Keep rich product display data off-chain as metadata served by the API.
3. Index contract events into a local read model.
4. Let Flutter read product/order data from the API.
5. Keep Flutter write actions, such as buy/ship/complete/withdraw, going directly through `MarketplaceService` and the smart contract.

## Architecture approach

The smart contract remains the source of truth for blockchain state:

- product ID
- seller address
- metadata URI
- price
- active flag
- order buyer/seller
- escrow amount
- order status
- seller withdrawal balance

The API is a read model for app display:

- product list and detail data
- product metadata from seed catalog
- buyer/seller order lists
- seller summaries
- indexed blockchain event state

Flutter is split by responsibility:

- Reads go through `MarketplaceApiClient`.
- Writes stay in `MarketplaceService` using `web3dart`.

This avoids changing the Solidity contract for rich product fields, because the existing contract only stores `metadataURI` and `price`.

## Files added or changed

### API package

Created a new `api/` Node/Express TypeScript package.

Key files:

- `api/package.json`
- `api/tsconfig.json`
- `api/.env.example`
- `api/data/seed-products.json`
- `api/src/config.ts`
- `api/src/server.ts`
- `api/src/db.ts`
- `api/src/clients.ts`
- `api/src/marketplaceAbi.ts`
- `api/src/seedData.ts`
- `api/src/routes/metadata.ts`
- `api/src/routes/products.ts`
- `api/src/routes/orders.ts`
- `api/src/routes/sellers.ts`
- `api/src/indexer/eventHandlers.ts`
- `api/src/indexer/sync.ts`
- `api/scripts/seed-products.ts`

API endpoints added:

- `GET /health`
- `GET /products`
- `GET /products/:id`
- `GET /products?category=...&tag=...&seller=...`
- `GET /orders?buyer=...`
- `GET /orders?seller=...`
- `GET /orders/:id`
- `GET /sellers/:address/summary`
- `GET /metadata/products/:slug.json`
- `POST /indexer/sync`

The API uses:

- Express
- TypeScript
- SQLite through `better-sqlite3`
- `viem` for chain reads, writes, and log indexing

### Seed catalog

Extracted product mock data into:

- `api/data/seed-products.json`

Each seed product includes fields such as:

- `slug`
- `name`
- `description`
- `category`
- `subCategory`
- `shopName`
- `thumbnailUrl`
- `images`
- `rating`
- `soldCount`
- `discountPercent`
- `variants`
- `tags`
- `priceEth`

Only `metadataURI` and `priceEth` are used when creating products on-chain.

### API seed script

Added:

- `api/scripts/seed-products.ts`

The script:

1. Reads `api/data/seed-products.json`.
2. Builds metadata URLs like `http://localhost:3000/metadata/products/<slug>.json`.
3. Calls `Marketplace.createProduct(metadataURI, parseEther(priceEth))` using the local Hardhat seller account.
4. Skips seeding if `nextProductId()` shows products already exist.

### API indexer

Added event indexing for:

- `ProductCreated`
- `ProductPurchased`
- `OrderShipped`
- `OrderCompleted`
- `SellerWithdrawal`

The indexer stores data in SQLite tables:

- `products`
- `orders`
- `seller_withdrawals`
- `indexer_state`

For order events, the API reads `getOrder(orderId)` from the contract to store canonical order state.

### Flutter config

Updated:

- `blockchain_flutter/lib/config.dart`

Added:

```dart
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000',
);
```

The default is Android emulator friendly. For desktop/browser testing, override with:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

### Flutter models and API client

Added:

- `blockchain_flutter/lib/models/product_metadata.dart`
- `blockchain_flutter/lib/models/product.dart`
- `blockchain_flutter/lib/models/order.dart`
- `blockchain_flutter/lib/api/marketplace_api_client.dart`

`MarketplaceApiClient` fetches:

- products
- single product
- buyer/seller orders
- single order

### Flutter providers

Updated:

- `blockchain_flutter/lib/providers/marketplace_provider.dart`

Read providers now use the API:

- `productsProvider`
- `featuredProductsProvider`
- `flashSaleProductsProvider`
- `productProvider`
- `buyerOrdersProvider`
- `sellerOrdersProvider`
- `orderProvider`

Write/service provider still uses the blockchain service.

### Flutter screens

Updated:

- `blockchain_flutter/lib/screens/home_screen.dart`
- `blockchain_flutter/lib/screens/product_detail_screen.dart`
- `blockchain_flutter/lib/screens/orders_screen.dart`

Home screen:

- Removed hardcoded product arrays.
- Loads products from API providers.
- Product cards use typed `Product` data.

Product detail screen:

- Accepts typed `Product`.
- Renders metadata from API product data.
- `Buy Now` calls `MarketplaceService.buyProduct(product.id, product.priceWei)`.

Orders screen:

- Removed hardcoded orders.
- Loads buyer orders from `buyerOrdersProvider(currentAddress)`.
- Maps contract statuses to tabs:
  - `Paid` / status `0` -> `To Ship`
  - `Shipped` / status `1` -> `To Receive`
  - `Completed` / status `2` -> `Completed`

## Verification completed

### API typecheck

Command run:

```bash
npm run typecheck --prefix api
```

Result:

- Passed.

### Smart contract tests

Command run:

```bash
npm run test --prefix contracts
```

Result:

- Passed.
- `10 passing`.

Covered areas include:

- product creation
- invalid product creation
- product purchase
- wrong payment rejection
- seller self-buy rejection
- seller mark shipped
- buyer complete order
- seller withdrawable balance
- invalid actor rejection

### Dart diagnostics

Changed Flutter files were checked through diagnostics during the session.

Resolved issues:

- Removed unused hardcoded mock product lists in `home_screen.dart`.
- Fixed Dart style hints in `orders_screen.dart`.
- Fixed Dart style hints in `marketplace_api_client.dart`.

## Current failure being worked on

Runtime local integration is not fully verified yet.

The observed failure was:

```text
connect ECONNREFUSED 127.0.0.1:8545
```

Meaning:

- The API process started on `localhost:3000`.
- The API/indexer tried to connect to Ethereum JSON-RPC at `127.0.0.1:8545`.
- Nothing was listening there.
- Therefore Hardhat local node was not running, or was not reachable at that port.

The same root cause also caused `npm run seed:products` to fail, because the seed script calls the contract through `eth_call` before creating products.

## Runtime test still pending

Need to run the full local flow:

1. Start local Hardhat node:

```bash
npm --prefix contracts exec hardhat node
```

2. Deploy marketplace contract to the local node:

```bash
npm run deploy:local --prefix contracts
```

3. Make sure API uses the deployed `MARKETPLACE_ADDRESS`.

Default local address is currently:

```text
0x5fbdb2315678afecb367f032d93f642f64180aa3
```

This is only valid if the local chain is fresh and deployment order is unchanged.

4. Start API:

```bash
npm run dev --prefix api
```

5. Seed products:

```bash
npm run seed:products --prefix api
```

6. Check API endpoints:

```text
GET http://localhost:3000/health
GET http://localhost:3000/products
GET http://localhost:3000/products/1
GET http://localhost:3000/orders?buyer=<buyer-address>
```

7. Run Flutter with API URL:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

For non-emulator local testing, use:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

## Known notes

- The local dev private keys in `blockchain_flutter/lib/config.dart` and `api/.env.example` are Hardhat default accounts only. They must not be used in production.
- `mall_screen.dart`, `cart_screen.dart`, and `profile_screen.dart` may still contain static/demo UI data and were not fully migrated in this pass.
- Seller dashboard API integration is not done yet.
- Product detail buy action works at code level but still needs live runtime verification against local chain and API indexer.
- API indexer currently logs errors when RPC is down. This is expected while Hardhat node is not running, but it could be made quieter later.

## Current next step

Continue runtime test from the failure point:

1. Start Hardhat node.
2. Deploy contract.
3. Start API.
4. Run seed script.
5. Verify `/products` returns seeded on-chain listings.
