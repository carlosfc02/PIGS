// lib/services/event_service.dart

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
  /// Si [eventId] != null, la guarda bajo events/{uid}/{eventId}/timestamp.jpg
  /// Si [eventId] == null, la guarda bajo events/{uid}/timestamp.jpg
  Future<String> _uploadImage(File file, {String? eventId}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final basePath = eventId == null
        ? 'events/${user.uid}/$timestamp.jpg'
        : 'events/${user.uid}/$eventId/$timestamp.jpg';

    final ref  = _storage.ref().child(basePath);
    final task = ref.putFile(file);
    final snap = await task.whenComplete(() => {});
    return await snap.ref.getDownloadURL();
  }

  /// Crea un nuevo evento (firma y storage funcionan igual que antes).
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required File imageFile,
    required String location,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    // 1) sube la imagen (no hay eventId aún)
    final imageUrl = await _uploadImage(imageFile);

    // 2) crea el doc en Firestore
    await _fs.collection('events').add({
      'title':       title.trim(),
      'description': description.trim(),
      'date':        date.toUtc(),
      'imageUrl':    imageUrl,
      'location':    location.trim(),
      'companyId':   user.uid,
      'createdAt':   FieldValue.serverTimestamp(),
    });
  }

  /// Recupera todos los eventos
  Stream<List<Event>> getEvents() {
    return _fs
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => Event.fromDoc(d)).toList()
    );
  }

  /// Recupera solo los que creó la empresa actual
  Stream<List<Event>> getMyEvents() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _fs
        .collection('events')
        .where('companyId', isEqualTo: user.uid)
        .orderBy('date')
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => Event.fromDoc(d)).toList()
    );
  }

  /// Actualiza un evento. Solo envía los campos no-null.
  /// Si [newImageFile] != null, la sube y actualiza `imageUrl`.
  Future<void> updateEvent({
    required String eventId,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    File? newImageFile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final docRef = _fs.collection('events').doc(eventId);
    final updates = <String, dynamic>{};

    if (title      != null) updates['title']       = title.trim();
    if (description!= null) updates['description'] = description.trim();
    if (date       != null) updates['date']        = date.toUtc();
    if (location   != null) updates['location']    = location.trim();

    if (newImageFile != null) {
      // la subimos bajo events/{uid}/{eventId}/
      final imageUrl = await _uploadImage(newImageFile, eventId: eventId);
      updates['imageUrl'] = imageUrl;
    }

    if (updates.isNotEmpty) {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.update(updates);
    }
  }
}
