import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategorySection(),
                  Container(height: 8, color: const Color(0xFFFFF0EE)),
                  _buildNotificationsFeed(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 1)),
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Center(
                  child: Text(
                    'Vibrant Marketplace',
                    style: AppTypography.titleLg.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.onBackground),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông báo', style: AppTypography.titleLg.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          Row(
            children: const [
              _CategoryButton(
                color: Color(0xFFDB3416),
                icon: Icons.local_offer_outlined,
                label: 'Khuyến\nmãi',
              ),
              SizedBox(width: 12),
              _CategoryButton(
                color: Color(0xFFE51D25),
                icon: Icons.local_shipping_outlined,
                label: 'Cập nhật\nđơn hàng',
                badgeCount: 2,
              ),
              SizedBox(width: 12),
              _CategoryButton(
                color: Color(0xFF976D00),
                icon: Icons.campaign_outlined,
                label: 'Tin tức\nhệ thống',
              ),
              SizedBox(width: 12),
              _CategoryButton(
                color: AppColors.surfaceContainerHighest,
                icon: Icons.sports_esports_outlined,
                label: 'Giải\ntrí',
                iconColor: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsFeed() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildOrderNotification(),
          const SizedBox(height: 16),
          _buildPromoNotification(),
          const SizedBox(height: 16),
          _buildSystemNotification(),
        ],
      ),
    );
  }

  Widget _buildOrderNotification() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBDCD6).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB4A5).withValues(alpha: 0.3)),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 4, color: AppColors.primary)),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/387a4860-c25a-4ba8-9e3d-59b30c706fad',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.image, color: AppColors.outline),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Đơn hàng đang giao', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w700)),
                          Text('10:42', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                          children: [
                            const TextSpan(text: 'Đơn hàng '),
                            TextSpan(text: '#VN883920', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                            const TextSpan(text: ' của bạn\nđang được giao bởi J&T…'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text('Track Order', style: AppTypography.labelLg.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoNotification() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
      ),
      padding: const EdgeInsets.all(17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFDB3416),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer_outlined, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Voucher 50k dành riêng\ncho bạn',
                        style: AppTypography.titleMd.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text('Hôm\nqua', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Mã giảm giá đã được thêm vào Ví\nVoucher của bạn. Áp dụng cho\nđơn từ 200k. Đừng bỏ lỡ!',
                    style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE2DC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 12, color: AppColors.onBackground),
                      const SizedBox(width: 6),
                      Text('Hết hạn trong 2 ngày', style: AppTypography.bodyLg.copyWith(color: AppColors.onBackground)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemNotification() {
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
        ),
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF976D00),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.campaign_outlined, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Chào mừng đến Vibrant\nMarketplace',
                          style: AppTypography.titleMd.copyWith(color: AppColors.onBackground),
                        ),
                      ),
                      Text('12\nTh08', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Khám phá hàng ngàn ưu đãi hấp\ndẫn mỗi ngày. Hoàn thiện hồ sơ\ncủa bạn ngay để nhận ngay gói…',
                    style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final int badgeCount;
  final Color? iconColor;

  const _CategoryButton({
    required this.color,
    required this.icon,
    required this.label,
    this.badgeCount = 0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 1, offset: const Offset(0, 1))],
                ),
                child: Icon(icon, size: 20, color: iconColor ?? Colors.white),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBA1A1A),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: Center(
                      child: Text('$badgeCount', style: AppTypography.labelSm.copyWith(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
