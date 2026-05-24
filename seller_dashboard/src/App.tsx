import { useMemo, useState } from 'react'
import './App.css'

type Page = 'Home' | 'Products' | 'Orders' | 'Finance'
type OrderStatus = 'Funds Locked' | 'Awaiting Delivery' | 'Completed'
type TransactionStatus = 'COMPLETED' | 'PENDING'

const navItems: Page[] = ['Home', 'Products', 'Orders', 'Finance']

const metrics = [
  { label: 'TOTAL SALES', value: '12.4 ETH', note: '≈ $32,150.00 USD', tone: 'default' },
  { label: 'ACTIVE LISTINGS', value: '42', note: '+3 this week', tone: 'accent' },
  { label: 'REPUTATION', value: '4.9 /5', note: 'Based on 128 reviews', tone: 'default' },
  { label: 'GAS TREND', value: 'Low', note: '12 Gwei avg • Optimal to list', tone: 'green' },
]

const products = [
  { name: 'HyperKnit Runner V2', price: '0.15 ETH', usd: '$414.00', status: 'Active', gradient: 'linear-gradient(135deg, #f97316, #b51c00)' },
  { name: 'Chronos Smart Watch', price: '0.08 ETH', usd: '$220.80', status: 'Active', gradient: 'linear-gradient(135deg, #14b8a6, #10b981)' },
  { name: 'Noise-Canceling Pods', price: '0.05 ETH', usd: '$138.00', status: 'Draft', gradient: 'linear-gradient(135deg, #e5e7eb, #9ca3af)' },
  { name: 'Mech PFP Alpha', price: '0.05 ETH', usd: '$138.00', status: 'Active', gradient: 'linear-gradient(135deg, #8b5cf6, #db3416)' },
]

const orders: Array<{ id: string; date: string; item: string; buyer: string; price: string; status: OrderStatus }> = [
  { id: '#ORD-9823', date: 'Oct 24, 14:30', item: 'HyperKnit Runner V2', buyer: '0x4a...9b2e', price: '0.15', status: 'Funds Locked' },
  { id: '#ORD-9822', date: 'Oct 23, 09:15', item: 'Chronos Smart Watch', buyer: '0xf1...c88d', price: '0.08', status: 'Awaiting Delivery' },
  { id: '#ORD-9810', date: 'Oct 20, 11:45', item: 'Noise-Canceling Pods', buyer: '0x77...2a1f', price: '0.05', status: 'Completed' },
]

const transactions: Array<{ date: string; type: string; amount: string; hash: string; status: TransactionStatus }> = [
  { date: 'Oct 24, 2023', type: 'Sale', amount: '+0.45', hash: '0x8f2...e31a', status: 'COMPLETED' },
  { date: 'Oct 21, 2023', type: 'Withdrawal', amount: '-1.50', hash: '0x3a1...c99b', status: 'COMPLETED' },
  { date: 'Oct 18, 2023', type: 'Sale', amount: '+0.12', hash: '0x9b4...f12c', status: 'PENDING' },
  { date: 'Oct 15, 2023', type: 'Sale', amount: '+1.05', hash: '0x1c7...d44e', status: 'COMPLETED' },
]

