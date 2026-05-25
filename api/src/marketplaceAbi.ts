export const marketplaceAbi = [
  {
    type: 'function',
    name: 'createProduct',
    inputs: [
      { name: 'metadataURI', type: 'string' },
      { name: 'price', type: 'uint256' }
    ],
    outputs: [{ name: 'productId', type: 'uint256' }],
    stateMutability: 'nonpayable'
  },
  {
    type: 'function',
    name: 'getOrder',
    inputs: [{ name: 'orderId', type: 'uint256' }],
    outputs: [
      {
        name: 'order',
        type: 'tuple',
        components: [
          { name: 'id', type: 'uint256' },
          { name: 'productId', type: 'uint256' },
          { name: 'buyer', type: 'address' },
          { name: 'seller', type: 'address' },
          { name: 'amount', type: 'uint256' },
          { name: 'status', type: 'uint8' }
        ]
      }
    ],
    stateMutability: 'view'
  },
  {
    type: 'function',
    name: 'nextProductId',
    inputs: [],
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view'
  },
  {
    type: 'event',
    name: 'ProductCreated',
    inputs: [
      { name: 'productId', type: 'uint256', indexed: true },
      { name: 'seller', type: 'address', indexed: true },
      { name: 'metadataURI', type: 'string', indexed: false },
      { name: 'price', type: 'uint256', indexed: false }
    ]
  },
  {
    type: 'event',
    name: 'ProductPurchased',
    inputs: [
      { name: 'orderId', type: 'uint256', indexed: true },
      { name: 'productId', type: 'uint256', indexed: true },
      { name: 'buyer', type: 'address', indexed: true },
      { name: 'amount', type: 'uint256', indexed: false }
    ]
  },
  {
    type: 'event',
    name: 'OrderShipped',
    inputs: [{ name: 'orderId', type: 'uint256', indexed: true }]
  },
  {
    type: 'event',
    name: 'OrderCompleted',
    inputs: [{ name: 'orderId', type: 'uint256', indexed: true }]
  },
  {
    type: 'event',
    name: 'SellerWithdrawal',
    inputs: [
      { name: 'seller', type: 'address', indexed: true },
      { name: 'amount', type: 'uint256', indexed: false }
    ]
  }
] as const;
