import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final String companyId;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.companyId,
  });

  factory Event.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Event(
      id:          doc.id,
      title:       data['title'] as String,
      description: data['description'] as String,
      imageUrl:    data['imageUrl'] as String,
      date:        (data['date'] as Timestamp).toDate(),
      location: data['location'] as String,
      companyId:   data['companyId'] as String,
    );
  }
}
