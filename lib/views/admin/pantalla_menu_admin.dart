import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaMenuAdmin extends StatelessWidget {
  const PantallaMenuAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(implicityLeading: false),
      body: StreamBuilder<List<Fotografo>>(
        stream: DatabaseService.instance.streamFotografos(),
        builder: (context, snapFot) {
          final fotCount = snapFot.data?.length ?? 0;
          return StreamBuilder<List<Cliente>>(
            stream: DatabaseService.instance.streamClientes(),
            builder: (context, snapCli) {
              final cliCount = snapCli.data?.length ?? 0;
              return StreamBuilder<List<Reservacion>>(
                stream: DatabaseService.instance.streamReservaciones(),
                builder: (context, snapRes) {
                  final resCount = snapRes.data?.length ?? 0;
                  final pendCount = snapRes.data?.where((r) => r.estado == 'Pendiente').length ?? 0;

                  return ListView(
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      // Admin Greeting
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Bienvenido al panel,',
                                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                              ),
                              Text(
                                'ADMINISTRADOR',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent, size: 26),
                            onPressed: () {
                              // Standard logout alert
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF475569),
                                  title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
                                  content: const Text('¿Desea salir del panel de administración?', style: TextStyle(color: Color(0xFFE2E8F0))),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF94A3B8))),
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
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Metric summaries
                      Row(
                        children: [
                          _buildMetricCard('Agenda', '$resCount reserv.', const Color(0xFFD97706), Icons.calendar_month),
                          const SizedBox(width: 16),
                          _buildMetricCard('Pendientes', '$pendCount a rev.', Colors.blueAccent, Icons.feedback_outlined),
                        ],
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'MÓDULOS DE GESTIÓN',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Module buttons
                      _buildAdminButton(
                        context: context,
                        title: 'EMPLEADOS / FOTÓGRAFOS',
                        subtitle: 'Alta, baja y especialidad del personal ($fotCount registrados)',
                        icon: Icons.badge_outlined,
                        route: '/admin_empleados',
                        accent: const Color(0xFFD97706),
                      ),

                      _buildAdminButton(
                        context: context,
                        title: 'SERVICIOS Y ESTUDIOS',
                        subtitle: 'Configura tarifas de paquetes y salas físicas de fotografía',
                        icon: Icons.collections,
                        route: '/admin_servicios',
                        accent: Colors.blueGrey,
                      ),

                      _buildAdminButton(
                        context: context,
                        title: 'USUARIOS / CLIENTES',
                        subtitle: 'Control y vista detallada de clientes ($cliCount activos)',
                        icon: Icons.people_outline,
                        route: '/admin_usuarios',
                        accent: Colors.teal,
                      ),

                      _buildAdminButton(
                        context: context,
                        title: 'SESIONES Y FACTURACIÓN',
                        subtitle: 'Verificar agenda, cobrar sesiones y entregar fotos finales',
                        icon: Icons.photo_camera_back_outlined,
                        route: '/admin_sesiones',
                        accent: Colors.pinkAccent,
                      ),
                      
                      // Se removió el botón del menú lateral según la solicitud.
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF475569),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF475569),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
