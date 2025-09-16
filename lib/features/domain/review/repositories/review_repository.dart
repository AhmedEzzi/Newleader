import '../../../data/review/models/review_model.dart';

abstract class ReviewRepository {
  Future<ReviewResponseModel> getProductReviews(int productId, {int page = 1});
  Future<bool> submitReview(int productId, double rating, String comment);
}