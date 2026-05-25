import Database from 'better-sqlite3';
import { config } from './config.js';

export const db = new Database(config.databasePath);
db.pragma('journal_mode = WAL');

export type ProductMetadata = {
  slug: string;
  name: string;
  description: string;
  category: string;
  subCategory: string;
  shopName: string;
  thumbnailUrl: string;
  images: string[];
  rating: number;
  soldCount: number;
  discountPercent?: number;
  variants: Array<{ name: string; values: string[] }>;
  tags: string[];
  priceEth: string;
};

export function initDb() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS products (
      id TEXT PRIMARY KEY,
      seller TEXT NOT NULL,
      metadata_uri TEXT NOT NULL,
      price_wei TEXT NOT NULL,
      active INTEGER NOT NULL DEFAULT 1,
      tx_hash TEXT,
      block_number INTEGER,
      metadata_json TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS orders (
      id TEXT PRIMARY KEY,
      product_id TEXT NOT NULL,
      buyer TEXT NOT NULL,
      seller TEXT NOT NULL,
      amount_wei TEXT NOT NULL,
      status INTEGER NOT NULL,
      tx_hash TEXT,
      block_number INTEGER
    );

    CREATE TABLE IF NOT EXISTS seller_withdrawals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      seller TEXT NOT NULL,
      amount_wei TEXT NOT NULL,
      tx_hash TEXT,
      block_number INTEGER
    );

    CREATE TABLE IF NOT EXISTS indexer_state (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    );
  `);
}

export function parseMetadata(row: { metadata_json: string }) {
  return JSON.parse(row.metadata_json) as ProductMetadata;
}

export function formatProduct(row: any) {
  return {
    id: row.id,
    seller: row.seller,
    metadataURI: row.metadata_uri,
    priceWei: row.price_wei,
    active: Boolean(row.active),
    txHash: row.tx_hash,
    blockNumber: row.block_number,
    metadata: parseMetadata(row)
  };
}

export function formatOrder(row: any) {
  return {
    id: row.id,
    productId: row.product_id,
    buyer: row.buyer,
    seller: row.seller,
    amountWei: row.amount_wei,
    status: row.status,
    statusLabel: ['Paid', 'Shipped', 'Completed', 'Cancelled'][Number(row.status)] ?? 'Unknown',
    txHash: row.tx_hash,
    blockNumber: row.block_number
  };
}
