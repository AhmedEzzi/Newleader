import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Assuming you use the shimmer package

class SearchSuggestionsShimmer extends StatelessWidget {
  const SearchSuggestionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title placeholder
            Container(
              height: 20.0,
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            const SizedBox(height: 12),
            // Chip placeholders in a Wrap
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(8, (index) { // Generate a few placeholder chips
                final double chipWidth = (index % 3 == 0) ? 100.0 : (index % 3 == 1) ? 120.0 : 80.0;
                return Container(
                  height: 32.0, // Approximate height of a Chip
                  width: chipWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0), // Match Chip border radius
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 