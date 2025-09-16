import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

class AddressFormShimmer extends StatelessWidget {
  const AddressFormShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title field shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 60),
        ),
        const SizedBox(height: 16),
        
        // Country dropdown shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 60),
        ),
        const SizedBox(height: 16),
        
        // State dropdown shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 60),
        ),
        const SizedBox(height: 16),
        
        // City dropdown shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 60),
        ),
        const SizedBox(height: 16),
        
        // Address field shimmer
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 100),
        ),
        const SizedBox(height: 16),
        
        // Postal code field shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ShimmerWidget.rectangular(height: 60),
        ),
        const SizedBox(height: 16),
        
        // Phone field shimmer
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child:  ShimmerWidget.rectangular(height: 60),
        ),
      ],
    );
  }
}
