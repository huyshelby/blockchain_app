import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedColor = 0;
  int _selectedSize = 0;
  int _currentImage = 0;

  final List<String> _colors = ['Silver', 'Black', 'Blue'];
  final List<String> _sizes = ['Standard', 'XL (Out of Stock)'];
  final List<bool> _sizeAvailable = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageGallery(),
                  _buildPriceSection(),
                  const SizedBox(height: 4),
                  _buildVariationSection(),
                  const SizedBox(height: 4),
                  _buildDeliveryInfo(),
                  const SizedBox(height: 4),
                  _buildProductDetails(),
                  const SizedBox(height: 4),
                  _buildReviewsSection(),
                  const SizedBox(height: 16),
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
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.onBackground),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(9999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(Icons.search, size: 19, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search products...',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20, color: AppColors.onBackground),
            onPressed: () {},
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.onBackground),
                onPressed: () {},
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 1),
                  ),
                  child: Center(
                    child: Text('2', style: AppTypography.labelSm.copyWith(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: 4,
            onPageChanged: (i) => setState(() => _currentImage = i),
            itemBuilder: (_, i) => Container(
              color: Colors.white,
              child: Image.network(
                'https://www.figma.com/api/mcp/asset/7db8254d-19e3-45d6-b4ce-9cd10d5e576f',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(
                  child: Icon(Icons.headphones, size: 80, color: AppColors.outline),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text('MALL', style: AppTypography.labelSm.copyWith(color: Colors.white, letterSpacing: 0.5)),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i == _currentImage ? AppColors.primary : AppColors.surfaceContainerHighest.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$199.00', style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '\$249.00',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text('-20%', style: AppTypography.labelSm.copyWith(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Premium Noise Cancelling Wireless Headphones - Silver Edition',
            style: AppTypography.titleMd.copyWith(color: AppColors.onBackground, height: 22 / 16),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star, size: 13, color: AppColors.tertiary),
              const SizedBox(width: 4),
              Text('4.8', style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
              Text(' (500+)', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 12),
              Container(width: 1, height: 12, color: AppColors.outlineVariant),
              const SizedBox(width: 12),
              Text('1.2k sold', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariationSection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: AppTypography.labelLg.copyWith(color: AppColors.onBackground)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_colors.length, (i) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedColor = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedColor == i ? const Color(0x33FFDAD3) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedColor == i ? AppColors.primary : AppColors.outlineVariant,
                      width: _selectedColor == i ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    _colors[i],
                    style: _selectedColor == i
                        ? AppTypography.labelMd.copyWith(color: AppColors.primary)
                        : AppTypography.bodyMd.copyWith(color: AppColors.onBackground),
                  ),
                ),
              ),
            )),
          ),
          const SizedBox(height: 16),
          Text('Size', style: AppTypography.labelLg.copyWith(color: AppColors.onBackground)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_sizes.length, (i) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: _sizeAvailable[i] ? () => setState(() => _selectedSize = i) : null,
                child: Opacity(
                  opacity: _sizeAvailable[i] ? 1.0 : 0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedSize == i && _sizeAvailable[i] ? const Color(0x33FFDAD3) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedSize == i && _sizeAvailable[i] ? AppColors.primary : AppColors.outlineVariant,
                        width: _selectedSize == i && _sizeAvailable[i] ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      _sizes[i],
                      style: _selectedSize == i && _sizeAvailable[i]
                          ? AppTypography.labelMd.copyWith(color: AppColors.primary)
                          : AppTypography.bodyMd.copyWith(color: AppColors.onBackground),
                    ),
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Standard Delivery', style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
                Text('Estimated arrival: Oct 25 - 28', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Text('\$2.99', style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product Details', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
              Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Experience pure audio bliss with our Premium Noise Cancelling Wireless Headphones. Featuring advanced Active Noise Cancellation (ANC) technology, high-…',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 22.75 / 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Product Ratings', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                  const SizedBox(width: 4),
                  Text('(150 reviews)', style: AppTypography.bodySm.copyWith(color: AppColors.primary)),
                ],
              ),
              Row(
                children: [
                  Text('See All', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 9),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(5, (_) => Icon(Icons.star, size: 12, color: AppColors.tertiary)),
                    const SizedBox(width: 8),
                    Text('J***.', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Absolutely love these! The noise cancellation is amazing for my daily commute. The silver finish looks very premium.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.onBackground),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/b4c1386b-846b-48a1-8853-8d75daa4c197',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Icon(Icons.image, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
        top: 9,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
        boxShadow: [BoxShadow(color: Color(0x0D281714), blurRadius: 6, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          _BottomIcon(icon: Icons.chat_bubble_outline, label: 'Chat'),
          _BottomIcon(icon: Icons.shopping_cart_outlined, label: 'Cart'),
          Container(width: 1, height: 48, margin: const EdgeInsets.symmetric(horizontal: 4), color: AppColors.outlineVariant),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Center(
                        child: Text('Add to Cart', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
                      ),
                      child: Center(
                        child: Text('Buy Now', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
