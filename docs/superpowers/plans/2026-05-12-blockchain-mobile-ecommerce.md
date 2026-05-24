# Blockchain Mobile E-commerce Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a cross-platform Expo mobile marketplace where sellers list products and buyers purchase through a Sepolia Solidity escrow contract using MetaMask Mobile.

**Architecture:** Use a small monorepo: `contracts/` contains the Hardhat project and marketplace contract; `mobile/` contains the Expo app. Contract tests define the marketplace behavior first. The mobile app uses focused services for wallet, contract reads/writes, and metadata display.

**Tech Stack:** Solidity, Hardhat, TypeScript, Expo React Native, WalletConnect/AppKit, Ethers, Sepolia.

---

## File Structure

Create this structure:

```text
contracts/
  contracts/Marketplace.sol
  hardhat.config.ts
  package.json
  scripts/deploy.ts
  test/Marketplace.ts
  tsconfig.json
mobile/
  app.json
  package.json
  tsconfig.json
  App.tsx
  src/blockchain/marketplaceAbi.ts
  src/blockchain/marketplaceConfig.ts
  src/blockchain/marketplaceService.ts
  src/data/demoMetadata.ts
  src/screens/HomeScreen.tsx
  src/screens/ProductDetailsScreen.tsx
  src/screens/CreateListingScreen.tsx
  src/screens/OrdersScreen.tsx
  src/screens/WalletScreen.tsx
  src/types/marketplace.ts
```

Responsibilities:

- `contracts/contracts/Marketplace.sol`: all on-chain marketplace, order, and escrow logic.
- `contracts/test/Marketplace.ts`: contract behavior tests.
- `contracts/scripts/deploy.ts`: deploy contract and print address.
- `mobile/App.tsx`: app shell, WalletConnect modal, simple screen navigation state.
- `mobile/src/blockchain/*`: ABI/config/service boundary for blockchain calls.
- `mobile/src/screens/*`: focused mobile UI screens.
- `mobile/src/types/marketplace.ts`: shared frontend types.

---

### Task 1: Scaffold Hardhat contract project

**Files:**
- Create: `contracts/package.json`
- Create: `contracts/hardhat.config.ts`
- Create: `contracts/tsconfig.json`
- Create: `contracts/contracts/Marketplace.sol`
- Create: `contracts/test/Marketplace.ts`

- [ ] **Step 1: Create contract package manifest**

Create `contracts/package.json`:

```json
{
  "name": "blockchain-vip-contracts",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "hardhat test",
    "compile": "hardhat compile",
    "deploy:sepolia": "hardhat run scripts/deploy.ts --build-profile production --network sepolia"
  },
  "devDependencies": {
    "@nomicfoundation/hardhat-toolbox-viem": "latest",
    "@types/node": "latest",
    "hardhat": "latest",
    "typescript": "latest"
  }
}
```

- [ ] **Step 2: Create Hardhat config**

Create `contracts/hardhat.config.ts`:

```ts
import type { HardhatUserConfig } from "hardhat/config";
import hardhatToolboxViemPlugin from "@nomicfoundation/hardhat-toolbox-viem";

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxViemPlugin],
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    sepolia: {
      type: "http",
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: process.env.SEPOLIA_PRIVATE_KEY ? [process.env.SEPOLIA_PRIVATE_KEY] : []
    }
  }
};

export default config;
```

- [ ] **Step 3: Create TypeScript config**

Create `contracts/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "types": ["node"]
  },
  "include": ["./test", "./scripts", "./hardhat.config.ts"]
}
```

- [ ] **Step 4: Add placeholder contract**

Create `contracts/contracts/Marketplace.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Marketplace {}
```

- [ ] **Step 5: Add placeholder test**

Create `contracts/test/Marketplace.ts`:

```ts
import { describe, it } from "node:test";

void describe;
void it;
```

- [ ] **Step 6: Install dependencies**

Run:

```powershell
npm install --prefix contracts
```

Expected: dependencies install and `contracts/package-lock.json` is created.

- [ ] **Step 7: Compile placeholder contract**

Run:

```powershell
npm run compile --prefix contracts
```

Expected: Hardhat compiles `Marketplace.sol` successfully.

---

### Task 2: Implement tested product listing behavior

**Files:**
- Modify: `contracts/contracts/Marketplace.sol`
- Modify: `contracts/test/Marketplace.ts`

- [ ] **Step 1: Replace test with failing product listing tests**

Replace `contracts/test/Marketplace.ts` with:

```ts
import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";

const { viem } = await network.connect();

async function deployMarketplaceFixture() {
  const [seller, buyer] = await viem.getWalletClients();
  const marketplace = await viem.deployContract("Marketplace");
  const publicClient = await viem.getPublicClient();

  return { marketplace, publicClient, seller, buyer };
}

describe("Marketplace products", () => {
  it("creates an active product listing", async () => {
    const { marketplace, publicClient, seller } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    const hash = await marketplace.write.createProduct(["ipfs://product-1", price], {
      account: seller.account
    });
    await publicClient.waitForTransactionReceipt({ hash });

    const product = await marketplace.read.getProduct([1n]);

    assert.equal(product.id, 1n);
    assert.equal(product.seller.toLowerCase(), seller.account.address.toLowerCase());
    assert.equal(product.metadataURI, "ipfs://product-1");
    assert.equal(product.price, price);
    assert.equal(product.active, true);
  });

  it("rejects listings with an empty metadata URI", async () => {
    const { marketplace, seller } = await deployMarketplaceFixture();

    await assert.rejects(
      marketplace.write.createProduct(["", 1n], { account: seller.account }),
      /InvalidMetadataURI/
    );
  });

  it("rejects listings with a zero price", async () => {
    const { marketplace, seller } = await deployMarketplaceFixture();

    await assert.rejects(
      marketplace.write.createProduct(["ipfs://product-1", 0n], { account: seller.account }),
      /InvalidPrice/
    );
  });
});
```

