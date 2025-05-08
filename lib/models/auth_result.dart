enum Role { user, company }

class AuthResult {
  final Role role;
  final String uid;

  AuthResult({ required this.role, required this.uid });
}