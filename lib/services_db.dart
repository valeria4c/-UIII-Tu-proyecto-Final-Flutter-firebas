import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ==========================================
// MODELS FOR THE 10 DATABASE TABLES
// ==========================================

class Cliente {
  final String idCliente;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String fechaNacimiento;
  final DateTime fechaRegistro;
  final bool activo;

  Cliente({
    required this.idCliente,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.fechaRegistro,
    this.activo = true,
  });

  factory Cliente.fromMap(Map<String, dynamic> map, String id) {
    return Cliente(
      idCliente: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'] ?? '',
      fechaNacimiento: map['fecha_nacimiento'] ?? '',
      fechaRegistro: map['fecha_registro'] != null 
          ? (map['fecha_registro'] is Timestamp 
              ? (map['fecha_registro'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_registro'].toString()))
          : DateTime.now(),
      activo: map['activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento,
      'fecha_registro': fechaRegistro.toIso8601String(),
      'activo': activo,
    };
  }
}

class Fotografo {
  final String idFotografo;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String especialidad;
  final String fechaContrato;
  final bool activo;

  Fotografo({
    required this.idFotografo,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.especialidad,
    required this.fechaContrato,
    this.activo = true,
  });

  factory Fotografo.fromMap(Map<String, dynamic> map, String id) {
    return Fotografo(
      idFotografo: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'] ?? '',
      especialidad: map['especialidad'] ?? '',
      fechaContrato: map['fecha_contrato'] ?? '',
      activo: map['activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'especialidad': especialidad,
      'fecha_contrato': fechaContrato,
      'activo': activo,
    };
  }
}

class Estudio {
  final String idEstudio;
  final String nombre;
  final String descripcion;
  final int capacidadPersonas;
  final String colorFondo;
  final double areaM2;
  final bool disponible;

  Estudio({
    required this.idEstudio,
    required this.nombre,
    required this.descripcion,
    required this.capacidadPersonas,
    required this.colorFondo,
    required this.areaM2,
    this.disponible = true,
  });

  factory Estudio.fromMap(Map<String, dynamic> map, String id) {
    return Estudio(
      idEstudio: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      capacidadPersonas: map['capacidad_personas'] is int 
          ? map['capacidad_personas'] 
          : int.tryParse(map['capacidad_personas']?.toString() ?? '0') ?? 0,
      colorFondo: map['color_fondo'] ?? '',
      areaM2: map['area_m2'] is double 
          ? map['area_m2'] 
          : double.tryParse(map['area_m2']?.toString() ?? '0.0') ?? 0.0,
      disponible: map['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'capacidad_personas': capacidadPersonas,
      'color_fondo': colorFondo,
      'area_m2': areaM2,
      'disponible': disponible,
    };
  }
}

class Paquete {
  final String idPaquete;
  final String nombre;
  final String descripcion;
  final int numFotosIncluidas;
  final int duracionMinutos;
  final double precio;
  final bool activo;

  Paquete({
    required this.idPaquete,
    required this.nombre,
    required this.descripcion,
    required this.numFotosIncluidas,
    required this.duracionMinutos,
    required this.precio,
    this.activo = true,
  });

  factory Paquete.fromMap(Map<String, dynamic> map, String id) {
    return Paquete(
      idPaquete: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      numFotosIncluidas: map['num_fotos_incluidas'] is int 
          ? map['num_fotos_incluidas'] 
          : int.tryParse(map['num_fotos_incluidas']?.toString() ?? '0') ?? 0,
      duracionMinutos: map['duracion_minutos'] is int 
          ? map['duracion_minutos'] 
          : int.tryParse(map['duracion_minutos']?.toString() ?? '0') ?? 0,
      precio: map['precio'] is double 
          ? map['precio'] 
          : double.tryParse(map['precio']?.toString() ?? '0.0') ?? 0.0,
      activo: map['activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'num_fotos_incluidas': numFotosIncluidas,
      'duracion_minutos': duracionMinutos,
      'precio': precio,
      'activo': activo,
    };
  }
}

class Reservacion {
  final String idReservacion;
  final String idCliente;
  final String idPaquete;
  final String idEstudio;
  final String idFotografo;
  final DateTime fechaHora;
  final String estado; // Pendiente, Confirmada, Cancelada, Completada
  final String canalOrigen;
  final String notas;
  final DateTime creadaEn;

  Reservacion({
    required this.idReservacion,
    required this.idCliente,
    required this.idPaquete,
    required this.idEstudio,
    required this.idFotografo,
    required this.fechaHora,
    this.estado = 'Pendiente',
    this.canalOrigen = 'App Móvil',
    this.notas = '',
    required this.creadaEn,
  });

  factory Reservacion.fromMap(Map<String, dynamic> map, String id) {
    return Reservacion(
      idReservacion: id,
      idCliente: map['id_cliente'] ?? '',
      idPaquete: map['id_paquete'] ?? '',
      idEstudio: map['id_estudio'] ?? '',
      idFotografo: map['id_fotografo'] ?? '',
      fechaHora: map['fecha_hora'] != null 
          ? (map['fecha_hora'] is Timestamp 
              ? (map['fecha_hora'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_hora'].toString()))
          : DateTime.now(),
      estado: map['estado'] ?? 'Pendiente',
      canalOrigen: map['canal_origen'] ?? 'App Móvil',
      notas: map['notas'] ?? '',
      creadaEn: map['creada_en'] != null 
          ? (map['creada_en'] is Timestamp 
              ? (map['creada_en'] as Timestamp).toDate() 
              : DateTime.parse(map['creada_en'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'id_paquete': idPaquete,
      'id_estudio': idEstudio,
      'id_fotografo': idFotografo,
      'fecha_hora': fechaHora.toIso8601String(),
      'estado': estado,
      'canal_origen': canalOrigen,
      'notas': notesSanitized(notas),
      'creada_en': creadaEn.toIso8601String(),
    };
  }

  static String notesSanitized(String notes) => notes;
}

class Sesion {
  final String idSesion;
  final String idReservacion;
  final DateTime fechaHoraInicio;
  final DateTime? fechaHoraFin;
  final String estado; // En curso, Finalizada, Post-procesamiento
  final int numFotosTomadas;
  final String observaciones;

  Sesion({
    required this.idSesion,
    required this.idReservacion,
    required this.fechaHoraInicio,
    this.fechaHoraFin,
    this.estado = 'En curso',
    this.numFotosTomadas = 0,
    this.observaciones = '',
  });

  factory Sesion.fromMap(Map<String, dynamic> map, String id) {
    return Sesion(
      idSesion: id,
      idReservacion: map['id_reservacion'] ?? '',
      fechaHoraInicio: map['fecha_hora_inicio'] != null 
          ? (map['fecha_hora_inicio'] is Timestamp 
              ? (map['fecha_hora_inicio'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_hora_inicio'].toString()))
          : DateTime.now(),
      fechaHoraFin: map['fecha_hora_fin'] != null 
          ? (map['fecha_hora_fin'] is Timestamp 
              ? (map['fecha_hora_fin'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_hora_fin'].toString()))
          : null,
      estado: map['estado'] ?? 'En curso',
      numFotosTomadas: map['num_fotos_tomadas'] is int 
          ? map['num_fotos_tomadas'] 
          : int.tryParse(map['num_fotos_tomadas']?.toString() ?? '0') ?? 0,
      observaciones: map['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_reservacion': idReservacion,
      'fecha_hora_inicio': fechaHoraInicio.toIso8601String(),
      'fecha_hora_fin': fechaHoraFin?.toIso8601String(),
      'estado': estado,
      'num_fotos_tomadas': numFotosTomadas,
      'observaciones': observaciones,
    };
  }
}

class Equipo {
  final String idEquipo;
  final String idEstudio;
  final String nombre;
  final String tipo; // Cámara, Lente, Iluminación, Accesorio, Otro
  final String marca;
  final String modelo;
  final String numSerie;
  final String estado; // Operativo, Mantenimiento, Damado, Baja
  final String fechaAdquisicion;
  final String ultimaRevision;

  Equipo({
    required this.idEquipo,
    required this.idEstudio,
    required this.nombre,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.numSerie,
    required this.estado,
    required this.fechaAdquisicion,
    required this.ultimaRevision,
  });

  factory Equipo.fromMap(Map<String, dynamic> map, String id) {
    return Equipo(
      idEquipo: id,
      idEstudio: map['id_estudio'] ?? '',
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? 'Cámara',
      marca: map['marca'] ?? '',
      modelo: map['modelo'] ?? '',
      numSerie: map['num_serie'] ?? '',
      estado: map['estado'] ?? 'Operativo',
      fechaAdquisicion: map['fecha_adquisicion'] ?? '',
      ultimaRevision: map['ultima_revision'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_estudio': idEstudio,
      'nombre': nombre,
      'tipo': tipo,
      'marca': marca,
      'modelo': modelo,
      'num_serie': numSerie,
      'estado': estado,
      'fecha_adquisicion': fechaAdquisicion,
      'ultima_revision': ultimaRevision,
    };
  }
}

class Pedido {
  final String idPedido;
  final String idSesion;
  final double subtotal;
  final double descuento;
  final double total;
  final String estadoPago; // Pendiente, Parcial, Pagado, Cancelado
  final DateTime fechaPedido;

  Pedido({
    required this.idPedido,
    required this.idSesion,
    required this.subtotal,
    this.descuento = 0.0,
    required this.total,
    this.estadoPago = 'Pendiente',
    required this.fechaPedido,
  });

  factory Pedido.fromMap(Map<String, dynamic> map, String id) {
    return Pedido(
      idPedido: id,
      idSesion: map['id_sesion'] ?? '',
      subtotal: map['subtotal'] is double 
          ? map['subtotal'] 
          : double.tryParse(map['subtotal']?.toString() ?? '0.0') ?? 0.0,
      descuento: map['descuento'] is double 
          ? map['descuento'] 
          : double.tryParse(map['descuento']?.toString() ?? '0.0') ?? 0.0,
      total: map['total'] is double 
          ? map['total'] 
          : double.tryParse(map['total']?.toString() ?? '0.0') ?? 0.0,
      estadoPago: map['estado_pago'] ?? 'Pendiente',
      fechaPedido: map['fecha_pedido'] != null 
          ? (map['fecha_pedido'] is Timestamp 
              ? (map['fecha_pedido'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_pedido'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_sesion': idSesion,
      'subtotal': subtotal,
      'descuento': descuento,
      'total': total,
      'estado_pago': estadoPago,
      'fecha_pedido': fechaPedido.toIso8601String(),
    };
  }
}

class ProductoFinal {
  final String idProducto;
  final String idPedido;
  final String tipo; // Digital, Impresión, Álbum, Enmarcado
  final String formato;
  final String dimensiones;
  final int cantidad;
  final double precioUnitario;
  final String urlArchivo;
  final String estadoEntrega; // Procesando, Listo, Entregado

  ProductoFinal({
    required this.idProducto,
    required this.idPedido,
    required this.tipo,
    required this.formato,
    required this.dimensiones,
    this.cantidad = 1,
    required this.precioUnitario,
    required this.urlArchivo,
    this.estadoEntrega = 'Procesando',
  });

  factory ProductoFinal.fromMap(Map<String, dynamic> map, String id) {
    return ProductoFinal(
      idProducto: id,
      idPedido: map['id_pedido'] ?? '',
      tipo: map['tipo'] ?? 'Digital',
      formato: map['formato'] ?? '',
      dimensiones: map['dimensiones'] ?? '',
      cantidad: map['cantidad'] is int 
          ? map['cantidad'] 
          : int.tryParse(map['cantidad']?.toString() ?? '1') ?? 1,
      precioUnitario: map['precio_unitario'] is double 
          ? map['precio_unitario'] 
          : double.tryParse(map['precio_unitario']?.toString() ?? '0.0') ?? 0.0,
      urlArchivo: map['url_archivo'] ?? '',
      estadoEntrega: map['estado_entrega'] ?? 'Procesando',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pedido': idPedido,
      'tipo': tipo,
      'formato': formato,
      'dimensiones': dimensiones,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'url_archivo': urlArchivo,
      'estado_entrega': estadoEntrega,
    };
  }
}

class Pago {
  final String idPago;
  final String idPedido;
  final double monto;
  final String metodoPago; // Efectivo, Tarjeta, Transferencia, Otro
  final String referencia;
  final DateTime fechaPago;
  final bool confirmado;

  Pago({
    required this.idPago,
    required this.idPedido,
    required this.monto,
    required this.metodoPago,
    this.referencia = '',
    required this.fechaPago,
    this.confirmado = false,
  });

  factory Pago.fromMap(Map<String, dynamic> map, String id) {
    return Pago(
      idPago: id,
      idPedido: map['id_pedido'] ?? '',
      monto: map['monto'] is double 
          ? map['monto'] 
          : double.tryParse(map['monto']?.toString() ?? '0.0') ?? 0.0,
      metodoPago: map['metodo_pago'] ?? 'Efectivo',
      referencia: map['referencia'] ?? '',
      fechaPago: map['fecha_pago'] != null 
          ? (map['fecha_pago'] is Timestamp 
              ? (map['fecha_pago'] as Timestamp).toDate() 
              : DateTime.parse(map['fecha_pago'].toString()))
          : DateTime.now(),
      confirmado: map['confirmado'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pedido': idPedido,
      'monto': monto,
      'metodo_pago': metodoPago,
      'referencia': referencia,
      'fecha_pago': fechaPago.toIso8601String(),
      'confirmado': confirmado,
    };
  }
}

// ==========================================
// CENTRAL SERVICES ENGINE (AUTH & DATABASE)
// ==========================================

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  bool _isFirebaseMode = false;
  String? _currentUserEmail;
  String? _currentUserId;
  String? _currentUserRole; // 'cliente' or 'admin'
  String? _currentUserName;

  bool get isFirebaseMode => _isFirebaseMode;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserId => _currentUserId;
  String? get currentUserRole => _currentUserRole;
  String? get currentUserName => _currentUserName;

  void setFirebaseMode(bool enabled) {
    _isFirebaseMode = enabled;
  }

  Future<bool> login(String email, String password, {String? employeeId}) async {
    if (_isFirebaseMode) {
      try {
        UserCredential creds = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _currentUserId = creds.user?.uid;
        _currentUserEmail = creds.user?.email;
        
        // Fetch role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('clientes').doc(_currentUserId).get();
        if (userDoc.exists) {
          _currentUserRole = 'cliente';
          _currentUserName = '${userDoc['nombre']} ${userDoc['apellido']}';
        } else {
          DocumentSnapshot fotografoDoc = await FirebaseFirestore.instance.collection('fotografos').doc(_currentUserId).get();
          if (fotografoDoc.exists || employeeId != null) {
            _currentUserRole = 'admin';
            _currentUserName = fotografoDoc.exists 
                ? '${fotografoDoc['nombre']} ${fotografoDoc['apellido']}'
                : 'Empleado Admin';
          } else {
            _currentUserRole = 'cliente'; // Default fallback
            _currentUserName = 'Usuario';
          }
        }

        // ── Registrar ingreso en Firestore ──────────────────────────────────
        // Cada login queda guardado en la colección 'accesos' de Firebase Console
        await FirebaseFirestore.instance.collection('accesos').add({
          'tipo': 'login',
          'uid': _currentUserId ?? 'desconocido',
          'email': _currentUserEmail ?? email,
          'rol': _currentUserRole ?? 'desconocido',
          'nombre': _currentUserName ?? 'Sin nombre',
          'timestamp': FieldValue.serverTimestamp(),
          'proyecto': 'studio-mochi22px',
        });
        debugPrint('📊 Login registrado en Firestore → uid: $_currentUserId | rol: $_currentUserRole');

        return true;
      } catch (e) {
        debugPrint('Firebase Login Error: $e');
        // Fall back to Mock login for testing convenience if Firebase fails
        return _loginMock(email, password, employeeId);
      }
    } else {
      return _loginMock(email, password, employeeId);
    }
  }

  /// Login con manejo de errores detallado para la pantalla de usuario/cliente.
  /// Distingue entre usuario no encontrado, contraseña incorrecta y otros errores.
  Future<void> loginWithError(
    String email,
    String password, {
    required VoidCallback onSuccess,
    required VoidCallback onUserNotFound,
    required VoidCallback onWrongPassword,
    required void Function(String message) onError,
    String? employeeId,
  }) async {
    if (_isFirebaseMode) {
      try {
        UserCredential creds = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _currentUserId = creds.user?.uid;
        _currentUserEmail = creds.user?.email;

        // Fetch role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('clientes').doc(_currentUserId).get();
        if (userDoc.exists) {
          _currentUserRole = 'cliente';
          _currentUserName = '${userDoc['nombre']} ${userDoc['apellido']}';
        } else {
          DocumentSnapshot fotografoDoc = await FirebaseFirestore.instance.collection('fotografos').doc(_currentUserId).get();
          if (fotografoDoc.exists || employeeId != null) {
            _currentUserRole = 'admin';
            _currentUserName = fotografoDoc.exists
                ? '${fotografoDoc['nombre']} ${fotografoDoc['apellido']}'
                : 'Empleado Admin';
          } else {
            _currentUserRole = 'cliente';
            _currentUserName = 'Usuario';
          }
        }

        await FirebaseFirestore.instance.collection('accesos').add({
          'tipo': 'login',
          'uid': _currentUserId ?? 'desconocido',
          'email': _currentUserEmail ?? email,
          'rol': _currentUserRole ?? 'desconocido',
          'nombre': _currentUserName ?? 'Sin nombre',
          'timestamp': FieldValue.serverTimestamp(),
          'proyecto': 'studio-mochi22px',
        });

        onSuccess();
      } on FirebaseAuthException catch (e) {
        debugPrint('FirebaseAuthException code: ${e.code}');
        switch (e.code) {
          case 'user-not-found':
          case 'invalid-email':
            onUserNotFound();
            break;
          case 'wrong-password':
          case 'invalid-credential':
            // 'invalid-credential' es el nuevo código en Firebase v9+
            // Intentamos verificar si el usuario existe para dar mensaje correcto
            try {
              // ignore: deprecated_member_use
              final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
              if (methods.isEmpty) {
                onUserNotFound();
              } else {
                onWrongPassword();
              }
            } catch (_) {
              onWrongPassword();
            }
            break;
          case 'user-disabled':
            onError('Esta cuenta ha sido deshabilitada. Contacta al administrador.');
            break;
          case 'too-many-requests':
            onError('Demasiados intentos fallidos. Espera unos minutos e intenta de nuevo.');
            break;
          default:
            onError('Correo o contraseña incorrectos.');
        }
      } catch (e) {
        debugPrint('Login Error: $e');
        // Si Firebase falla por conexión, usamos mock
        _loginMock(email, password, employeeId);
        onSuccess();
      }
    } else {
      // Modo mock: siempre exitoso
      _loginMock(email, password, employeeId);
      onSuccess();
    }
  }

  bool _loginMock(String email, String password, String? employeeId) {
    _currentUserEmail = email;
    if (employeeId != null || email.toLowerCase().contains('admin') || email.toLowerCase().contains('empleado')) {
      _currentUserRole = 'admin';
      _currentUserId = 'mock_admin_123';
      _currentUserName = 'Administrador Mochi';
    } else {
      _currentUserRole = 'cliente';
      // Find client in mocks or create dynamic client id
      _currentUserId = 'mock_client_${email.hashCode}';
      _currentUserName = 'Cliente Mochi';
    }

    // ── Intentar registrar en Firestore aunque sea modo Mock ────────────────
    // Si Firebase sí está inicializado, el registro igual se guarda
    try {
      FirebaseFirestore.instance.collection('accesos').add({
        'tipo': 'login_mock',
        'uid': _currentUserId ?? 'mock',
        'email': email,
        'rol': _currentUserRole ?? 'desconocido',
        'nombre': _currentUserName ?? 'Sin nombre',
        'timestamp': FieldValue.serverTimestamp(),
        'proyecto': 'studio-mochi22px',
      });
      debugPrint('📊 Login Mock registrado en Firestore → email: $email');
    } catch (_) {
      // Firebase no disponible en modo mock puro — OK
    }

    return true;
  }

  Future<bool> registerCliente(String nombre, String apellido, String email, String password, String telefono) async {
    if (_isFirebaseMode) {
      try {
        UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = creds.user!.uid;
        _currentUserId = uid;
        _currentUserEmail = email;
        _currentUserRole = 'cliente';
        _currentUserName = '$nombre $apellido';

        Cliente newCliente = Cliente(
          idCliente: uid,
          nombre: nombre,
          apellido: apellido,
          email: email,
          telefono: telefono,
          fechaNacimiento: '1995-01-01',
          fechaRegistro: DateTime.now(),
        );

        await FirebaseFirestore.instance.collection('clientes').doc(uid).set(newCliente.toMap());
        // Also save in local DB engine
        await DatabaseService.instance.createCliente(newCliente);
        return true;
      } catch (e) {
        debugPrint('Firebase Register Error: $e');
        return _registerMock(nombre, apellido, email, telefono);
      }
    } else {
      return _registerMock(nombre, apellido, email, telefono);
    }
  }

  Future<bool> _registerMock(String nombre, String apellido, String email, String telefono) async {
    String uid = 'mock_client_${email.hashCode}';
    _currentUserId = uid;
    _currentUserEmail = email;
    _currentUserRole = 'cliente';
    _currentUserName = '$nombre $apellido';

    Cliente mockCli = Cliente(
      idCliente: uid,
      nombre: nombre,
      apellido: apellido,
      email: email,
      telefono: telefono,
      fechaNacimiento: '2000-01-01',
      fechaRegistro: DateTime.now(),
    );

    await DatabaseService.instance.createCliente(mockCli);
    return true;
  }

  Future<void> logout() async {
    if (_isFirebaseMode) {
      await FirebaseAuth.instance.signOut();
    }
    _currentUserId = null;
    _currentUserEmail = null;
    _currentUserRole = null;
    _currentUserName = null;
  }

  Future<void> updateProfile(String nombre, String apellido, String telefono, String email) async {
    if (_currentUserId == null) return;
    _currentUserName = '$nombre $apellido';
    _currentUserEmail = email;

    if (_isFirebaseMode && !_currentUserId!.startsWith('mock_')) {
      try {
        await FirebaseFirestore.instance.collection('clientes').doc(_currentUserId).update({
          'nombre': nombre,
          'apellido': apellido,
          'telefono': telefono,
          'email': email,
        });
      } catch (e) {
        debugPrint('Error updating Firestore profile: $e');
      }
    }

    // Update in local database engine anyway
    Cliente updated = Cliente(
      idCliente: _currentUserId!,
      nombre: nombre,
      apellido: apellido,
      email: email,
      telefono: telefono,
      fechaNacimiento: '1995-01-01',
      fechaRegistro: DateTime.now(),
    );
    await DatabaseService.instance.createCliente(updated); // Updates in Mock maps
  }
}

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  bool _isFirebaseMode = false;
  
  // Local Mock Databases (Reactive streams emulation via StreamControllers)
  final Map<String, Cliente> _mockClientes = {};
  final Map<String, Fotografo> _mockFotografos = {};
  final Map<String, Estudio> _mockEstudios = {};
  final Map<String, Paquete> _mockPaquetes = {};
  final Map<String, Reservacion> _mockReservaciones = {};
  final Map<String, Sesion> _mockSesiones = {};
  final Map<String, Equipo> _mockEquipos = {};
  final Map<String, Pedido> _mockPedidos = {};
  final Map<String, ProductoFinal> _mockProductosFinales = {};
  final Map<String, Pago> _mockPagos = {};

  // StreamControllers for live updates in UI
  final _clientesStream = StreamController<List<Cliente>>.broadcast();
  final _fotografosStream = StreamController<List<Fotografo>>.broadcast();
  final _estudiosStream = StreamController<List<Estudio>>.broadcast();
  final _paquetesStream = StreamController<List<Paquete>>.broadcast();
  final _reservacionesStream = StreamController<List<Reservacion>>.broadcast();
  final _sesionesStream = StreamController<List<Sesion>>.broadcast();
  final _equiposStream = StreamController<List<Equipo>>.broadcast();
  final _pedidosStream = StreamController<List<Pedido>>.broadcast();
  final _productosFinalesStream = StreamController<List<ProductoFinal>>.broadcast();
  final _pagosStream = StreamController<List<Pago>>.broadcast();

  void init(bool firebaseEnabled) {
    _isFirebaseMode = firebaseEnabled;
    _populateInitialMocks();
    _triggerStreams();
  }

  void _triggerStreams() {
    _clientesStream.add(_mockClientes.values.toList());
    _fotografosStream.add(_mockFotografos.values.toList());
    _estudiosStream.add(_mockEstudios.values.toList());
    _paquetesStream.add(_mockPaquetes.values.toList());
    _reservacionesStream.add(_mockReservaciones.values.toList());
    _sesionesStream.add(_mockSesiones.values.toList());
    _equiposStream.add(_mockEquipos.values.toList());
    _pedidosStream.add(_mockPedidos.values.toList());
    _productosFinalesStream.add(_mockProductosFinales.values.toList());
    _pagosStream.add(_mockPagos.values.toList());
  }

  void _populateInitialMocks() {
    // 1. Clientes
    _mockClientes['client1'] = Cliente(
      idCliente: 'client1',
      nombre: 'Juan',
      apellido: 'Pérez',
      email: 'juan@mochi.com',
      telefono: '555-123-4567',
      fechaNacimiento: '1990-05-15',
      fechaRegistro: DateTime.now().subtract(const Duration(days: 30)),
    );
    _mockClientes['client2'] = Cliente(
      idCliente: 'client2',
      nombre: 'María',
      apellido: 'Rodríguez',
      email: 'maria@gmail.com',
      telefono: '555-987-6543',
      fechaNacimiento: '1994-08-22',
      fechaRegistro: DateTime.now().subtract(const Duration(days: 15)),
    );

    // 2. Fotografos
    _mockFotografos['f1'] = Fotografo(
      idFotografo: 'f1',
      nombre: 'Alejandro',
      apellido: 'Ruiz',
      email: 'alejandro@mochi.com',
      telefono: '555-222-1111',
      especialidad: 'Retrato y Moda',
      fechaContrato: '2023-01-10',
    );
    _mockFotografos['f2'] = Fotografo(
      idFotografo: 'f2',
      nombre: 'Fernanda',
      apellido: 'Gómez',
      email: 'fernanda@mochi.com',
      telefono: '555-333-2222',
      especialidad: 'Bodas y Eventos',
      fechaContrato: '2022-06-15',
    );
    _mockFotografos['f3'] = Fotografo(
      idFotografo: 'f3',
      nombre: 'Carlos',
      apellido: 'Sosa',
      email: 'carlos@mochi.com',
      telefono: '555-444-3333',
      especialidad: 'Producto Comercial',
      fechaContrato: '2024-02-01',
    );

    // 3. Estudios
    _mockEstudios['e1'] = Estudio(
      idEstudio: 'e1',
      nombre: 'Estudio Luz Natural',
      descripcion: 'Estudio de 45m2 con ventanales de piso a techo orientados al norte. Ideal para retratos artísticos y moda.',
      capacidadPersonas: 6,
      colorFondo: 'Blanco / Gris Claro',
      areaM2: 45.0,
    );
    _mockEstudios['e2'] = Estudio(
      idEstudio: 'e2',
      nombre: 'Estudio Creativo Croma',
      descripcion: 'Espacio cerrado con ciclorama verde croma y negro de alta absorción. Sistema de iluminación inteligente DMX.',
      capacidadPersonas: 8,
      colorFondo: 'Croma Verde / Negro',
      areaM2: 60.0,
    );

    // 4. Paquetes
    _mockPaquetes['p1'] = Paquete(
      idPaquete: 'p1',
      nombre: 'Sesión Familiar Oro',
      descripcion: '1 hora de sesión en estudio, 25 fotografías digitales editadas en alta resolución, 2 cambios de ropa, entrega en 5 días.',
      numFotosIncluidas: 25,
      duracionMinutos: 60,
      precio: 1500.0,
    );
    _mockPaquetes['p2'] = Paquete(
      idPaquete: 'p2',
      nombre: 'XV Años Premium',
      descripcion: '3 horas de sesión, locación y estudio, 80 fotografías editadas, fotolibro impreso de 20 páginas, maquillaje básico incluido.',
      numFotosIncluidas: 80,
      duracionMinutos: 180,
      precio: 4500.0,
    );
    _mockPaquetes['p3'] = Paquete(
      idPaquete: 'p3',
      nombre: 'Corporativo Profesional',
      descripcion: '30 minutos de sesión de retrato corporativo, 5 retratos ejecutivos retocados con fondo gris, ideales para LinkedIn y currículum.',
      numFotosIncluidas: 5,
      duracionMinutos: 30,
      precio: 850.0,
    );
    _mockPaquetes['p4'] = Paquete(
      idPaquete: 'p4',
      nombre: 'Paquete Boda de Ensueño',
      descripcion: 'Cobertura completa de ceremonia y fiesta (hasta 8 horas), foto + video cinematográfico, entrega en galería digital premium.',
      numFotosIncluidas: 300,
      duracionMinutos: 480,
      precio: 12000.0,
    );

    // 5. Reservaciones
    _mockReservaciones['res1'] = Reservacion(
      idReservacion: 'res1',
      idCliente: 'client1',
      idPaquete: 'p1',
      idEstudio: 'e1',
      idFotografo: 'f1',
      fechaHora: DateTime.now().add(const Duration(days: 1, hours: 2)),
      estado: 'Confirmada',
      canalOrigen: 'App Móvil',
      notas: 'Desean fotos principalmente con temática otoñal.',
      creadaEn: DateTime.now().subtract(const Duration(days: 2)),
    );
    _mockReservaciones['res2'] = Reservacion(
      idReservacion: 'res2',
      idCliente: 'client2',
      idPaquete: 'p2',
      idEstudio: 'e2',
      idFotografo: 'f2',
      fechaHora: DateTime.now().subtract(const Duration(days: 1)),
      estado: 'Completada',
      canalOrigen: 'Sitio Web',
      notas: 'Sesión completada satisfactoriamente ayer.',
      creadaEn: DateTime.now().subtract(const Duration(days: 10)),
    );
    _mockReservaciones['res3'] = Reservacion(
      idReservacion: 'res3',
      idCliente: 'client1',
      idPaquete: 'p4',
      idEstudio: 'e1',
      idFotografo: 'f2',
      fechaHora: DateTime.now().add(const Duration(days: 15)),
      estado: 'Pendiente',
      canalOrigen: 'Llamada Telefónica',
      notas: 'Reservación para ceremonia de boda civil.',
      creadaEn: DateTime.now(),
    );

    // 6. Sesiones
    _mockSesiones['ses1'] = Sesion(
      idSesion: 'ses1',
      idReservacion: 'res2',
      fechaHoraInicio: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      fechaHoraFin: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      estado: 'Finalizada',
      numFotosTomadas: 145,
      observaciones: 'Todas las poses de XV años salieron muy bien. Iluminación estable.',
    );

    // 7. Equipos
    _mockEquipos['eq1'] = Equipo(
      idEquipo: 'eq1',
      idEstudio: 'e1',
      nombre: 'Sony Alpha 7IV',
      tipo: 'Cámara',
      marca: 'Sony',
      modelo: 'A7 IV',
      numSerie: 'SONY-A74-90802',
      estado: 'Operativo',
      fechaAdquisicion: '2022-11-20',
      ultimaRevision: '2024-04-15',
    );
    _mockEquipos['eq2'] = Equipo(
      idEquipo: 'eq2',
      idEstudio: 'e1',
      nombre: 'Lente Sony 24-70mm f2.8 GMaster II',
      tipo: 'Lente',
      marca: 'Sony',
      modelo: 'FE 24-70 GM2',
      numSerie: 'SONY-GM-30291',
      estado: 'Operativo',
      fechaAdquisicion: '2023-01-15',
      ultimaRevision: '2024-04-15',
    );
    _mockEquipos['eq3'] = Equipo(
      idEquipo: 'eq3',
      idEstudio: 'e2',
      nombre: 'Flash de Estudio Profoto D2 1000 AirTTL',
      tipo: 'Iluminación',
      marca: 'Profoto',
      modelo: 'D2 1000W',
      numSerie: 'PROFOTO-D2-48201',
      estado: 'Operativo',
      fechaAdquisicion: '2021-08-10',
      ultimaRevision: '2024-01-20',
    );

    // 8. Pedidos
    _mockPedidos['ped1'] = Pedido(
      idPedido: 'ped1',
      idSesion: 'ses1',
      subtotal: 4500.0,
      descuento: 500.0,
      total: 4000.0,
      estadoPago: 'Pagado',
      fechaPedido: DateTime.now().subtract(const Duration(days: 1)),
    );

    // 9. Productos Finales (Galerías / Entregables)
    _mockProductosFinales['prod1'] = ProductoFinal(
      idProducto: 'prod1',
      idPedido: 'ped1',
      tipo: 'Digital',
      formato: 'JPG / RAW',
      dimensiones: '6000 x 4000 px',
      cantidad: 1,
      precioUnitario: 4000.0,
      urlArchivo: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=600',
      estadoEntrega: 'Listo',
    );
    _mockProductosFinales['prod2'] = ProductoFinal(
      idProducto: 'prod2',
      idPedido: 'ped1',
      tipo: 'Impresión',
      formato: 'Papel Fotográfico Mate',
      dimensiones: '8x10 pulgadas',
      cantidad: 5,
      precioUnitario: 0.0,
      urlArchivo: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=600',
      estadoEntrega: 'Entregado',
    );

    // 10. Pagos
    _mockPagos['pag1'] = Pago(
      idPago: 'pag1',
      idPedido: 'ped1',
      monto: 4000.0,
      metodoPago: 'Tarjeta',
      referencia: 'TXN-908127390',
      fechaPago: DateTime.now().subtract(const Duration(days: 1)),
      confirmado: true,
    );
  }

  // ==========================================
  // READ API (STREAMS FOR LIVE UI UPDATE)
  // ==========================================

  Stream<List<Cliente>> streamClientes() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('clientes').snapshots().map((snap) =>
          snap.docs.map((doc) => Cliente.fromMap(doc.data(), doc.id)).toList());
    }
    return _clientesStream.stream;
  }

  Stream<List<Fotografo>> streamFotografos() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('fotografos').snapshots().map((snap) =>
          snap.docs.map((doc) => Fotografo.fromMap(doc.data(), doc.id)).toList());
    }
    return _fotografosStream.stream;
  }

  Stream<List<Estudio>> streamEstudios() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('estudios').snapshots().map((snap) =>
          snap.docs.map((doc) => Estudio.fromMap(doc.data(), doc.id)).toList());
    }
    return _estudiosStream.stream;
  }

  Stream<List<Paquete>> streamPaquetes() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('paquetes').snapshots().map((snap) =>
          snap.docs.map((doc) => Paquete.fromMap(doc.data(), doc.id)).toList());
    }
    return _paquetesStream.stream;
  }

  Stream<List<Reservacion>> streamReservaciones() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('reservaciones').snapshots().map((snap) =>
          snap.docs.map((doc) => Reservacion.fromMap(doc.data(), doc.id)).toList());
    }
    return _reservacionesStream.stream;
  }

  Stream<List<Sesion>> streamSesiones() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('sesiones').snapshots().map((snap) =>
          snap.docs.map((doc) => Sesion.fromMap(doc.data(), doc.id)).toList());
    }
    return _sesionesStream.stream;
  }

  Stream<List<Equipo>> streamEquipos() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('equipos').snapshots().map((snap) =>
          snap.docs.map((doc) => Equipo.fromMap(doc.data(), doc.id)).toList());
    }
    return _equiposStream.stream;
  }

  Stream<List<Pedido>> streamPedidos() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('pedidos').snapshots().map((snap) =>
          snap.docs.map((doc) => Pedido.fromMap(doc.data(), doc.id)).toList());
    }
    return _pedidosStream.stream;
  }

  Stream<List<ProductoFinal>> streamProductosFinales() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('productos_finales').snapshots().map((snap) =>
          snap.docs.map((doc) => ProductoFinal.fromMap(doc.data(), doc.id)).toList());
    }
    return _productosFinalesStream.stream;
  }

  Stream<List<Pago>> streamPagos() {
    if (_isFirebaseMode) {
      return FirebaseFirestore.instance.collection('pagos').snapshots().map((snap) =>
          snap.docs.map((doc) => Pago.fromMap(doc.data(), doc.id)).toList());
    }
    return _pagosStream.stream;
  }

  // ==========================================
  // WRITE API (CRUD OPERATIONS)
  // ==========================================

  // --- CLIENTE ---
  Future<void> createCliente(Cliente cliente) async {
    if (_isFirebaseMode && !cliente.idCliente.startsWith('mock_')) {
      await FirebaseFirestore.instance.collection('clientes').doc(cliente.idCliente).set(cliente.toMap());
    }
    _mockClientes[cliente.idCliente] = cliente;
    _clientesStream.add(_mockClientes.values.toList());
  }

  Future<void> deleteCliente(String id) async {
    if (_isFirebaseMode && !id.startsWith('mock_')) {
      await FirebaseFirestore.instance.collection('clientes').doc(id).delete();
    }
    _mockClientes.remove(id);
    _clientesStream.add(_mockClientes.values.toList());
  }

  // --- FOTOGRAFO ---
  Future<void> saveFotografo(Fotografo fotografo) async {
    String id = fotografo.idFotografo.isEmpty ? 'f_${DateTime.now().millisecondsSinceEpoch}' : fotografo.idFotografo;
    Fotografo updated = Fotografo(
      idFotografo: id,
      nombre: fotografo.nombre,
      apellido: fotografo.apellido,
      email: fotografo.email,
      telefono: fotografo.telefono,
      especialidad: fotografo.especialidad,
      fechaContrato: fotografo.fechaContrato,
      activo: fotografo.activo,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('fotografos').doc(id).set(updated.toMap());
    }
    _mockFotografos[id] = updated;
    _fotografosStream.add(_mockFotografos.values.toList());
  }

  Future<void> deleteFotografo(String id) async {
    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('fotografos').doc(id).delete();
    }
    _mockFotografos.remove(id);
    _fotografosStream.add(_mockFotografos.values.toList());
  }

  // --- ESTUDIO ---
  Future<void> saveEstudio(Estudio estudio) async {
    String id = estudio.idEstudio.isEmpty ? 'e_${DateTime.now().millisecondsSinceEpoch}' : estudio.idEstudio;
    Estudio updated = Estudio(
      idEstudio: id,
      nombre: estudio.nombre,
      descripcion: estudio.descripcion,
      capacidadPersonas: estudio.capacidadPersonas,
      colorFondo: estudio.colorFondo,
      areaM2: estudio.areaM2,
      disponible: estudio.disponible,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('estudios').doc(id).set(updated.toMap());
    }
    _mockEstudios[id] = updated;
    _estudiosStream.add(_mockEstudios.values.toList());
  }

  Future<void> deleteEstudio(String id) async {
    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('estudios').doc(id).delete();
    }
    _mockEstudios.remove(id);
    _estudiosStream.add(_mockEstudios.values.toList());
  }

  // --- PAQUETE ---
  Future<void> savePaquete(Paquete paquete) async {
    String id = paquete.idPaquete.isEmpty ? 'p_${DateTime.now().millisecondsSinceEpoch}' : paquete.idPaquete;
    Paquete updated = Paquete(
      idPaquete: id,
      nombre: paquete.nombre,
      descripcion: paquete.descripcion,
      numFotosIncluidas: paquete.numFotosIncluidas,
      duracionMinutos: paquete.duracionMinutos,
      precio: paquete.precio,
      activo: paquete.activo,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('paquetes').doc(id).set(updated.toMap());
    }
    _mockPaquetes[id] = updated;
    _paquetesStream.add(_mockPaquetes.values.toList());
  }

  Future<void> deletePaquete(String id) async {
    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('paquetes').doc(id).delete();
    }
    _mockPaquetes.remove(id);
    _paquetesStream.add(_mockPaquetes.values.toList());
  }

  // --- RESERVACION ---
  Future<void> saveReservacion(Reservacion reservacion) async {
    String id = reservacion.idReservacion.isEmpty ? 'res_${DateTime.now().millisecondsSinceEpoch}' : reservacion.idReservacion;
    Reservacion updated = Reservacion(
      idReservacion: id,
      idCliente: reservacion.idCliente,
      idPaquete: reservacion.idPaquete,
      idEstudio: reservacion.idEstudio,
      idFotografo: reservacion.idFotografo,
      fechaHora: reservacion.fechaHora,
      estado: reservacion.estado,
      canalOrigen: reservacion.canalOrigen,
      notas: reservacion.notas,
      creadaEn: reservacion.creadaEn,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('reservaciones').doc(id).set(updated.toMap());
    }
    _mockReservaciones[id] = updated;
    _reservacionesStream.add(_mockReservaciones.values.toList());
  }

  Future<void> deleteReservacion(String id) async {
    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('reservaciones').doc(id).delete();
    }
    _mockReservaciones.remove(id);
    _reservacionesStream.add(_mockReservaciones.values.toList());
  }

  // --- SESION ---
  Future<void> saveSesion(Sesion sesion) async {
    String id = sesion.idSesion.isEmpty ? 'ses_${DateTime.now().millisecondsSinceEpoch}' : sesion.idSesion;
    Sesion updated = Sesion(
      idSesion: id,
      idReservacion: sesion.idReservacion,
      fechaHoraInicio: sesion.fechaHoraInicio,
      fechaHoraFin: sesion.fechaHoraFin,
      estado: sesion.estado,
      numFotosTomadas: sesion.numFotosTomadas,
      observaciones: sesion.observaciones,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('sesiones').doc(id).set(updated.toMap());
    }
    _mockSesiones[id] = updated;
    _sesionesStream.add(_mockSesiones.values.toList());
  }

  // --- EQUIPO ---
  Future<void> saveEquipo(Equipo equipo) async {
    String id = equipo.idEquipo.isEmpty ? 'eq_${DateTime.now().millisecondsSinceEpoch}' : equipo.idEquipo;
    Equipo updated = Equipo(
      idEquipo: id,
      idEstudio: equipo.idEstudio,
      nombre: equipo.nombre,
      tipo: equipo.tipo,
      marca: equipo.marca,
      modelo: equipo.modelo,
      numSerie: equipo.numSerie,
      estado: equipo.estado,
      fechaAdquisicion: equipo.fechaAdquisicion,
      ultimaRevision: equipo.ultimaRevision,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('equipos').doc(id).set(updated.toMap());
    }
    _mockEquipos[id] = updated;
    _equiposStream.add(_mockEquipos.values.toList());
  }

  Future<void> deleteEquipo(String id) async {
    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('equipos').doc(id).delete();
    }
    _mockEquipos.remove(id);
    _equiposStream.add(_mockEquipos.values.toList());
  }

