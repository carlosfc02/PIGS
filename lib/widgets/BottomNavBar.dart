import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  // Rutas estáticas para cada pestaña
  static const List<String> _routes = [
    '/home',
    '/search',
    '/profile',
  ];

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    this.backgroundColor = Colors.black,
    this.selectedItemColor = Colors.white,
    this.unselectedItemColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      currentIndex: currentIndex,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),    label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search),  label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person),  label: 'Profile'),
      ],
      onTap: (index) {
                       // si ya estás en esa pestaña, nada
        final route = _routes[index];
        Navigator.pushReplacementNamed(context, route);  // navega a la ruta fija
      },
    );
  }
}
