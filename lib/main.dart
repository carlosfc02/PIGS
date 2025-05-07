import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ravents/screens/event_detail_page.dart';
import 'package:ravents/screens/home_page.dart';
import 'package:ravents/screens/login_screen.dart';
import 'package:ravents/screens/profile_user_screen.dart';
import 'package:ravents/screens/register_company_screen.dart';
import 'package:ravents/screens/register_screen.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
       initialRoute: '/login',

      routes: {
        '/home': (_) => HomePage(),
        // '/search: (_) => SearchScreen(),
        '/profile': (_) => ProfileScreen(),
        '/register': (_) => RegisterScreen(),
        '/login': (_) => LoginScreen(),
        '/register_company': (_) => const RegisterCompanyScreen(),
      },
    );
  }
}