import 'dart:convert';
import 'dart:typed_data';

import 'package:cupping_therapy/core/errors/app_exception.dart';
import 'package:cupping_therapy/core/network/api_client.dart';
import 'package:cupping_therapy/core/network/paginated_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestAdapter implements HttpClientAdapter {
  _TestAdapter(this.respond);

  final Future<ResponseBody> Function(RequestOptions options) respond;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(Map<String, dynamic> body, int statusCode) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  test(
    'attaches bearer token only to requests explicitly marked protected',
    () async {
      final adapter = _TestAdapter(
        (_) async => _jsonResponse({
          'data': {'id': 1},
        }, 200),
      );
      final dio = Dio();
      dio.httpClientAdapter = adapter;
      final client = ApiClient(
        dio: dio,
        baseUrl: 'https://api.example.test/api/v1',
        tokenReader: () async => 'private-token',
      );

      await client.get<Map<String, dynamic>>('profile', requiresAuth: true);
      expect(
        adapter.lastRequest?.headers['Authorization'],
        'Bearer private-token',
      );
      expect(adapter.lastRequest?.uri.path, '/api/v1/profile');

      await client.get<Map<String, dynamic>>('therapy-services');
      expect(
        adapter.lastRequest?.headers.containsKey('Authorization'),
        isFalse,
      );
    },
  );

  test('converts Laravel validation responses into field errors', () async {
    final adapter = _TestAdapter(
      (_) async => _jsonResponse({
        'message': 'The customer name field is required.',
        'errors': {
          'customer_name': ['The customer name field is required.'],
        },
      }, 422),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      dio: dio,
      baseUrl: 'https://api.example.test/api/v1',
    );

    await expectLater(
      client.post<Map<String, dynamic>>(
        'appointments',
        data: const {'therapy_service_id': 3},
      ),
      throwsA(
        isA<AppException>()
            .having((error) => error.code, 'status code', 422)
            .having(
              (error) => error.firstErrorFor('customer_name'),
              'validation message',
              'The customer name field is required.',
            ),
      ),
    );
  });

  test('clears the session for protected 401 responses only', () async {
    var sessionCleared = false;
    final adapter = _TestAdapter(
      (_) async => _jsonResponse({'message': 'Unauthenticated.'}, 401),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      dio: dio,
      baseUrl: 'https://api.example.test/api/v1',
      tokenReader: () async => 'token',
      onUnauthorized: () async {
        sessionCleared = true;
      },
    );

    await expectLater(
      client.get<Map<String, dynamic>>('my-appointments', requiresAuth: true),
      throwsA(isA<AppException>().having((error) => error.code, 'status', 401)),
    );
    expect(sessionCleared, isTrue);

    sessionCleared = false;
    await expectLater(
      client.get<Map<String, dynamic>>('therapy-services'),
      throwsA(isA<AppException>().having((error) => error.code, 'status', 401)),
    );
    expect(sessionCleared, isFalse);
  });

  test('parses Laravel pagination metadata and next-page state', () {
    final result = PaginatedResult<int>.fromJson({
      'data': [
        {'id': 7},
      ],
      'links': {'next': 'https://api.example.test?page=2'},
      'meta': {'current_page': 1, 'last_page': 2, 'per_page': 15, 'total': 16},
    }, (json) => json['id'] as int);

    expect(result.data, [7]);
    expect(result.currentPage, 1);
    expect(result.lastPage, 2);
    expect(result.total, 16);
    expect(result.hasMore, isTrue);
  });
}
