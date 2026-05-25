import { parseEther } from 'viem';
import { publicClient, sellerAccount, walletClient } from '../src/clients.js';
import { config } from '../src/config.js';
import { marketplaceAbi } from '../src/marketplaceAbi.js';
import { seedProducts } from '../src/seedData.js';

async function main() {
  const nextProductId = await publicClient.readContract({
    address: config.marketplaceAddress,
    abi: marketplaceAbi,
    functionName: 'nextProductId'
  });

  if (nextProductId > 1n) {
    console.log(`Marketplace already has products. nextProductId=${nextProductId}. Skipping seed.`);
    return;
  }

  for (const product of seedProducts) {
    const metadataUri = `${config.metadataBaseUrl}/metadata/products/${product.slug}.json`;
    const hash = await walletClient.writeContract({
      address: config.marketplaceAddress,
      abi: marketplaceAbi,
      functionName: 'createProduct',
      args: [metadataUri, parseEther(product.priceEth)],
      account: sellerAccount
    });

    await publicClient.waitForTransactionReceipt({ hash });
    console.log(`Seeded ${product.name}: ${hash}`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
