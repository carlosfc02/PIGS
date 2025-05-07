// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth       = FirebaseAuth.instance;
  final FirebaseFirestore _fs    = FirebaseFirestore.instance;

  /// Crea usuario en Auth y guarda perfil en Firestore.
  Future<String?> registerUser({
    required String name,
    required String surname,
    required String email,
    required String password, required String username,
  }) async {
    try {
      // 1) Registro en Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;
      final uid  = user.uid;

      // 2) Guarda perfil en Firestore
      await _fs.collection('users').doc(uid).set({
        'name': name,
        'surname': surname,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await user.updateDisplayName('$name $surname');
      await user.reload();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
