import { Router } from 'express';
import { db } from '../db.js';

export const sellersRouter = Router();

sellersRouter.get('/:address/summary', (req, res) => {
  const address = req.params.address;
  const productCount = db.prepare('SELECT COUNT(*) as count FROM products WHERE lower(seller) = lower(?) AND active = 1').get(address) as { count: number };
  const orderRows = db.prepare('SELECT status, amount_wei FROM orders WHERE lower(seller) = lower(?)').all(address) as Array<{ status: number; amount_wei: string }>;
  const withdrawalRows = db.prepare('SELECT amount_wei FROM seller_withdrawals WHERE lower(seller) = lower(?)').all(address) as Array<{ amount_wei: string }>;

  const ordersByStatus = orderRows.reduce<Record<string, number>>((counts, order) => {
    const label = ['Paid', 'Shipped', 'Completed', 'Cancelled'][order.status] ?? 'Unknown';
    counts[label] = (counts[label] ?? 0) + 1;
    return counts;
  }, {});

  const completedSalesWei = orderRows
    .filter((order) => order.status === 2)
    .reduce((sum, order) => sum + BigInt(order.amount_wei), 0n)
    .toString();

  const withdrawnWei = withdrawalRows
    .reduce((sum, row) => sum + BigInt(row.amount_wei), 0n)
    .toString();

  res.json({
    seller: address,
    activeProducts: productCount.count,
    ordersByStatus,
    completedSalesWei,
    withdrawnWei
  });
});