- [ ] **Step 2: Run tests to verify failure**

Run:

```powershell
npm test --prefix contracts
```

Expected: FAIL because `createProduct` and `getProduct` do not exist.

- [ ] **Step 3: Implement product listing contract code**

Replace `contracts/contracts/Marketplace.sol` with:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Marketplace {
    error InvalidMetadataURI();
    error InvalidPrice();
    error ProductNotFound();

    struct Product {
        uint256 id;
        address payable seller;
        string metadataURI;
        uint256 price;
        bool active;
    }

    uint256 public nextProductId = 1;

    mapping(uint256 => Product) private products;

    event ProductCreated(uint256 indexed productId, address indexed seller, string metadataURI, uint256 price);

    function createProduct(string calldata metadataURI, uint256 price) external returns (uint256 productId) {
        if (bytes(metadataURI).length == 0) revert InvalidMetadataURI();
        if (price == 0) revert InvalidPrice();

        productId = nextProductId++;
        products[productId] = Product({
            id: productId,
            seller: payable(msg.sender),
            metadataURI: metadataURI,
            price: price,
            active: true
        });

        emit ProductCreated(productId, msg.sender, metadataURI, price);
    }

    function getProduct(uint256 productId) external view returns (Product memory product) {
        product = products[productId];
        if (product.id == 0) revert ProductNotFound();
    }
}
```

- [ ] **Step 4: Run tests to verify pass**

Run:

```powershell
npm test --prefix contracts
```

Expected: PASS for all product tests.

---

### Task 3: Implement tested purchase and escrow behavior

**Files:**
- Modify: `contracts/contracts/Marketplace.sol`
- Modify: `contracts/test/Marketplace.ts`

- [ ] **Step 1: Add failing purchase tests**

Append this `describe` block to `contracts/test/Marketplace.ts`:

```ts
describe("Marketplace purchases", () => {
  it("lets a buyer purchase a product into escrow", async () => {
    const { marketplace, publicClient, seller, buyer } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.buyProduct([1n], {
        account: buyer.account,
        value: price
      })
    });

    const order = await marketplace.read.getOrder([1n]);

    assert.equal(order.id, 1n);
    assert.equal(order.productId, 1n);
    assert.equal(order.buyer.toLowerCase(), buyer.account.address.toLowerCase());
    assert.equal(order.seller.toLowerCase(), seller.account.address.toLowerCase());
    assert.equal(order.amount, price);
    assert.equal(order.status, 0);
  });

  it("rejects purchases with the wrong payment amount", async () => {
    const { marketplace, publicClient, seller, buyer } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await assert.rejects(
      marketplace.write.buyProduct([1n], { account: buyer.account, value: price - 1n }),
      /WrongPaymentAmount/
    );
  });

  it("prevents sellers from buying their own products", async () => {
    const { marketplace, publicClient, seller } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await assert.rejects(
      marketplace.write.buyProduct([1n], { account: seller.account, value: price }),
      /SellerCannotBuyOwnProduct/
    );
  });
});
```

- [ ] **Step 2: Run tests to verify failure**

Run:

```powershell
npm test --prefix contracts
```

Expected: FAIL because `buyProduct` and `getOrder` do not exist.

- [ ] **Step 3: Replace contract with purchase implementation**

Replace `contracts/contracts/Marketplace.sol` with:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Marketplace {
    error InvalidMetadataURI();
    error InvalidPrice();
    error ProductNotFound();
    error ProductInactive();
    error WrongPaymentAmount();
    error SellerCannotBuyOwnProduct();
    error OrderNotFound();

    enum OrderStatus {
        Paid,
        Shipped,
        Completed,
        Cancelled
    }

    struct Product {
        uint256 id;
        address payable seller;
        string metadataURI;
        uint256 price;
        bool active;
    }

    struct Order {
        uint256 id;
        uint256 productId;
        address buyer;
        address payable seller;
        uint256 amount;
        OrderStatus status;
    }

    uint256 public nextProductId = 1;
    uint256 public nextOrderId = 1;

    mapping(uint256 => Product) private products;
    mapping(uint256 => Order) private orders;

    event ProductCreated(uint256 indexed productId, address indexed seller, string metadataURI, uint256 price);
    event ProductPurchased(uint256 indexed orderId, uint256 indexed productId, address indexed buyer, uint256 amount);

    function createProduct(string calldata metadataURI, uint256 price) external returns (uint256 productId) {
        if (bytes(metadataURI).length == 0) revert InvalidMetadataURI();
        if (price == 0) revert InvalidPrice();

        productId = nextProductId++;
        products[productId] = Product({
            id: productId,
            seller: payable(msg.sender),
            metadataURI: metadataURI,
            price: price,
            active: true
        });

        emit ProductCreated(productId, msg.sender, metadataURI, price);
    }

    function buyProduct(uint256 productId) external payable returns (uint256 orderId) {
        Product storage product = products[productId];
        if (product.id == 0) revert ProductNotFound();
        if (!product.active) revert ProductInactive();
        if (msg.sender == product.seller) revert SellerCannotBuyOwnProduct();
        if (msg.value != product.price) revert WrongPaymentAmount();

        orderId = nextOrderId++;
        orders[orderId] = Order({
            id: orderId,
            productId: productId,
            buyer: msg.sender,
            seller: product.seller,
            amount: msg.value,
            status: OrderStatus.Paid
        });

        emit ProductPurchased(orderId, productId, msg.sender, msg.value);
    }

    function getProduct(uint256 productId) external view returns (Product memory product) {
        product = products[productId];
        if (product.id == 0) revert ProductNotFound();
    }

    function getOrder(uint256 orderId) external view returns (Order memory order) {
        order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
    }
}
```

- [ ] **Step 4: Run tests to verify pass**

