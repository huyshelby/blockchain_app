import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../widgets/bottom_nav_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['All', 'To Pay', 'To Ship', 'To Receive', 'Completed'];

  final List<_OrderData> _orders = [
    _OrderData(
      shopName: 'Tech Gadget Store',
      status: 'Completed',
      statusColor: AppColors.primary,
      productName: 'Premium Wireless Noise-Cancelling Headphones Pro Max',
      variant: 'Color: Matte Black',
      quantity: 1,
      price: '\$299.00',
      total: '\$299.00',
      imageUrl: 'https://www.figma.com/api/mcp/asset/774c2b2f-f627-474f-9a24-4374c0ded14b',
      primaryAction: 'Rate',
      primaryFilled: true,
      secondaryAction: 'Buy Again',
    ),
    _OrderData(
      shopName: 'Urban Sneaker Hub',
      status: 'To Ship',
      statusColor: AppColors.secondary,
      productName: 'Limited Edition Urban Running Shoes',
      variant: 'Size: US 10 | Color: Fire Red',
      quantity: 1,
      price: '\$145.50',
      total: '\$145.50',
      imageUrl: 'https://www.figma.com/api/mcp/asset/72b72794-59de-4ad9-b8b4-04530f6199c0',
      primaryAction: 'Track Order',
      primaryFilled: false,
      secondaryAction: 'Contact Seller',
    ),
    _OrderData(
      shopName: 'Modern Home Decor',
      status: 'To Receive',
      statusColor: AppColors.onSurfaceVariant,
      productName: 'Minimalist Ceramic Vase - Nordic Design Collection',
      variant: 'Style: Tall | Color: Off-White',
      quantity: 2,
      price: '\$34.00',
      total: '\$68.00',
      imageUrl: 'https://www.figma.com/api/mcp/asset/e78fd5a2-68ec-4f27-9cff-40dab5adfabf',
      primaryAction: 'Track Order',
      primaryFilled: false,
      secondaryAction: null,
      statusNote: 'Parcel is out for delivery',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildTabs(),
          Expanded(child: _buildOrderList()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.onBackground),
          ),
          Text('My Orders', style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.onBackground),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: AppColors.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search product name or Order ID',
                style: AppTypography.bodyMd.copyWith(color: AppColors.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.background,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        labelStyle: AppTypography.labelLg,
        unselectedLabelStyle: AppTypography.labelMd,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        dividerColor: AppColors.outlineVariant,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _orders.length,
      separatorBuilder: (c, i) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _OrderCard(order: _orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _OrderData order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(order.shopName, style: AppTypography.labelLg.copyWith(color: AppColors.onBackground)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 10, color: AppColors.onSurfaceVariant),
                  ],
                ),
                Text(order.status, style: AppTypography.labelMd.copyWith(color: order.statusColor)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFFFE9E5)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFFFE9E5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    order.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Icon(Icons.image, color: AppColors.outline),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.productName,
                              style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(order.variant, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('x${order.quantity}', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                            Text(order.price, style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFFFE9E5)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Order Total: ', style: AppTypography.bodyMd.copyWith(color: AppColors.onBackground)),
                    Text(order.total, style: AppTypography.titleLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (order.statusNote != null)
                      Expanded(
                        child: Text(order.statusNote!, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      )
                    else
                      const Spacer(),
                    Row(
                      children: [
                        if (order.secondaryAction != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.outlineVariant),
                            ),
                            child: Text(order.secondaryAction!, style: AppTypography.labelMd.copyWith(color: AppColors.onBackground)),
                          ),
                        if (order.secondaryAction != null) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: order.primaryFilled ? AppColors.primary : null,
                            borderRadius: BorderRadius.circular(8),
                            border: order.primaryFilled ? null : Border.all(color: AppColors.primary),
                            boxShadow: order.primaryFilled
                                ? const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))]
                                : null,
                          ),
                          child: Text(
                            order.primaryAction,
                            style: AppTypography.labelLg.copyWith(
                              color: order.primaryFilled ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderData {
  final String shopName;
  final String status;
  final Color statusColor;
  final String productName;
  final String variant;
  final int quantity;
  final String price;
  final String total;
  final String imageUrl;
  final String primaryAction;
  final bool primaryFilled;
  final String? secondaryAction;
  final String? statusNote;

  _OrderData({
    required this.shopName,
    required this.status,
    required this.statusColor,
    required this.productName,
    required this.variant,
    required this.quantity,
    required this.price,
    required this.total,
    required this.imageUrl,
    required this.primaryAction,
    required this.primaryFilled,
    this.secondaryAction,
    this.statusNote,
  });
}
