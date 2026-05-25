import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/order.dart';
import '../models/product.dart';

class MarketplaceApiClient {
  MarketplaceApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<List<Product>> fetchProducts({
    String? category,
    String? tag,
    String? seller,
  }) async {
    final query = <String, String>{};
    if (category != null) query['category'] = category;
    if (tag != null) query['tag'] = tag;
    if (seller != null) query['seller'] = seller;
    final json = await _get('/products', query);
    return (json as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<Product> fetchProduct(BigInt id) async {
    final json = await _get('/products/$id');
    return Product.fromJson(json as Map<String, dynamic>);
  }

  Future<List<MarketplaceOrder>> fetchOrders({
    String? buyer,
    String? seller,
  }) async {
    final query = <String, String>{};
    if (buyer != null) query['buyer'] = buyer;
    if (seller != null) query['seller'] = seller;
    final json = await _get('/orders', query);
    return (json as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(MarketplaceOrder.fromJson)
        .toList();
  }

  Future<MarketplaceOrder> fetchOrder(BigInt id) async {
    final json = await _get('/orders/$id');
    return MarketplaceOrder.fromJson(json as Map<String, dynamic>);
  }

  Future<dynamic> _get(String path, [Map<String, String>? query]) async {
    final uri = Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: query?.isEmpty ?? true ? null : query);
    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'API request failed: ${response.statusCode} ${response.body}',
      );
    }
    return jsonDecode(response.body);
  }
}
