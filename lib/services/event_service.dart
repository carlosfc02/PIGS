import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/event.dart';

class EventService {
  final _auth    = FirebaseAuth.instance;
  final _fs      = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Sube la imagen de evento a Storage y devuelve su URL pública.
  Future<String> uploadEventImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final ref = _storage
        .ref()
        .child('events/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

  /// Crea un documento en la colección `events`.
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required File imageFile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    // 1) Sube la imagen y obtiene URL
    final imageUrl = await uploadEventImage(imageFile);

    // 2) Inserta el evento en Firestore
    await _fs.collection('events').add({
      'title':       title.trim(),
      'description': description.trim(),
      'date':        date.toUtc(),
      'imageUrl':    imageUrl,
      'companyId':   user.uid,
      'createdAt':   FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Event>> getEvents() {
    return _fs
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Event.fromDoc(doc))
        .toList(),
    );
  }

  Stream<List<Event>> getMyEvents() {
    final user = _auth.currentUser;
    if (user == null) {
      // Si no hay usuario, devolvemos un stream vacío
      return const Stream.empty();
    }
    return _fs
        .collection('events')
        .where('companyId', isEqualTo: user.uid)
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Event.fromDoc(doc)).toList());
  }
}
