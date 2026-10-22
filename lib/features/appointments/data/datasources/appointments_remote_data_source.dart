import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_result.dart';
import '../models/appointment_model.dart';

abstract class AppointmentsRemoteDataSource {
  const AppointmentsRemoteDataSource();

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> values);
  Future<PaginatedResult<AppointmentModel>> getMyAppointments({int page = 1});
  Future<void> cancelAppointment(String id);
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  const AppointmentsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<Map<String, dynamic>> createAppointment(
    Map<String, dynamic> values,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.appointments,
      data: values,
    );
    final data = response.data?['data'];
    if (data is! Map) {
      throw const FormatException('Invalid appointment response.');
    }
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<PaginatedResult<AppointmentModel>> getMyAppointments({
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.myAppointments,
      queryParameters: {'page': page, 'per_page': 15},
      requiresAuth: true,
    );
    return PaginatedResult.fromJson(
      response.data ?? const {},
      AppointmentModel.fromJson,
    );
  }

  @override
  Future<void> cancelAppointment(String id) async {
    await _client.post<Map<String, dynamic>>(
      '${ApiEndpoints.myAppointments}/$id/cancel',
      requiresAuth: true,
    );
  }
}