function App() {
  const [activePage, setActivePage] = useState<Page>('Home')
  const pageTitle = activePage === 'Home' ? 'Dashboard' : activePage

  return (
    <div className="dashboard-shell">
      <aside className={`sidebar ${activePage.toLowerCase()}-sidebar`} aria-label="Seller dashboard navigation">
        <div className="brand-block">
          <div className="merchant-avatar">Ξ</div>
          <div>
            <div className="brand-name">EtherSeller</div>
            <div className="merchant-badge">{activePage === 'Products' || activePage === 'Finance' ? 'Verified Merchant' : 'VERIFIED MERCHANT'}</div>
          </div>
        </div>
        {activePage === 'Products' && (
          <div className="seller-profile-card">
            <div className="seller-profile-icon">◈</div>
            <div><strong>Seller Profile Avatar</strong><span>Verified Merchant</span></div>
          </div>
        )}

        <nav className="nav-list">
          {navItems.map((item) => (
            <button aria-label={item} className={`nav-item ${activePage === item ? 'active' : ''}`} key={item} onClick={() => setActivePage(item)} type="button">
              <span aria-hidden="true" className="nav-icon">{navIcon(item)}</span>
              <span>{item}</span>
            </button>
          ))}
          <button className="nav-item" type="button"><span className="nav-icon">⚙</span><span>Settings</span></button>
        </nav>
      </aside>

      <main className="main-area">
        <header className={`topbar ${activePage.toLowerCase()}-topbar`}>
          {activePage !== 'Orders' && <h1>{pageTitle}</h1>}
          <label className="search-pill">
            <span>⌕</span>
            <input placeholder={activePage === 'Orders' ? 'Search orders, TX hashes...' : activePage === 'Finance' ? 'Search...' : 'Search orders, contracts...'} aria-label="Search orders and contracts" />
          </label>
          <div className="top-actions">
            <div className="wallet-chip"><span />0.045 ETH / $124.20</div>
            <button className="icon-button" type="button" aria-label="Notifications">◒</button>
            <button className="icon-button" type="button" aria-label="Wallet">◈</button>
          </div>
        </header>

        <section className="canvas">
          {activePage === 'Home' && <OverviewPage />}
          {activePage === 'Products' && <ProductsPage />}
          {activePage === 'Orders' && <OrdersPage />}
          {activePage === 'Finance' && <FinancePage />}
        </section>
      </main>
    </div>
  )
}

function navIcon(item: Page) {
  return { Home: '⌂', Products: '▣', Orders: '≣', Finance: '◍' }[item]
}

