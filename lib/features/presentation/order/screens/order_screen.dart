import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../controller/order_provider.dart';
import '../widgets/shimmer/order_screen_shimmer.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OrderProvider>();
      provider.fetchOrderDetails(widget.orderId);
      provider.fetchOrderItems(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: const CustomBackButton(respectDirection: true),
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text(
            'order_details'.tr(context),
            style: context.displaySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          final bool isLoadingDetails =
              provider.orderDetailsState == LoadingState.loading;
          final bool isLoadingItems =
              provider.orderItemsState == LoadingState.loading;

          if (isLoadingDetails && isLoadingItems) {
            return const OrderScreenShimmer();
          }

          if (provider.orderDetailsState == LoadingState.error) {
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
                        provider.orderDetailsError,
                        style: context.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (provider.orderItemsState == LoadingState.error) {
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
                        provider.orderItemsError,
                        style: context.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final orderDetails = provider.selectedOrderDetails;
          if (orderDetails == null) {
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
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.search_off,
                          size: 40,
                          color: Colors.orange[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'order_details_not_found'.tr(context),
                        style: context.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          DateTime? orderDate;
          try {
            final parts = orderDetails.date.split('/');
            if (parts.length >= 3) {
              // Format is likely "dd/mm/yyyy"
              orderDate = DateTime(
                int.parse(parts[2]), // year
                int.parse(parts[1]), // month
                int.parse(parts[0]), // day
              );
            }
          } catch (e) {
            // If parsing fails, use the current date as a fallback
            orderDate = DateTime.now();
          }
          
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header Card
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 100),
                        child: _buildOrderHeaderCard(orderDetails),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Delivery Address
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                        child: _buildSectionCard(
                          title: 'delivery_address'.tr(context),
                          icon: Icons.location_on_outlined,
                          child: _buildAddressContent(orderDetails.shippingAddress),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Order Items
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 300),
                        child: _buildSectionCard(
                          title: '${'order_items'.tr(context)} (${provider.orderItems.length})',
                          icon: Icons.shopping_bag_outlined,
                          child: isLoadingItems 
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Column(
                                  children: provider.orderItems.map((item) {
                                    final index = provider.orderItems.indexOf(item);
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: index == provider.orderItems.length - 1 ? 0 : 16,
                                      ),
                                      child: _buildOrderItemCard(item),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ),
                              
                      const SizedBox(height: 20),
                      
                      // Price Details
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 400),
                        child: _buildSectionCard(
                          title: 'price_details'.tr(context),
                          icon: Icons.receipt_outlined,
                          child: _buildPriceDetailsContent(orderDetails),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Payment Information
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 500),
                        child: _buildSectionCard(
                          title: 'payment_information'.tr(context),
                          icon: Icons.payment_outlined,
                          child: _buildPaymentInfoContent(orderDetails),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Order Timeline
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 600),
                        child: _buildSectionCard(
                          title: 'order_timeline'.tr(context),
                          icon: Icons.timeline_outlined,
                          child: _buildOrderTimelineContent(orderDetails),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Order Header Card with status and progress
  Widget _buildOrderHeaderCard(dynamic orderDetails) {
    final statusInfo = getStatusInfo(orderDetails.deliveryStatus, '');
    
    return Container(
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
              color: statusInfo.color.withValues(alpha: 0.05),
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
                      'order_number'.tr(context),
                      style: context.bodyMedium!.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${orderDetails.code}',
                      style: context.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusInfo.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusInfo.label.tr(context),
                    style: context.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Progress section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Order Progress Bar
                _buildOrderProgressBar(orderDetails.deliveryStatus),
                
                const SizedBox(height: 16),
                
                // Order Timeline Steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSimpleOrderStep('ordered'.tr(context), true),
                    _buildSimpleOrderStep('in_transit'.tr(context), 
                        orderDetails.deliveryStatus.toLowerCase() == 'picked_up' || 
                        orderDetails.deliveryStatus.toLowerCase() == 'on_the_way' ||
                        orderDetails.deliveryStatus == 'On The Way' ||
                        orderDetails.deliveryStatus.toLowerCase().contains('انتظار')),
                    _buildSimpleOrderStep('delivered'.tr(context), 
                        orderDetails.deliveryStatus.toLowerCase() == 'delivered'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Card with title and icon
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: context.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Section content
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
  
  // Status Badge
  Widget _buildStatusBadge(String status) {
    final statusInfo = getStatusInfo(status, '');
    
    return Text(
      statusInfo.label.tr(context),
      style: context.titleSmall!.copyWith(
        fontWeight: FontWeight.w400,
        color: statusInfo.color,
      ),
    );
  }
  
  // Order Progress Bar
  Widget _buildOrderProgressBar(String status) {
    String statusLower = status.toLowerCase();
    int progress = 0;
    
    if (statusLower == 'pending' || statusLower.contains('انتظار')) {
      progress = 1;
    } else if (statusLower == 'picked_up' || statusLower == 'on_the_way' || status == 'On The Way') {
      progress = 2;
    } else if (statusLower == 'delivered') {
      progress = 3;
    }
    
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Expanded(
            flex: progress >= 1 ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            flex: progress < 1 ? 1 : 0,
            child: Container(color: Colors.transparent),
          ),
          Expanded(
            flex: progress >= 2 ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            flex: progress < 2 ? 1 : 0,
            child: Container(color: Colors.transparent),
          ),
          Expanded(
            flex: progress >= 3 ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            flex: progress < 3 ? 1 : 0,
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
  
  // Helper to get status color and label
  StatusInfo getStatusInfo(String status, String statusString) {
    // Handle arabic and english status values
    String statusLower = status.toLowerCase();
    
    if (statusLower == 'pending' || statusLower.contains('انتظار')) {
      return StatusInfo('processing', const Color(0xFFCB997E));
    } else if (statusLower == 'picked_up' || statusLower == 'on_the_way' || status == 'On The Way') {
      return StatusInfo('in_transit', const Color(0xFF2196F3));
    } else if (statusLower == 'delivered') {
      return StatusInfo('delivered', const Color(0xFF4CAF50));
    } else {
      // Use the status string provided by API if available
      return StatusInfo(statusString.isNotEmpty ? statusString : 'processing', const Color(0xFFFF9800));
    }
  }
  
  // Order Step
  Widget _buildOrderStep(String label, bool isActive, DateTime date) {
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        if (isActive)
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }
  
  // Address Content
  Widget _buildAddressContent(dynamic address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.name,
          style: context.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_city_outlined,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${address.address}, ${address.city}, ${address.state}, ${address.country} ${address.postalCode}',
                style: context.bodyLarge!.copyWith(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              address.phone,
              style: context.bodyLarge!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Order Item Card
  Widget _buildOrderItemCard(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: context.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (item.variation.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${'variation'.tr(context)}: ${item.variation}',
                    style: context.bodyMedium!.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${'quantity'.tr(context)}: ${item.quantity}',
                    style: context.bodyMedium!.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                item.price,
                style: context.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Price Details Content
  Widget _buildPriceDetailsContent(dynamic orderDetails) {
    final items = [
      {'label': 'subtotal'.tr(context), 'value': orderDetails.subtotal},
      {'label': 'shipping_fee'.tr(context), 'value': orderDetails.shippingCost},
      {'label': 'tax'.tr(context), 'value': orderDetails.tax},
    ];
    
    if (orderDetails.couponDiscount.isNotEmpty && orderDetails.couponDiscount != '0' && orderDetails.couponDiscount != '0.00') {
      items.add({'label': 'coupon_discount'.tr(context), 'value': orderDetails.couponDiscount});
    }
    
    return Column(
      children: [
        ...items.map((item) => _buildPriceRow(item['label']!, item['value']!)),
        const SizedBox(height: 12),
        Container(
          height: 1,
          color: Colors.grey[200],
        ),
        const SizedBox(height: 12),
        _buildPriceRow('total'.tr(context), orderDetails.grandTotal, isTotal: true),
      ],
    );
  }
  
  // Price row
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodyLarge!.copyWith(
              color: isTotal ? Colors.black87 : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: context.bodyLarge!.copyWith(
              color: isTotal ? AppTheme.primaryColor : Colors.black87,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Payment Information Content
  Widget _buildPaymentInfoContent(dynamic orderDetails) {
    final paymentStatus = orderDetails.paymentStatus.toLowerCase() == 'paid' ? 'paid'.tr(context) : 'pending'.tr(context);
    final statusColor = paymentStatus == 'paid'.tr(context) ? Colors.green[700] : Colors.orange[700];
    final bgColor = paymentStatus == 'paid'.tr(context) ? Colors.green[50] : Colors.orange[50];
    
    // Get payment type icon based on payment_type
    IconData paymentIcon = Icons.credit_card;
    String paymentType = orderDetails.paymentType ?? 'Cash Payment';
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
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            paymentIcon,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentTypeKey.tr(context),
                style: context.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${'date'.tr(context)}: ${orderDetails.date}',
                style: context.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            paymentStatus,
            style: context.bodySmall!.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  
  // Order Timeline Content
  Widget _buildOrderTimelineContent(dynamic orderDetails) {
    // Parse the order date
    DateTime orderDate;
    try {
      final parts = orderDetails.date.split('/');
      if (parts.length >= 3) {
        orderDate = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      } else {
        orderDate = DateTime.now();
      }
    } catch (e) {
      orderDate = DateTime.now();
    }
    
    // Format dates for display
    String formatDate(DateTime date) {
      return '${date.day}/${date.month}/${date.year}';
    }
    
    final deliveryStatus = orderDetails.deliveryStatus.toLowerCase();
    final confirmedDate = formatDate(orderDate);
    
    // Determine if in transit (picked up, on the way, etc.)
    final isInTransit = deliveryStatus == 'picked_up' || 
                         deliveryStatus == 'on_the_way' || 
                         orderDetails.deliveryStatus == 'On The Way' ||
                         deliveryStatus.contains('انتظار');
                         
    final shippedDate = isInTransit || deliveryStatus == 'delivered'
        ? formatDate(orderDate.add(const Duration(days: 1)))
        : 'pending'.tr(context);
        
    final deliveredDate = deliveryStatus == 'delivered'
        ? formatDate(orderDate.add(const Duration(days: 3)))
        : 'expected_in_3_5_days'.tr(context);
    
    final timelineItems = [
      {
        'icon': Icons.check_circle,
        'color': Colors.green,
        'title': 'delivered'.tr(context),
        'date': deliveredDate,
        'active': deliveryStatus == 'delivered',
      },
      {
        'icon': Icons.local_shipping,
        'color': Colors.blue,
        'title': 'in_transit'.tr(context),
        'date': shippedDate,
        'active': isInTransit || deliveryStatus == 'delivered',
      },
      {
        'icon': Icons.check,
        'color': AppTheme.primaryColor,
        'title': 'order_confirmed'.tr(context),
        'date': confirmedDate,
        'active': true,
      },
    ];
    
    return Column(
      children: timelineItems.map((item) => _buildTimelineItem(
        icon: item['icon'] as IconData,
        color: item['color'] as Color,
        title: item['title'] as String,
        date: item['date'] as String,
        isActive: item['active'] as bool,
        isLast: item == timelineItems.last,
      )).toList(),
    );
  }
  
  // Timeline Item
  Widget _buildTimelineItem({
    required IconData icon,
    required Color color,
    required String title,
    required String date,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: isActive ? color.withValues(alpha: 0.3) : Colors.grey[300],
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black87 : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: context.bodyMedium!.copyWith(
                    color: isActive ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Simple Order Step
  Widget _buildSimpleOrderStep(String label, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: context.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }
  
  // Contact Support Dialog
  void _showContactSupportDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'contact_support'.tr(context),
      text: 'do_you_want_to_contact_customer_support'.tr(context),
      confirmBtnText: 'yes'.tr(context),
      cancelBtnText: 'cancel'.tr(context),
      onConfirmBtnTap: () {
        Navigator.pop(context);
        // Add logic to contact support
      },
    );
  }
  
  // Cancel Order Dialog
  void _showCancelOrderDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'cancel_order'.tr(context),
      text: 'are_you_sure_you_want_to_cancel_this_order'.tr(context),
      confirmBtnText: 'yes_cancel'.tr(context),
      cancelBtnText: 'no_keep_it'.tr(context),
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        Navigator.pop(context);
        // Add logic to cancel order
      },
    );
  }
}

// Helper class for status information
class StatusInfo {
  final String label;
  final Color color;
  
  StatusInfo(this.label, this.color);
}

