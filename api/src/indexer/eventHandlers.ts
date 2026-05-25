import { decodeEventLog, formatEther } from 'viem';
import { publicClient } from '../clients.js';
import { config } from '../config.js';
import { db } from '../db.js';
import { marketplaceAbi } from '../marketplaceAbi.js';
import { findSeedProduct, slugFromMetadataUri } from '../seedData.js';

function metadataForUri(metadataUri: string) {
  const slug = slugFromMetadataUri(metadataUri);
  if (!slug) return null;
  return findSeedProduct(slug) ?? null;
}

async function upsertOrder(orderId: bigint, txHash?: string, blockNumber?: bigint) {
  const order = await publicClient.readContract({
    address: config.marketplaceAddress,
    abi: marketplaceAbi,
    functionName: 'getOrder',
    args: [orderId]
  });

  db.prepare(`
    INSERT INTO orders (id, product_id, buyer, seller, amount_wei, status, tx_hash, block_number)
    VALUES (@id, @productId, @buyer, @seller, @amountWei, @status, @txHash, @blockNumber)
    ON CONFLICT(id) DO UPDATE SET
      product_id = excluded.product_id,
      buyer = excluded.buyer,
      seller = excluded.seller,
      amount_wei = excluded.amount_wei,
      status = excluded.status,
      tx_hash = COALESCE(excluded.tx_hash, orders.tx_hash),
      block_number = COALESCE(excluded.block_number, orders.block_number)
  `).run({
    id: order.id.toString(),
    productId: order.productId.toString(),
    buyer: order.buyer,
    seller: order.seller,
    amountWei: order.amount.toString(),
    status: Number(order.status),
    txHash,
    blockNumber: blockNumber ? Number(blockNumber) : null
  });
}

export async function handleMarketplaceLog(log: { data: `0x${string}`; topics: [`0x${string}`, ...`0x${string}`[]]; transactionHash?: `0x${string}`; blockNumber?: bigint }) {
  const decoded = decodeEventLog({ abi: marketplaceAbi, data: log.data, topics: log.topics });

  if (decoded.eventName === 'ProductCreated') {
    const args = decoded.args;
    const metadata = metadataForUri(args.metadataURI) ?? {
      slug: `product-${args.productId}`,
      name: `Product #${args.productId}`,
      description: args.metadataURI,
      category: 'Marketplace',
      subCategory: 'General',
      shopName: 'Blockchain VIP',
      thumbnailUrl: '',
      images: [],
      rating: 0,
      soldCount: 0,
      variants: [],
      tags: [],
      priceEth: formatEther(args.price)
    };

    db.prepare(`
      INSERT INTO products (id, seller, metadata_uri, price_wei, active, tx_hash, block_number, metadata_json)
      VALUES (@id, @seller, @metadataUri, @priceWei, 1, @txHash, @blockNumber, @metadataJson)
      ON CONFLICT(id) DO UPDATE SET
        seller = excluded.seller,
        metadata_uri = excluded.metadata_uri,
        price_wei = excluded.price_wei,
        active = 1,
        tx_hash = COALESCE(excluded.tx_hash, products.tx_hash),
        block_number = COALESCE(excluded.block_number, products.block_number),
        metadata_json = excluded.metadata_json
    `).run({
      id: args.productId.toString(),
      seller: args.seller,
      metadataUri: args.metadataURI,
      priceWei: args.price.toString(),
      txHash: log.transactionHash,
      blockNumber: log.blockNumber ? Number(log.blockNumber) : null,
      metadataJson: JSON.stringify(metadata)
    });
    return;
  }

  if (decoded.eventName === 'ProductPurchased') {
    await upsertOrder(decoded.args.orderId, log.transactionHash, log.blockNumber);
    return;
  }

  if (decoded.eventName === 'OrderShipped' || decoded.eventName === 'OrderCompleted') {
    await upsertOrder(decoded.args.orderId, log.transactionHash, log.blockNumber);
    return;
  }

  if (decoded.eventName === 'SellerWithdrawal') {
    db.prepare(`
      INSERT INTO seller_withdrawals (seller, amount_wei, tx_hash, block_number)
      VALUES (?, ?, ?, ?)
    `).run(decoded.args.seller, decoded.args.amount.toString(), log.transactionHash, log.blockNumber ? Number(log.blockNumber) : null);
  }
}
