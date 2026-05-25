import { createPublicClient, createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { foundry } from 'viem/chains';
import { config } from './config.js';

export const publicClient = createPublicClient({
  chain: foundry,
  transport: http(config.rpcUrl)
});

export const sellerAccount = privateKeyToAccount(config.sellerPrivateKey);

export const walletClient = createWalletClient({
  account: sellerAccount,
  chain: foundry,
  transport: http(config.rpcUrl)
});
