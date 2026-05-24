import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAddressSection(),
                  const SizedBox(height: 8),
                  _buildOrderSection(),
                  const SizedBox(height: 8),
                  _buildVoucherSection(),
                  const SizedBox(height: 8),
                  _buildPaymentMethod(),
                  const SizedBox(height: 8),
                  _buildPaymentSummary(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 9,
        left: 16,
        right: 48,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.onBackground),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Thanh toán', style: AppTypography.titleLg.copyWith(color: AppColors.onBackground)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0),
                  AppColors.secondary,
                  AppColors.secondary.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.126, 0.253, 0.505],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Địa chỉ nhận hàng', style: AppTypography.labelLg.copyWith(color: AppColors.onBackground)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Nguyen Van A', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                          const SizedBox(width: 8),
                          Text('|', style: AppTypography.bodyLg.copyWith(color: AppColors.outlineVariant)),
                          const SizedBox(width: 8),
                          Text('(+84) 912 345 678', style: AppTypography.bodyLg.copyWith(color: AppColors.onBackground)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tòa nhà Tech, 123 Đường Công Nghệ, Phường Sáng Tạo, Quận Đổi Mới, TP. Hồ Chí Minh',
                        style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection() {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.storefront, size: 16, color: AppColors.onBackground),
                const SizedBox(width: 8),
                Text('TechGear Official Store', style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
              ],
            ),
          ),
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/95d5a7a5-7df3-4226-84db-01fc7de18e9c',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Icon(Icons.headphones, color: AppColors.outline),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tai nghe Bluetooth chống ồn chủ động không dây cao cấp ANC V5.3',
                        style: AppTypography.bodySm.copyWith(color: AppColors.onBackground),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Phân loại: Đen Titan', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('₫1.250.000', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                          Text('x1', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHighest, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phương thức vận chuyển', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
                    const SizedBox(height: 4),
                    Text('Nhanh', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                    Text('Nhận hàng vào 12 Th10 - 14 Th10', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Row(
                  children: [
                    Text('₫25.000', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 14, color: AppColors.onSurfaceVariant),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHighest, width: 1)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text('Tin nhắn:', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
                ),
                Expanded(
                  child: Text(
                    'Lưu ý cho người bán...',
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Tổng số tiền (1 sản phẩm): ', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                Text('₫1.275.000', style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Voucher giảm giá', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Chọn hoặc nhập mã', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 14, color: AppColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 20, color: AppColors.onBackground),
              const SizedBox(width: 8),
              Text('Phương thức thanh\ntoán', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
            ],
          ),
          Row(
            children: [
              Text('Thanh toán khi nhận\nhàng', style: AppTypography.bodySm.copyWith(color: AppColors.onBackground)),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 14, color: AppColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chi tiết thanh toán', style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Tổng tiền hàng', value: '₫1.250.000'),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Tổng phí vận chuyển', value: '₫25.000'),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Giảm giá phí vận chuyển', value: '-₫15.000', isDiscount: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(top: 9),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.surfaceContainerHighest, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng thanh toán', style: AppTypography.labelLg.copyWith(color: AppColors.onBackground)),
                Text('₫1.260.000', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
        boxShadow: [BoxShadow(color: Color(0x0D281714), blurRadius: 6, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tổng thanh toán', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      Text('₫1.260.000', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 64,
                  constraints: const BoxConstraints(minWidth: 140),
                  color: AppColors.primary,
                  child: Center(
                    child: Text('Đặt hàng', style: AppTypography.titleMd.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;
  const _SummaryRow({required this.label, required this.value, this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            color: isDiscount ? AppColors.primary : AppColors.onBackground,
          ),
        ),
      ],
    );
  }
}
