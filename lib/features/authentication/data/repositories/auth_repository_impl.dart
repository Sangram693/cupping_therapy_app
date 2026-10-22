import '../../../../core/services/auth_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final AuthStorage _storage;

  @override
  Future<UserEntity> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _remote.login(identifier, password);
    await _storage.saveToken(result.token);
    return result.user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String preferredLocale,
  }) async {
    final values = <String, dynamic>{
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'preferred_locale': preferredLocale,
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };
    final result = await _remote.register(values);
    await _storage.saveToken(result.token);
    return result.user;
  }

  @override
  Future<UserEntity?> restoreSession() async {
    if (!await _storage.hasActiveSession()) return null;
    try {
      return await _remote.getCurrentUser();
    } on AppException catch (error) {
      if (error.code == 401) {
        await _storage.clearToken();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (await _storage.hasActiveSession()) {
        await _remote.logout();
      }
    } finally {
      await _storage.clearToken();
    }
  }

  @override
  Future<UserEntity> getProfile() => _remote.getProfile();

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> changes) =>
      _remote.updateProfile(changes);
}
