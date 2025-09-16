import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'address_item_shimmer.dart';
import 'shimmer_widget.dart';

class AddressListShimmer extends StatelessWidget {
  final int itemCount;

  const AddressListShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header info card shimmer
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              // Icon shimmer
              const ShimmerWidget.circular(width: 50, height: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer
                    ShimmerWidget.rectangular(
                      width: 150,
                      height: 18,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 4),
                    // Subtitle shimmer
                     ShimmerWidget.rectangular(
                      width: 100,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Address items shimmer
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const AddressItemShimmer(),
            ),
          ),
        ),

        // Add button shimmer
        Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Divider shimmer
              Container(
                height: 1,
                margin: const EdgeInsets.only(bottom: 16),
                child: ShimmerWidget.rectangular(height: 1, borderRadius: 0),
              ),
              // Button shimmer
              ShimmerWidget.rectangular(
                height: 48,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
