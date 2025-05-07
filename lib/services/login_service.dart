import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Intenta autenticar con email y password.
  /// Devuelve `null` si OK, o el mensaje de error si falla.
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
