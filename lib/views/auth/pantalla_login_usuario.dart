import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaLoginUsuario extends StatefulWidget {
  const PantallaLoginUsuario({super.key});

  @override
  State<PantallaLoginUsuario> createState() => _PantallaLoginUsuarioState();
}

class _PantallaLoginUsuarioState extends State<PantallaLoginUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  bool _userNotFound = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _userNotFound = false;
    });

    try {
      await AuthService.instance.loginWithError(
        _emailController.text.trim(),
        _passwordController.text,
        onSuccess: () {
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/user_dashboard', (route) => false);
          }
        },
        onUserNotFound: () {
          if (context.mounted) {
            setState(() {
              _userNotFound = true;
              _errorMessage = 'Este correo no está registrado. ¿Deseas crear una cuenta?';
            });
          }
        },
        onWrongPassword: () {
          if (context.mounted) {
            setState(() {
              _errorMessage = 'Contraseña incorrecta. Por favor intenta de nuevo.';
            });
          }
        },
        onError: (msg) {
          if (context.mounted) {
            setState(() {
              _errorMessage = 'Error: $msg';
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Verifica tu internet e intenta de nuevo.';
      });
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: const Color(0xFF475569),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF475569), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 60,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'INICIAR SESIÓN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa para agendar tus sesiones de fotos y ver tus galerías digitales.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _userNotFound
                            ? const Color(0xFFD97706).withValues(alpha: 0.15)
                            : Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _userNotFound ? const Color(0xFFD97706) : Colors.redAccent,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                _userNotFound ? Icons.person_off_outlined : Icons.error_outline,
                                color: _userNotFound ? const Color(0xFFD97706) : Colors.redAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: _userNotFound ? const Color(0xFFD97706) : Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_userNotFound) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFD97706),
                                  side: const BorderSide(color: Color(0xFFD97706)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                icon: const Icon(Icons.person_add_outlined, size: 18),
                                label: const Text(
                                  'CREAR CUENTA AHORA',
                                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8, fontSize: 13),
                                ),
                                onPressed: () => Navigator.pushNamed(context, '/registro_usuario'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Correo
                  const Text('Correo Electrónico:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(hint: 'ejemplo@correo.com', prefixIcon: Icons.email_outlined),
                    validator: (val) => val == null || !val.contains('@') ? 'Ingrese un correo válido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Contraseña
                  const Text('Contraseña:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(hint: 'Mínimo 6 caracteres', prefixIcon: Icons.lock_outline),
                    validator: (val) => val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 24),

                  // Iniciar Sesión button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706), // Gold Accent
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                          )
                        : const Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                          ),
                  ),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      '¿Aún no tienes cuenta?',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/registro_usuario'),
                    child: const Text(
                      'Regístrate aquí',
                      style: TextStyle(
                        color: Color(0xFFD97706),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF64748B)),
      fillColor: const Color(0xFF1E293B),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD97706), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
    );
  }
}
