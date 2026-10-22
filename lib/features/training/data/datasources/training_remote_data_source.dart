import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_result.dart';
import '../models/training_program_model.dart';

abstract class TrainingRemoteDataSource {
  const TrainingRemoteDataSource();

  Future<PaginatedResult<TrainingProgramModel>> getPrograms({int page = 1});
  Future<TrainingProgramModel> getProgram(String slug);
  Future<Map<String, dynamic>> submitEnrollment(Map<String, dynamic> values);
  Future<PaginatedResult<Map<String, dynamic>>> getMyEnrollments({
    int page = 1,
  });
}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource {
  const TrainingRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<PaginatedResult<TrainingProgramModel>> getPrograms({
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.trainingPrograms,
      queryParameters: {'page': page, 'per_page': 15},
    );
    return PaginatedResult.fromJson(
      response.data ?? const {},
      TrainingProgramModel.fromJson,
    );
  }

  @override
  Future<TrainingProgramModel> getProgram(String slug) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.trainingPrograms}/$slug',
    );
    final data = response.data?['data'];
    if (data is! Map) throw const FormatException('Invalid program response.');
    return TrainingProgramModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<Map<String, dynamic>> submitEnrollment(
    Map<String, dynamic> values,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.trainingEnrollments,
      data: values,
    );
    final data = response.data?['data'];
    if (data is! Map) {
      throw const FormatException('Invalid enrollment response.');
    }
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<PaginatedResult<Map<String, dynamic>>> getMyEnrollments({
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.myTrainingEnrollments,
      queryParameters: {'page': page, 'per_page': 15},
      requiresAuth: true,
    );
    return PaginatedResult.fromJson(response.data ?? const {}, (json) => json);
  }
}