  // --- PEDIDO ---
  Future<void> savePedido(Pedido pedido) async {
    String id = pedido.idPedido.isEmpty ? 'ped_${DateTime.now().millisecondsSinceEpoch}' : pedido.idPedido;
    Pedido updated = Pedido(
      idPedido: id,
      idSesion: pedido.idSesion,
      subtotal: pedido.subtotal,
      descuento: pedido.descuento,
      total: pedido.total,
      estadoPago: pedido.estadoPago,
      fechaPedido: pedido.fechaPedido,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('pedidos').doc(id).set(updated.toMap());
    }
    _mockPedidos[id] = updated;
    _pedidosStream.add(_mockPedidos.values.toList());
  }

  // --- PRODUCTO FINAL ---
  Future<void> saveProductoFinal(ProductoFinal pf) async {
    String id = pf.idProducto.isEmpty ? 'prod_${DateTime.now().millisecondsSinceEpoch}' : pf.idProducto;
    ProductoFinal updated = ProductoFinal(
      idProducto: id,
      idPedido: pf.idPedido,
      tipo: pf.tipo,
      formato: pf.formato,
      dimensiones: pf.dimensiones,
      cantidad: pf.cantidad,
      precioUnitario: pf.precioUnitario,
      urlArchivo: pf.urlArchivo,
      estadoEntrega: pf.estadoEntrega,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('productos_finales').doc(id).set(updated.toMap());
    }
    _mockProductosFinales[id] = updated;
    _productosFinalesStream.add(_mockProductosFinales.values.toList());
  }

  // --- PAGO ---
  Future<void> savePago(Pago pago) async {
    String id = pago.idPago.isEmpty ? 'pag_${DateTime.now().millisecondsSinceEpoch}' : pago.idPago;
    Pago updated = Pago(
      idPago: id,
      idPedido: pago.idPedido,
      monto: pago.monto,
      metodoPago: pago.metodoPago,
      referencia: pago.referencia,
      fechaPago: pago.fechaPago,
      confirmado: pago.confirmado,
    );

    if (_isFirebaseMode) {
      await FirebaseFirestore.instance.collection('pagos').doc(id).set(updated.toMap());
    }
    _mockPagos[id] = updated;
    _pagosStream.add(_mockPagos.values.toList());
  }
}
