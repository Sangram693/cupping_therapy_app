import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_result.dart';
import '../models/therapy_service_model.dart';

abstract class TherapyRemoteDataSource {
  const TherapyRemoteDataSource();

  Future<PaginatedResult<TherapyServiceModel>> getServices({int page = 1});
  Future<TherapyServiceModel> getService(String slug);
}

class TherapyRemoteDataSourceImpl implements TherapyRemoteDataSource {
  const TherapyRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<PaginatedResult<TherapyServiceModel>> getServices({
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.therapyServices,
      queryParameters: {'page': page, 'per_page': 15},
    );
    return PaginatedResult.fromJson(
      response.data ?? const {},
      TherapyServiceModel.fromJson,
    );
  }

  @override
  Future<TherapyServiceModel> getService(String slug) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.therapyServices}/$slug',
    );
    final data = response.data?['data'];
    if (data is! Map) throw const FormatException('Invalid service response.');
    return TherapyServiceModel.fromJson(Map<String, dynamic>.from(data));
  }
}
