import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../domain/order/entities/order_item.dart';

class OrderItemsList extends StatelessWidget {
  final List<OrderItem> orderItems;

  const OrderItemsList({
    super.key,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    if (orderItems.isEmpty) {
      return Center(child: Text('no_items_found'.tr(context)));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final item = orderItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.variation.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Variation: ${item.variation}'.tr(context),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.price,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text('Qty: ${item.quantity}'.tr(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
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
      },
    );
  }
}