class ProductVariant {
  final String name;
  final List<String> values;

  const ProductVariant({required this.name, required this.values});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      name: json['name'] as String? ?? '',
      values: (json['values'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
    );
  }
}

class ProductMetadata {
  final String slug;
  final String name;
  final String description;
  final String category;
  final String subCategory;
  final String shopName;
  final String thumbnailUrl;
  final List<String> images;
  final double rating;
  final int soldCount;
  final int? discountPercent;
  final List<ProductVariant> variants;
  final List<String> tags;
  final String priceEth;

  const ProductMetadata({
    required this.slug,
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.shopName,
    required this.thumbnailUrl,
    required this.images,
    required this.rating,
    required this.soldCount,
    required this.discountPercent,
    required this.variants,
    required this.tags,
    required this.priceEth,
  });

  factory ProductMetadata.fromJson(Map<String, dynamic> json) {
    return ProductMetadata(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? 'Product',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Marketplace',
      subCategory: json['subCategory'] as String? ?? 'General',
      shopName: json['shopName'] as String? ?? 'Blockchain VIP',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      soldCount: (json['soldCount'] as num?)?.toInt() ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      variants: (json['variants'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductVariant.fromJson)
          .toList(),
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
      priceEth: json['priceEth'] as String? ?? '0',
    );
  }
}
