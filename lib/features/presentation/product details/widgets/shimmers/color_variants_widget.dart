import 'package:flutter/material.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/features/presentation/product details/widgets/shimmers/shimmer_widget.dart';

class ColorVariantsWidget extends StatefulWidget {
  final ProductDetails product;
  final bool isLoading;

  const ColorVariantsWidget({
    super.key,
    required this.product,
    this.isLoading = false,
  });

  @override
  State<ColorVariantsWidget> createState() => _ColorVariantsWidgetState();
}

class _ColorVariantsWidgetState extends State<ColorVariantsWidget> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Row(
        children: List.generate(
          3, // Placeholder for 3 color variants
              (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ShimmerWidget(
              width: 50,
              height: 50,
              isCircular: true,
            ),
          ),
        ),
      );
    }

    final colorList = widget.product.colors.map((color) {
      try {
        return Color(int.parse(color.replaceAll('#', '0xff')));
      } catch (e) {
        return Colors.grey;
      }
    }).toList();

    return widget.product.colors.isNotEmpty
        ? Row(
      children: List.generate(colorList.length, (index) {
        return GestureDetector(
          onTap: () => setState(() => selectedColorIndex = index),
          child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: colorList[index],
              shape: BoxShape.circle,
              boxShadow: selectedColorIndex == index
                  ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
          ),
        );
      }),
    )
        : const SizedBox.shrink();
  }
}