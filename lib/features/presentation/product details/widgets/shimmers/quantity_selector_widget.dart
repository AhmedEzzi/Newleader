import 'package:flutter/material.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/features/presentation/product details/widgets/shimmers/shimmer_widget.dart';
import '../product_theme.dart';

class QuantitySelectorWidget extends StatefulWidget {
  final ProductDetails product;
  final bool isLoading;

  const QuantitySelectorWidget({
    super.key,
    required this.product,
    this.isLoading = false,
  });

  @override
  State<QuantitySelectorWidget> createState() => _QuantitySelectorWidgetState();
}

class _QuantitySelectorWidgetState extends State<QuantitySelectorWidget> {
  int quantity = 2;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const ShimmerWidget(height: 40, isRow: true);
    }

    String cleanedPrice =
    widget.product.price.replaceAll(RegExp(r'[^\d.]'), '');
    double price = double.tryParse(cleanedPrice) ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) {
                  setState(() => quantity--);
                }
              },
              icon: const Icon(Icons.remove, size: 20),
            ),
            Text(
              quantity.toString().padLeft(2, '0'),
              style: ProductTheme.titleLarge(context),
            ),
            IconButton(
              onPressed: () => setState(() => quantity++),
              icon: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        Text('\$${(price * quantity).toStringAsFixed(2)}',
          style: ProductTheme.titleLarge(context),
        ),
      ],
    );
  }
}