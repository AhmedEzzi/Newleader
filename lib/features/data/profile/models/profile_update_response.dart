class ProfileUpdateResponse {
  final bool result;
  final String message;
  final String? path;

  ProfileUpdateResponse({
    required this.result,
    required this.message,
    this.path,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      result: json['result'] ?? false,
      message: json['message'] ?? '',
      path: json['path'],
    );
  }
}
