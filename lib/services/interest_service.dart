import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterestService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  /// Stream de lista de IDs de eventos marcados como favoritos por el usuario.
  Stream<List<String>> interestedIdsStream() {
    final uid = _auth.currentUser!.uid;
    return _fs
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) {
      final data = snap.data();
      return List<String>.from(data?['interestedEvents'] ?? []);
    });
  }

  /// Comprueba si un evento está marcado como favorito.
  Future<bool> isInterested(String eventId) async {
    final uid  = _auth.currentUser!.uid;
    final snap = await _fs.collection('users').doc(uid).get();
    final list = List<String>.from(snap.data()?['interestedEvents'] ?? []);
    return list.contains(eventId);
  }

  /// Añade un evento a favoritos.
  Future<void> addInterest(String eventId) {
    final uid = _auth.currentUser!.uid;
    return _fs.collection('users').doc(uid).update({
      'interestedEvents': FieldValue.arrayUnion([eventId])
    });
  }

  /// Elimina un evento de favoritos.
  Future<void> removeInterest(String eventId) {
    final uid = _auth.currentUser!.uid;
    return _fs.collection('users').doc(uid).update({
      'interestedEvents': FieldValue.arrayRemove([eventId])
    });
  }
}
