import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ravents/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artist: ${event.artist}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Date: ${_formatDate(event.date)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _launchURL(event.ticketUrl),
              child: const Text('Buy Tickets'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}