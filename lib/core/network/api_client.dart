import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient({Dio? dio, String? baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
              connectTimeout: AppConstants.defaultTimeout,
              receiveTimeout: AppConstants.defaultTimeout,
              headers: <String, dynamic>{'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return ApiResponse<T>.success(
        data: response.data is T ? response.data as T : null,
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
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return ApiResponse<T>.success(
        data: response.data is T ? response.data as T : null,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  AppException _handleDioError(DioException error) {
    final message = error.response?.data is Map
        ? error.response!.data['message'] as String? ?? 'Request failed'
        : error.message ?? 'Request failed';

    return AppException(message, code: error.response?.statusCode);
  }
}
