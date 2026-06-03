import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  bool _notificacionesEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white70,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'CONFIGURACIÓN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Settings Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Notificaciones Push',
                    subtitle:
                        'Alertas sobre recordatorios de sesiones y entregas.',
                    icon: Icons.notifications_none_outlined,
                    value: _notificacionesEnabled,
                    onChanged: (val) {
                      setState(() {
                        _notificacionesEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFD97706), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
      ),
      trailing: Switch(
        value: value,
        activeTrackColor: const Color(0xFFD97706).withValues(alpha: 0.5),
        activeThumbColor: const Color(0xFFD97706),
        onChanged: onChanged,
      ),
    );
  }
}
