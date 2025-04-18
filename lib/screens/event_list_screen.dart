import 'package:flutter/material.dart';
import 'package:ravents/models/event.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatelessWidget {
  EventListScreen({Key? key}) : super(key: key);

  final List<Event> events = [
    Event(
      title: 'Rock Night',
      artist: 'The Rockers',
      date: DateTime(2025, 5, 10),
      ticketUrl: Uri.parse('https://tickets.example.com/rock'),
    ),
    Event(
      title: 'Jazz Fest',
      artist: 'Smooth Jazz Band',
      date: DateTime(2025, 6, 2),
      ticketUrl: Uri.parse('https://tickets.example.com/jazz'),
    ),
    Event(
      title: 'Rave Maspalomas',
      artist: 'XN',
      date: DateTime(2025, 5, 15),
      ticketUrl: Uri.parse('https://tickets.example.com/ravemaspalomas'),
    ),
    Event(
      title: 'Jazz Fest',
      artist: 'Smooth Jazz Band',
      date: DateTime(2025, 6, 2),
      ticketUrl: Uri.parse('https://tickets.example.com/jazz'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text('${event.artist} • ${_formatDate(event.date)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}