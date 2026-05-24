# Blockchain E-commerce Upgrade — Implementation Plan

> **For agentic workers:** Use executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Upgrade blockchain e-commerce from prototype to full system with Flutter buyer app, React seller dashboard, and IPFS storage.

**Architecture:** Smart Contract (Solidity/Hardhat) ← Seller Dashboard (React Vite + wagmi) + Buyer App (Flutter + WalletConnect) → IPFS (Pinata)

**Tech Stack:** Solidity 0.8.28, Hardhat, React 18 + Vite, Tailwind CSS, wagmi v2, viem, Flutter 3.x, web3dart, WalletConnect, Pinata IPFS

---

## Architecture Overview

```
┌─────────────────────┐     ┌─────────────────────┐
│  Seller Dashboard   │     │   Flutter Buyer App  │
│  (React + wagmi)    │     │  (web3dart + WC)     │
└────────┬────────────┘     └────────┬─────────────┘
         │                           │
         │  ethers/viem              │  web3dart
         ▼                           ▼
┌─────────────────────────────────────────────────┐
│         Marketplace.sol (Sepolia)                │
│  createProduct | buyProduct | markShipped        │
│  completeOrder | withdraw                       │
└─────────────────────────────────────────────────┘
         │                           │
         ▼                           ▼
┌─────────────────────────────────────────────────┐
│              IPFS (Pinata)                       │
│  Product images & metadata JSON                 │
└─────────────────────────────────────────────────┘
```

---

## Phase 1: Deploy Contract to Sepolia

### Prerequisites

- [ ] Ensure Hardhat project is configured with Sepolia network
- [ ] Get Sepolia ETH from a faucet (e.g., sepoliafaucet.com)
- [ ] Get an Alchemy/Infura RPC URL for Sepolia

### 1.1 Configure Environment Variables

- [ ] Create `contracts/.env` with deployment secrets:

```env
# contracts/.env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
SEPOLIA_PRIVATE_KEY=0xYOUR_PRIVATE_KEY_HERE
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```

- [ ] Add `.env` to `contracts/.gitignore` (if not already there)

### 1.2 Configure Hardhat for Sepolia

- [ ] Update `contracts/hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: process.env.SEPOLIA_PRIVATE_KEY
        ? [process.env.SEPOLIA_PRIVATE_KEY]
        : [],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
```

- [ ] Install dotenv if not present:

```bash
cd contracts
npm install dotenv
```

### 1.3 Create Deploy Script

- [ ] Create `contracts/scripts/deploy.js`:

```javascript
const hre = require("hardhat");

async function main() {
  console.log("Deploying Marketplace contract to Sepolia...");

  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy();
  await marketplace.waitForDeployment();

  const address = await marketplace.getAddress();
  console.log(`Marketplace deployed to: ${address}`);

  // Wait for block confirmations for Etherscan verification
  console.log("Waiting for 5 block confirmations...");
  await marketplace.deploymentTransaction().wait(5);

  // Verify on Etherscan
  console.log("Verifying contract on Etherscan...");
  await hre.run("verify:verify", {
    address: address,
    constructorArguments: [],
  });

  console.log("Contract verified on Etherscan!");
  console.log(`View at: https://sepolia.etherscan.io/address/${address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

### 1.4 Deploy and Verify

- [ ] Run deployment:

```bash
cd contracts
npx hardhat run scripts/deploy.js --network sepolia
```

- [ ] Save the deployed contract address for use in Phase 2 and Phase 3
- [ ] Verify deployment on Sepolia Etherscan

### 1.5 Export Contract Artifacts

- [ ] Confirm ABI is available at `contracts/artifacts/contracts/Marketplace.sol/Marketplace.json`
- [ ] Copy ABI to shared location for frontend and mobile:

```bash
# The ABI will be consumed by:
# - seller-dashboard/src/abi/Marketplace.json
# - flutter_app/assets/abi/Marketplace.json
```

---

## Phase 2: Seller Dashboard (React + Vite + Tailwind + wagmi)

### 2.1 Scaffold Project

- [ ] Create Vite React project:

```bash
cd c:\Users\huy\Desktop\Blockchain_vip
npm create vite@latest seller-dashboard -- --template react-ts
cd seller-dashboard
npm install
```

- [ ] Install dependencies:

```bash
npm install @tanstack/react-query wagmi viem@2.x @wagmi/core @wagmi/connectors
npm install react-router-dom react-hot-toast
npm install -D tailwindcss @tailwindcss/vite
```

- [ ] Configure Tailwind — update `seller-dashboard/vite.config.ts`:

