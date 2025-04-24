// lib/screens/event_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/BottomNavBar.dart';

class EventDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final DateTime dateTime;
  final String location;

  const EventDetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: ListView(
          children: [
            // === FOTO DE CABECERA CON ICONO DE FAVORITO ===
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, size: 28, color: Colors.white),
                    onPressed: () {
                      // TODO: lógica de "favorito"
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === TÍTULO, FECHA Y UBICACIÓN ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del evento
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Fecha y hora
                  Text(
                    DateFormat('EEE d MMM y, HH:mm').format(dateTime),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 4),

                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // === COMENTARIOS DE ORGANIZADORES ===
                  const Text(
                    'Comments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Ejemplo estático de comentarios
                  ...[
                    'Bienvenidos al evento. Hora de apertura: 18:00.',
                    'Habrá zona de parking gratuita.',
                  ].map((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          comment,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // === PREVIEW DEL THREAD DE DISCUSIÓN ===
                  const Text(
                    'Discussion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Línea vertical + iconos + burbujas
                  Column(
                    children: [
                      // Main Thread
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Línea
                          Container(width: 2, height: 48, color: Colors.grey),
                          const SizedBox(width: 12),
                          // Contenido
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Main Thread',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Aquí hablan los que quieren asistir.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // User Thread
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Línea
                          Container(width: 2, height: 80, color: Colors.grey),
                          const SizedBox(width: 12),
                          // Avatar usuario
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey[800],
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 12),
                          // Contenido
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'User Thread',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '¡Yo también voy a ir!',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Botón “+” para añadir más hilos
                      Row(
                        children: [
                          Container(width: 2, height: 32, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Icon(Icons.add, color: Colors.white),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}