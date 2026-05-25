import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/marketplace_api_client.dart';
import '../models/order.dart';
import '../models/product.dart';

final marketplaceApiClientProvider = Provider.autoDispose<MarketplaceApiClient>(
  (ref) {
    return MarketplaceApiClient();
  },
);

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final api = ref.watch(marketplaceApiClientProvider);
  return api.fetchProducts();
});

final featuredProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final api = ref.watch(marketplaceApiClientProvider);
  return api.fetchProducts(tag: 'featured');
});

final flashSaleProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final api = ref.watch(marketplaceApiClientProvider);
  return api.fetchProducts(tag: 'flash-sale');
});

final productProvider = FutureProvider.autoDispose.family<Product, BigInt>((
  ref,
  productId,
) async {
  final api = ref.watch(marketplaceApiClientProvider);
  return api.fetchProduct(productId);
});

final buyerOrdersProvider = FutureProvider.autoDispose
    .family<List<MarketplaceOrder>, String>((ref, buyer) async {
      final api = ref.watch(marketplaceApiClientProvider);
      return api.fetchOrders(buyer: buyer);
    });

final sellerOrdersProvider = FutureProvider.autoDispose
    .family<List<MarketplaceOrder>, String>((ref, seller) async {
      final api = ref.watch(marketplaceApiClientProvider);
      return api.fetchOrders(seller: seller);
    });

final orderProvider = FutureProvider.autoDispose
    .family<MarketplaceOrder, BigInt>((ref, orderId) async {
      final api = ref.watch(marketplaceApiClientProvider);
      return api.fetchOrder(orderId);
    });
