import 'product_metadata.dart';

class Product {
  final BigInt id;
  final String seller;
  final String metadataURI;
  final BigInt priceWei;
  final bool active;
  final ProductMetadata metadata;

  const Product({
    required this.id,
    required this.seller,
    required this.metadataURI,
    required this.priceWei,
    required this.active,
    required this.metadata,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: BigInt.parse(json['id'].toString()),
      seller: json['seller'] as String? ?? '',
      metadataURI: json['metadataURI'] as String? ?? '',
      priceWei: BigInt.parse(json['priceWei'].toString()),
      active: json['active'] as bool? ?? false,
      metadata: ProductMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  double get priceEth => priceWei.toDouble() / 1000000000000000000;

  String get priceLabel => '${priceEth.toStringAsFixed(3)} ETH';

  String get imageUrl => metadata.thumbnailUrl.isNotEmpty
      ? metadata.thumbnailUrl
      : (metadata.images.isNotEmpty ? metadata.images.first : '');
}
