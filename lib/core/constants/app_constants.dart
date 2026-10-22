class AppConstants {
  AppConstants._();

  static const String appName = 'Cupping Therapy';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.2:8000/api/v1/',
  );
  static const Duration defaultTimeout = Duration(seconds: 20);
}
