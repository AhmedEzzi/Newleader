import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/order/entities/order.dart';
import '../controller/order_provider.dart';
import '../widgets/shimmer/orders_list_shimmer.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  // Filter categories
  final List<String> _tabs = [
    'all_orders',
    'processing',
    'shipped',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<OrderProvider>();
      if (provider.hasNextPage && !provider.isLoadingMore) {
        provider.loadMoreOrders();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text(
            'my_orders'.tr(context),
            style: context.displaySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        leading: const CustomBackButton(),
      ),
      body: Column(
        children: [
          // Modern Tab bar for order categories
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
                dividerHeight: 0,
                labelColor: AppTheme.primaryColor,
                labelStyle: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelColor: Colors.grey[600],
                unselectedLabelStyle: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.all(8),
                tabs: _tabs.map((tab) => Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(tab.tr(context)),
                  ),
                )).toList(),
                onTap: (index) {
                  setState(() {});
                },
              ),
            ),
          ),

          // Order list
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                if (provider.ordersState == LoadingState.loading &&
                    provider.orders.isEmpty) {
                  return const OrdersListShimmer();
                }

                if (provider.ordersState == LoadingState.error) {
                  return FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 40,
                                color: Colors.red[400],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              provider.ordersError,
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () => provider.fetchOrders(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh, size: 20),
                                label: Text(
                                  'try_again'.tr(context),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (provider.orders.isEmpty) {
                  return _buildEmptyOrdersState(context);
                }

                // Filter orders based on the selected tab
                final filteredOrders = _filterOrders(
                  provider.orders,
                  _tabController.index,
                );

                if (filteredOrders.isEmpty) {
                  final tabName = _tabs[_tabController.index].toLowerCase();
                  return FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                tabName == 'shipped'
                                    ? Icons.local_shipping_outlined
                                    : tabName == 'delivered'
                                    ? Icons.check_circle_outline
                                    : Icons.pending_outlined,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'no_${tabName.toLowerCase()}_orders'.tr(context),
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'you_dont_have_any_${tabName.toLowerCase()}_orders_at_the_moment'
                                  .tr(context),
                              style: context.bodyLarge.copyWith(
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchOrders(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount:
                        filteredOrders.length +
                        (provider.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredOrders.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CustomLoadingWidget()),
                        );
                      }

                      final order = filteredOrders[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 100 * index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _buildOrderCard(context, order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to filter orders based on tab selection
  List<Order> _filterOrders(List<Order> orders, int tabIndex) {
    if (tabIndex == 0) return orders; // All orders

    List<String> statuses = [];
    if (tabIndex == 1) {
      // Processing tab - show orders with "pending" or "قيد الانتظار" status
      statuses = ['pending', 'قيد الانتظار'];
    } else if (tabIndex == 2) {
      // Shipped tab - show orders with "picked_up", "on_the_way", "On The Way" status
      statuses = ['picked_up', 'on_the_way', 'On The Way'];
    } else {
      // Delivered tab - show orders with "delivered" status
      statuses = ['delivered'];
    }

    return orders
        .where(
          (order) =>
              statuses.contains(order.deliveryStatus) ||
              statuses.contains(order.deliveryStatus.toLowerCase()) ||
              statuses.contains(order.deliveryStatusString),
        )
        .toList();
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final status = getStatusInfo(
      order.deliveryStatus,
      order.deliveryStatusString,
    );

    // Format the date to "May 25, 2025" style
    String formattedDate = order.date;

    // Get payment type icon based on payment_type
    IconData paymentIcon = Icons.credit_card;
    String paymentType = order.paymentType ?? 'Cash Payment';
    String paymentTypeKey = 'credit_card_payment';

    if (paymentType.toLowerCase().contains('cash')) {
      paymentIcon = Icons.money;
      paymentTypeKey = 'cash_payment';
    } else if (paymentType.toLowerCase().contains('wallet')) {
      paymentIcon = Icons.account_balance_wallet;
      paymentTypeKey = 'wallet_payment';
    } else if (paymentType.toLowerCase().contains('visa') ||
        paymentType.toLowerCase().contains('mastercard') ||
        paymentType.toLowerCase().contains('credit')) {
      paymentIcon = Icons.credit_card;
      paymentTypeKey = 'credit_card_payment';
    }

    return InkWell(
      onTap: () {
        AppRoutes.navigateTo(
          context,
          AppRoutes.orderDetailsScreen,
          arguments: {'orderId': order.id},
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with order number and status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.code,
                        style: context.titleLarge.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: context.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: status.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.label.tr(context),
                      style: context.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body with payment info and total
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Payment method
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          paymentIcon,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          paymentTypeKey.tr(context),
                          style: context.bodyLarge.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Total amount
                      Text(
                        order.grandTotal,
                        style: context.headlineSmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // View details button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'view_details'.tr(context),
                        style: context.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to get status color and label
  StatusInfo getStatusInfo(String status, String statusString) {
    // Handle arabic and english status values
    String statusLower = status.toLowerCase();

    if (statusLower == 'pending' || statusLower.contains('انتظار')) {
      return StatusInfo('processing', AppTheme.primaryColor);
    } else if (statusLower == 'picked_up' ||
        statusLower == 'on_the_way' ||
        status == 'On The Way') {
      return StatusInfo('in_transit', const Color(0xFF2196F3));
    } else if (statusLower == 'delivered') {
      return StatusInfo('delivered', const Color(0xFF4CAF50));
    } else {
      // Use the status string provided by API if available
      return StatusInfo(statusString, const Color(0xFFFF9800));
    }
  }

  Widget _buildEmptyOrdersState(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 50,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'no_orders_yet'.tr(context),
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'looks_like_you_havent_placed_any_orders_yet_Start_shopping_to_see_your_orders_here'
                    .tr(context),
                style: context.bodyLarge.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: CustomButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
                  },
                  child: Text(
                    'start_shopping'.tr(context),
                    textAlign: TextAlign.center,
                    style: context.titleLarge.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
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

// Helper class for status information
class StatusInfo {
  final String label;
  final Color color;

  StatusInfo(this.label, this.color);
}
