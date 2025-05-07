// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey                = GlobalKey<FormState>();
  final _nameController         = TextEditingController();
  final _surnameController      = TextEditingController();
  final _usernameController      = TextEditingController();
  final _emailController        = TextEditingController();
  final _passwordController     = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await _authService.registerUser(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    } else {
      // Registro OK: navega a la pantalla principal
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_register.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.05,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/appLogo2.png',
                          width: screenWidth * 0.35,
                        ),
                        const SizedBox(height: 16),

                        // Nombre
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Apellidos
                        TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(labelText: 'Surname'),
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your surname'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // username
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your username'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your email'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Contraseña
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Repetir contraseña
                        TextFormField(
                          controller: _repeatPasswordController,
                          decoration:
                          const InputDecoration(labelText: 'Repeat Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please repeat your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Muestra mensaje de error
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Botón de registro
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFEA0000),
                              side: const BorderSide(color: Color(0xFFEA0000)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed:
                            _isLoading ? null : _onRegisterPressed,
                            child: _isLoading
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFEA0000),
                              ),
                            )
                                : const Text('Register'),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register_company');
                          },
                          child: const Text(
                            'You are a company? Create Company Account',
                            style: TextStyle(
                              color: Colors.black54,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
