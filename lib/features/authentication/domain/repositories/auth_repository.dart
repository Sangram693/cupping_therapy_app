import '../entities/user_entity.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<UserEntity> login({
    required String identifier,
    required String password,
  });
  Future<UserEntity> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String preferredLocale,
  });
  Future<UserEntity?> restoreSession();
  Future<void> logout();
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> changes);
}
