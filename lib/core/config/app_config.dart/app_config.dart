enum Environment { development, staging, production }

class AppConfig {
  late String apiBaseUrl = 'https://admin.leadercompany-eg.com/api/v2';

  late Environment environment;
  bool enableLogging = true;
  String appName = 'Leader Company';
  String appVersion = '1.0.0';
  int connectTimeout = 30000;
  int receiveTimeout = 30000;

  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  void initialize({
    required Environment environment,
    required String apiBaseUrl,
    bool? enableLogging,
    String? appName,
    String? appVersion,
    int? connectTimeout,
    int? receiveTimeout,
  }) {
    this.environment = environment;
    this.apiBaseUrl = apiBaseUrl;
    this.enableLogging = enableLogging ?? this.enableLogging;
    this.appName = appName ?? this.appName;
    this.appVersion = appVersion ?? this.appVersion;
    this.connectTimeout = connectTimeout ?? this.connectTimeout;
    this.receiveTimeout = receiveTimeout ?? this.receiveTimeout;
  }

  bool get isProduction => environment == Environment.production;
  bool get isDevelopment => environment == Environment.development;
}
