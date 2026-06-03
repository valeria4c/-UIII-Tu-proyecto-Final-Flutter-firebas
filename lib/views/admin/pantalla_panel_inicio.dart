import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaPanelInicio extends StatelessWidget {
  const PantallaPanelInicio({super.key});

  void _mostrarConfirmacionCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF475569),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFD97706), width: 1.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFD97706), size: 24),
            SizedBox(width: 10),
            Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar la sesión de administración?',
          style: TextStyle(color: Color(0xFFE2E8F0)),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF94A3B8))),
            onPressed: () => Navigator.pop(context),
            child: const Text('NO', style: TextStyle(color: Color(0xFFE2E8F0))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
            child: const Text('SÍ, SALIR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(implicityLeading: true),
      drawer: Drawer(
        backgroundColor: const Color(0xFF475569),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF334155),
                border: Border(bottom: BorderSide(color: Color(0xFF334155), width: 1.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFF475569),
                    radius: 26,
                    child: Icon(Icons.admin_panel_settings, color: Color(0xFFD97706), size: 30),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'STUDIO MOCHI 22PX',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0),
                  ),
                  Text(
                    'Panel Administrativo',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),

            // Navigation tiles
            _buildDrawerTile(context, 'Centro de Comando', Icons.dashboard_outlined, '/admin_menu'),
            _buildDrawerTile(context, 'Gestión de Empleados', Icons.badge_outlined, '/admin_empleados'),
            _buildDrawerTile(context, 'Gestión de Servicios', Icons.collections_bookmark_outlined, '/admin_servicios'),
            _buildDrawerTile(context, 'Control de Clientes', Icons.people_outline, '/admin_usuarios'),
            _buildDrawerTile(context, 'Agenda de Sesiones', Icons.photo_camera_back_outlined, '/admin_sesiones'),

            const Divider(color: Color(0xFF334155)),
            
            // Logout tile
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () => _mostrarConfirmacionCerrarSesion(context),
            )
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_open, size: 72, color: Color(0xFFD97706)),
              const SizedBox(height: 16),
              const Text(
                'Menú de Navegación Lateral Activo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Desliza desde el borde izquierdo o pulsa el botón del extremo superior para ver los accesos directos administrativos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin_menu'),
                child: const Text('VOLVER AL COMANDO CENTRAL', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerTile(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF94A3B8)),
      title: Text(title, style: const TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF64748B)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
