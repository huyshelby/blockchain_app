import { cleanup, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, describe, expect, it } from 'vitest'
import '@testing-library/jest-dom/vitest'
import App from './App'

const pages = [
  ['Home', '7-Day Sales Volume'],
  ['Products', 'Inventory Studio'],
  ['Orders', 'Order Management'],
  ['Finance', 'Finance & Wallet'],
]

afterEach(() => cleanup())

describe('Seller dashboard', () => {
  it('renders the full-screen seller dashboard shell', () => {
    render(<App />)

    expect(screen.getByText('EtherSeller')).toBeInTheDocument()
    expect(screen.getByText('VERIFIED MERCHANT')).toBeInTheDocument()
    expect(screen.getByText('0.045 ETH / $124.20')).toBeInTheDocument()
    expect(screen.getByPlaceholderText('Search orders, contracts...')).toBeInTheDocument()
  })

  it.each(pages)('shows %s page content from the sidebar', async (page, heading) => {
    const user = userEvent.setup()
    render(<App />)

    await user.click(screen.getByRole('button', { name: page }))

    expect(screen.getByRole('heading', { name: heading })).toBeInTheDocument()
  })
})
