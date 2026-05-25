import { Router } from 'express';
import { db, formatProduct } from '../db.js';

export const productsRouter = Router();

productsRouter.get('/', (req, res) => {
  const conditions = ['active = 1'];
  const params: Record<string, string> = {};

  if (typeof req.query.seller === 'string') {
    conditions.push('lower(seller) = lower(@seller)');
    params.seller = req.query.seller;
  }

  const rows = db.prepare(`SELECT * FROM products WHERE ${conditions.join(' AND ')} ORDER BY CAST(id AS INTEGER) DESC`).all(params);
  let products = rows.map(formatProduct);

  if (typeof req.query.category === 'string') {
    products = products.filter((product) => product.metadata.category.toLowerCase() === req.query.category!.toString().toLowerCase());
  }

  if (typeof req.query.tag === 'string') {
    products = products.filter((product) => product.metadata.tags.includes(req.query.tag!.toString()));
  }

  res.json(products);
});

productsRouter.get('/:id', (req, res) => {
  const row = db.prepare('SELECT * FROM products WHERE id = ?').get(req.params.id);
  if (!row) {
    res.status(404).json({ error: 'Product not found' });
    return;
  }

  res.json(formatProduct(row));
});
