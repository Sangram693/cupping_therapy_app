class AuthModel {
  const AuthModel({required this.email, required this.token});

  final String email;
  final String token;

  Map<String, dynamic> toJson() => {'email': email, 'token': token};
}
