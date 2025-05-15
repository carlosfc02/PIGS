// lib/services/profile_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final _auth    = FirebaseAuth.instance;
  final _fs      = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Stream que emite los datos del documento users/{uid}
  Stream<Map<String, dynamic>?> userProfileStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _fs
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  /// Sube [file] a Storage en users/{uid}/profile.jpg
  /// y luego guarda la URL en Firestore en el campo 'photoUrl'.
  Future<void> updateProfileImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
    // Sube el archivo
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    // Obtén la URL
    final url = await snapshot.ref.getDownloadURL();
    // Actualiza Firestore
    await _fs.collection('users').doc(user.uid).update({
      'photoUrl': url,
    });
  }

  Stream<Map<String, dynamic>?> companyProfileStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _fs
        .collection('companies')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<void> updateCompanyProfileImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final ref = _storage.ref().child('companies/${user.uid}/profile.jpg');
    final snapshot = await ref.putFile(file);
    final url = await snapshot.ref.getDownloadURL();
    await _fs.collection('companies').doc(user.uid).update({'photoUrl': url});
  }

}
