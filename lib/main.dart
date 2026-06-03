import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'services_db.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Inicializar Firebase con credenciales reales ──────────────────────────
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    debugPrint('✅ Firebase conectado al proyecto: studio-mochi22px');

    // ── Registrar apertura de la app en Firestore ─────────────────────────
    // Cada vez que alguien abre la app, se guarda un documento en "accesos"
    await FirebaseFirestore.instance.collection('accesos').add({
      'tipo': 'apertura_app',
      'timestamp': FieldValue.serverTimestamp(),
      'plataforma': _getPlatformName(),
      'proyecto': 'studio-mochi22px',
      'version': '1.0.0',
    });
    debugPrint('📊 Apertura registrada en Firestore → colección: accesos');
  } catch (e) {
    debugPrint('⚠️ Firebase no disponible, usando modo Mock: $e');
  }

  // ── Inicializar servicios con el motor apropiado ──────────────────────────
  DatabaseService.instance.init(firebaseInitialized);
  AuthService.instance.setFirebaseMode(firebaseInitialized);

  runApp(const StudioMochiApp());
}

/// Detecta la plataforma actual para guardarlo en Firestore
String _getPlatformName() {
  if (kIsWeb) return 'Web';
  try {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
  } catch (_) {}
  return 'Web';
}


class StudioMochiApp extends StatelessWidget {
  const StudioMochiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studio Mochi 22px',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Slate Dark theme matching gray & deep slate/navy palette
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF334155),
        scaffoldBackgroundColor: const Color(0xFF334155),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD97706), // Premium Gold
          secondary: Color(0xFF64748B), // Slate Gray
          surface: Color(0xFF475569), // Sleek Card Navy / fondo principal
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Color(0xFFF8FAFC),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFFF8FAFC), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
          bodyMedium: TextStyle(color: Color(0xFF94A3B8)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF334155),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
