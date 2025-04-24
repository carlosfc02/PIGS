import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'widgets/BottomNavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Events',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/search': (context) => const PlaceholderScreen(title: 'Search'),
        '/profile': (context) => const PlaceholderScreen(title: 'Profile'),
      },
    );
  }
}

/// Pantallas de ejemplo para /search y /profile.
/// Luego las podrías sustituir por tus propias pantallas.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El Scaffold imita el estilo: fondo negro, texto blanco
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        // Ajusta el índice para resaltar la pestaña correspondiente
        currentIndex: title == 'Search'
            ? 1
            : title == 'Profile'
            ? 2
            : 0,
      ),
    );
  }
}
