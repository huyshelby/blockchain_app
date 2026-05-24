import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";

const { viem } = await network.connect();

async function deployMarketplaceFixture() {
  const [seller, buyer] = await viem.getWalletClients();
  const marketplace = await viem.deployContract("Marketplace");
  const publicClient = await viem.getPublicClient();

  return { marketplace, publicClient, seller, buyer };
}

describe("Marketplace products", () => {
  it("creates an active product listing", async () => {
    const { marketplace, publicClient, seller } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    const hash = await marketplace.write.createProduct(["ipfs://product-1", price], {
      account: seller.account
    });
    await publicClient.waitForTransactionReceipt({ hash });

    const product = await marketplace.read.getProduct([1n]);

    assert.equal(product.id, 1n);
    assert.equal(product.seller.toLowerCase(), seller.account.address.toLowerCase());
    assert.equal(product.metadataURI, "ipfs://product-1");
    assert.equal(product.price, price);
    assert.equal(product.active, true);
  });

  it("rejects listings with an empty metadata URI", async () => {
    const { marketplace, seller } = await deployMarketplaceFixture();

    await assert.rejects(
      marketplace.write.createProduct(["", 1n], { account: seller.account }),
      /InvalidMetadataURI/
    );
  });

  it("rejects listings with a zero price", async () => {
    const { marketplace, seller } = await deployMarketplaceFixture();

    await assert.rejects(
      marketplace.write.createProduct(["ipfs://product-1", 0n], { account: seller.account }),
      /InvalidPrice/
    );
  });
});

describe("Marketplace purchases", () => {
  it("lets a buyer purchase a product into escrow", async () => {
    const { marketplace, publicClient, seller, buyer } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.buyProduct([1n], {
        account: buyer.account,
        value: price
      })
    });

    const order = await marketplace.read.getOrder([1n]);

    assert.equal(order.id, 1n);
    assert.equal(order.productId, 1n);
    assert.equal(order.buyer.toLowerCase(), buyer.account.address.toLowerCase());
    assert.equal(order.seller.toLowerCase(), seller.account.address.toLowerCase());
    assert.equal(order.amount, price);
    assert.equal(order.status, 0);
  });

  it("rejects purchases with the wrong payment amount", async () => {
    const { marketplace, publicClient, seller, buyer } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await assert.rejects(
      marketplace.write.buyProduct([1n], { account: buyer.account, value: price - 1n }),
      /WrongPaymentAmount/
    );
  });

  it("prevents sellers from buying their own products", async () => {
    const { marketplace, publicClient, seller } = await deployMarketplaceFixture();
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });

    await assert.rejects(
      marketplace.write.buyProduct([1n], { account: seller.account, value: price }),
      /SellerCannotBuyOwnProduct/
    );
  });
});

describe("Marketplace escrow lifecycle", () => {
  async function createPaidOrderFixture() {
    const fixture = await deployMarketplaceFixture();
    const { marketplace, publicClient, seller, buyer } = fixture;
    const price = 1_000_000_000_000_000n;

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.createProduct(["ipfs://product-1", price], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.buyProduct([1n], { account: buyer.account, value: price })
    });

    return { ...fixture, price };
  }

  it("lets the seller mark an order shipped", async () => {
    const { marketplace, publicClient, seller } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });

    const order = await marketplace.read.getOrder([1n]);
    assert.equal(order.status, 1);
  });

  it("lets the buyer complete a shipped order", async () => {
    const { marketplace, publicClient, seller, buyer } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.completeOrder([1n], { account: buyer.account })
    });

    const order = await marketplace.read.getOrder([1n]);
    assert.equal(order.status, 2);
  });

  it("credits seller withdrawable balance when buyer completes order", async () => {
    const { marketplace, publicClient, seller, buyer, price } = await createPaidOrderFixture();

    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.markShipped([1n], { account: seller.account })
    });
    await publicClient.waitForTransactionReceipt({
      hash: await marketplace.write.completeOrder([1n], { account: buyer.account })
    });

    const balance = await marketplace.read.withdrawableBalance([seller.account.address]);
    assert.equal(balance, price);
  });

  it("blocks invalid order actors", async () => {
    const { marketplace, buyer } = await createPaidOrderFixture();

    await assert.rejects(
      marketplace.write.markShipped([1n], { account: buyer.account }),
      /OnlySeller/
    );
  });
});
