// lib/screens/event_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/thread.dart';
import '../models/reply.dart';
import '../services/thread_service.dart';
import '../services/interest_service.dart';
import '../widgets/BottomNavBar.dart';

class EventDetailPage extends StatefulWidget {
  final String   eventId;
  final String  description;
  final String   imageUrl;
  final String   title;
  final DateTime dateTime;
  final String   location;

  const EventDetailPage({
    Key? key,
    required this.eventId,
    required this.description,
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
  final _threadService   = ThreadService();

  bool _isFav     = false;
  bool _loadingFav = true;

  @override
  void initState() {
    super.initState();
    _loadFavState();
  }

  Future<void> _loadFavState() async {
    final fav = await _interestService.isInterested(widget.eventId);
    setState(() {
      _isFav      = fav;
      _loadingFav = false;
    });
  }

  Future<void> _toggleFav() async {
    setState(() { _loadingFav = true; });
    if (_isFav) {
      await _interestService.removeInterest(widget.eventId);
    } else {
      await _interestService.addInterest(widget.eventId);
    }
    setState(() {
      _isFav      = !_isFav;
      _loadingFav = false;
    });
  }

  void _showAddThreadDialog() {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        String content = '';
        return AlertDialog(
          title: const Text('Nuevo hilo'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Título del hilo'),
            onChanged: (v) => content = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                if (content.trim().isEmpty) return;
                Navigator.of(ctx).pop(content.trim());
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((result) async {
      if (result != null) {
        try {
          await _threadService.addThread(widget.eventId, result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hilo creado')),
          );
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    });
  }

  void _showAddReplyDialog(String threadId) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        String reply = '';
        return AlertDialog(
          title: const Text('Responder hilo'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Tu respuesta'),
            onChanged: (v) => reply = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                if (reply.trim().isEmpty) return;
                Navigator.of(ctx).pop(reply.trim());
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    ).then((result) async {
      if (result != null) {
        try {
          await _threadService.addReply(widget.eventId, threadId, result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Respuesta enviada')),
          );
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 50),
          // === FOTO + FAVORITO ===
          Stack(children: [
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
              right: 16, top: 16,
              child: IconButton(
                icon: _loadingFav
                    ? SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                )
                    : Icon(
                  _isFav ? Icons.favorite : Icons.favorite_border,
                  size: 28,
                  color: _isFav ? Colors.red : Colors.white,
                ),
                onPressed: _loadingFav ? null : _toggleFav,
              ),
            ),
          ]),

          const SizedBox(height: 16),

          // === TÍTULO / FECHA / UBICACIÓN ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEE d MMM y, HH:mm').format(widget.dateTime),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, size: 20, color: Colors.white70),
                const SizedBox(width: 6),
                Text(widget.location,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ]),
              const SizedBox(height: 24),
            ]),
          ),

          // === COMENTARIOS ESTÁTICOS ===
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Description',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...[widget.description].map((c) =>
              Padding(
                padding: const EdgeInsets.only(bottom:12,left:16,right:16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(c, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ),
              ),
          ),

          const SizedBox(height: 24),

          // === DISCUSSION HEADER + BOTÓN ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [
              const Expanded(
                child: Text('Discussion',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _showAddThreadDialog,
              ),
            ]),
          ),
          const SizedBox(height: 8),

          // === MAIN THREAD DINÁMICO ===
          StreamBuilder<String>(
            stream: _threadService.mainThreadStream(widget.eventId),
            builder: (context, snap) {
              final content = snap.data ?? 'Loading main thread…';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width:2, height:48, color:Colors.grey),
                  const SizedBox(width:12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Main Thread',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height:4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(content,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ]),
                  ),
                ]),
              );
            },
          ),

          const SizedBox(height: 24),

          // === SUB-HILOS + RESPUESTAS ===
          StreamBuilder<List<Thread>>(
            stream: _threadService.threadsStream(widget.eventId),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ));
              }
              // Excluimos el hilo con id "main", si existe:
              final threads = (snap.data ?? [])
                  .where((t) => t.id != 'main')
                  .toList();

              if (threads.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal:16.0),
                  child: Text('No sub-threads yet',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: threads.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.grey),
                itemBuilder: (ctx, i) {
                  final t = threads[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-hilo
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(
                            t.authorName.isEmpty ? 'U' : t.authorName[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(t.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(DateFormat('HH:mm').format(t.createdAt),
                          style: const TextStyle(color: Colors.white54, fontSize:12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.reply, color: Colors.white, size:20),
                          onPressed: () => _showAddReplyDialog(t.id),
                        ),
                      ),

                      // Respuestas al sub-hilo
                      StreamBuilder<List<Reply>>(
                        stream: _threadService.repliesStream(widget.eventId, t.id),
                        builder: (c2, snap2) {
                          if (snap2.connectionState == ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          final replies = snap2.data ?? [];
                          return Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Column(
                              children: replies.map((r) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 12,
                                    child: Text(
                                      r.authorName.isEmpty ? 'U' : r.authorName[0],
                                      style: const TextStyle(fontSize:12),
                                    ),
                                  ),
                                  title: Text(r.authorName,
                                    style: const TextStyle(color:Colors.white, fontSize:14),
                                  ),
                                  subtitle: Text(r.content,
                                    style: const TextStyle(color:Colors.white70, fontSize:13),
                                  ),
                                  trailing: Text(DateFormat('HH:mm').format(r.createdAt),
                                    style: const TextStyle(color:Colors.white54, fontSize:10),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
