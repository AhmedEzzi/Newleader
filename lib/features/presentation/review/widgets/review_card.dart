import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import '../../../../../core/utils/widgets/custom_cached_image.dart';
import '../../../domain/review/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context),
            const SizedBox(height: 10),
            _buildRating(context),
            const SizedBox(height: 10),
            _buildComment(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CustomImage(
            imageUrl: review.avatar,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userName,
              style: context.titleLarge!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              review.time,
              style: context.bodySmall!.copyWith(color: AppTheme.darkDividerColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: review.rating,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 20.0,
        ),
        const SizedBox(width: 8),
        Text(
          review.rating.toString(),
          maxLines: 2,
          style: context.titleSmall!.copyWith(color: AppTheme.darkDividerColor),
        ),
      ],
    );
  }

  Widget _buildComment(BuildContext context) {
    return Text(
      review.comment,
      maxLines: 2,
      style: context.titleMedium!.copyWith(color: AppTheme.black),
    );
  }
}