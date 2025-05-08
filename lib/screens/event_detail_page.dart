import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/interest_service.dart';
import '../widgets/BottomNavBar.dart';

class EventDetailPage extends StatefulWidget {
  final String   eventId;
  final String   imageUrl;
  final String   title;
  final DateTime dateTime;
  final String   location;

  const EventDetailPage({
    Key? key,
    required this.eventId,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.location,
  }) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _interestService = InterestService();
  bool _isFav = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavState();
  }

  Future<void> _loadFavState() async {
    final fav = await _interestService.isInterested(widget.eventId);
    setState(() {
      _isFav = fav;
      _loading = false;
    });
  }

  Future<void> _toggleFav() async {
    setState(() { _loading = true; });
    if (_isFav) {
      await _interestService.removeInterest(widget.eventId);
    } else {
      await _interestService.addInterest(widget.eventId);
    }
    setState(() {
      _isFav = !_isFav;
      _loading = false;
    });
  }

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
                    widget.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: IconButton(
                    icon: _loading
                        ? SizedBox(
                      width: 28, height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                    )
                        : Icon(
                      _isFav ? Icons.favorite : Icons.favorite_border,
                      size: 28,
                      color: _isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: _loading ? null : _toggleFav,
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
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Fecha y hora
                  Text(
                    DateFormat('EEE d MMM y, HH:mm').format(widget.dateTime),
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
                          widget.location,
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
                          Container(width: 2, height: 48, color: Colors.grey),
                          const SizedBox(width: 12),
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

                      const SizedBox(height: 16),

                      // User Thread
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 2, height: 80, color: Colors.grey),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey[800],
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 12),
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
