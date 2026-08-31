class AuthCredential {
  const AuthCredential({
    required this.email,
    required this.password,
    this.username,
  });

  final String email;
  final String password;
  final String? username;

  @override
  String toString() => "AuthCredential(email: $email)";
}
