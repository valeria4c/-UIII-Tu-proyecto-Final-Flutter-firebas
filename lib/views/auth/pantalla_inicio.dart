import 'package:flutter/material.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155), // Blue-navy claro premium
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF334155),
              Color(0xFF475569),
              Color(0xFF334155),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing icon container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD97706).withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 100,
                    color: Color(0xFFD97706), // Accent gold/amber
                  ),
                ),
                const SizedBox(height: 32),
                // Premium Studio Title
                const Text(
                  'STUDIO MOCHI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: 4.0,
                  ),
                ),
                const Text(
                  '22PX',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD97706), // Gold subtitle
                    letterSpacing: 6.0,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fotografía Profesional • Retratos • Eventos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8), // Cool grey
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 64),
                // Clean Undertone Interactive Button
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/seleccion_rol'),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF475569),
                      border: Border.all(color: const Color(0xFFD97706), width: 1.5),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'INGRESAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF8FAFC),
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFD97706)),
                      ],
                    ),
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
