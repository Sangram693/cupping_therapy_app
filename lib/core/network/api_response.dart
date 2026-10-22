class ApiResponse<T> {
  const ApiResponse({
    this.data,
    this.statusCode,
    this.message,
    this.success = false,
    this.error,
  });

  factory ApiResponse.success({
    T? data,
    int? statusCode,
    String message = 'Success',
  }) {
    return ApiResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: true,
    );
  }

  factory ApiResponse.failure({
    T? data,
    int? statusCode,
    String message = 'Request failed',
  }) {
    return ApiResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: false,
    );
  }

  final T? data;
  final int? statusCode;
  final String? message;
  final bool success;
  final Object? error;
}
