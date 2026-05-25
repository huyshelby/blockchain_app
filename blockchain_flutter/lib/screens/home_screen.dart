import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';
import '../models/product.dart';
import '../providers/marketplace_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<_CategoryData> _categories = [
    _CategoryData(icon: Icons.devices, label: 'Tech'),
    _CategoryData(icon: Icons.checkroom, label: 'Fashion'),
    _CategoryData(icon: Icons.home_outlined, label: 'Home'),
    _CategoryData(icon: Icons.spa_outlined, label: 'Beauty'),
    _CategoryData(icon: Icons.sports_basketball, label: 'Sports'),
    _CategoryData(icon: Icons.toys_outlined, label: 'Toys'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildPromoBanner()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildFlashSale()),
          SliverToBoxAdapter(child: _buildProductGridHeader()),
          _buildProductGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      toolbarHeight: 56,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(9999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search for products...',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _CartIcon(),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.chat_bubble_outline,
              color: AppColors.onBackground,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.network(
                  'https://www.figma.com/api/mcp/asset/0c362cc2-2bc5-4f45-8035-f73aab1127fc',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0x99000000), Color(0x00000000)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BIG SALE',
                      style: AppTypography.displayLg.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Up to 70% off on selected items.',
                      style: AppTypography.bodyMd.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        itemCount: _categories.length,
        separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          return SizedBox(
            width: 60,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    cat.icon,
                    color: AppColors.onBackground,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat.label,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlashSale() {
    final flashProducts = ref.watch(flashSaleProductsProvider);
    return Container(
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Flash Sale',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              _CountdownBox(value: '02'),
              _CountdownSeparator(),
              _CountdownBox(value: '45'),
              _CountdownSeparator(),
              _CountdownBox(value: '12'),
              const Spacer(),
              Text(
                'See All >',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: flashProducts.when(
              data: (products) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (c, i) => const SizedBox(width: 16),
                itemBuilder: (_, i) => _FlashProductCard(product: products[i]),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  _LoadError(message: 'Unable to load flash sale products'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'Just For You',
        style: AppTypography.headlineMd.copyWith(color: AppColors.onBackground),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = ref.watch(productsProvider);
    return products.when(
      data: (items) => SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.58,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _ProductCard(product: items[index]),
            childCount: items.length,
          ),
        ),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Unable to load products'),
        ),
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.onBackground,
              size: 20,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '3',
                  style: AppTypography.labelSm.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String value;
  const _CountdownBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: AppTypography.labelMd.copyWith(color: Colors.white),
      ),
    );
  }
}

class _CountdownSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        ':',
        style: AppTypography.labelMd.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _FlashProductCard extends StatelessWidget {
  final Product product;
  const _FlashProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 128,
                  width: double.infinity,
                  color: AppColors.surfaceContainerHighest,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Icon(Icons.image, color: AppColors.onSurfaceVariant),
                  ),
                ),
                if (product.metadata.discountPercent != null)
                  Positioned(
                    top: 8,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        '-${product.metadata.discountPercent}%',
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      product.priceLabel,
                      style: AppTypography.titleMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: LinearProgressIndicator(
                      value: (product.metadata.soldCount / 1000).clamp(
                        0.1,
                        1.0,
                      ),
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      '${product.metadata.soldCount}+ sold',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
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

class _LoadError extends StatelessWidget {
  final String message;
  const _LoadError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D281714),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 173,
                  width: double.infinity,
                  color: AppColors.surfaceContainerHighest,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Icon(Icons.image, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.metadata.discountPercent == null
                          ? 'VIP'
                          : '${product.metadata.discountPercent}% OFF',
                      style: AppTypography.labelSm.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow.withValues(
                        alpha: 0.8,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 15,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.metadata.name,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onBackground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.priceLabel,
                      style: AppTypography.titleMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 10, color: AppColors.tertiary),
                        const SizedBox(width: 2),
                        Text(
                          '${product.metadata.rating}',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '|',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Text(
                          '${product.metadata.soldCount}+ sold',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final IconData icon;
  final String label;
  _CategoryData({required this.icon, required this.label});
}
