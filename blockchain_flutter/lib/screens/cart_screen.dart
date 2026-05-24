import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final List<_ShopGroup> _shops = [
    _ShopGroup(
      name: 'TechZone Official',
      isSelected: true,
      items: [
        _CartItem(
          name: 'Laptop Mới Nhất 2024 Cấu Hình Mạnh Mẽ, Thiết Kế Mỏng Nhẹ…',
          variant: 'Màu: Bạc, RAM 16GB',
          price: '₫15.990.000',
          quantity: 1,
          isSelected: true,
          imageUrl: 'https://www.figma.com/api/mcp/asset/fb20c971-9ede-4c1f-88d3-48b09da8bb82',
        ),
      ],
    ),
    _ShopGroup(
      name: 'Fashion Boutique',
      isSelected: false,
      items: [
        _CartItem(
          name: 'Áo Thun Nam Cổ Tròn Basic Cotton 100% Thoáng Mát Phù…',
          variant: 'Trắng, Size L',
          price: '₫150.000',
          quantity: 2,
          isSelected: false,
          imageUrl: 'https://www.figma.com/api/mcp/asset/e01e68ee-6af3-41d9-ae37-5bdcb06eabdd',
        ),
      ],
    ),
  ];

  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ..._shops.map((shop) => _buildShopSection(shop)),
                  const SizedBox(height: 8),
                  _buildVoucherSection(),
                ],
              ),
            ),
          ),
          _buildFooter(context),
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
        right: 16,
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
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.onBackground),
            ),
          ),
          const SizedBox(width: 16),
          Text('Giỏ hàng (3)', style: AppTypography.headlineMd.copyWith(color: AppColors.onBackground)),
          const Spacer(),
          Text('Sửa', style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildShopSection(_ShopGroup shop) {
    return Padding(
      padding: EdgeInsets.only(top: shop == _shops.first ? 16 : 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHighest, width: 1)),
              ),
              child: Row(
                children: [
                  _Checkbox(isSelected: shop.isSelected, onTap: () {}),
                  const SizedBox(width: 7),
                  Icon(Icons.storefront, size: 15, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(shop.name, style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 14, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
            ...shop.items.map((item) => _buildCartItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(_CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _Checkbox(isSelected: item.isSelected, onTap: () {}),
          ),
          const SizedBox(width: 8),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Icon(Icons.image, color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(item.variant, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.price, style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
                    _QuantityStepper(quantity: item.quantity),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
        ),
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
                Text('Chọn hoặc nhập mã', style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 14, color: AppColors.outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          _Checkbox(isSelected: _selectAll, onTap: () => setState(() => _selectAll = !_selectAll)),
          const SizedBox(width: 7),
          Text('Tất cả', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tổng thanh toán:', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
              Text('₫15.990.000', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Mua hàng (1)', style: AppTypography.labelLg.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  const _Checkbox({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  const _QuantityStepper({required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text('-', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(vertical: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Center(
              child: Text('$quantity', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
            ),
          ),
          SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text('+', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopGroup {
  final String name;
  final bool isSelected;
  final List<_CartItem> items;
  _ShopGroup({required this.name, required this.isSelected, required this.items});
}

class _CartItem {
  final String name;
  final String variant;
  final String price;
  final int quantity;
  final bool isSelected;
  final String imageUrl;
  _CartItem({
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.imageUrl,
  });
}
