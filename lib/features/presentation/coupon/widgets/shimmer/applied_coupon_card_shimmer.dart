import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppliedCouponCardShimmer extends StatelessWidget {
  const AppliedCouponCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Code label
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 16,
                color: Colors.white,
              ),

              // Discount label
              const SizedBox(height: 4),
              Container(
                width: 120,
                height: 16,
                color: Colors.white,
              ),

              // Remove button
              const SizedBox(height: 12),
              Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}