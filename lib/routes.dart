import 'package:flutter/material.dart';
import 'views/auth/pantalla_inicio.dart';
import 'views/auth/pantalla_seleccion_rol.dart';
import 'views/auth/pantalla_login_admin.dart';
import 'views/auth/pantalla_login_usuario.dart';
import 'views/auth/pantalla_registro_usuario.dart';
import 'views/usuario/pantalla_dashboard_usuario.dart';
import 'views/usuario/pantalla_mis_sesiones.dart';
import 'views/usuario/pantalla_mis_galerias.dart';
import 'views/usuario/pantalla_perfil_usuario.dart';
import 'views/usuario/pantalla_editar_informacion.dart';
import 'views/usuario/pantalla_configuracion.dart';
import 'views/admin/pantalla_menu_admin.dart';
import 'views/admin/pantalla_panel_inicio.dart';
import 'views/admin/pantalla_gestion_empleados.dart';
import 'views/admin/pantalla_gestion_servicios.dart';
import 'views/admin/pantalla_gestion_usuarios.dart';
import 'views/admin/pantalla_gestion_sesiones.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PantallaInicio());
      case '/seleccion_rol':
        return MaterialPageRoute(builder: (_) => const PantallaSeleccionRol());
      case '/login_admin':
        return MaterialPageRoute(builder: (_) => const PantallaLoginAdmin());
      case '/login_usuario':
        return MaterialPageRoute(builder: (_) => const PantallaLoginUsuario());
      case '/registro_usuario':
        return MaterialPageRoute(builder: (_) => const PantallaRegistroUsuario());
      case '/user_dashboard':
        return MaterialPageRoute(builder: (_) => const PantallaDashboardUsuario());
      case '/user_sesiones':
        return MaterialPageRoute(builder: (_) => const PantallaMisSesiones());
      case '/user_galerias':
        return MaterialPageRoute(builder: (_) => const PantallaMisGalerias());
      case '/user_perfil':
        return MaterialPageRoute(builder: (_) => const PantallaPerfilUsuario());
      case '/user_editar_info':
        return MaterialPageRoute(builder: (_) => const PantallaEditarInformacion());
      case '/user_configuracion':
        return MaterialPageRoute(builder: (_) => const PantallaConfiguracion());
      case '/admin_menu':
        return MaterialPageRoute(builder: (_) => const PantallaMenuAdmin());
      case '/admin_inicio':
        return MaterialPageRoute(builder: (_) => const PantallaPanelInicio());
      case '/admin_empleados':
        return MaterialPageRoute(builder: (_) => const PantallaGestionEmpleados());
      case '/admin_servicios':
        return MaterialPageRoute(builder: (_) => const PantallaGestionServicios());
      case '/admin_usuarios':
        return MaterialPageRoute(builder: (_) => const PantallaGestionUsuarios());
      case '/admin_sesiones':
        return MaterialPageRoute(builder: (_) => const PantallaGestionSesiones());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Ruta no encontrada',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
    }
  }
}
