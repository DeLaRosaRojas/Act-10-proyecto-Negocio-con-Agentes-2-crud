import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // Controladores para el formulario de agregar
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final CollectionReference _usuariosCollection = FirebaseFirestore.instance.collection('usuarios');

  // --- CREAR ---
  Future<void> _agregarUsuario() async {
    final String nombre = _nombreController.text;
    final String correo = _correoController.text;
    final String password = _passwordController.text;
    final int? edad = int.tryParse(_edadController.text);
    final int? telefono = int.tryParse(_telefonoController.text);

    if (nombre.isNotEmpty && correo.isNotEmpty && password.isNotEmpty && edad != null && telefono != null) {
      try {
        await _usuariosCollection.add({
          'nombre': nombre,
          'correo': correo,
          'contraseña': password,
          'edad': edad,
          'telefono': telefono,
        });

        _nombreController.clear();
        _correoController.clear();
        _passwordController.clear();
        _edadController.clear();
        _telefonoController.clear();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario agregado exitosamente.')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar usuario: $e')),
        );
      }
    } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos correctamente.')),
        );
    }
  }

  // --- ACTUALIZAR ---
  Future<void> _mostrarDialogoEditar(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    final TextEditingController nombreEdit = TextEditingController(text: data['nombre']);
    final TextEditingController correoEdit = TextEditingController(text: data['correo']);
    final TextEditingController passwordEdit = TextEditingController(text: data['contraseña']);
    final TextEditingController edadEdit = TextEditingController(text: data['edad'].toString());
    final TextEditingController telefonoEdit = TextEditingController(text: data['telefono'].toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nombreEdit, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: correoEdit, decoration: const InputDecoration(labelText: "Correo")),
                TextField(controller: passwordEdit, decoration: const InputDecoration(labelText: "Contraseña")),
                TextField(controller: edadEdit, decoration: const InputDecoration(labelText: "Edad"), keyboardType: TextInputType.number),
                TextField(controller: telefonoEdit, decoration: const InputDecoration(labelText: "Teléfono"), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Actualizar'),
              onPressed: () async {
                final int? edad = int.tryParse(edadEdit.text);
                final int? telefono = int.tryParse(telefonoEdit.text);
                if (nombreEdit.text.isNotEmpty && correoEdit.text.isNotEmpty && passwordEdit.text.isNotEmpty && edad != null && telefono != null) {
                   await doc.reference.update({
                     'nombre': nombreEdit.text,
                     'correo': correoEdit.text,
                     'contraseña': passwordEdit.text,
                     'edad': edad,
                     'telefono': telefono,
                   });
                   if (!mounted) return;
                   Navigator.of(context).pop();
                 }
              },
            ),
          ],
        );
      },
    );
  }

  // --- ELIMINAR ---
  Future<void> _eliminarUsuario(String docId) async {
    await _usuariosCollection.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administración de Usuarios"),
      ),
      body: Column(
        children: [
          // Formulario para agregar nuevos usuarios
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              runSpacing: 8.0,
              children: [
                TextField(controller: _nombreController, decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder())),
                TextField(controller: _correoController, decoration: const InputDecoration(labelText: "Correo", border: OutlineInputBorder())),
                TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()), obscureText: true),
                TextField(controller: _edadController, decoration: const InputDecoration(labelText: "Edad", border: OutlineInputBorder()), keyboardType: TextInputType.number),
                TextField(controller: _telefonoController, decoration: const InputDecoration(labelText: "Teléfono", border: OutlineInputBorder()), keyboardType: TextInputType.number),
                Center(
                  child: ElevatedButton(onPressed: _agregarUsuario, child: const Text("Agregar Usuario")),
                )
              ],
            ),
          ),
          const Divider(),
          // Lista de usuarios
          Expanded(
            child: StreamBuilder(
              stream: _usuariosCollection.orderBy('nombre').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay usuarios registrados."));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(data['nombre'] ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['correo'] ?? 'Sin correo'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _mostrarDialogoEditar(doc),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _eliminarUsuario(doc.id),
                              tooltip: 'Eliminar',
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
