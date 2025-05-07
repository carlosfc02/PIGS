import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  /// Devuelve los datos del perfil del usuario actual desde Firestore.
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _fs.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}