Run:

```powershell
npm test --prefix contracts
```

Expected: PASS for product and purchase tests.

---

### Task 4: Implement tested shipping, completion, and withdrawals

**Files:**
- Modify: `contracts/contracts/Marketplace.sol`
- Modify: `contracts/test/Marketplace.ts`

- [ ] **Step 1: Add failing escrow lifecycle tests**

Append this `describe` block to `contracts/test/Marketplace.ts`:

```ts
describe("Marketplace escrow lifecycle", () => {
  async function createPaidOrderFixture() {
    const fixture = await deployMarketplaceFixture();
    const { marketplace, publicClient, seller, buyer } = fixture;
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.buyProduct([1n], { account: buyer.account, value: price })
    });

    return { ...fixture, price };
  }

  it("lets the seller mark an order shipped", async () => {
    const { marketplace, publicClient, seller } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });

    const order = await marketplace.read.getOrder([1n]);
    assert.equal(order.status, 1);
  });

  it("lets the buyer complete a shipped order", async () => {
    const { marketplace, publicClient, seller, buyer } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.completeOrder([1n], { account: buyer.account })
    });

    const order = await marketplace.read.getOrder([1n]);
    assert.equal(order.status, 2);
  });

  it("credits seller withdrawable balance when buyer completes order", async () => {
    const { marketplace, publicClient, seller, buyer, price } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.completeOrder([1n], { account: buyer.account })
    });

    const balance = await marketplace.read.withdrawableBalance([seller.account.address]);
    assert.equal(balance, price);
  });

  it("blocks invalid order actors", async () => {
    const { marketplace, buyer } = await createPaidOrderFixture();

    await assert.rejects(
      marketplace.write.markShipped([1n], { account: buyer.account }),
      /OnlySeller/
    );
  });
});
```

- [ ] **Step 2: Run tests to verify failure**

Run:

```powershell
npm test --prefix contracts
```

Expected: FAIL because escrow lifecycle functions do not exist.

- [ ] **Step 3: Replace contract with escrow lifecycle implementation**

