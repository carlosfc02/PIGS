import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/BottomNavBar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthService _authService       = AuthService();
  final ProfileService _profileService = ProfileService();

  final List<Map<String, String>> events = [
    {
      'image': 'assets/images/dj_background.jpg',
      'title': 'Festival 1',
    },
    {
      'image': 'assets/images/background_register.jpg',
      'title': 'Festival 2',
    },
    {
      'image': 'assets/images/dj_background.jpg',
      'title': 'Festival 3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileService.fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data;
            // Si existe el campo 'username' lo usamos, si no un fallback genérico:
            final username = data != null && data.containsKey('username')
                ? data['username'] as String
                : 'Usuario';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header: avatar, username, follows, settings
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 64,
                        backgroundImage:
                        AssetImage('assets/images/artist1.jpg'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Followers 0   •   Following 5",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),

                      // Menú de ajustes
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onSelected: (value) async {
                          if (value == 'logout') {
                            await _authService.signOut();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              );
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'logout',
                            child: Text('Cerrar sesión'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- Sección: Artists @user follows
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Artists @$username follows",
                    style:
                    TextStyle(color: Colors.grey[300], fontSize: 20),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    children: [
                      _artistCircle('assets/images/artist1.jpg'),
                      const SizedBox(width: 12),
                      _artistCircle('assets/images/artist2.jpg'),
                      const SizedBox(width: 12),
                      _artistCircle('assets/images/artist3.jpg'),
                      const SizedBox(width: 12),
                      moreArtistButton(),
                    ],
                  ),
                ),

                // --- Sección: Events of interest
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Events of interest",
                    style:
                    TextStyle(color: Colors.grey[300], fontSize: 20),
                  ),
                ),
                const SizedBox(height: 8),

                // --- Lista vertical de eventos
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: events.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 16),
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
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _artistCircle(String assetPath) => CircleAvatar(
    radius: 42,
    backgroundImage: AssetImage(assetPath),
  );

  Widget moreArtistButton() => GestureDetector(
    onTap: () {
      // Acción de “ver más”
    },
    child: CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey[800],
      child: const Icon(Icons.add, size: 40, color: Colors.white),
    ),
  );
}

class EventCard extends StatelessWidget {
  final String imageAsset;
  final String title;

  const EventCard({
    super.key,
    required this.imageAsset,
    required this.title,
  });

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
                style: const TextStyle(
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
