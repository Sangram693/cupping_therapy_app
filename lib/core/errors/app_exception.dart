class AppException implements Exception {
  const AppException(
    this.message, {
    this.code,
    this.validationErrors = const {},
  });

  final String message;
  final int? code;
  final Map<String, List<String>> validationErrors;

  String? firstErrorFor(String field) => validationErrors[field]?.firstOrNull;

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}
