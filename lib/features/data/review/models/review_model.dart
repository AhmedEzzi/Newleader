class ReviewModel {
  final int userId;
  final String userName;
  final String avatar;
  final double rating;
  final String comment;
  final String time;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.time,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      avatar: json['avatar'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'avatar': avatar,
    'rating': rating,
    'comment': comment,
    'time': time,
  };
}

class ReviewResponseModel {
  final List<ReviewModel> reviews;
  final int total;

  ReviewResponseModel({
    required this.reviews,
    required this.total,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      reviews: (json['data'] as List?)
          ?.map((e) => ReviewModel.fromJson(e))
          .toList() ??
          [],
      total: json['meta']?['total'] ?? 0,
    );
  }
}




