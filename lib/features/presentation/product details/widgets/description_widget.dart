import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/features/presentation/product details/widgets/product_theme.dart';

class DescriptionWidget extends StatelessWidget {
  final ProductDetails product;

  const DescriptionWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    print(product.slug);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        product.description.isNotEmpty
            ? Text(
              'key_feature'.tr(context),
              style: context.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
              ),
            )
            : const SizedBox.shrink(),
        product.description.isNotEmpty
            ? Html(
              data: product.description,
              style: {
                '*': Style(
                  fontSize: FontSize(14.0),
                  lineHeight: const LineHeight(1.6),
                  color: Colors.black54,
                ),
              },
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
