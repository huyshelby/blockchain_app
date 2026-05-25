import 'product.dart';

class MarketplaceOrder {
  final BigInt id;
  final BigInt productId;
  final String buyer;
  final String seller;
  final BigInt amountWei;
  final int status;
  final String statusLabel;
  final Product? product;

  const MarketplaceOrder({
    required this.id,
    required this.productId,
    required this.buyer,
    required this.seller,
    required this.amountWei,
    required this.status,
    required this.statusLabel,
    required this.product,
  });

  factory MarketplaceOrder.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return MarketplaceOrder(
      id: BigInt.parse(json['id'].toString()),
      productId: BigInt.parse(json['productId'].toString()),
      buyer: json['buyer'] as String? ?? '',
      seller: json['seller'] as String? ?? '',
      amountWei: BigInt.parse(json['amountWei'].toString()),
      status: (json['status'] as num?)?.toInt() ?? 0,
      statusLabel: json['statusLabel'] as String? ?? 'Paid',
      product: productJson is Map<String, dynamic>
          ? Product.fromJson(productJson)
          : null,
    );
  }

  double get amountEth => amountWei.toDouble() / 1000000000000000000;

  String get amountLabel => '${amountEth.toStringAsFixed(3)} ETH';

  String get buyerStatusLabel {
    return switch (status) {
      0 => 'To Ship',
      1 => 'To Receive',
      2 => 'Completed',
      _ => 'Cancelled',
    };
  }
}
