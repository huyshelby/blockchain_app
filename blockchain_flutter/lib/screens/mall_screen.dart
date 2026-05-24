import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  int _selectedCategory = 0;

  final List<_SidebarCategory> _categories = [
    _SidebarCategory(icon: Icons.devices, label: 'Công\nnghệ'),
    _SidebarCategory(icon: Icons.checkroom, label: 'Thời\ntrang'),
    _SidebarCategory(icon: Icons.home_outlined, label: 'Nhà cửa'),
    _SidebarCategory(icon: Icons.spa_outlined, label: 'Làm đẹp'),
    _SidebarCategory(icon: Icons.sports_basketball, label: 'Thể thao'),
    _SidebarCategory(icon: Icons.toys_outlined, label: 'Đồ chơi'),
    _SidebarCategory(icon: Icons.local_grocery_store, label: 'Siêu thị'),
  ];

  final List<_SubCategory> _subCategories = [
    _SubCategory(
      label: 'Laptop & Máy\ntính',
      imageUrl: 'https://www.figma.com/api/mcp/asset/50a0ec04-8780-4ac8-a0ff-7e2e414498b8',
    ),
    _SubCategory(
      label: 'Âm thanh',
      imageUrl: 'https://www.figma.com/api/mcp/asset/38ea7770-c276-4631-81db-c0a249e9a1b6',
    ),
    _SubCategory(
      label: 'Đồng hồ\nthông minh',
      imageUrl: 'https://www.figma.com/api/mcp/asset/932c2eb6-69c0-4558-9e47-5a6895d3196b',
    ),
    _SubCategory(
      label: 'Phụ kiện điện\nthoại',
      imageUrl: 'https://www.figma.com/api/mcp/asset/d67eb3fc-e8b5-4789-9a69-b7e302148d5b',
    ),
  ];

  final List<_PopularProduct> _popularProducts = [
    _PopularProduct(
      name: 'Tay cầm chơi game không dây',
      price: '1.250.000đ',
      discount: '-15%',
      imageUrl: 'https://www.figma.com/api/mcp/asset/1b634d54-9888-44a2-90bc-d6edba397bf7',
    ),
    _PopularProduct(
      name: 'Loa Bluetooth Mini Âm Thanh…',
      price: '450.000đ',
      imageUrl: 'https://www.figma.com/api/mcp/asset/b4302dfc-870c-48f9-af89-1122d3ee6001',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tìm kiếm sản phẩm...',
                      style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.onBackground),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 88,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final isActive = i == _selectedCategory;
          final cat = _categories[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                color: isActive ? AppColors.surfaceContainer : Colors.transparent,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(cat.icon, size: 20, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
                      ),
                      Text(
                        cat.label,
                        style: isActive
                            ? AppTypography.titleMd.copyWith(color: AppColors.primary)
                            : AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (isActive)
                    Positioned(
                      left: -8,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 4, color: AppColors.primary),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Công nghệ & Điện tử', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
                Row(
                  children: [
                    Text('Xem tất cả', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 12, color: AppColors.primary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildHighlightCard(),
            const SizedBox(height: 12),
            _buildSubCategoryGrid(),
            const SizedBox(height: 32),
            Text('Sản phẩm phổ biến', style: AppTypography.titleMd.copyWith(color: AppColors.onBackground)),
            const SizedBox(height: 16),
            _buildPopularProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard() {
    return Container(
      height: 140,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://www.figma.com/api/mcp/asset/220fcc60-191b-4286-b788-f3f88aeeb9c1',
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: AppColors.primaryContainer),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xCC3F2C28), Color(0x003F2C28)],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Điện thoại Mới', style: AppTypography.titleMd.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Giảm đến 30%', style: AppTypography.bodyLg.copyWith(color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: _subCategories.length,
      itemBuilder: (_, i) {
        final sub = _subCategories[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  sub.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(Icons.category, color: AppColors.outline),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sub.label,
                style: AppTypography.labelMd.copyWith(color: AppColors.onBackground),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularProducts() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _popularProducts.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final product = _popularProducts[i];
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
              boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      color: AppColors.surfaceContainerLow,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(Icons.image, color: AppColors.outline),
                      ),
                    ),
                    if (product.discount != null)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(product.discount!, style: AppTypography.bodyLg.copyWith(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyLg.copyWith(color: AppColors.onBackground),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.price,
                        style: AppTypography.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SidebarCategory {
  final IconData icon;
  final String label;
  _SidebarCategory({required this.icon, required this.label});
}

class _SubCategory {
  final String label;
  final String imageUrl;
  _SubCategory({required this.label, required this.imageUrl});
}

class _PopularProduct {
  final String name;
  final String price;
  final String? discount;
  final String imageUrl;
  _PopularProduct({required this.name, required this.price, this.discount, required this.imageUrl});
}
