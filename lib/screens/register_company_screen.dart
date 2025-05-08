import 'package:flutter/material.dart';
import '../services/company_auth_service.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _repeatCtrl   = TextEditingController();

  final _service      = CompanyAuthService();

  bool _isLoading     = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _repeatCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading    = true;
      _errorMessage = null;
    });

    final error = await _service.registerCompany(
      companyName: _nameCtrl.text,
      description: _descCtrl.text,
      email:       _emailCtrl.text,
      password:    _passwordCtrl.text,
    );

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading    = false;
      });
    } else {
      // Registro OK: navega al dashboard de empresa
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/create_event');
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
                  vertical:   h * 0.05,
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
                          width: w * 0.35,
                        ),
                        const SizedBox(height: 16),

                        // Nombre de empresa
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Company Name'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please enter the company name'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Descripción
                        TextFormField(
                          controller: _descCtrl,
                          decoration: const InputDecoration(labelText: 'Description'),
                          maxLines: 2,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please enter a description'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please enter your email'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Password
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please enter a password'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Repeat Password
                        TextFormField(
                          controller: _repeatCtrl,
                          decoration: const InputDecoration(labelText: 'Repeat Password'),
                          obscureText: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please repeat your password';
                            if (v != _passwordCtrl.text) return 'Passwords do not match';
                            return null;
                          },
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
                            onPressed: _isLoading ? null : _onRegisterPressed,
                            child: _isLoading
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFEA0000),
                              ),
                            )
                                : const Text('Register Company'),
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
