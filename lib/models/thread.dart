import 'package:cloud_firestore/cloud_firestore.dart';

class Thread {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  Thread({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory Thread.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Thread(
      id: doc.id,
      authorId:    data['authorId']    as String,
      authorName:  data['authorName']  as String,
      content:     data['content']     as String,
      createdAt:   (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