Replace `contracts/contracts/Marketplace.sol` with the final contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Marketplace {
    error InvalidMetadataURI();
    error InvalidPrice();
    error ProductNotFound();
    error ProductInactive();
    error WrongPaymentAmount();
    error SellerCannotBuyOwnProduct();
    error OrderNotFound();
    error OnlySeller();
    error OnlyBuyer();
    error InvalidOrderStatus();
    error NothingToWithdraw();
    error WithdrawFailed();

    enum OrderStatus {
        Paid,
        Shipped,
        Completed,
        Cancelled
    }

    struct Product {
        uint256 id;
        address payable seller;
        string metadataURI;
        uint256 price;
        bool active;
    }

    struct Order {
        uint256 id;
        uint256 productId;
        address buyer;
        address payable seller;
        uint256 amount;
        OrderStatus status;
    }

    uint256 public nextProductId = 1;
    uint256 public nextOrderId = 1;

    mapping(uint256 => Product) private products;
    mapping(uint256 => Order) private orders;
    mapping(address => uint256) public withdrawableBalance;

    event ProductCreated(uint256 indexed productId, address indexed seller, string metadataURI, uint256 price);
    event ProductPurchased(uint256 indexed orderId, uint256 indexed productId, address indexed buyer, uint256 amount);
    event OrderShipped(uint256 indexed orderId);
    event OrderCompleted(uint256 indexed orderId);
    event SellerWithdrawal(address indexed seller, uint256 amount);

    function createProduct(string calldata metadataURI, uint256 price) external returns (uint256 productId) {
        if (bytes(metadataURI).length == 0) revert InvalidMetadataURI();
        if (price == 0) revert InvalidPrice();

        productId = nextProductId++;
        products[productId] = Product({
            id: productId,
            seller: payable(msg.sender),
            metadataURI: metadataURI,
            price: price,
            active: true
        });

        emit ProductCreated(productId, msg.sender, metadataURI, price);
    }

    function buyProduct(uint256 productId) external payable returns (uint256 orderId) {
        Product storage product = products[productId];
        if (product.id == 0) revert ProductNotFound();
        if (!product.active) revert ProductInactive();
        if (msg.sender == product.seller) revert SellerCannotBuyOwnProduct();
        if (msg.value != product.price) revert WrongPaymentAmount();

        orderId = nextOrderId++;
        orders[orderId] = Order({
            id: orderId,
            productId: productId,
            buyer: msg.sender,
            seller: product.seller,
            amount: msg.value,
            status: OrderStatus.Paid
        });

        emit ProductPurchased(orderId, productId, msg.sender, msg.value);
    }

    function markShipped(uint256 orderId) external {
        Order storage order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
        if (msg.sender != order.seller) revert OnlySeller();
        if (order.status != OrderStatus.Paid) revert InvalidOrderStatus();

        order.status = OrderStatus.Shipped;
        emit OrderShipped(orderId);
    }

    function completeOrder(uint256 orderId) external {
        Order storage order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
        if (msg.sender != order.buyer) revert OnlyBuyer();
        if (order.status != OrderStatus.Shipped) revert InvalidOrderStatus();

        order.status = OrderStatus.Completed;
        withdrawableBalance[order.seller] += order.amount;
        emit OrderCompleted(orderId);
    }

    function withdraw() external {
        uint256 amount = withdrawableBalance[msg.sender];
        if (amount == 0) revert NothingToWithdraw();

        withdrawableBalance[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert WithdrawFailed();

        emit SellerWithdrawal(msg.sender, amount);
    }

    function getProduct(uint256 productId) external view returns (Product memory product) {
        product = products[productId];
        if (product.id == 0) revert ProductNotFound();
    }

    function getOrder(uint256 orderId) external view returns (Order memory order) {
        order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
    }
}
```

- [ ] **Step 4: Run tests to verify pass**

Run:

```powershell
npm test --prefix contracts
```

Expected: PASS for all contract tests.

---

### Task 5: Add deployment script and ABI export source

**Files:**
- Create: `contracts/scripts/deploy.ts`
- Modify: `contracts/package.json`

- [ ] **Step 1: Create deployment script**

Create `contracts/scripts/deploy.ts`:

```ts
import { network } from "hardhat";

const { viem, networkName } = await network.connect();

console.log(`Deploying Marketplace to ${networkName}...`);

const marketplace = await viem.deployContract("Marketplace");

console.log("Marketplace address:", marketplace.address);
```

- [ ] **Step 2: Compile and verify artifacts exist**

Run:

```powershell
npm run compile --prefix contracts
```

Expected: `contracts/artifacts/contracts/Marketplace.sol/Marketplace.json` exists and contains ABI.

- [ ] **Step 3: Run local deployment smoke test**

Run:

```powershell
npx --prefix contracts hardhat run contracts/scripts/deploy.ts
```

Expected: prints a local `Marketplace address:`.

---

### Task 6: Scaffold Expo mobile app

**Files:**
- Create: `mobile/package.json`
- Create: `mobile/app.json`
- Create: `mobile/tsconfig.json`
- Create: `mobile/App.tsx`

- [ ] **Step 1: Create Expo app package manifest**

Create `mobile/package.json`:

```json
{
  "name": "blockchain-vip-mobile",
  "version": "0.1.0",
  "private": true,
  "main": "expo/AppEntry.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@walletconnect/react-native-compat": "latest",
    "@web3modal/ethers-react-native": "latest",
    "ethers": "latest",
    "expo": "latest",
    "expo-status-bar": "latest",
    "react": "latest",
    "react-native": "latest",
    "react-native-get-random-values": "latest",
    "react-native-svg": "latest"
  },
  "devDependencies": {
    "@types/react": "latest",
    "typescript": "latest"
  }
}
```

- [ ] **Step 2: Create app config**

Create `mobile/app.json`:

```json
{
  "expo": {
    "name": "Blockchain VIP Marketplace",
    "slug": "blockchain-vip-marketplace",
    "scheme": "blockchainvip",
    "version": "0.1.0",
    "orientation": "portrait",
    "platforms": ["ios", "android"],
    "ios": {
      "bundleIdentifier": "com.blockchainvip.marketplace"
    },
    "android": {
      "package": "com.blockchainvip.marketplace"
    }
  }
}
```

- [ ] **Step 3: Create mobile TypeScript config**

Create `mobile/tsconfig.json`:

```json
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true
  }
}
```

- [ ] **Step 4: Create minimal app shell**

Create `mobile/App.tsx`:

```tsx
import { StatusBar } from "expo-status-bar";
import { SafeAreaView, Text, View } from "react-native";

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: "#0f172a" }}>
      <View style={{ flex: 1, alignItems: "center", justifyContent: "center", padding: 24 }}>
        <Text style={{ color: "white", fontSize: 28, fontWeight: "700", textAlign: "center" }}>
          Blockchain VIP Marketplace
        </Text>
        <Text style={{ color: "#cbd5e1", fontSize: 16, marginTop: 12, textAlign: "center" }}>
          Mobile marketplace powered by Sepolia escrow contracts.
        </Text>
      </View>
      <StatusBar style="light" />
    </SafeAreaView>
  );
}
```

- [ ] **Step 5: Install mobile dependencies**

Run:

```powershell
npm install --prefix mobile
```

Expected: dependencies install and `mobile/package-lock.json` is created.

- [ ] **Step 6: Typecheck mobile shell**

Run:

```powershell
npm run typecheck --prefix mobile
```

Expected: PASS with no TypeScript errors.

---

### Task 7: Add mobile marketplace types, config, ABI, and service boundary

**Files:**
- Create: `mobile/src/types/marketplace.ts`
- Create: `mobile/src/blockchain/marketplaceConfig.ts`
- Create: `mobile/src/blockchain/marketplaceAbi.ts`
- Create: `mobile/src/blockchain/marketplaceService.ts`

- [ ] **Step 1: Create frontend marketplace types**

Create `mobile/src/types/marketplace.ts`:

```ts
export type OrderStatus = "Paid" | "Shipped" | "Completed" | "Cancelled";

export type ProductMetadata = {
  name: string;
  description: string;
  image: string;
  category: string;
};

export type Product = {
  id: bigint;
  seller: string;
  metadataURI: string;
  price: bigint;
  active: boolean;
  metadata?: ProductMetadata;
};

export type Order = {
  id: bigint;
  productId: bigint;
  buyer: string;
  seller: string;
  amount: bigint;
  status: OrderStatus;
};
```

- [ ] **Step 2: Create marketplace config**

Create `mobile/src/blockchain/marketplaceConfig.ts`:

```ts
export const sepolia = {
  chainId: 11155111,
  name: "Sepolia",
  currency: "ETH",
  explorerUrl: "https://sepolia.etherscan.io",
  rpcUrl: "https://ethereum-sepolia-rpc.publicnode.com"
};

