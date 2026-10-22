import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient({
    Dio? dio,
    String? baseUrl,
    Future<String?> Function()? tokenReader,
    Future<void> Function()? onUnauthorized,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: _normalizedBaseUrl(baseUrl ?? AppConstants.apiBaseUrl),
               connectTimeout: AppConstants.defaultTimeout,
               receiveTimeout: AppConstants.defaultTimeout,
               sendTimeout: AppConstants.defaultTimeout,
               headers: <String, dynamic>{'Accept': 'application/json'},
             ),
           ) {
    if (dio != null && baseUrl != null) {
      _dio.options.baseUrl = _normalizedBaseUrl(baseUrl);
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['requiresAuth'] == true) {
            final token = await tokenReader?.call();
            if (token == null || token.isEmpty) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: const AppException(
                    'Authentication required.',
                    code: 401,
                  ),
                ),
              );
              return;
            }
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['requiresAuth'] == true) {
            await onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;

  static String _normalizedBaseUrl(String value) =>
      value.endsWith('/') ? value : '$value/';

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
          extra: {'requiresAuth': requiresAuth},
        ),
      );

      return ApiResponse<T>.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
          extra: {'requiresAuth': requiresAuth},
        ),
      );

      return ApiResponse<T>.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return ApiResponse<T>.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  AppException _handleDioError(DioException error) {
    if (error.error is AppException) {
      return error.error as AppException;
    }
    final responseData = error.response?.data;
    final message = responseData is Map
        ? responseData['message']?.toString() ?? 'Request failed'
        : switch (error.type) {
            DioExceptionType.connectionTimeout ||
            DioExceptionType.sendTimeout ||
            DioExceptionType.receiveTimeout => 'The request timed out.',
            DioExceptionType.connectionError =>
              'Unable to connect to the server.',
            DioExceptionType.cancel => 'The request was cancelled.',
            _ => 'Request failed.',
          };
    final rawErrors = responseData is Map ? responseData['errors'] : null;
    final errors = <String, List<String>>{};
    if (rawErrors is Map) {
      for (final entry in rawErrors.entries) {
        final value = entry.value;
        if (value is List) {
          errors[entry.key.toString()] = value
              .map((item) => item.toString())
              .toList();
        } else if (value != null) {
          errors[entry.key.toString()] = [value.toString()];
        }
      }
    }
    return AppException(
      message,
      code: error.response?.statusCode,
      validationErrors: errors,
    );
  }
}
