import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_provider.dart';

final productsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(marketplaceServiceProvider);
  final nextId = await service.getNextProductId();
  final products = <Map<String, dynamic>>[];
  for (var i = BigInt.one; i < nextId; i += BigInt.one) {
    final p = await service.getProduct(i);
    if (p['active'] == true) products.add(p);
  }
  return products;
});

final orderProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, BigInt>((ref, orderId) async {
  final service = ref.watch(marketplaceServiceProvider);
  return service.getOrder(orderId);
});

final nextProductIdProvider = FutureProvider.autoDispose<BigInt>((ref) async {
  final service = ref.watch(marketplaceServiceProvider);
  return service.getNextProductId();
});