export const marketplaceAddress = "0x0000000000000000000000000000000000000000";
```

- [ ] **Step 3: Create ABI file**

Create `mobile/src/blockchain/marketplaceAbi.ts`:

```ts
export const marketplaceAbi = [
  "function createProduct(string metadataURI, uint256 price) returns (uint256)",
  "function buyProduct(uint256 productId) payable returns (uint256)",
  "function markShipped(uint256 orderId)",
  "function completeOrder(uint256 orderId)",
  "function withdraw()",
  "function withdrawableBalance(address seller) view returns (uint256)",
  "function getProduct(uint256 productId) view returns (tuple(uint256 id, address seller, string metadataURI, uint256 price, bool active))",
  "function getOrder(uint256 orderId) view returns (tuple(uint256 id, uint256 productId, address buyer, address seller, uint256 amount, uint8 status))",
  "function nextProductId() view returns (uint256)",
  "function nextOrderId() view returns (uint256)",
  "event ProductCreated(uint256 indexed productId, address indexed seller, string metadataURI, uint256 price)",
  "event ProductPurchased(uint256 indexed orderId, uint256 indexed productId, address indexed buyer, uint256 amount)",
  "event OrderShipped(uint256 indexed orderId)",
  "event OrderCompleted(uint256 indexed orderId)",
  "event SellerWithdrawal(address indexed seller, uint256 amount)"
] as const;
```

- [ ] **Step 4: Create marketplace service**

Create `mobile/src/blockchain/marketplaceService.ts`:

```ts
import { Contract, BrowserProvider, JsonRpcProvider, parseEther } from "ethers";
import { marketplaceAbi } from "./marketplaceAbi";
import { marketplaceAddress, sepolia } from "./marketplaceConfig";
import type { Order, Product } from "../types/marketplace";

const orderStatuses = ["Paid", "Shipped", "Completed", "Cancelled"] as const;

export function readOnlyContract() {
  const provider = new JsonRpcProvider(sepolia.rpcUrl, sepolia.chainId);
  return new Contract(marketplaceAddress, marketplaceAbi, provider);
}

export async function signerContract(walletProvider: unknown) {
  const provider = new BrowserProvider(walletProvider as never);
  const signer = await provider.getSigner();
  return new Contract(marketplaceAddress, marketplaceAbi, signer);
}

export async function getProduct(productId: bigint): Promise<Product> {
  const contract = readOnlyContract();
  const product = await contract.getProduct(productId);
  return {
    id: product.id,
    seller: product.seller,
    metadataURI: product.metadataURI,
    price: product.price,
    active: product.active
  };
}

export async function getOrder(orderId: bigint): Promise<Order> {
  const contract = readOnlyContract();
  const order = await contract.getOrder(orderId);
  return {
    id: order.id,
    productId: order.productId,
    buyer: order.buyer,
    seller: order.seller,
    amount: order.amount,
    status: orderStatuses[Number(order.status)]
  };
}

export async function createProduct(walletProvider: unknown, metadataURI: string, priceEth: string) {
  const contract = await signerContract(walletProvider);
  return contract.createProduct(metadataURI, parseEther(priceEth));
}

export async function buyProduct(walletProvider: unknown, productId: bigint, price: bigint) {
  const contract = await signerContract(walletProvider);
  return contract.buyProduct(productId, { value: price });
}

export async function markShipped(walletProvider: unknown, orderId: bigint) {
  const contract = await signerContract(walletProvider);
  return contract.markShipped(orderId);
}

export async function completeOrder(walletProvider: unknown, orderId: bigint) {
  const contract = await signerContract(walletProvider);
  return contract.completeOrder(orderId);
}

export async function withdraw(walletProvider: unknown) {
  const contract = await signerContract(walletProvider);
  return contract.withdraw();
}
```

- [ ] **Step 5: Typecheck service code**

Run:

```powershell
npm run typecheck --prefix mobile
```

Expected: PASS with no TypeScript errors.

---

### Task 8: Add wallet connection shell and navigation

**Files:**
- Modify: `mobile/App.tsx`

- [ ] **Step 1: Replace app shell with WalletConnect/AppKit setup**

Replace `mobile/App.tsx` with:

```tsx
import "@walletconnect/react-native-compat";
import "react-native-get-random-values";

import { createWeb3Modal, defaultConfig, Web3Modal, W3mButton } from "@web3modal/ethers-react-native";
import { StatusBar } from "expo-status-bar";
import { useState } from "react";
import { Pressable, SafeAreaView, Text, View } from "react-native";
import { sepolia } from "./src/blockchain/marketplaceConfig";
import { HomeScreen } from "./src/screens/HomeScreen";
import { CreateListingScreen } from "./src/screens/CreateListingScreen";
import { OrdersScreen } from "./src/screens/OrdersScreen";
import { WalletScreen } from "./src/screens/WalletScreen";

const projectId = "YOUR_WALLETCONNECT_PROJECT_ID";

const metadata = {
  name: "Blockchain VIP Marketplace",
  description: "Mobile marketplace powered by Sepolia escrow contracts",
  url: "https://localhost",
  icons: ["https://walletconnect.com/walletconnect-logo.png"],
  redirect: {
    native: "blockchainvip://"
  }
};

const config = defaultConfig({ metadata });

createWeb3Modal({
  projectId,
  chains: [sepolia],
  config,
  enableAnalytics: false
});

type Tab = "home" | "create" | "orders" | "wallet";

export default function App() {
  const [tab, setTab] = useState<Tab>("home");

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: "#0f172a" }}>
      <View style={{ padding: 16, borderBottomWidth: 1, borderBottomColor: "#1e293b" }}>
        <Text style={{ color: "white", fontSize: 22, fontWeight: "700" }}>Blockchain VIP</Text>
        <Text style={{ color: "#94a3b8", marginTop: 4 }}>Sepolia escrow marketplace</Text>
        <View style={{ marginTop: 12 }}>
          <W3mButton />
        </View>
      </View>

      <View style={{ flex: 1 }}>
        {tab === "home" ? <HomeScreen /> : null}
        {tab === "create" ? <CreateListingScreen /> : null}
        {tab === "orders" ? <OrdersScreen /> : null}
        {tab === "wallet" ? <WalletScreen /> : null}
      </View>

      <View style={{ flexDirection: "row", borderTopWidth: 1, borderTopColor: "#1e293b" }}>
        {(["home", "create", "orders", "wallet"] as const).map((item) => (
          <Pressable key={item} onPress={() => setTab(item)} style={{ flex: 1, padding: 14, alignItems: "center" }}>
            <Text style={{ color: tab === item ? "#38bdf8" : "#94a3b8", fontWeight: "700", textTransform: "capitalize" }}>
              {item}
            </Text>
          </Pressable>
        ))}
      </View>

      <Web3Modal />
      <StatusBar style="light" />
    </SafeAreaView>
  );
}
```

- [ ] **Step 2: Run typecheck to verify missing screens fail**

Run:

```powershell
npm run typecheck --prefix mobile
```

Expected: FAIL because screen files do not exist yet.

---

### Task 9: Add mobile screens with demo metadata and blockchain action wiring

**Files:**
- Create: `mobile/src/data/demoMetadata.ts`
- Create: `mobile/src/screens/HomeScreen.tsx`
- Create: `mobile/src/screens/ProductDetailsScreen.tsx`
- Create: `mobile/src/screens/CreateListingScreen.tsx`
- Create: `mobile/src/screens/OrdersScreen.tsx`
- Create: `mobile/src/screens/WalletScreen.tsx`

- [ ] **Step 1: Create demo metadata map**

Create `mobile/src/data/demoMetadata.ts`:

```ts
import type { ProductMetadata } from "../types/marketplace";

