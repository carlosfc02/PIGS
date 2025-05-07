// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/BottomNavBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService    = AuthService();
  final _profileService = ProfileService();
  final _picker         = ImagePicker();

  // Datos de ejemplo para eventos…
  final List<Map<String, String>> events = [
    { 'image': 'assets/images/dj_background.jpg',      'title': 'Festival 1' },
    { 'image': 'assets/images/background_register.jpg','title': 'Festival 2' },
    { 'image': 'assets/images/dj_background.jpg',      'title': 'Festival 3' },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: _profileService.userProfileStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final data     = snapshot.data ?? {};
            final username = data['username'] as String? ?? 'Usuario';
            final photoUrl = data['photoUrl'] as String?;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Avatar con botón para cambiarla
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl)
                                : const AssetImage('assets/images/artist1.jpg')
                            as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _onChangeProfileImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
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

                      // Menú de ajustes / logout
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.settings,
                            color: Colors.white),
                        onSelected: (value) async {
                          if (value == 'logout') {
                            await _authService.signOut();
                            if (mounted) {
                              Navigator.pushReplacementNamed(
                                  context, '/login');
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

                // --- Artistas seguidos
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Artists @$username follows",
                    style: TextStyle(
                        color: Colors.grey[300], fontSize: 20),
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

                // --- Eventos de interés
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Events of interest",
                    style: TextStyle(
                        color: Colors.grey[300], fontSize: 20),
                  ),
                ),
                const SizedBox(height: 8),

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
      bottomNavigationBar:
      const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _artistCircle(String assetPath) => CircleAvatar(
    radius: 42,
    backgroundImage: AssetImage(assetPath),
  );

  Widget moreArtistButton() => GestureDetector(
    onTap: () {},
    child: CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey[800],
      child: const Icon(Icons.add, size: 40, color: Colors.white),
    ),
  );

  Future<void> _onChangeProfileImage() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    try {
      await _profileService.updateProfileImage(file);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
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
      padding:
      const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(12),
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
