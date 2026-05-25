import { Router } from 'express';
import { findSeedProduct } from '../seedData.js';

export const metadataRouter = Router();

metadataRouter.get('/products/:slug.json', (req, res) => {
  const product = findSeedProduct(req.params.slug);
  if (!product) {
    res.status(404).json({ error: 'Metadata not found' });
    return;
  }

  res.json(product);
});
