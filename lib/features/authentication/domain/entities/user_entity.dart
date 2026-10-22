class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.preferredLocale,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  final String? preferredLocale;
}