```typescript
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
});
```

- [ ] Add Tailwind import to `seller-dashboard/src/index.css`:

```css
@import "tailwindcss";
```

### 2.2 Configure wagmi + Wallet Connection

- [ ] Create `seller-dashboard/src/config/wagmi.ts`:

```typescript
import { http, createConfig } from "wagmi";
import { sepolia } from "wagmi/chains";
import { injected, walletConnect } from "wagmi/connectors";

export const config = createConfig({
  chains: [sepolia],
  connectors: [
    injected(),
    walletConnect({
      projectId: import.meta.env.VITE_WC_PROJECT_ID,
    }),
  ],
  transports: {
    [sepolia.id]: http(import.meta.env.VITE_SEPOLIA_RPC_URL),
  },
});
```

- [ ] Create `seller-dashboard/src/config/contract.ts`:

```typescript
import MarketplaceABI from "../abi/Marketplace.json";

export const MARKETPLACE_ADDRESS =
  import.meta.env.VITE_CONTRACT_ADDRESS as `0x${string}`;
export const MARKETPLACE_ABI = MarketplaceABI.abi;
```

- [ ] Create `seller-dashboard/.env`:

```env
VITE_CONTRACT_ADDRESS=0xYOUR_DEPLOYED_ADDRESS
VITE_SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY
VITE_WC_PROJECT_ID=YOUR_WALLETCONNECT_PROJECT_ID
```

- [ ] Copy ABI to `seller-dashboard/src/abi/Marketplace.json`

### 2.3 App Shell and Routing

- [ ] Update `seller-dashboard/src/App.tsx`:

```typescript
import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { config } from "./config/wagmi";
import { Layout } from "./components/Layout";
import { Dashboard } from "./pages/Dashboard";
import { CreateProduct } from "./pages/CreateProduct";
import { Orders } from "./pages/Orders";
import { Finance } from "./pages/Finance";

const queryClient = new QueryClient();

function App() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Layout />}>
              <Route index element={<Dashboard />} />
              <Route path="create" element={<CreateProduct />} />
              <Route path="orders" element={<Orders />} />
              <Route path="finance" element={<Finance />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </QueryClientProvider>
    </WagmiProvider>
  );
}

export default App;
```

- [ ] Create `seller-dashboard/src/components/Layout.tsx` with sidebar navigation and wallet connect button
- [ ] Create `seller-dashboard/src/components/ConnectWallet.tsx`:

```typescript
import { useAccount, useConnect, useDisconnect } from "wagmi";

export function ConnectWallet() {
  const { address, isConnected } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();

  if (isConnected) {
    return (
      <div className="flex items-center gap-2">
        <span className="text-sm font-mono">
          {address?.slice(0, 6)}...{address?.slice(-4)}
        </span>
        <button
          onClick={() => disconnect()}
          className="px-3 py-1 bg-red-500 text-white rounded text-sm"
        >
          Disconnect
        </button>
      </div>
    );
  }

  return (
    <div className="flex gap-2">
      {connectors.map((connector) => (
        <button
          key={connector.uid}
          onClick={() => connect({ connector })}
          className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
        >
          {connector.name}
        </button>
      ))}
    </div>
  );
}
```

### 2.4 Create Product Page

- [ ] Create `seller-dashboard/src/pages/CreateProduct.tsx`:

```typescript
import { useState } from "react";
import { useWriteContract, useWaitForTransactionReceipt } from "wagmi";
import { parseEther } from "viem";
import { MARKETPLACE_ADDRESS, MARKETPLACE_ABI } from "../config/contract";

export function CreateProduct() {
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");
  const [ipfsHash, setIpfsHash] = useState("");

  const { writeContract, data: hash } = useWriteContract();
  const { isLoading, isSuccess } = useWaitForTransactionReceipt({ hash });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    writeContract({
      address: MARKETPLACE_ADDRESS,
      abi: MARKETPLACE_ABI,
      functionName: "createProduct",
      args: [name, parseEther(price), ipfsHash],
    });
  };

  return (
    <div className="max-w-lg mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Create Product</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Form fields for name, price, IPFS hash */}
        {/* Submit button with loading state */}
      </form>
    </div>
  );
}
```

### 2.5 Orders Management Page

- [ ] Create `seller-dashboard/src/pages/Orders.tsx` with:
  - Read orders from contract using `useReadContract`
  - Display order status (Paid, Shipped, Completed)
  - "Mark Shipped" button calling `markShipped` function
  - Filter by status tabs

### 2.6 Finance / Withdraw Page

