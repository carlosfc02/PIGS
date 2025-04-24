// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = cred.user!;
      // Usa el perfil de Auth para guardar nombre y apellidos
      await user.updateDisplayName('$name $surname');
      await user.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

}
