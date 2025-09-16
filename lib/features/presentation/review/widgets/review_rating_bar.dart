import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../core/utils/extension/translate_extension.dart';

class ReviewRatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingUpdate;
  final double itemSize;
  final bool allowHalfRating;
  final bool readOnly;

  const ReviewRatingBar({
    super.key,
    required this.rating,
    required this.onRatingUpdate,
    this.itemSize = 40.0,
    this.allowHalfRating = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!readOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'rate_product'.tr(context),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        Wrap(
          children: [
            readOnly
                ? RatingBarIndicator(
              rating: rating,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: itemSize,
            )
                : RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: allowHalfRating,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: onRatingUpdate,
              itemSize: itemSize,
            ),
            if (readOnly) ...[
              const SizedBox(width: 8),
              Text(
                rating.toString(),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}