- [ ] Create `seller-dashboard/src/pages/Finance.tsx`:

```typescript
import { useReadContract, useWriteContract, useAccount } from "wagmi";
import { formatEther } from "viem";
import { MARKETPLACE_ADDRESS, MARKETPLACE_ABI } from "../config/contract";

export function Finance() {
  const { address } = useAccount();

  const { data: balance } = useReadContract({
    address: MARKETPLACE_ADDRESS,
    abi: MARKETPLACE_ABI,
    functionName: "balances",
    args: [address],
  });

  const { writeContract } = useWriteContract();

  const handleWithdraw = () => {
    writeContract({
      address: MARKETPLACE_ADDRESS,
      abi: MARKETPLACE_ABI,
      functionName: "withdraw",
    });
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Finance</h1>
      <div className="bg-white rounded-lg shadow p-6">
        <p className="text-gray-600">Available Balance</p>
        <p className="text-3xl font-bold">
          {balance ? formatEther(balance as bigint) : "0"} ETH
        </p>
        <button
          onClick={handleWithdraw}
          className="mt-4 px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700"
        >
          Withdraw
        </button>
      </div>
    </div>
  );
}
```

### 2.7 Dashboard Overview Page

- [ ] Create `seller-dashboard/src/pages/Dashboard.tsx` with:
  - Total products listed
  - Pending orders count
  - Available balance summary
  - Recent activity feed

---

## Phase 3: Flutter Buyer App

### 3.1 Add Dependencies

- [ ] Update `flutter_app/pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  web3dart: ^2.7.3
  walletconnect_flutter_v2: ^2.3.1
  http: ^1.2.0
  provider: ^6.1.1
  cached_network_image: ^3.3.0
  flutter_dotenv: ^5.1.0
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

- [ ] Run:

```bash
cd flutter_app
flutter pub get
```

### 3.2 Create Models

- [ ] Create `flutter_app/lib/models/product.dart`:

```dart
import 'package:web3dart/web3dart.dart';

class Product {
  final BigInt id;
  final String name;
  final BigInt price;
  final EthereumAddress seller;
  final String ipfsHash;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.seller,
    required this.ipfsHash,
    required this.isActive,
  });

  String get priceInEth => (price / BigInt.from(10).pow(18)).toString();
}
```

- [ ] Create `flutter_app/lib/models/order.dart`:

```dart
class Order {
  final BigInt orderId;
  final BigInt productId;
  final String buyer;
  final String seller;
  final BigInt amount;
  final OrderStatus status;

  Order({
    required this.orderId,
    required this.productId,
    required this.buyer,
    required this.seller,
    required this.amount,
    required this.status,
  });
}

enum OrderStatus { paid, shipped, completed, cancelled }
```

### 3.3 Create Services

- [ ] Create `flutter_app/lib/services/marketplace_service.dart`:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class MarketplaceService {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _createProduct;
  late ContractFunction _buyProduct;
  late ContractFunction _getProduct;

  final String _rpcUrl;
  final String _contractAddress;

  MarketplaceService({
    required String rpcUrl,
    required String contractAddress,
  })  : _rpcUrl = rpcUrl,
        _contractAddress = contractAddress;

  Future<void> init() async {
    _client = Web3Client(_rpcUrl, Client());
    final abiJson = await rootBundle.loadString('assets/abi/Marketplace.json');
    final abi = jsonDecode(abiJson)['abi'];
    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abi), 'Marketplace'),
      EthereumAddress.fromHex(_contractAddress),
    );
    _createProduct = _contract.function('createProduct');
    _buyProduct = _contract.function('buyProduct');
    _getProduct = _contract.function('getProduct');
  }

  Future<List<dynamic>> getProduct(BigInt productId) async {
    return await _client.call(
      contract: _contract,
      function: _getProduct,
      params: [productId],
    );
  }

  Future<String> buyProduct(BigInt productId, BigInt price, Credentials creds) async {
    final tx = await _client.sendTransaction(
      creds,
      Transaction.callContract(
        contract: _contract,
        function: _buyProduct,
        parameters: [productId],
        value: EtherAmount.inWei(price),
      ),
      chainId: 11155111, // Sepolia
    );
    return tx;
  }
}
```

- [ ] Create `flutter_app/lib/services/ipfs_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class IpfsService {
  static const String _gateway = 'https://gateway.pinata.cloud/ipfs';

  Future<Map<String, dynamic>> fetchMetadata(String ipfsHash) async {
    final response = await http.get(Uri.parse('$_gateway/$ipfsHash'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch IPFS metadata');
  }

  String getImageUrl(String ipfsHash) {
    return '$_gateway/$ipfsHash';
  }
}
```

