import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

class WalletBadge extends StatelessWidget {
  final String truncatedAddress;
  final String balance;
  final bool isSeller;

  const WalletBadge({
    super.key,
    required this.truncatedAddress,
    required this.balance,
    required this.isSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryContainer,
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                truncatedAddress,
                style:
                    AppTypography.labelMd.copyWith(color: AppColors.onSurface),
              ),
              Text(
                balance,
                style:
                    AppTypography.labelSm.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSeller
                  ? AppColors.tertiaryFixedDim.withValues(alpha: 0.2)
                  : AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isSeller ? 'Seller' : 'Buyer',
              style: AppTypography.labelSm.copyWith(
                color: isSeller ? AppColors.tertiary : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
