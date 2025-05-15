// lib/screens/company_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../widgets/BottomNavBarCompany.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});
  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _authService    = AuthService();
  final _profileService = ProfileService();
  final _picker         = ImagePicker();

  Future<void> _changePhoto() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    try {
      await _profileService.updateCompanyProfileImage(File(img.path));
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Photo updated')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: _profileService.companyProfileStream(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }
            final data = snap.data;
            if (data == null) {
              return const Center(
                child: Text('No company data', style: TextStyle(color: Colors.white70)),
              );
            }
            final photoUrl = data['photoUrl'] as String?;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar + cambiar foto
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/images/company_placeholder.png')
                          as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: GestureDetector(
                            onTap: _changePhoto,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[800],
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nombre
                  Text(
                    data['companyName'] as String? ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data['email'] as String? ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Descripción
                  const Text(
                    'Description',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['description'] as String? ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),

                  const Spacer(),

                  // Cerrar sesión
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      onPressed: () async {
                        await _authService.signOut();
                        if (mounted) Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
