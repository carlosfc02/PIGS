// lib/services/login_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  /// Intenta hacer sign-in y devuelve AuthResult con el rol.
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    // 1) Autenticar en Firebase Auth
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final uid = cred.user!.uid;

    // 2) Intentar leer companies/{uid}
    bool isCompany = false;
    try {
      final doc = await _fs.collection('companies').doc(uid).get();
      isCompany = doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // OK, no es empresa (o no tiene permiso), lo tratamos como usuario normal
        isCompany = false;
      } else {
        rethrow; // si fuera otro error, lo propago
      }
    }

    // 3) Si no es empresa, comprobamos users/{uid}
    bool isUser = false;
    if (!isCompany) {
      try {
        final doc = await _fs.collection('users').doc(uid).get();
        isUser = doc.exists;
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          // no debería pasar si tu regla permite leer your own user doc
          isUser = false;
        } else {
          rethrow;
        }
      }
    }

    if (isCompany) {
      return AuthResult(role: Role.company, uid: uid);
    }
    if (isUser) {
      return AuthResult(role: Role.user,    uid: uid);
    }

    // Si no está en ninguna, cerramos sesión y devolvemos error
    await _auth.signOut();
    throw FirebaseAuthException(
      code: 'no-role',
      message: 'No tienes un perfil de usuario o empresa en la base de datos.',
    );
  }

  Future<void> signOut() => _auth.signOut();
}
