import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder? shape;
  final bool isCircular;
  final bool isRow;

  const ShimmerWidget({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shape,
    this.isCircular = false,
    this.isRow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: isRow
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: Colors.grey[300],
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey[300],
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                color: Colors.grey[300],
              ),
            ],
          ),
          Container(
            width: 80,
            height: 20,
            color: Colors.grey[300],
          ),
        ],
      )
          : Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[300],
          shape: shape ??
              (isCircular
                  ? const CircleBorder()
                  : const RoundedRectangleBorder()),
        ),
      ),
    );
  }
}