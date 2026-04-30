import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'telas_page.dart';
import 'usuarios_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el tema claro por defecto como una base segura y estable
    final ThemeData baseTheme = ThemeData.light();
    final Color primaryColor = Colors.red[900]!; // Un rojo oscuro y elegante

    // Aplicamos solo los cambios específicos que pediste
    final ThemeData theme = baseTheme.copyWith(
      // Color de fondo de la app
      scaffoldBackgroundColor: Colors.white,
      
      // Tema para la barra de navegación
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Color para el título y los iconos en el AppBar
      ),
      
      // Tema para los botones principales
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Fondo del botón
          foregroundColor: Colors.white, // Texto del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Esto asegura que otros elementos (como el cursor y los bordes de los campos de texto)
      // también usen el nuevo color principal.
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor,
        secondary: primaryColor,
      ),
    );

    return MaterialApp(
      title: 'Ropa.cl',
      theme: theme, // Aplicamos el nuevo tema claro
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/telas': (context) => const TelasPage(),
        '/usuarios': (context) => const UsuariosPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
