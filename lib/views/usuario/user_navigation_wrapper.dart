import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';

class UserNavigationWrapper extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const UserNavigationWrapper({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(implicityLeading: false),
      body: Container(
        color: const Color(0xFF334155),
        child: body,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF475569), // Sleek Navy Slate
              selectedItemColor: const Color(0xFFD97706), // Gold Accent
              unselectedItemColor: const Color(0xFF94A3B8), // Metallic silver
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              elevation: 10,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.8),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.8),
              onTap: (index) {
                if (index == currentIndex) return;
                if (index == 0) Navigator.pushReplacementNamed(context, '/user_dashboard');
                if (index == 1) Navigator.pushReplacementNamed(context, '/user_sesiones');
                if (index == 2) Navigator.pushReplacementNamed(context, '/user_galerias');
                if (index == 3) Navigator.pushReplacementNamed(context, '/user_perfil');
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.camera_alt),
                  ),
                  label: 'INICIO',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.calendar_month),
                  ),
                  label: 'SESIONES',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.image),
                  ),
                  label: 'GALERÍA',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.person),
                  ),
                  label: 'PERFIL',
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF1E293B), // Dark slate matching the theme
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Text(
              'Por: Valeria Herrera Sanchez | 6-I CBTIS 128',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF94A3B8), // Slate 400
                fontSize: 10,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
