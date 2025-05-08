import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;


  Future<String?> registerCompany({
    required String companyName,
    required String email,
    required String password,
    String? description,
  }) async {
    UserCredential cred;
    try {
      // 1) crea en Firebase Auth
      cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

    final uid = cred.user!.uid;

    try {
      // 2) guarda perfil en Firestore → colección "companies"
      await _fs.collection('companies').doc(uid).set({
        'companyName': companyName.trim(),
        'email':       email.trim(),
        'description': description?.trim() ?? '',
        'role':        'company',
        'createdAt':   FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      // rollback en Auth
      try { await cred.user!.delete(); } catch (_) {}
      return 'Error saving company: $e';
    }
  }
}
