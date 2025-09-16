import '../repositories/review_repository.dart';

class SubmitReviewUseCase {
  final ReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<bool> call(int productId, double rating, String comment) async {
    return await repository.submitReview(productId, rating, comment);
  }
}