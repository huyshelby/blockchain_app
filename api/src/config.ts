import 'dotenv/config';

function requiredEnv(name: string, fallback?: string) {
  const value = process.env[name] ?? fallback;
  if (!value) throw new Error(`Missing environment variable: ${name}`);
  return value;
}

export const config = {
  port: Number(process.env.PORT ?? 3000),
  rpcUrl: requiredEnv('RPC_URL', 'http://127.0.0.1:8545'),
  marketplaceAddress: requiredEnv('MARKETPLACE_ADDRESS', '0x5fbdb2315678afecb367f032d93f642f64180aa3') as `0x${string}`,
  sellerPrivateKey: requiredEnv('SELLER_PRIVATE_KEY', '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80') as `0x${string}`,
  databasePath: process.env.DATABASE_PATH ?? './marketplace.db',
  metadataBaseUrl: process.env.METADATA_BASE_URL ?? 'http://localhost:3000',
  startBlock: BigInt(process.env.START_BLOCK ?? '0'),
  pollIntervalMs: Number(process.env.POLL_INTERVAL_MS ?? 3000)
};
