import { publicClient } from '../clients.js';
import { config } from '../config.js';
import { db, initDb } from '../db.js';
import { handleMarketplaceLog } from './eventHandlers.js';

const stateKey = 'marketplace:lastIndexedBlock';

function getLastIndexedBlock() {
  const row = db.prepare('SELECT value FROM indexer_state WHERE key = ?').get(stateKey) as { value: string } | undefined;
  return row ? BigInt(row.value) : config.startBlock - 1n;
}

function setLastIndexedBlock(blockNumber: bigint) {
  db.prepare(`
    INSERT INTO indexer_state (key, value) VALUES (?, ?)
    ON CONFLICT(key) DO UPDATE SET value = excluded.value
  `).run(stateKey, blockNumber.toString());
}

export async function syncMarketplaceEvents() {
  initDb();
  const latestBlock = await publicClient.getBlockNumber();
  const lastIndexed = getLastIndexedBlock();

  if (lastIndexed >= latestBlock) return { fromBlock: latestBlock, toBlock: latestBlock, count: 0 };

  const fromBlock = lastIndexed + 1n;
  const logs = await publicClient.getLogs({
    address: config.marketplaceAddress,
    fromBlock,
    toBlock: latestBlock
  });

  for (const log of logs) {
    await handleMarketplaceLog(log as any);
  }

  setLastIndexedBlock(latestBlock);
  return { fromBlock, toBlock: latestBlock, count: logs.length };
}

export function startIndexerLoop() {
  syncMarketplaceEvents().catch((error) => console.error('Initial indexer sync failed:', error));
  return setInterval(() => {
    syncMarketplaceEvents().catch((error) => console.error('Indexer sync failed:', error));
  }, config.pollIntervalMs);
}

if (import.meta.url === `file://${process.argv[1]}`) {
  syncMarketplaceEvents()
    .then((result) => {
      console.log(`Indexed ${result.count} logs from ${result.fromBlock} to ${result.toBlock}`);
    })
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}
