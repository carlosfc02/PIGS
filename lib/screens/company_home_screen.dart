// lib/screens/company_home_screen.dart

import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import 'company_event_detail_page.dart';  
import '../widgets/BottomNavBarCompany.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _eventService = EventService();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Events',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<List<Event>>(
        stream: _eventService.getMyEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading your events:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return const Center(
              child: Text(
                'You haven’t created any events yet',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final e = events[i];
              return _CompanyEventCard(event: e);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create_event'),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

class _CompanyEventCard extends StatelessWidget {
  final Event event;
  const _CompanyEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Al pulsar, vamos a la pantalla de detalle editable
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompanyEventDetailPage(event: event),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Imagen de fondo
              Image.network(
                event.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              // Gradiente inferior
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Título y fecha
              Positioned(
                bottom: 12,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.date.day}/${event.date.month}/${event.date.year}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
