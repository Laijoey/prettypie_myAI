class BackendApi {
  BackendApi._();

  static const String defaultBaseUrl =
      'https://mygov-backend-947969904935.asia-southeast1.run.app';

  static const String configuredBaseUrl = String.fromEnvironment(
    'BACKEND_API_BASE_URL',
    defaultValue: defaultBaseUrl,
  );

  static String get baseUrl {
    final value = configuredBaseUrl.trim();
    return value.isEmpty ? defaultBaseUrl : value;
  }
}