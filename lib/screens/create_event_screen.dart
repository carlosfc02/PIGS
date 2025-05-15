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
  final _formKey        = GlobalKey<FormState>();
  final _titleCtrl      = TextEditingController();
  final _descCtrl       = TextEditingController();
  final _locationCtrl   = TextEditingController();

  DateTime? _eventDate;
  File? _pickedImage;
  bool _locationTBD = false;

  bool _isLoading    = false;
  String? _errorMessage;

  final _picker       = ImagePicker();
  final _eventService = EventService();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _pickedImage = File(img.path));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.red, // botón de aceptar en rojo
            onPrimary: Colors.white,
            surface: Colors.black, // fondo del datepicker
            onSurface: Colors.white, // texto
          ),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _eventDate = d);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_eventDate == null) {
      setState(() => _errorMessage = 'Please select the event date');
      return;
    }
    if (_pickedImage == null) {
      setState(() => _errorMessage = 'Please select an image for the event');
      return;
    }
    if (!_locationTBD && _locationCtrl.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter the location or mark "TBD"');
      return;
    }
    final location = _locationTBD
        ? 'To be determined'
        : _locationCtrl.text.trim();

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
        location:    location,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create Event', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              // Title
              TextFormField(
                controller: _titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter the title' : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 12),

              // Location TBD switch
              SwitchListTile(
                title: const Text('Location to be determined', style: TextStyle(color: Colors.white)),
                activeColor: Colors.red,
                value: _locationTBD,
                onChanged: (v) => setState(() => _locationTBD = v),
              ),

              // Location text field
              if (!_locationTBD) ...[
                TextFormField(
                  controller: _locationCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter the location' : null,
                ),
                const SizedBox(height: 12),
              ],

              // Date picker
              Row(children: [
                Expanded(
                  child: Text(
                    _eventDate == null
                        ? 'No date chosen'
                        : 'Date: ${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Select date', style: TextStyle(color: Colors.red)),
                ),
              ]),
              const SizedBox(height: 12),

              // Image picker
              if (_pickedImage != null)
                Image.file(_pickedImage!, width: w * 0.5, height: 120, fit: BoxFit.cover),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.white),
                label: const Text('Select image', style: TextStyle(color: Colors.white)),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 16),

              // Error message
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isLoading ? null : _onSubmit,
                  child: _isLoading
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Create Event'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
