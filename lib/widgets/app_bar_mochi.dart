import 'package:flutter/material.dart';

class AppBarMochi extends StatelessWidget implements PreferredSizeWidget {
  final bool implicityLeading;
  final List<Widget>? actions;

  const AppBarMochi({
    super.key,
    this.implicityLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF334155), // Dark Navy
      elevation: 4,
      shadowColor: Colors.black38,
      automaticallyImplyLeading: implicityLeading,
      iconTheme: const IconThemeData(color: Color(0xFFE2E8F0)), // Cool grey/silver
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.camera_alt_outlined, color: Color(0xFFD97706), size: 22), // Gold accent
          SizedBox(width: 10),
          Text(
            'STUDIO MOCHI 22PX',
            style: TextStyle(
              color: Color(0xFFF8FAFC), // Off-white
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
