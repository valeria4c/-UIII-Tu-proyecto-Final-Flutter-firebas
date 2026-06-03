// firebase_options.dart
// Generado para el proyecto: studio-mochi22px
// Project Number: 989807580886

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opciones de Firebase para el proyecto studio-mochi22px.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está disponible para esta plataforma.',
        );
    }
  }

  // ─── WEB ───────────────────────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD-9OKIF5lx9wottWSadPvM7rv1z_xGWLE',
    authDomain: 'studio-mochi22px.firebaseapp.com',
    databaseURL: 'https://studio-mochi22px-default-rtdb.firebaseio.com',
    projectId: 'studio-mochi22px',
    storageBucket: 'studio-mochi22px.firebasestorage.app',
    messagingSenderId: '989807580886',
    appId: '1:989807580886:web:a6a2cc1758afca0dee5b77',
    measurementId: 'G-H21347PMG1',
  );

  // ─── ANDROID ───────────────────────────────────────────────────────────────
  // Mismas credenciales del proyecto; para producción descarga google-services.json
  // desde Firebase Console → Configuración del proyecto → Android app.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-9OKIF5lx9wottWSadPvM7rv1z_xGWLE',
    authDomain: 'studio-mochi22px.firebaseapp.com',
    databaseURL: 'https://studio-mochi22px-default-rtdb.firebaseio.com',
    projectId: 'studio-mochi22px',
    storageBucket: 'studio-mochi22px.firebasestorage.app',
    messagingSenderId: '989807580886',
    appId: '1:989807580886:web:a6a2cc1758afca0dee5b77',
    measurementId: 'G-H21347PMG1',
  );

  // ─── iOS ───────────────────────────────────────────────────────────────────
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-9OKIF5lx9wottWSadPvM7rv1z_xGWLE',
    authDomain: 'studio-mochi22px.firebaseapp.com',
    databaseURL: 'https://studio-mochi22px-default-rtdb.firebaseio.com',
    projectId: 'studio-mochi22px',
    storageBucket: 'studio-mochi22px.firebasestorage.app',
    messagingSenderId: '989807580886',
    appId: '1:989807580886:web:a6a2cc1758afca0dee5b77',
    measurementId: 'G-H21347PMG1',
  );

  // ─── macOS ─────────────────────────────────────────────────────────────────
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-9OKIF5lx9wottWSadPvM7rv1z_xGWLE',
    authDomain: 'studio-mochi22px.firebaseapp.com',
    databaseURL: 'https://studio-mochi22px-default-rtdb.firebaseio.com',
    projectId: 'studio-mochi22px',
    storageBucket: 'studio-mochi22px.firebasestorage.app',
    messagingSenderId: '989807580886',
    appId: '1:989807580886:web:a6a2cc1758afca0dee5b77',
    measurementId: 'G-H21347PMG1',
  );

  // ─── Windows ───────────────────────────────────────────────────────────────
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-9OKIF5lx9wottWSadPvM7rv1z_xGWLE',
    authDomain: 'studio-mochi22px.firebaseapp.com',
    databaseURL: 'https://studio-mochi22px-default-rtdb.firebaseio.com',
    projectId: 'studio-mochi22px',
    storageBucket: 'studio-mochi22px.firebasestorage.app',
    messagingSenderId: '989807580886',
    appId: '1:989807580886:web:a6a2cc1758afca0dee5b77',
    measurementId: 'G-H21347PMG1',
  );
}
