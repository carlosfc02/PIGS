// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../widgets/BottomNavBar.dart';

class ProfileScreen extends StatelessWidget {
  // Ejemplo de datos de eventos; en la app real vendrán del backend
  final List<Map<String, String>> events = [
    {
      'image': 'assets/images/dj_background.jpg',
      'title': 'Festival 1',
    },
    {
      'image': 'assets/images/dj_background.jpg',
      'title': 'Festival 2',
    },
    {
      'image': 'assets/images/festival3.jpg',
      'title': 'Festival 3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Fondo negro en toda la pantalla
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: avatar, nombre, follows, settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/artist1.jpg'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User name",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Followers 0   •   Following 5",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // --- Sección: Artists @user follows
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Artists @user follows",
                style: TextStyle(color: Colors.grey[300], fontSize: 20),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                children: [
                  _artistCircle('assets/images/artist1.jpg'),
                  SizedBox(width: 12),
                  _artistCircle('assets/images/artist2.jpg'),
                  SizedBox(width: 12),
                  _artistCircle('assets/images/artist3.jpg'),
                  SizedBox(width: 12),
                  moreArtistButton(),
                ],
              ),
            ),

            SizedBox(height: 24),

            // --- Título de la sección de eventos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Events of interest",
                style: TextStyle(color: Colors.grey[300], fontSize: 20),
              ),
            ),

            // --- Lista vertical de eventos
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: events.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    imageAsset: event['image']!,
                    title: event['title']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  /// Widget para mostrar un artista en un círculo
  Widget _artistCircle(String assetPath) => CircleAvatar(
    radius: 42,
    backgroundImage: AssetImage(assetPath),
  );

  /// Botón para ver más artistas
  Widget moreArtistButton() => GestureDetector(
    onTap: () {
      // Acción para “ver más”
    },
    child: CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey[800],
      child: Icon(Icons.add, size: 40, color: Colors.white),
    ),
  );
}

/// Widget reutilizable para representar un evento
class EventCard extends StatelessWidget {
  final String imageAsset;
  final String title;

  const EventCard({
    Key? key,
    required this.imageAsset,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.asset(
              imageAsset,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
