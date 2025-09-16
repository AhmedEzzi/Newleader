import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/features/presentation/product details/widgets/shimmers/shimmer_widget.dart';
import '../product_theme.dart';

class DescriptionWidget extends StatelessWidget {
  final ProductDetails product;
  final bool isEditing;
  final bool isLoading;

  const DescriptionWidget({
    super.key,
    required this.product,
    required this.isEditing,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLoading
            ? ShimmerWidget(width: 100, height: 20)
            : Text('description'.tr(context), style: ProductTheme.titleMedium(context)),
        const SizedBox(height: 8),
        isLoading
            ? Column(
          children: [
            ShimmerWidget(height: 14),
            const SizedBox(height: 8),
            ShimmerWidget(height: 14),
            const SizedBox(height: 8),
            ShimmerWidget(height: 14),
          ],
        )
            : product.description.isNotEmpty
            ? Html(
          data: product.description,
          style: {
            '*': Style(
              fontSize: FontSize(14.0),
              lineHeight: LineHeight(1.6),
              color: Colors.black54,
            ),
          },
        )
            :  Text('no_description_available'.tr(context),
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}