import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController correo = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login() async {
    if (!mounted) return;
    try {
      var result = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: correo.text)
          .get();

      if (result.docs.isNotEmpty) {
        var user = result.docs.first.data();

        if (user['contraseña'] == password.text) {
          if (!mounted) return;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          mostrarError("Contraseña incorrecta");
        }
      } else {
        mostrarError("Usuario no encontrado");
      }
    } catch (e) {
      mostrarError("Error al iniciar sesión: $e");
    }
  }

  void mostrarError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Parisina")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: correo,
                decoration: const InputDecoration(labelText: "Correo")),
            TextField(
                controller: password,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Iniciar Sesión")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: const Text("Registrarse"),
            )
          ],
        ),
      ),
    );
  }
}