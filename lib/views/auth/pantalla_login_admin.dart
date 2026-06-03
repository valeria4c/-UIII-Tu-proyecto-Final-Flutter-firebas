import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaLoginAdmin extends StatefulWidget {
  const PantallaLoginAdmin({super.key});

  @override
  State<PantallaLoginAdmin> createState() => _PantallaLoginAdminState();
}

class _PantallaLoginAdminState extends State<PantallaLoginAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _employeeIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = await AuthService.instance.login(
        _emailController.text.trim(),
        _passwordController.text,
        employeeId: _employeeIdController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/admin_menu', (route) => false);
      } else if (context.mounted) {
        setState(() {
          _errorMessage = 'Credenciales de administrador incorrectas.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: $e';
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
    _employeeIdController.dispose();
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
              border: Border.all(color: const Color(0xFFD97706), width: 1.0),
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
                    Icons.admin_panel_settings_outlined,
                    size: 60,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PANEL DE ADMINISTRACIÓN',
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
                    'Ingreso exclusivo para fotógrafos y personal de Studio Mochi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
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
                    decoration: _buildInputDecoration(hint: 'ejemplo@mochi.com', prefixIcon: Icons.email_outlined),
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
                    decoration: _buildInputDecoration(hint: '••••••••', prefixIcon: Icons.lock_outline),
                    validator: (val) => val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 16),

                  // ID de Empleado
                  const Text('ID de Empleado:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _employeeIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(hint: 'Mochi-EMP-XXX', prefixIcon: Icons.badge_outlined),
                    validator: (val) => val == null || val.isEmpty ? 'Requerido para administradores' : null,
                  ),
                  const SizedBox(height: 28),

                  // Iniciar Sesion Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
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
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Regresar',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
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
