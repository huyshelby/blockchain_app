import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildOrderSection(context),
                  const SizedBox(height: 8),
                  _buildUtilitiesSection(),
                  const SizedBox(height: 8),
                  _buildMenuSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDB3416), AppColors.primary],
        ),
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.settings_outlined, size: 20, color: Colors.white),
                const SizedBox(width: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 20, color: Colors.white),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('3', style: AppTypography.labelSm.copyWith(color: AppColors.primary, fontSize: 10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/dd18a6fb-847e-4f95-945b-a4f9570d4fda',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.person, size: 32, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nguyen Van A', style: AppTypography.headlineMd.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium, size: 12, color: AppColors.onBackground),
                            const SizedBox(width: 4),
                            Text('Thành viên Bạc', style: AppTypography.labelSm.copyWith(color: AppColors.onBackground)),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 10, color: AppColors.onBackground),
                          ],
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

  Widget _buildOrderSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x0D281714), blurRadius: 12, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đơn mua', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  },
                  child: Row(
                    children: [
                      Text('Xem lịch sử mua hàng', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 12, color: AppColors.onSurfaceVariant),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFFFE2DC)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                _OrderStatusItem(icon: Icons.receipt_long_outlined, label: 'Chờ xác nhận', badgeCount: 1),
                _OrderStatusItem(icon: Icons.inventory_2_outlined, label: 'Chờ lấy hàng'),
                _OrderStatusItem(icon: Icons.local_shipping_outlined, label: 'Đang giao'),
                _OrderStatusItem(icon: Icons.rate_review_outlined, label: 'Đánh giá'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilitiesSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x0D281714), blurRadius: 12, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Tiện ích của tôi', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFFFE2DC)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _UtilityItem(icon: Icons.confirmation_number_outlined, label: 'Kho Voucher'),
                  _UtilityItem(icon: Icons.monetization_on_outlined, label: 'Xu thưởng'),
                  _UtilityItem(icon: Icons.favorite_border, label: 'Đã Thích'),
                  _UtilityItem(icon: Icons.history, label: 'Đã Xem'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x0D281714), blurRadius: 12, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _MenuItem(icon: Icons.person_outline, label: 'Thiết lập tài khoản'),
            _MenuItem(icon: Icons.help_outline, label: 'Trung tâm trợ giúp'),
            _MenuItem(icon: Icons.chat_outlined, label: 'Trò chuyện với chúng tôi'),
            _MenuItem(icon: Icons.info_outline, label: 'Giới thiệu', showBorder: false),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  const _OrderStatusItem({required this.icon, required this.label, this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 23, color: AppColors.onBackground),
              if (badgeCount > 0)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 1),
                    ),
                    child: Center(
                      child: Text('$badgeCount', style: AppTypography.labelSm.copyWith(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onBackground), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _UtilityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _UtilityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 23, color: AppColors.onBackground),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onBackground), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showBorder;
  const _MenuItem({required this.icon, required this.label, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFFFE2DC), width: 1)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onBackground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
          ),
          Icon(Icons.chevron_right, size: 14, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
