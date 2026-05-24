import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

enum TxStatus { idle, pending, success, error }

class TxStatusIndicator extends StatelessWidget {
  final TxStatus status;
  final String? txHash;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const TxStatusIndicator({
    super.key,
    required this.status,
    this.txHash,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TxStatus.idle:
        return const SizedBox.shrink();
      case TxStatus.pending:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Processing transaction...',
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        );
      case TxStatus.success:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction successful',
                        style: AppTypography.labelMd
                            .copyWith(color: const Color(0xFF2E7D32))),
                    if (txHash != null)
                      Text(
                        'TX: ${txHash!.substring(0, 16)}...',
                        style: AppTypography.bodySm
                            .copyWith(color: const Color(0xFF4CAF50)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      case TxStatus.error:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  errorMessage ?? 'Transaction failed',
                  style: AppTypography.bodySm.copyWith(color: AppColors.error),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: Text('Retry',
                      style:
                          AppTypography.labelMd.copyWith(color: AppColors.error)),
                ),
            ],
          ),
        );
    }
  }
}