- [ ] Create `flutter_app/lib/services/wallet_service.dart`:

```dart
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletService {
  late Web3App _web3App;
  SessionData? _session;

  Future<void> init() async {
    _web3App = await Web3App.createInstance(
      projectId: 'YOUR_WC_PROJECT_ID',
      metadata: const PairingMetadata(
        name: 'Blockchain Shop',
        description: 'Buy products on-chain',
        url: 'https://blockchainshop.example',
        icons: ['https://blockchainshop.example/icon.png'],
      ),
    );
  }

  Future<SessionData> connect() async {
    final resp = await _web3App.connect(
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:11155111'], // Sepolia
          methods: ['eth_sendTransaction', 'personal_sign'],
          events: ['chainChanged', 'accountsChanged'],
        ),
      },
    );
    // Display URI for wallet to scan
    // resp.uri contains the WalletConnect URI
    _session = await resp.session.future;
    return _session!;
  }

  String? get currentAddress {
    if (_session == null) return null;
    final accounts = _session!.namespaces['eip155']?.accounts;
    if (accounts == null || accounts.isEmpty) return null;
    // Format: eip155:11155111:0x...
    return accounts.first.split(':').last;
  }

  bool get isConnected => _session != null;
}
```

### 3.4 Create Screens

- [ ] Create `flutter_app/lib/screens/home_screen.dart`:
  - Grid/list of available products
  - Pull-to-refresh
  - Search/filter functionality
  - Navigate to product details on tap

- [ ] Create `flutter_app/lib/screens/product_details_screen.dart`:
  - Product image from IPFS
  - Name, price, seller address
  - "Buy Now" button triggering wallet transaction
  - Transaction status feedback

- [ ] Create `flutter_app/lib/screens/orders_screen.dart`:
  - List of user's orders
  - Order status tracking (Paid → Shipped → Completed)
  - "Confirm Received" button calling `completeOrder`

- [ ] Create `flutter_app/lib/screens/wallet_screen.dart`:
  - WalletConnect connection UI
  - Display connected address
  - Network info (Sepolia)
  - Disconnect option

### 3.5 App Configuration

- [ ] Create `flutter_app/assets/abi/Marketplace.json` (copy from contracts artifacts)

- [ ] Create `flutter_app/.env`:

```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY
CONTRACT_ADDRESS=0xYOUR_DEPLOYED_ADDRESS
WC_PROJECT_ID=YOUR_WALLETCONNECT_PROJECT_ID
```

- [ ] Update `flutter_app/lib/main.dart` to initialize services and set up routing:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'services/marketplace_service.dart';
import 'services/wallet_service.dart';
import 'services/ipfs_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final marketplaceService = MarketplaceService(
    rpcUrl: dotenv.env['SEPOLIA_RPC_URL']!,
    contractAddress: dotenv.env['CONTRACT_ADDRESS']!,
  );
  await marketplaceService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => marketplaceService),
        Provider(create: (_) => WalletService()),
        Provider(create: (_) => IpfsService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockchain Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
```

---

## Phase 4: IPFS Integration (Pinata)

### 4.1 Pinata Setup

- [ ] Create account at [pinata.cloud](https://pinata.cloud)
- [ ] Generate API keys (API Key + Secret)
- [ ] Add to seller dashboard `.env`:

```env
VITE_PINATA_API_KEY=your_api_key
VITE_PINATA_SECRET_KEY=your_secret_key
```

### 4.2 Upload Flow in Seller Dashboard

- [ ] Create `seller-dashboard/src/services/pinata.ts`:

```typescript
const PINATA_API_URL = "https://api.pinata.cloud";

export async function uploadImageToPinata(file: File): Promise<string> {
  const formData = new FormData();
  formData.append("file", file);

  const response = await fetch(`${PINATA_API_URL}/pinning/pinFileToIPFS`, {
    method: "POST",
    headers: {
      pinata_api_key: import.meta.env.VITE_PINATA_API_KEY,
      pinata_secret_api_key: import.meta.env.VITE_PINATA_SECRET_KEY,
    },
    body: formData,
  });

  const data = await response.json();
  return data.IpfsHash;
}

export async function uploadMetadataToPinata(metadata: {
  name: string;
  description: string;
  image: string;
  price: string;
}): Promise<string> {
  const response = await fetch(`${PINATA_API_URL}/pinning/pinJSONToIPFS`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      pinata_api_key: import.meta.env.VITE_PINATA_API_KEY,
      pinata_secret_api_key: import.meta.env.VITE_PINATA_SECRET_KEY,
    },
    body: JSON.stringify({
      pinataContent: metadata,
      pinataMetadata: { name: `product-${metadata.name}` },
    }),
  });

  const data = await response.json();
  return data.IpfsHash;
}
```

- [ ] Update `CreateProduct.tsx` to integrate Pinata upload:
  1. User fills in product name, description, price
  2. User uploads product image → `uploadImageToPinata()` → get image hash
  3. Create metadata JSON with image hash → `uploadMetadataToPinata()` → get metadata hash
  4. Call `createProduct(name, price, metadataHash)` on contract

### 4.3 Fetch Flow in Flutter App

- [ ] Update `flutter_app/lib/services/ipfs_service.dart` to handle product metadata:

```dart
class IpfsService {
  static const String _gateway = 'https://gateway.pinata.cloud/ipfs';

