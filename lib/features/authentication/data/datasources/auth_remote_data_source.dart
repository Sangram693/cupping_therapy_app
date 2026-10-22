import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<AuthModel> login(String identifier, String password);
  Future<AuthModel> register(Map<String, dynamic> values);
  Future<void> logout();
  Future<UserEntity> getCurrentUser();
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> changes);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<AuthModel> login(String identifier, String password) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.authLogin,
      data: {'identifier': identifier, 'password': password},
    );
    return AuthModel.fromEnvelope(response.data ?? const {});
  }

  @override
  Future<AuthModel> register(Map<String, dynamic> values) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.authRegister,
      data: values,
    );
    return AuthModel.fromEnvelope(response.data ?? const {});
  }

  @override
  Future<void> logout() async {
    await _client.post<Map<String, dynamic>>(
      ApiEndpoints.authLogout,
      requiresAuth: true,
    );
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.authMe,
      requiresAuth: true,
    );
    return _parseUser(response.data);
  }

  @override
  Future<UserEntity> getProfile() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
      requiresAuth: true,
    );
    return _parseUser(response.data);
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> changes) async {
    final response = await _client.put<Map<String, dynamic>>(
      ApiEndpoints.profile,
      data: changes,
      requiresAuth: true,
    );
    return _parseUser(response.data);
  }

  UserEntity _parseUser(Map<String, dynamic>? envelope) {
    final data = envelope?['data'];
    final rawUser = data is Map && data['user'] is Map ? data['user'] : data;
    if (rawUser is! Map) {
      throw const FormatException('Invalid user response.');
    }
    final json = Map<String, dynamic>.from(rawUser);
    return UserEntity(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      email: '${json['email'] ?? ''}',
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      preferredLocale: json['preferred_locale'] as String?,
    );
  }
}
