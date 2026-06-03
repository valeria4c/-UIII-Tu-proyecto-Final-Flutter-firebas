import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';

class PantallaSeleccionRol extends StatelessWidget {
  const PantallaSeleccionRol({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155), // Blue-navy claro premium
      appBar: const AppBarMochi(implicityLeading: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.supervised_user_circle_outlined,
                size: 80,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 24),
              const Text(
                '¿Cómo deseas ingresar hoy?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona tu perfil de acceso para Studio Mochi 22px',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 48),

              // CLIENT CARD BUTTON
              _buildRoleCard(
                context: context,
                title: 'CLIENTE / USUARIO',
                description: 'Agenda tus sesiones fotográficas, revisa tu calendario y accede a tu galería digital de entregables.',
                icon: Icons.camera_alt,
                color: const Color(0xFF475569),
                borderColor: const Color(0xFF64748B),
                onTap: () => Navigator.pushNamed(context, '/login_usuario'),
              ),

              const SizedBox(height: 24),

              // EMPLOYEE CARD BUTTON
              _buildRoleCard(
                context: context,
                title: 'ADMINISTRADOR / EMPLEADO',
                description: 'Gestiona la agenda, servicios, fotógrafos, inventario, facturación y entrega archivos digitales a tus clientes.',
                icon: Icons.admin_panel_settings,
                color: const Color(0xFF475569),
                borderColor: const Color(0xFFD97706), // Gold border for admin accent
                onTap: () => Navigator.pushNamed(context, '/login_admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                  ),
                  child: Icon(icon, color: borderColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: borderColor == const Color(0xFFD97706) ? const Color(0xFFD97706) : const Color(0xFFF8FAFC),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
