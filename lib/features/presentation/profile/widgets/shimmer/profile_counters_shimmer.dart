import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCountersShimmer extends StatelessWidget {
  const ProfileCountersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCounterItemShimmer(),
            _buildCounterItemShimmer(),
            _buildCounterItemShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterItemShimmer() {
    return Container(
      width: 100,
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}