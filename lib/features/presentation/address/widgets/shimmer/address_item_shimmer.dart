import 'package:flutter/material.dart';
import 'shimmer_widget.dart';
import '../../../../../core/config/themes.dart/theme.dart';

class AddressItemShimmer extends StatelessWidget {
  const AddressItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with title and action buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - icon and title
                Expanded(
                  child: Row(
                    children: [
                      // Location icon shimmer
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ShimmerWidget.rectangular(
                          width: 36,
                          height: 36,
                          borderRadius: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title shimmer
                            ShimmerWidget.rectangular(
                              width: 120,
                              height: 18,
                            ),
                            const SizedBox(height: 4),
                            // Default badge shimmer (sometimes visible)
                            Container(
                              width: 60,
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ShimmerWidget.rectangular(
                                width: 60,
                                height: 16,
                                borderRadius: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action buttons
                Row(
                  children: [
                    // Edit button shimmer
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ShimmerWidget.rectangular(
                        width: 34,
                        height: 34,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete button shimmer
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ShimmerWidget.rectangular(
                        width: 34,
                        height: 34,
                        borderRadius: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: Colors.grey.shade200,
              child: ShimmerWidget.rectangular(height: 1, borderRadius: 0),
            ),
          ),
          
          // Address details section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full address line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(top: 2),
                      child: const ShimmerWidget.circular(width: 16, height: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShimmerWidget.rectangular(
                        height: 16,
                        borderRadius: 4,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                // City and state line
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      child: const ShimmerWidget.circular(width: 16, height: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShimmerWidget.rectangular(
                        width: 160,
                        height: 14,
                        borderRadius: 4,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                // Country line
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      child: const ShimmerWidget.circular(width: 16, height: 16),
                    ),
                    const SizedBox(width: 8),
                    ShimmerWidget.rectangular(
                      width: 100,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                // Phone line
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      child: const ShimmerWidget.circular(width: 16, height: 16),
                    ),
                    const SizedBox(width: 8),
                     ShimmerWidget.rectangular(
                      width: 120,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Make default button (sometimes visible)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ShimmerWidget.rectangular(
              height: 40,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}
