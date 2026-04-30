import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController telefono = TextEditingController();

  Future<void> registrar() async {
    if (!mounted) return;
    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nombre': nombre.text,
        'correo': correo.text,
        'contraseña': password.text,
        'edad': int.parse(edad.text),
        'telefono': int.parse(telefono.text),
      });

      if (!mounted) return; // Esta comprobación ya existía y es correcta
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return; // ¡ESTA ES LA LÍNEA QUE FALTABA!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nombre,
                  decoration: const InputDecoration(labelText: "Nombre")),
              TextField(
                  controller: correo,
                  decoration: const InputDecoration(labelText: "Correo")),
              TextField(
                  controller: password,
                  decoration: const InputDecoration(labelText: "Contraseña")),
              TextField(
                  controller: edad, decoration: const InputDecoration(labelText: "Edad")),
              TextField(
                  controller: telefono,
                  decoration: const InputDecoration(labelText: "Teléfono")),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: registrar, child: const Text("Registrar")),
            ],
          ),
        ),
      ),
    );
  }
}
