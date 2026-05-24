import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'escrow_progress.dart';

class OrderCard extends StatelessWidget {
  final BigInt orderId;
  final BigInt productId;
  final int status;
  final String buyer;
  final String seller;
  final String amount;
  final bool isSeller;
  final VoidCallback? onMarkShipped;
  final VoidCallback? onComplete;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.productId,
    required this.status,
    required this.buyer,
    required this.seller,
    required this.amount,
    required this.isSeller,
    this.onMarkShipped,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D281714),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #$orderId',
                  style: AppTypography.titleMd
                      .copyWith(color: AppColors.onSurface)),
              Text(amount,
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Product #$productId',
            style: AppTypography.bodySm
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          EscrowProgress(currentStatus: status),
          const SizedBox(height: AppSpacing.md),
          if (isSeller && status == 0)
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: onMarkShipped,
                icon: const Icon(Icons.local_shipping, size: 18),
                label: Text('Mark Shipped', style: AppTypography.labelMd),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          if (!isSeller && status == 1)
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check_circle, size: 18),
                label: Text('Confirm Received', style: AppTypography.labelMd),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
