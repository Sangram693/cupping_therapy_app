import '../../domain/entities/user_entity.dart';

class AuthModel {
  const AuthModel({required this.user, required this.token});

  final UserEntity user;
  final String token;

  factory AuthModel.fromEnvelope(Map<String, dynamic> envelope) {
    final data = envelope['data'];
    if (data is! Map || data['user'] is! Map || data['token'] is! String) {
      throw const FormatException('Invalid authentication response.');
    }
    final user = Map<String, dynamic>.from(data['user'] as Map);
    return AuthModel(
      user: UserEntity(
        id: '${user['id'] ?? ''}',
        name: '${user['name'] ?? ''}',
        email: '${user['email'] ?? ''}',
        phone: user['phone'] as String?,
        role: user['role'] as String?,
        preferredLocale: user['preferred_locale'] as String?,
      ),
      token: data['token'] as String,
    );
  }
}
