import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class GetProductReviewsUseCase {
  final ReviewRepository repository;

  GetProductReviewsUseCase(this.repository);

  Future<List<Review>> call(int productId, {int page = 1}) async {
    final response = await repository.getProductReviews(productId, page: page);
    return response.reviews.map((model) => Review(
      userId: model.userId,
      userName: model.userName,
      avatar: model.avatar,
      rating: model.rating,
      comment: model.comment,
      time: model.time,
    )).toList();
  }
}