# Blockchain VIP

Blockchain VIP is a marketplace e-commerce MVP built on Ethereum smart contracts with a Flutter mobile app and seller dashboard.

## Project structure

- `contracts/` — Solidity Marketplace contract, Hardhat config, tests, and deploy scripts.
- `blockchain_flutter/` — Flutter mobile app for marketplace browsing and buyer flows.
- `seller_dashboard/` — Seller-facing dashboard, if present in the local workspace.
- `docs/` — Project specs and planning documents, if present.

## MVP flow

1. Seller creates a product listing.
2. Buyer purchases the product and ETH is held in escrow.
3. Seller marks the order as shipped.
4. Buyer completes the order.
5. Seller withdraws released funds.

## Development commands

```bash
cd contracts
npm run compile
npm run test
npm run deploy:local
```

```bash
cd blockchain_flutter
flutter run
flutter test
```

## Notes

This project is currently intended for local development and Sepolia testnet demos. Do not use local Hardhat development private keys in production.
