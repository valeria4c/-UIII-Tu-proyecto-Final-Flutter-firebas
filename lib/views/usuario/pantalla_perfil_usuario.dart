import 'package:flutter/material.dart';
import 'user_navigation_wrapper.dart';
import '../../services_db.dart';

class PantallaPerfilUsuario extends StatelessWidget {
  const PantallaPerfilUsuario({super.key});

  void _mostrarConfirmacionCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF475569), // Sleek Navy Slate
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFD97706), width: 1.0), // Gold Accent Border
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFD97706), size: 28),
            SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión en Studio Mochi 22px?',
          style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          // Cancel button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF94A3B8)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('NO', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold)),
          ),
          // Confirm button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
            child: const Text('SÍ, SALIR', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserNavigationWrapper(
      currentIndex: 3,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD97706), width: 2.0),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF475569),
                  child: Icon(Icons.person, size: 60, color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                AuthService.instance.currentUserName ?? 'Cliente Mochi',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              // Email
              Text(
                AuthService.instance.currentUserEmail ?? 'usuario@correo.com',
                style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 36),

              // Menu navigation options
              _buildMenuButton(
                context, 
                'Configuración del Sistema', 
                Icons.settings_outlined,
                '/user_configuracion'
              ),
              _buildMenuButton(
                context, 
                'Editar mi Información', 
                Icons.edit_note_outlined,
                '/user_editar_info'
              ),
              
              const SizedBox(height: 32),

              // Close Session Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF475569),
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(220, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.redAccent, width: 1.0),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.logout, size: 20),
                onPressed: () => _mostrarConfirmacionCerrarSesion(context),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, String? route) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF334155)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF475569),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onPressed: () {
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Portafolio del Studio Mochi 22px disponible pronto.')),
            );
          }
        },
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD97706), size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
