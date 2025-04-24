// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/BottomNavBar.dart';
import 'event_detail_page.dart'; // Asegúrate de tener esta pantalla creada

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Ahora almacenamos también DateTime y location
  final List<Map<String, dynamic>> events = [
    {
      'title': 'Aquasella',
      'imageUrl': 'https://unika.fm/wp-content/uploads/2024/11/20241120_aquasella.jpg',
      'dateTime': DateTime(2024, 11, 20, 18, 0),
      'location': 'Cangas de Onís, Spain',
    },
    {
      'title': 'Monegros',
      'imageUrl': 'https://viciousmagazine.com/wp-content/uploads/2022/11/34c1d763-b5ad-c250-ca38-903f3b38ede5-scaled.jpg',
      'dateTime': DateTime(2022, 8, 13, 22, 0),
      'location': 'Fraga, Spain',
    },
    {
      'title': 'Coachella',
      'imageUrl': 'https://estacionk2.com/wp-content/uploads/2024/04/673625844.jpg',
      'dateTime': DateTime(2024, 4, 12, 15, 0),
      'location': 'Indio, California, USA',
    },
    // Añade más eventos aquí…
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: ListView(
          children: [
            // Título arriba de la lista
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Events you follow:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Las tarjetas de evento con gesto de tap
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
                          title: e['title'] as String,
                          imageUrl: e['imageUrl'] as String,
                          dateTime: e['dateTime'] as DateTime,
                          location: e['location'] as String,
                        ),
                      ),
                    );
                  },
                  child: EventCard(
                    title: e['title'] as String,
                    imageUrl: e['imageUrl'] as String,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
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