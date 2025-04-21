import 'package:flutter/material.dart';
import 'package:ravents/screens/profile_user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ravents Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: '/home',
      initialRoute: '/profile',

      routes: {
        // '/home': (_) => PreviewScreen(),
        // '/search: (_) => SearchScreen(),
        '/profile': (_) => ProfileScreen(),
      },
    );
  }
}