// lib/features/presentation/order/widgets/order_details_card.dart
import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../domain/order/entities/order_details.dart';

class OrderDetailsCard extends StatelessWidget {
  final OrderDetails orderDetails;

  const OrderDetailsCard({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${orderDetails.code}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text('Date: ${orderDetails.date}'),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 10),
            _buildStatusSection(context),
            const SizedBox(height: 10),
            _buildDivider(),
            const SizedBox(height: 10),
            _buildPriceDetails(context),
            const SizedBox(height: 10),
            _buildDivider(),
            const SizedBox(height: 10),
            _buildShippingAddress(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('status'.tr(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildStatusChip(
                context,
                'Payment: ${orderDetails.paymentStatusString}',
                orderDetails.paymentStatus == 'paid' ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 8.0), // Optional: adds spacing between chips
            Flexible(
              child: _buildStatusChip(
                context,
                'Delivery: ${orderDetails.deliveryStatusString}',
                orderDetails.deliveryStatus == 'confirmed' ? Colors.blue : Colors.orange,
              ),
            ),
          ],
        ),
        if (orderDetails.cancelRequest) ...[
          const SizedBox(height: 10),
          _buildStatusChip(
            context,
            'Cancel Request: Pending',
            Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _buildPriceDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Details'.tr(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        _buildPriceRow('Payment Method', orderDetails.paymentType),
        _buildPriceRow('Subtotal', orderDetails.subtotal),
        _buildPriceRow('Shipping Cost', orderDetails.shippingCost),
        _buildPriceRow('Tax', orderDetails.tax),
        _buildPriceRow('Coupon Discount', orderDetails.couponDiscount),
        const Divider(),
        _buildPriceRow(
          'Total',
          orderDetails.grandTotal,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address'.tr(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Text(orderDetails.shippingAddress.name),
        if (orderDetails.shippingAddress.email != null)
          Text(orderDetails.shippingAddress.email!),
        Text(orderDetails.shippingAddress.address),
        Text('${orderDetails.shippingAddress.city}, ${orderDetails.shippingAddress.state}'.tr(context)),
        Text('${orderDetails.shippingAddress.country} ${orderDetails.shippingAddress.postalCode}'.tr(context)),
        Text('Phone: ${orderDetails.shippingAddress.phone}'.tr(context)),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}