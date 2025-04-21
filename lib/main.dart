import 'package:flutter/material.dart';
import 'package:ravents/screens/profile_user_screen.dart';
import 'package:ravents/screens/profile_user_screen.dart'; // <-- Make sure this file exists and is correctly named
// import 'register_screen.dart'; // Optional, if you plan to navigate

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
      home: ProfileScreen(),
    );
  }
}