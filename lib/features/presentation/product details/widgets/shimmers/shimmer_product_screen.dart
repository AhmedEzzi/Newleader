import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/product_theme.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/shimmers/shimmer_widget.dart';

class ShimmerProductScreen extends StatelessWidget {
  const ShimmerProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Stack(
                  children: [
                    // Shimmer for main product image
                    ShimmerWidget(height: screenHeight * 0.4),
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: CustomBackButton(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shimmer for product title
                      const ShimmerWidget(
                        width: 250,
                        height: 24,
                      ),
                      const SizedBox(height: 8),
                      // Shimmer for price
                      const ShimmerWidget(
                        width: 120,
                        height: 20,
                      ),
                      const SizedBox(height: 16),

                      // Shimmer for color variants
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerWidget(
                            width: 120,
                            height: 18,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              4,
                                  (index) => Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: const ShimmerWidget(
                                  width: 50,
                                  height: 50,
                                  isCircular: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Shimmer for choice options
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerWidget(
                            width: 150,
                            height: 18,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: List.generate(
                              3,
                                  (index) => const ShimmerWidget(
                                width: 80,
                                height: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Shimmer for description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerWidget(
                            width: 100,
                            height: 18,
                          ),
                          const SizedBox(height: 8),
                          const ShimmerWidget(height: 14),
                          const SizedBox(height: 4),
                          const ShimmerWidget(height: 14),
                          const SizedBox(height: 4),
                          const ShimmerWidget(height: 14),
                          const SizedBox(height: 4),
                          const ShimmerWidget(width: 200, height: 14),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Shimmer for reviews section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ShimmerWidget(width: 150, height: 20),
                          const ShimmerWidget(width: 100, height: 20),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Shimmer for review cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const ShimmerWidget(
                                        width: 40,
                                        height: 40,
                                        isCircular: true,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          ShimmerWidget(width: 100, height: 16),
                                          SizedBox(height: 4),
                                          ShimmerWidget(width: 80, height: 12),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const ShimmerWidget(width: 100, height: 16),
                                  const SizedBox(height: 8),
                                  const ShimmerWidget(height: 14),
                                  const SizedBox(height: 4),
                                  const ShimmerWidget(width: 250, height: 14),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Shimmer for related products
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerWidget(width: 150, height: 20),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ShimmerWidget(height: 120),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      ShimmerWidget(width: 120, height: 16),
                                      SizedBox(height: 8),
                                      ShimmerWidget(width: 80, height: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Shimmer for bottom cart button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ProductTheme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  ShimmerWidget(height: 50, isRow: true),
                  SizedBox(height: 10),
                  ShimmerWidget(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}