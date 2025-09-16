import '../../../domain/review/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReviewResponseModel> getProductReviews(int productId, {int page = 1}) {
    return remoteDataSource.getProductReviews(productId, page: page);
  }

  @override
  Future<bool> submitReview(int productId, double rating, String comment) {
    return remoteDataSource.submitReview(productId, rating, comment);
  }
}