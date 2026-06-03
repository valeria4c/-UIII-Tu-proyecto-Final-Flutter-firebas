import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaEditarInformacion extends StatefulWidget {
  const PantallaEditarInformacion({super.key});

  @override
  State<PantallaEditarInformacion> createState() => _PantallaEditarInformacionState();
}

class _PantallaEditarInformacionState extends State<PantallaEditarInformacion> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Splitting mock name into name & surname
    String fullName = AuthService.instance.currentUserName ?? 'Cliente Mochi';
    List<String> parts = fullName.split(' ');
    String first = parts.isNotEmpty ? parts.first : 'Cliente';
    String last = parts.length > 1 ? parts.sublist(1).join(' ') : 'Mochi';

    _nombreController = TextEditingController(text: first);
    _apellidoController = TextEditingController(text: last);
    _emailController = TextEditingController(text: AuthService.instance.currentUserEmail ?? '');
    _telefonoController = TextEditingController(text: '555-123-4567'); // Default placeholder
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.updateProfile(
        _nombreController.text.trim(),
        _apellidoController.text.trim(),
        _telefonoController.text.trim(),
        _emailController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Información actualizada exitosamente.'),
          backgroundColor: Color(0xFFD97706),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF475569),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155), width: 0.5),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'EDITAR INFORMACIÓN',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.8),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 16),

                _buildField('Nombre:', _nombreController, Icons.person_outline),
                _buildField('Apellidos:', _apellidoController, Icons.people_outline),
                _buildField('Correo Electrónico:', _emailController, Icons.email_outlined, isEmail: true),
                _buildField('Número de Teléfono:', _telefonoController, Icons.phone_android, isPhone: true),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'GUARDAR CAMBIOS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: isPhone ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
            decoration: InputDecoration(
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
                borderSide: const BorderSide(color: Color(0xFFD97706)),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Este campo es requerido';
              if (isEmail && !val.contains('@')) return 'Ingrese un correo válido';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
