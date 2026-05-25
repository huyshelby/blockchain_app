import { Router } from 'express';
import { db, formatOrder, formatProduct } from '../db.js';

export const ordersRouter = Router();

function withProduct(order: ReturnType<typeof formatOrder>) {
  const productRow = db.prepare('SELECT * FROM products WHERE id = ?').get(order.productId);
  return {
    ...order,
    product: productRow ? formatProduct(productRow) : null
  };
}

export const orderStatusNames = ['Paid', 'Shipped', 'Completed', 'Cancelled'];

ordersRouter.get('/', (req, res) => {
  const conditions: string[] = [];
  const params: Record<string, string> = {};

  if (typeof req.query.buyer === 'string') {
    conditions.push('lower(buyer) = lower(@buyer)');
    params.buyer = req.query.buyer;
  }

  if (typeof req.query.seller === 'string') {
    conditions.push('lower(seller) = lower(@seller)');
    params.seller = req.query.seller;
  }

  const where = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';
  const rows = db.prepare(`SELECT * FROM orders ${where} ORDER BY CAST(id AS INTEGER) DESC`).all(params);
  res.json(rows.map(formatOrder).map(withProduct));
});

ordersRouter.get('/:id', (req, res) => {
  const row = db.prepare('SELECT * FROM orders WHERE id = ?').get(req.params.id);
  if (!row) {
    res.status(404).json({ error: 'Order not found' });
    return;
  }

  res.json(withProduct(formatOrder(row)));
});
