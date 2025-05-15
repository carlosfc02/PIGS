// lib/screens/company_event_detail_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event.dart';
import '../models/thread.dart';
import '../models/reply.dart';
import '../services/event_service.dart';
import '../services/thread_service.dart';
import '../widgets/BottomNavBar.dart';

class CompanyEventDetailPage extends StatefulWidget {
  final Event event;
  const CompanyEventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  State<CompanyEventDetailPage> createState() => _CompanyEventDetailPageState();
}

class _CompanyEventDetailPageState extends State<CompanyEventDetailPage> {
  final _formKey       = GlobalKey<FormState>();
  final _titleCtrl     = TextEditingController();
  final _descCtrl      = TextEditingController();
  final _locationCtrl  = TextEditingController();

  DateTime? _date;
  File?     _newImage;
  bool      _isSaving  = false;

  final _picker        = ImagePicker();
  final _eventService  = EventService();
  final _threadService = ThreadService();

  @override
  void initState() {
    super.initState();
    // Iniciar controles con datos del evento
    _titleCtrl.text    = widget.event.title;
    _descCtrl.text     = widget.event.description;
    _locationCtrl.text = widget.event.location;
    _date              = widget.event.date;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => _newImage = File(f.path));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate:  now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a date')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await _eventService.updateEvent(
        eventId:      widget.event.id,
        title:        _titleCtrl.text.trim(),
        description:  _descCtrl.text.trim(),
        date:         _date,
        location:     _locationCtrl.text.trim(),
        newImageFile: _newImage,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _editMainThread() {
    String temp = '';
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Edit main thread', style: TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Main thread content',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
          onChanged: (v) => temp = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.of(ctx).pop(temp), child: const Text('Save', style: TextStyle(color: Colors.white))),
        ],
      ),
    ).then((result) async {
      if (result != null && result.trim().isNotEmpty) {
        await _threadService.updateMainThread(widget.event.id, result.trim());
        setState(() {}); // Rebuild para refrescar el StreamBuilder
      }
    });
  }

  void _showAddThreadDialog() {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        String content = '';
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('New Thread', style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Thread title', hintStyle: TextStyle(color: Colors.white54)),
            onChanged: (v) => content = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
            TextButton(
              onPressed: () {
                if (content.trim().isEmpty) return;
                Navigator.of(ctx).pop(content.trim());
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((result) async {
      if (result != null) {
        await _threadService.addThread(widget.event.id, result);
      }
    });
  }

  void _showAddReplyDialog(String threadId) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        String reply = '';
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Reply Thread', style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Your reply', hintStyle: TextStyle(color: Colors.white54)),
            onChanged: (v) => reply = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
            TextButton(
              onPressed: () {
                if (reply.trim().isEmpty) return;
                Navigator.of(ctx).pop(reply.trim());
              },
              child: const Text('Send', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((result) async {
      if (result != null) {
        await _threadService.addReply(widget.event.id, threadId, result);
      }
    });
  }

  Widget _buildThreadWithReplies(Thread t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Text(t.authorName.isEmpty ? 'U' : t.authorName[0])),
          title: Text(t.authorName, style: const TextStyle(color: Colors.white)),
          subtitle: Text(t.content, style: const TextStyle(color: Colors.white70)),
          trailing: IconButton(
            icon: const Icon(Icons.reply, color: Colors.white, size: 20),
            onPressed: () => _showAddReplyDialog(t.id),
          ),
        ),
        StreamBuilder<List<Reply>>(
          stream: _threadService.repliesStream(widget.event.id, t.id),
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
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(r.authorName, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: Text(r.content, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    trailing: Text(
                      DateFormat('HH:mm').format(r.createdAt),
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ------ Imagen (tap para cambiar) ------
            GestureDetector(
              onTap: _pickImage,
              child: _newImage != null
                  ? Image.file(_newImage!, height: 200, fit: BoxFit.cover)
                  : Image.network(widget.event.imageUrl, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),

            // ------ Formulario de edición ------
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Enter a description' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Enter a location' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _date == null
                              ? 'No date chosen'
                              : DateFormat.yMMMd().format(_date!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text('Select date', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save changes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.grey, height: 32),

            // ------ Main Thread (editable) ------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: StreamBuilder<String>(
                stream: _threadService.mainThreadStream(widget.event.id),
                builder: (context, snap) {
                  final content = snap.data ?? 'No main thread yet';
                  return Row(
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
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: _editMainThread,
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ------ Discussion Header ------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Discussion',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _showAddThreadDialog,
                ),
              ],
            ),

            // ------ Sub-threads + replies ------
            StreamBuilder<List<Thread>>(
              stream: _threadService.threadsStream(widget.event.id),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                final threads = snap.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: threads.length,
                  itemBuilder: (ctx, i) => _buildThreadWithReplies(threads[i]),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
