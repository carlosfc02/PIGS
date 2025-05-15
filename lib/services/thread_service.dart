// lib/services/thread_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/thread.dart';
import '../models/reply.dart';

class ThreadService {
  final FirebaseFirestore _fs   = FirebaseFirestore.instance;
  final FirebaseAuth      _auth = FirebaseAuth.instance;

  /// Stream de los sub-hilos de un evento (excluye el main thread)
  Stream<List<Thread>> threadsStream(String eventId) {
    return _fs
        .collection('events')
        .doc(eventId)
        .collection('threads')
        .where('isMain', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => Thread.fromDoc(d)).toList()
    );
  }

  Future<void> addThread(String eventId, String content) async {
    final user = _auth.currentUser!;
    final userName = user.displayName ?? user.email!.split('@').first;

    await _fs
        .collection('events')
        .doc(eventId)
        .collection('threads')
        .add({
      'authorId':   user.uid,
      'authorName': userName,
      'content':    content,
      'createdAt':  FieldValue.serverTimestamp(),
      'isMain':     false,
    });
  }

  Stream<List<Reply>> repliesStream(String eventId, String threadId) {
    return _fs
        .collection('events')
        .doc(eventId)
        .collection('threads')
        .doc(threadId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => Reply.fromDoc(d)).toList()
    );
  }

  Future<void> addReply(String eventId, String threadId, String content) async {
    final user = _auth.currentUser!;
    final userName = user.displayName ?? user.email!.split('@').first;

    await _fs
        .collection('events')
        .doc(eventId)
        .collection('threads')
        .doc(threadId)
        .collection('replies')
        .add({
      'authorId':   user.uid,
      'authorName': userName,
      'content':    content,
      'createdAt':  FieldValue.serverTimestamp(),
    });
  }

  Stream<String> mainThreadStream(String eventId) {
    return _fs
        .collection('events')
        .doc(eventId)
        .snapshots()
        .map((snap) {
      final data = snap.data();
      return data != null && data['mainThread'] != null
          ? data['mainThread'] as String
          : '';
    });
  }

  Future<void> updateMainThread(String eventId, String content) {
    return _fs
        .collection('events')
        .doc(eventId)
        .update({'mainThread': content});
  }

  Future<String> getMainThreadContent(String eventId) async {
    final docSnap = await _fs.collection('events').doc(eventId).get();
    if (!docSnap.exists) return '';
    final data = docSnap.data()!;
    return (data['mainThread'] as String?) ?? '';
  }

}