export const demoMetadata: Record<string, ProductMetadata> = {
  "ipfs://demo-phone": {
    name: "Verified Smartphone",
    description: "Demo physical product listed through the escrow marketplace.",
    image: "https://placehold.co/600x400/png",
    category: "Electronics"
  },
  "ipfs://demo-watch": {
    name: "Collector Watch",
    description: "Demo premium item with blockchain purchase history.",
    image: "https://placehold.co/600x400/png",
    category: "Fashion"
  }
};
```

- [ ] **Step 2: Create home screen**

Create `mobile/src/screens/HomeScreen.tsx`:

```tsx
import { formatEther } from "ethers";
import { useEffect, useState } from "react";
import { ActivityIndicator, Pressable, ScrollView, Text, View } from "react-native";
import { getProduct } from "../blockchain/marketplaceService";
import { demoMetadata } from "../data/demoMetadata";
import type { Product } from "../types/marketplace";
import { ProductDetailsScreen } from "./ProductDetailsScreen";

export function HomeScreen() {
  const [products, setProducts] = useState<Product[]>([]);
  const [selected, setSelected] = useState<Product | null>(null);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("Create listings after deploying the contract and setting its address.");

  useEffect(() => {
    let cancelled = false;

    async function loadProducts() {
      setLoading(true);
      const loaded: Product[] = [];

      for (const id of [1n, 2n, 3n, 4n, 5n]) {
        try {
          const product = await getProduct(id);
          loaded.push({ ...product, metadata: demoMetadata[product.metadataURI] });
        } catch {
          break;
        }
      }

      if (!cancelled) {
        setProducts(loaded);
        setMessage(loaded.length === 0 ? "No products found yet." : "");
        setLoading(false);
      }
    }

    void loadProducts();
    return () => {
      cancelled = true;
    };
  }, []);

  if (selected) {
    return <ProductDetailsScreen product={selected} onBack={() => setSelected(null)} />;
  }

  return (
    <ScrollView style={{ flex: 1, padding: 16 }}>
      <Text style={{ color: "white", fontSize: 26, fontWeight: "800" }}>Marketplace</Text>
      <Text style={{ color: "#94a3b8", marginTop: 6 }}>Browse products listed on Sepolia.</Text>

      {loading ? <ActivityIndicator style={{ marginTop: 24 }} /> : null}
      {message ? <Text style={{ color: "#fbbf24", marginTop: 24 }}>{message}</Text> : null}

      {products.map((product) => (
        <Pressable
          key={product.id.toString()}
          onPress={() => setSelected(product)}
          style={{ backgroundColor: "#1e293b", borderRadius: 18, padding: 16, marginTop: 16 }}
        >
          <Text style={{ color: "white", fontSize: 18, fontWeight: "700" }}>
            {product.metadata?.name || product.metadataURI}
          </Text>
          <Text style={{ color: "#94a3b8", marginTop: 6 }}>{product.metadata?.category || "Uncategorized"}</Text>
          <Text style={{ color: "#38bdf8", marginTop: 10, fontWeight: "800" }}>{formatEther(product.price)} ETH</Text>
        </Pressable>
      ))}
    </ScrollView>
  );
}
```

- [ ] **Step 3: Create product details screen**

Create `mobile/src/screens/ProductDetailsScreen.tsx`:

```tsx
import { useWeb3ModalProvider } from "@web3modal/ethers-react-native";
import { formatEther } from "ethers";
import { useState } from "react";
import { Pressable, Text, View } from "react-native";
import { buyProduct } from "../blockchain/marketplaceService";
import type { Product } from "../types/marketplace";

type Props = {
  product: Product;
  onBack: () => void;
};

export function ProductDetailsScreen({ product, onBack }: Props) {
  const { walletProvider } = useWeb3ModalProvider();
  const [message, setMessage] = useState("");

  async function handleBuy() {
    if (!walletProvider) {
      setMessage("Connect MetaMask Mobile first.");
      return;
    }

    try {
      setMessage("Waiting for wallet approval...");
      const tx = await buyProduct(walletProvider, product.id, product.price);
      setMessage(`Transaction submitted: ${tx.hash}`);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Transaction failed.");
    }
  }

  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Pressable onPress={onBack}>
        <Text style={{ color: "#38bdf8", fontWeight: "700" }}>Back</Text>
      </Pressable>

      <Text style={{ color: "white", fontSize: 28, fontWeight: "800", marginTop: 18 }}>
        {product.metadata?.name || product.metadataURI}
      </Text>
      <Text style={{ color: "#94a3b8", marginTop: 10 }}>{product.metadata?.description || "No description."}</Text>
      <Text style={{ color: "#38bdf8", marginTop: 18, fontSize: 20, fontWeight: "800" }}>{formatEther(product.price)} ETH</Text>
      <Text style={{ color: "#64748b", marginTop: 12 }}>Seller: {product.seller}</Text>

      <Pressable onPress={handleBuy} style={{ backgroundColor: "#38bdf8", borderRadius: 14, padding: 16, marginTop: 24 }}>
        <Text style={{ color: "#082f49", textAlign: "center", fontWeight: "800" }}>Buy with Sepolia ETH</Text>
      </Pressable>

      {message ? <Text style={{ color: "#fbbf24", marginTop: 16 }}>{message}</Text> : null}
    </View>
  );
}
```

- [ ] **Step 4: Create listing screen**

Create `mobile/src/screens/CreateListingScreen.tsx`:

```tsx
import { useWeb3ModalProvider } from "@web3modal/ethers-react-native";
import { useState } from "react";
import { Pressable, Text, TextInput, View } from "react-native";
import { createProduct } from "../blockchain/marketplaceService";

