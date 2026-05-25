import products from '../data/seed-products.json' with { type: 'json' };
import type { ProductMetadata } from './db.js';

export const seedProducts = products as ProductMetadata[];

export function findSeedProduct(slug: string) {
  return seedProducts.find((product) => product.slug === slug);
}

export function slugFromMetadataUri(metadataUri: string) {
  const match = metadataUri.match(/\/metadata\/products\/([^/]+)\.json$/);
  return match?.[1];
}
