class AppConfig {
  static const String appName = 'HELMO';
  /// Design revision — bumped whenever the visual language changes.
  static const String designRevision = 'classic-2';
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.helmo.com/v1',
  );
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const int pageSize = 10;
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
}