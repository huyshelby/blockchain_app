import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../models/order.dart';
import '../providers/marketplace_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'All',
    'To Pay',
    'To Ship',
    'To Receive',
    'Completed',
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
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.onBackground,
            ),
          ),
          Text(
            'My Orders',
            style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 20,
              color: AppColors.onBackground,
            ),
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
    final address = ref
        .watch(marketplaceServiceProvider)
        .currentAddress
        .hexEip55;
    final orders = ref.watch(buyerOrdersProvider(address));

    return orders.when(
      data: (items) {
        final selectedTab = _tabs[_tabController.index];
        final visibleOrders = selectedTab == 'All'
            ? items
            : items
                  .where((order) => order.buyerStatusLabel == selectedTab)
                  .toList();
        if (visibleOrders.isEmpty) {
          return const Center(child: Text('No orders yet'));
        }
        return ListView.separated(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: visibleOrders.length,
          separatorBuilder: (c, i) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _OrderCard(order: visibleOrders[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Unable to load orders')),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final MarketplaceOrder order;
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
                    Text(
                      order.product?.metadata.shopName ?? 'Blockchain VIP',
                      style: AppTypography.labelLg.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
                Text(
                  order.buyerStatusLabel,
                  style: AppTypography.labelMd.copyWith(
                    color: _statusColor(order.status),
                  ),
                ),
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
                    order.product?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Icon(Icons.image, color: AppColors.outline),
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
                              order.product?.metadata.name ??
                                  'Product #${order.productId}',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onBackground,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.statusLabel,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'x1',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              order.amountLabel,
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onBackground,
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
          const Divider(height: 1, color: Color(0xFFFFE9E5)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Order Total: ',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                    Text(
                      order.amountLabel,
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: order.status == 2 ? AppColors.primary : null,
                            borderRadius: BorderRadius.circular(8),
                            border: order.status == 2
                                ? null
                                : Border.all(color: AppColors.primary),
                            boxShadow: order.status == 2
                                ? const [
                                    BoxShadow(
                                      color: Color(0x0D000000),
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            _primaryAction(order.status),
                            style: AppTypography.labelLg.copyWith(
                              color: order.status == 2
                                  ? Colors.white
                                  : AppColors.primary,
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

Color _statusColor(int status) {
  return switch (status) {
    0 => AppColors.secondary,
    1 => AppColors.onSurfaceVariant,
    2 => AppColors.primary,
    _ => AppColors.error,
  };
}

String _primaryAction(int status) {
  return switch (status) {
    0 => 'Contact Seller',
    1 => 'Track Order',
    2 => 'Rate',
    _ => 'View Details',
  };
}