export function CreateListingScreen() {
  const { walletProvider } = useWeb3ModalProvider();
  const [metadataURI, setMetadataURI] = useState("ipfs://demo-phone");
  const [priceEth, setPriceEth] = useState("0.001");
  const [message, setMessage] = useState("");

  async function handleCreate() {
    if (!walletProvider) {
      setMessage("Connect MetaMask Mobile first.");
      return;
    }

    try {
      setMessage("Waiting for wallet approval...");
      const tx = await createProduct(walletProvider, metadataURI, priceEth);
      setMessage(`Listing submitted: ${tx.hash}`);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Listing failed.");
    }
  }

  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Text style={{ color: "white", fontSize: 26, fontWeight: "800" }}>Create Listing</Text>
      <Text style={{ color: "#94a3b8", marginTop: 6 }}>Store metadata URI and price on Sepolia.</Text>

      <Text style={{ color: "#cbd5e1", marginTop: 20 }}>Metadata URI</Text>
      <TextInput
        value={metadataURI}
        onChangeText={setMetadataURI}
        autoCapitalize="none"
        style={{ backgroundColor: "#1e293b", color: "white", borderRadius: 12, padding: 14, marginTop: 8 }}
      />

      <Text style={{ color: "#cbd5e1", marginTop: 16 }}>Price ETH</Text>
      <TextInput
        value={priceEth}
        onChangeText={setPriceEth}
        keyboardType="decimal-pad"
        style={{ backgroundColor: "#1e293b", color: "white", borderRadius: 12, padding: 14, marginTop: 8 }}
      />

      <Pressable onPress={handleCreate} style={{ backgroundColor: "#38bdf8", borderRadius: 14, padding: 16, marginTop: 24 }}>
        <Text style={{ color: "#082f49", textAlign: "center", fontWeight: "800" }}>Create On-chain Listing</Text>
      </Pressable>

      {message ? <Text style={{ color: "#fbbf24", marginTop: 16 }}>{message}</Text> : null}
    </View>
  );
}
```

- [ ] **Step 5: Create orders screen**

Create `mobile/src/screens/OrdersScreen.tsx`:

```tsx
import { useWeb3ModalProvider } from "@web3modal/ethers-react-native";
import { useState } from "react";
import { Pressable, Text, TextInput, View } from "react-native";
import { completeOrder, getOrder, markShipped, withdraw } from "../blockchain/marketplaceService";
import type { Order } from "../types/marketplace";

export function OrdersScreen() {
  const { walletProvider } = useWeb3ModalProvider();
  const [orderId, setOrderId] = useState("1");
  const [order, setOrder] = useState<Order | null>(null);
  const [message, setMessage] = useState("");

  async function loadOrder() {
    try {
      setOrder(await getOrder(BigInt(orderId)));
      setMessage("");
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Could not load order.");
    }
  }

  async function sendAction(action: "ship" | "complete" | "withdraw") {
    if (!walletProvider) {
      setMessage("Connect MetaMask Mobile first.");
      return;
    }

    try {
      const tx = action === "ship"
        ? await markShipped(walletProvider, BigInt(orderId))
        : action === "complete"
          ? await completeOrder(walletProvider, BigInt(orderId))
          : await withdraw(walletProvider);
      setMessage(`Transaction submitted: ${tx.hash}`);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Transaction failed.");
    }
  }

  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Text style={{ color: "white", fontSize: 26, fontWeight: "800" }}>Orders</Text>
      <Text style={{ color: "#94a3b8", marginTop: 6 }}>Load an order and move escrow forward.</Text>

      <TextInput
        value={orderId}
        onChangeText={setOrderId}
        keyboardType="number-pad"
        style={{ backgroundColor: "#1e293b", color: "white", borderRadius: 12, padding: 14, marginTop: 20 }}
      />

      <Pressable onPress={loadOrder} style={{ backgroundColor: "#334155", borderRadius: 14, padding: 14, marginTop: 12 }}>
        <Text style={{ color: "white", textAlign: "center", fontWeight: "800" }}>Load Order</Text>
      </Pressable>

      {order ? (
        <View style={{ backgroundColor: "#1e293b", borderRadius: 16, padding: 16, marginTop: 16 }}>
          <Text style={{ color: "white", fontWeight: "800" }}>Order #{order.id.toString()}</Text>
          <Text style={{ color: "#94a3b8", marginTop: 6 }}>Status: {order.status}</Text>
          <Text style={{ color: "#94a3b8", marginTop: 6 }}>Buyer: {order.buyer}</Text>
          <Text style={{ color: "#94a3b8", marginTop: 6 }}>Seller: {order.seller}</Text>
        </View>
      ) : null}

      <Pressable onPress={() => sendAction("ship")} style={{ backgroundColor: "#38bdf8", borderRadius: 14, padding: 14, marginTop: 16 }}>
        <Text style={{ color: "#082f49", textAlign: "center", fontWeight: "800" }}>Mark Shipped</Text>
      </Pressable>
      <Pressable onPress={() => sendAction("complete")} style={{ backgroundColor: "#22c55e", borderRadius: 14, padding: 14, marginTop: 12 }}>
        <Text style={{ color: "#052e16", textAlign: "center", fontWeight: "800" }}>Complete Order</Text>
      </Pressable>
      <Pressable onPress={() => sendAction("withdraw")} style={{ backgroundColor: "#f59e0b", borderRadius: 14, padding: 14, marginTop: 12 }}>
        <Text style={{ color: "#451a03", textAlign: "center", fontWeight: "800" }}>Withdraw Seller Funds</Text>
      </Pressable>

      {message ? <Text style={{ color: "#fbbf24", marginTop: 16 }}>{message}</Text> : null}
    </View>
  );
}
```

- [ ] **Step 6: Create wallet screen**

Create `mobile/src/screens/WalletScreen.tsx`:

```tsx
import { W3mButton, useWeb3ModalAccount } from "@web3modal/ethers-react-native";
import { Text, View } from "react-native";

