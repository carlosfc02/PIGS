import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _titleCtrl    = TextEditingController();
  final _descCtrl     = TextEditingController();
  DateTime? _eventDate;
  File? _pickedImage;

  bool _isLoading = false;
  String? _errorMessage;

  final _picker       = ImagePicker();
  final _eventService = EventService();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _pickedImage = File(img.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) {
      setState(() {
        _eventDate = d;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_eventDate == null) {
      setState(() => _errorMessage = 'Selecciona la fecha del evento');
      return;
    }
    if (_pickedImage == null) {
      setState(() => _errorMessage = 'Selecciona una imagen para el evento');
      return;
    }

    setState(() {
      _isLoading    = true;
      _errorMessage = null;
    });

    try {
      await _eventService.createEvent(
        title:       _titleCtrl.text,
        description: _descCtrl.text,
        date:        _eventDate!,
        imageFile:   _pickedImage!,
      );
      if (!mounted) return;
      Navigator.pop(context); // vuelve al dashboard empresas
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evento')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Título
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Introduce el título'
                      : null,
                ),
                const SizedBox(height: 12),

                // Descripción
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Introduce una descripción'
                      : null,
                ),
                const SizedBox(height: 12),

                // Fecha
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _eventDate == null
                            ? 'Sin fecha seleccionada'
                            : 'Fecha: ${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Seleccionar fecha'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Imagen
                _pickedImage != null
                    ? Image.file(_pickedImage!, width: w * 0.5, height: 120, fit: BoxFit.cover)
                    : const SizedBox(),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Seleccionar imagen'),
                  onPressed: _pickImage,
                ),
                const SizedBox(height: 16),

                // Error
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                ],

                // Botón Crear
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    child: _isLoading
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Crear Evento'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
