// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading     = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
      _isLoading    = true;
    });

    try {
      // Intenta autenticar con email y contraseña
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si el usuario se ha autenticado correctamente, navega al perfil
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      // Muestra el mensaje de error de Firebase
      setState(() => _errorMessage = e.message);
    } catch (e) {
      // Cualquier otro error
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo reutilizado del register
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
                  horizontal: w * 0.08,
                  vertical: h * 0.05,
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
                        // Logo
                        Image.asset(
                          'assets/images/appLogo2.png',
                          width: w * 0.35,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Please enter your email' : null,
                        ),
                        const SizedBox(height: 8),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Error message
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Botón de Login
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFEA0000),
                              side: const BorderSide(color: Color(0xFFEA0000)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFEA0000),
                              ),
                            )
                                : const Text('Login'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Enlace para registro
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: TextButton(
                            onPressed: () {
                              // Navega a la ruta '/register'
                              Navigator.pushReplacementNamed(context, '/register');
                              // Si quieres mantener la pila y poder volver atrás:
                              // Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'New user? Create Account',
                              style: TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.underline, // opcional: subrayado
                              ),
                              textAlign: TextAlign.center,
                            ),
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
