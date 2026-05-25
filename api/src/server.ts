import cors from 'cors';
import express from 'express';
import { config } from './config.js';
import { initDb } from './db.js';
import { startIndexerLoop, syncMarketplaceEvents } from './indexer/sync.js';
import { metadataRouter } from './routes/metadata.js';
import { ordersRouter } from './routes/orders.js';
import { productsRouter } from './routes/products.js';
import { sellersRouter } from './routes/sellers.js';

initDb();

const app = express();
app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

app.post('/indexer/sync', async (_req, res, next) => {
  try {
    res.json(await syncMarketplaceEvents());
  } catch (error) {
    next(error);
  }
});

app.use('/metadata', metadataRouter);
app.use('/products', productsRouter);
app.use('/orders', ordersRouter);
app.use('/sellers', sellersRouter);

app.use((error: unknown, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(error);
  res.status(500).json({ error: error instanceof Error ? error.message : 'Internal server error' });
});

app.listen(config.port, () => {
  console.log(`Blockchain VIP API listening on http://localhost:${config.port}`);
});

startIndexerLoop();
