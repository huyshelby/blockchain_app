import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

class EscrowProgress extends StatelessWidget {
  final int currentStatus; // 0=Paid, 1=Shipped, 2=Completed

  const EscrowProgress({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = ['Paid', 'Shipped', 'Completed'];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isActive = currentStatus > stepIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? AppColors.primary : AppColors.outlineVariant,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = currentStatus >= stepIndex;
        final isCurrent = currentStatus == stepIndex;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
                border: isCurrent
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: isActive
                  ? const Icon(Icons.check, size: 14, color: AppColors.onPrimary)
                  : null,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              steps[stepIndex],
              style: AppTypography.labelSm.copyWith(
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        );
      }),
    );
  }
}
