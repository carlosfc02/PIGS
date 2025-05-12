// lib/services/thread_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/thread.dart';
import '../models/reply.dart';

class ThreadService {
  final _fs   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Stream de hilos de un evento
  Stream<List<Thread>> threadsStream(String eventId) {
    return _fs
        .collection('events').doc(eventId)
        .collection('threads')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Thread.fromDoc(d)).toList());
  }

  // Añadir hilo
  Future<void> addThread(String eventId, String content) async {
    final user = _auth.currentUser!;
    final userName = user.displayName ?? user.email!.split('@').first;
    await _fs
        .collection('events').doc(eventId)
        .collection('threads')
        .add({
      'authorId':   user.uid,
      'authorName': userName,
      'content':    content,
      'createdAt':  FieldValue.serverTimestamp(),
    });
  }

  // Stream de respuestas de un hilo
  Stream<List<Reply>> repliesStream(String eventId, String threadId) {
    return _fs
        .collection('events').doc(eventId)
        .collection('threads').doc(threadId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Reply.fromDoc(d)).toList());
  }

  // Añadir respuesta a un hilo
  Future<void> addReply(String eventId, String threadId, String content) async {
    final user = _auth.currentUser!;
    final userName = user.displayName ?? user.email!.split('@').first;
    await _fs
        .collection('events').doc(eventId)
        .collection('threads').doc(threadId)
        .collection('replies')
        .add({
      'authorId':   user.uid,
      'authorName': userName,
      'content':    content,
      'createdAt':  FieldValue.serverTimestamp(),
    });
  }
}