  Future<ProductMetadata> fetchProductMetadata(String ipfsHash) async {
    final response = await http.get(Uri.parse('$_gateway/$ipfsHash'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductMetadata(
        name: data['name'],
        description: data['description'],
        imageUrl: '$_gateway/${data['image']}',
        price: data['price'],
      );
    }
    throw Exception('Failed to fetch product metadata');
  }
}

class ProductMetadata {
  final String name;
  final String description;
  final String imageUrl;
  final String price;

  ProductMetadata({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}
```

- [ ] Update product listing and detail screens to load images from IPFS gateway
- [ ] Add `cached_network_image` for efficient image loading with placeholders

### 4.4 IPFS Metadata Schema

- [ ] Use consistent metadata format across seller dashboard and buyer app:

```json
{
  "name": "Product Name",
  "description": "Product description text",
  "image": "QmImageHash...",
  "price": "0.05",
  "attributes": {
    "category": "electronics",
    "condition": "new"
  }
}
```

---

## Success Criteria

- [ ] **Phase 1:** Contract deployed to Sepolia and verified on Etherscan
- [ ] **Phase 2:** Seller can connect wallet, create products, view orders, mark shipped, and withdraw funds
- [ ] **Phase 3:** Buyer can browse products, connect wallet via WalletConnect, purchase products, and track orders
- [ ] **Phase 4:** Product images and metadata stored on IPFS via Pinata; both apps can read/write IPFS content
- [ ] **Integration:** End-to-end flow works: seller creates product → buyer purchases → seller ships → buyer confirms → seller withdraws

---

## File Structure (Final)

```
Blockchain_vip/
├── contracts/
│   ├── contracts/Marketplace.sol
│   ├── scripts/deploy.js
│   ├── artifacts/
│   ├── hardhat.config.js
│   └── .env
├── seller-dashboard/
│   ├── src/
│   │   ├── abi/Marketplace.json
│   │   ├── components/
│   │   │   ├── Layout.tsx
│   │   │   └── ConnectWallet.tsx
│   │   ├── config/
│   │   │   ├── wagmi.ts
│   │   │   └── contract.ts
│   │   ├── pages/
│   │   │   ├── Dashboard.tsx
│   │   │   ├── CreateProduct.tsx
│   │   │   ├── Orders.tsx
│   │   │   └── Finance.tsx
│   │   ├── services/
│   │   │   └── pinata.ts
│   │   ├── App.tsx
│   │   └── index.css
│   ├── .env
│   └── vite.config.ts
├── flutter_app/
│   ├── lib/
│   │   ├── models/
│   │   │   ├── product.dart
│   │   │   └── order.dart
│   │   ├── services/
│   │   │   ├── marketplace_service.dart
│   │   │   ├── ipfs_service.dart
│   │   │   └── wallet_service.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── product_details_screen.dart
│   │   │   ├── orders_screen.dart
│   │   │   └── wallet_screen.dart
│   │   └── main.dart
│   ├── assets/abi/Marketplace.json
│   ├── .env
│   └── pubspec.yaml
└── docs/
    └── superpowers/
        ├── specs/
        │   └── 2026-05-18-blockchain-ecommerce-upgrade-design.md
        └── plans/
            └── 2026-05-18-blockchain-ecommerce-upgrade.md
```

---

## Notes

- All `.env` files must be kept out of version control
- WalletConnect Project ID is obtained from [cloud.walletconnect.com](https://cloud.walletconnect.com)
- Sepolia is a testnet — no real funds are at risk
- Pinata free tier allows 500 uploads and 100 requests/day — sufficient for development
- Contract address must be consistent across seller dashboard and Flutter app configs