function OverviewPage() {
  return (
    <div className="page-stack">
      <div className="metric-grid">
        {metrics.map((metric) => (
          <article className={`metric-card ${metric.tone}`} key={metric.label}>
            <div className="metric-orb" />
            <span>{metric.label}</span>
            <strong>{metric.value}</strong>
            <small>{metric.note}</small>
          </article>
        ))}
      </div>
      <div className="overview-grid">
        <article className="panel chart-panel">
          <div className="panel-header"><h2>7-Day Sales Volume</h2><button type="button">View Report ›</button></div>
          <div className="bar-chart" aria-label="7-day sales bar chart">
            {[58, 72, 44, 92, 63, 28, 20].map((height, index) => (
              <div className="bar-column" key={height + index}>
                <div className="ghost-bar" style={{ height: `${Math.max(18, 100 - height)}%` }} />
                <div className="hot-bar" style={{ height: `${height}%` }} />
                <span>{['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]}</span>
              </div>
            ))}
          </div>
        </article>
        <article className="panel activity-panel">
          <div className="panel-header"><h2>Recent Activity</h2><button type="button">•••</button></div>
          <ActivityItem title="Escrow Released" detail="Contract 0x8F2...91a completed." amount="+1.2 ETH" tone="green" />
          <ActivityItem title="New Bid Received" detail='Item #4092 "Abstract Genesis"' amount="0.45 ETH" tone="red" />
          <ActivityItem title="Listing Created" detail="Smart contract deployed successfully." amount="Tx: 0x2A..." tone="cream" />
          <ActivityItem title="Dispute Opened" detail="Order #882 requires attention." amount="Action Req" tone="amber" />
          <button className="wide-button" type="button">View All Activity</button>
        </article>
      </div>
    </div>
  )
}

function ActivityItem({ title, detail, amount, tone }: { title: string; detail: string; amount: string; tone: string }) {
  return <div className="activity-item"><div className={`activity-dot ${tone}`}>●</div><div><strong>{title}</strong><span>{detail}</span><small>2 mins ago</small></div><code>{amount}</code></div>
}

function ProductsPage() {
  return (
    <div className="page-stack">
      <PageIntro title="Inventory Studio" subtitle="Curate listings, tune prices, and keep your storefront contract-ready." action="Create Product" />
      <div className="product-grid">
        {products.map((product) => (
          <article className="product-card" key={product.name}>
            <div className="product-art" style={{ background: product.gradient }}><span>{product.status}</span></div>
            <div className="product-body"><h2>{product.name}</h2><div className="price-line"><strong>{product.price}</strong><span>{product.usd}</span></div><div className="product-actions"><button type="button">Edit Price</button><button type="button" aria-label={`Archive ${product.name}`}>⌫</button></div></div>
          </article>
        ))}
      </div>
    </div>
  )
}

function OrdersPage() {
  const counts = useMemo(() => [['ALL ORDERS', '1,284', '+12% this week'], ['IN ESCROW', '42', '8.45 ETH Locked'], ['SHIPPED', '89', 'Awaiting delivery confirmation'], ['COMPLETED', '1,153', 'Funds released']], [])
  return (
    <div className="page-stack">
      <PageIntro title="Order Management" subtitle="Track sales, monitor escrow status, and manage fulfillments." action="Export CSV" />
      <div className="order-metrics">{counts.map(([label, value, note]) => <article className="mini-card" key={label}><span>{label}</span><strong>{value}</strong><small>{note}</small></article>)}</div>
      <article className="panel table-panel">
        <div className="tabs"><button className="selected" type="button">All Orders</button><button type="button">Pending Payment</button><button type="button">In Escrow <b>42</b></button><button type="button">Shipped</button><button type="button">Completed</button></div>
        <div className="filter-row"><input placeholder="Filter by Item or Address..." /><button type="button">Filters</button></div>
        <table><thead><tr><th>ORDER ID / DATE</th><th>ITEM</th><th>BUYER ADDRESS</th><th>PRICE (ETH)</th><th>CONTRACT STATUS</th><th>ACTIONS</th></tr></thead><tbody>{orders.map((order) => <OrderRow key={order.id} order={order} />)}</tbody></table>
        <div className="pagination"><span>Showing 1-10 of 1,284 orders</span><div><button type="button">‹</button><button className="selected" type="button">1</button><button type="button">2</button><button type="button">3</button><span>...</span><button type="button">›</button></div></div>
      </article>
    </div>
  )
}

function OrderRow({ order }: { order: { id: string; date: string; item: string; buyer: string; price: string; status: OrderStatus } }) {
  return <tr><td><strong>{order.id}</strong><small>{order.date}</small></td><td><span className="item-thumb" />{order.item}</td><td><code>{order.buyer}</code></td><td>{order.price}</td><td><span className={`status ${order.status.toLowerCase().replaceAll(' ', '-')}`}>{order.status}</span></td><td><button type="button">{order.status === 'Funds Locked' ? 'Update Shipping Hash' : order.status === 'Completed' ? 'Funds Released' : 'View Details'}</button></td></tr>
}

function FinancePage() {
  return (
    <div className="page-stack">
      <PageIntro title="Finance & Wallet" subtitle="Manage your earnings, withdrawals, and smart contract settings." />
      <div className="finance-grid">
        <article className="balance-card"><span>AVAILABLE TO WITHDRAW</span><div><strong>3.2</strong><b>ETH</b></div><p>≈ $8,832.00 USD</p><div className="finance-actions"><button type="button">Withdraw Funds</button><button type="button">◈</button></div></article>
        <article className="panel wallet-card"><h2>Wallet Settings</h2><label>Payout Address<input value="0x71C...976F" readOnly /></label><button type="button">Edit Address</button><label>Gas Fee Preference</label><div className="gas-options"><button type="button">Low</button><button className="selected" type="button">Standard</button><button type="button">Fast</button></div><small>Current Standard Gas: 12 Gwei</small></article>
      </div>
      <article className="panel table-panel"><div className="panel-header"><h2>Transaction History</h2><button type="button">View All on Explorer ›</button></div><table><thead><tr><th>DATE</th><th>TYPE</th><th>AMOUNT (ETH)</th><th>TX HASH</th><th>STATUS</th></tr></thead><tbody>{transactions.map((tx) => <tr key={tx.hash}><td>{tx.date}</td><td>{tx.type}</td><td><strong>{tx.amount}</strong></td><td><code>{tx.hash}</code></td><td><span className={`tx-status ${tx.status.toLowerCase()}`}>{tx.status}</span></td></tr>)}</tbody></table><div className="load-more"><button type="button">Load More</button></div></article>
    </div>
  )
}

function PageIntro({ title, subtitle, action }: { title: string; subtitle: string; action?: string }) {
  return <div className="page-intro"><div><h2>{title}</h2><p>{subtitle}</p></div>{action && <button type="button">{action}</button>}</div>
}

export default App
