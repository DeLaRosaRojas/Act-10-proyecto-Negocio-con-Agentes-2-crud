import 'package:flutter/material.dart';
import 'telas_page.dart'; // Corregido
import 'usuarios_page.dart'; // Corregido

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Inicio'),
        automaticallyImplyLeading: false, // Oculta el botón de regreso
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOTÓN TELAS
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelasPage()),
                    );
                  },
                  child: const Text(
                    "CRUD Telas",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // BOTÓN USUARIOS
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UsuariosPage()),
                    );
                  },
                  child: const Text(
                    "CRUD Usuarios",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const Spacer(), // Empuja el siguiente botón hacia el fondo

              // BOTÓN CERRAR SESIÓN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Un color diferente para distinguirlo
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Navega a la pantalla de login y elimina todas las rutas anteriores
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: const Text(
                    "Cerrar Sesión",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Un poco de espacio al final
            ],
          ),
        ),
      ),
    );
  }
}
