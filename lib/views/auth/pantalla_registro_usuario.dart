import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaRegistroUsuario extends StatefulWidget {
  const PantallaRegistroUsuario({super.key});

  @override
  State<PantallaRegistroUsuario> createState() => _PantallaRegistroUsuarioState();
}

class _PantallaRegistroUsuarioState extends State<PantallaRegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = await AuthService.instance.registerCliente(
        _nombreController.text.trim(),
        _apellidoController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _telefonoController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        // Deslogueamos al usuario para que deba ingresar sus credenciales
        await AuthService.instance.logout();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada! Por favor, inicia sesión para verificar.'),
            backgroundColor: Color(0xFFD97706),
          ),
        );
        // Navigate back to login
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'El correo ya se encuentra registrado.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al registrar: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
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
                    Icons.app_registration,
                    size: 50,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'CREA TU CUENTA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  _buildFormField(
                    label: 'Nombre:',
                    controller: _nombreController,
                    hint: 'Ingresa tu nombre',
                    icon: Icons.person_outline,
                    validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
                  ),

                  _buildFormField(
                    label: 'Apellidos:',
                    controller: _apellidoController,
                    hint: 'Ingresa tus apellidos',
                    icon: Icons.people_outline,
                    validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
                  ),

                  _buildFormField(
                    label: 'Correo Electrónico:',
                    controller: _emailController,
                    hint: 'ejemplo@correo.com',
                    icon: Icons.email_outlined,
                    validator: (val) => val == null || !val.contains('@') ? 'Ingrese un correo válido' : null,
                  ),

                  _buildFormField(
                    label: 'Contraseña:',
                    controller: _passwordController,
                    hint: 'Mínimo 6 caracteres',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (val) => val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),

                  _buildFormField(
                    label: 'Número de Teléfono:',
                    controller: _telefonoController,
                    hint: '10 dígitos',
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                          )
                        : const Text(
                            'CREAR CUENTA',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                          ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Ya tengo una cuenta, iniciar sesión',
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
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
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
