class LanguageModel {
  final String code;
  final String name;
  final String languageCode;
  final String countryCode;

  LanguageModel({
    required this.code,
    required this.name,
    required this.languageCode,
    required this.countryCode,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code'],
      name: json['name'],
      languageCode: json['languageCode'],
      countryCode: json['countryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'languageCode': languageCode,
      'countryCode': countryCode,
    };
  }
}