export function WalletScreen() {
  const { address, chainId, isConnected } = useWeb3ModalAccount();

  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Text style={{ color: "white", fontSize: 26, fontWeight: "800" }}>Wallet</Text>
      <Text style={{ color: "#94a3b8", marginTop: 6 }}>Connect MetaMask Mobile with WalletConnect.</Text>
      <View style={{ marginTop: 18 }}>
        <W3mButton />
      </View>
      <Text style={{ color: "#cbd5e1", marginTop: 20 }}>Connected: {isConnected ? "Yes" : "No"}</Text>
      <Text style={{ color: "#cbd5e1", marginTop: 10 }}>Address: {address || "Not connected"}</Text>
      <Text style={{ color: "#cbd5e1", marginTop: 10 }}>Chain ID: {chainId || "Unknown"}</Text>
      {chainId && chainId !== 11155111 ? (
        <Text style={{ color: "#f87171", marginTop: 14 }}>Switch MetaMask Mobile to Sepolia.</Text>
      ) : null}
    </View>
  );
}
```

- [ ] **Step 7: Typecheck mobile app**

Run:

```powershell
npm run typecheck --prefix mobile
```

Expected: PASS with no TypeScript errors.

---

### Task 10: Connect deployment output to mobile app and verify end-to-end

**Files:**
- Modify: `mobile/src/blockchain/marketplaceConfig.ts`
- Modify: `mobile/src/blockchain/marketplaceAbi.ts` if the compiled ABI differs from the minimal ABI.

- [ ] **Step 1: Deploy contract to Sepolia**

Set environment variables in PowerShell:

```powershell
$env:SEPOLIA_RPC_URL="https://your-sepolia-rpc-url"
$env:SEPOLIA_PRIVATE_KEY="0xYourPrivateKeyWithoutFundsYouCareAbout"
npm run deploy:sepolia --prefix contracts
```

Expected: command prints `Marketplace address: 0x...`.

- [ ] **Step 2: Update mobile contract address**

Modify `mobile/src/blockchain/marketplaceConfig.ts`:

```ts
export const sepolia = {
  chainId: 11155111,
  name: "Sepolia",
  currency: "ETH",
  explorerUrl: "https://sepolia.etherscan.io",
  rpcUrl: "https://ethereum-sepolia-rpc.publicnode.com"
};

export const marketplaceAddress = "PASTE_DEPLOYED_MARKETPLACE_ADDRESS_HERE";
```

- [ ] **Step 3: Replace WalletConnect project ID**

Modify `mobile/App.tsx`:

```ts
const projectId = "PASTE_WALLETCONNECT_PROJECT_ID_HERE";
```

- [ ] **Step 4: Run contract tests**

Run:

```powershell
npm test --prefix contracts
```

Expected: PASS.

- [ ] **Step 5: Run mobile typecheck**

Run:

```powershell
npm run typecheck --prefix mobile
```

Expected: PASS.

- [ ] **Step 6: Start Expo app**

Run:

```powershell
npm start --prefix mobile
```

Expected: Expo starts and prints a QR code / development server URL.

- [ ] **Step 7: Manual mobile verification**

On Android or iOS device with MetaMask Mobile:

1. Open the Expo app.
2. Tap connect wallet.
3. Approve connection in MetaMask Mobile.
4. Confirm the wallet is on Sepolia.
5. Create listing with `ipfs://demo-phone` and `0.001` ETH.
6. Return to Home and verify the listing appears.
7. Use a second wallet to buy the product.
8. Use seller wallet to mark shipped.
9. Use buyer wallet to complete order.
10. Use seller wallet to withdraw funds.

Expected: all transactions submit through MetaMask Mobile and order status moves from `Paid` to `Shipped` to `Completed`.

---

## Self-Review

Spec coverage:

- Cross-platform mobile app: covered in Tasks 6-10.
- MetaMask Mobile wallet connection: covered in Tasks 8-10.
- Marketplace feed, details, create listing, wallet, purchases/orders: covered in Task 9.
- Sepolia Solidity escrow contract: covered in Tasks 1-5 and Task 10.
- Off-chain metadata URI model: covered in Tasks 2, 7, and 9.
- Contract tests: covered in Tasks 2-4.
- Manual mobile verification: covered in Task 10.

Placeholder scan:

- The only paste values are external credentials/IDs that must come from the developer: Sepolia RPC URL, deployer private key, deployed contract address, and WalletConnect project ID.
- No code task uses undefined helper names without defining them in the same or earlier task.

Type consistency:

- Contract names, function names, event names, and frontend service names are consistent across tasks.
- Order statuses use Solidity enum order `Paid=0`, `Shipped=1`, `Completed=2`, `Cancelled=3` and frontend mapping matches it.
