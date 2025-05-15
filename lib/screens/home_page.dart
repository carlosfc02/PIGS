import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/BottomNavBar.dart';
import 'event_detail_page.dart'; // tu detalle de evento

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<Event>>(
        stream: _eventService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error cargando eventos:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final events = snapshot.data!;
          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No hay eventos disponibles',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Recommended Events:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Mapea cada Event a tu EventCard + navegación
                ...events.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailPage(
                              title:    e.title,
                              description: e.description,
                              imageUrl: e.imageUrl,
                              dateTime: e.date,
                              location: e.location,
                              eventId: e.id,
                            ),
                          ),
                        );
                      },
                      child: EventCard(
                        title:    e.title,
                        imageUrl: e.imageUrl,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const EventCard({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
