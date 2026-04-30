import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelasPage extends StatefulWidget {
  const TelasPage({super.key});

  @override
  State<TelasPage> createState() => _TelasPageState();
}

class _TelasPageState extends State<TelasPage> {
  // Controladores para el formulario de agregar
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  // Referencia a la colección de Firestore
  final CollectionReference _telasCollection = FirebaseFirestore.instance.collection('telas');

  // --- CREAR ---
  Future<void> _agregarTela() async {
    final String nombre = _nombreController.text;
    final String tipo = _tipoController.text;
    final String color = _colorController.text;
    final int? precio = int.tryParse(_precioController.text);
    final int? stock = int.tryParse(_stockController.text);

    if (nombre.isNotEmpty && tipo.isNotEmpty && color.isNotEmpty && precio != null && stock != null) {
      try {
        await _telasCollection.add({
          'nombre': nombre,
          'tipo': tipo,
          'color': color,
          'precio': precio,
          'stock': stock,
        });
        // Limpiar los campos después de agregar
        _nombreController.clear();
        _tipoController.clear();
        _colorController.clear();
        _precioController.clear();
        _stockController.clear();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela agregada exitosamente.')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar: $e')),
        );
      }
    }
  }

  // --- ACTUALIZAR ---
  Future<void> _mostrarDialogoEditar(DocumentSnapshot doc) async {
    // Precargar los datos del documento en los controladores
    final data = doc.data() as Map<String, dynamic>;
    final TextEditingController nombreEdit = TextEditingController(text: data['nombre']);
    final TextEditingController tipoEdit = TextEditingController(text: data['tipo']);
    final TextEditingController colorEdit = TextEditingController(text: data['color']);
    final TextEditingController precioEdit = TextEditingController(text: data['precio'].toString());
    final TextEditingController stockEdit = TextEditingController(text: data['stock'].toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tela'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nombreEdit, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: tipoEdit, decoration: const InputDecoration(labelText: "Tipo")),
                TextField(controller: colorEdit, decoration: const InputDecoration(labelText: "Color")),
                TextField(controller: precioEdit, decoration: const InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
                TextField(controller: stockEdit, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
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
                 final int? precio = int.tryParse(precioEdit.text);
                 final int? stock = int.tryParse(stockEdit.text);
                 if (precio != null && stock != null) {
                   await doc.reference.update({
                     'nombre': nombreEdit.text,
                     'tipo': tipoEdit.text,
                     'color': colorEdit.text,
                     'precio': precio,
                     'stock': stock,
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
  Future<void> _eliminarTela(String docId) async {
    await _telasCollection.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD de Telas"),
      ),
      body: Column(
        children: [
          // Formulario para agregar nuevas telas
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(controller: _nombreController, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: _tipoController, decoration: const InputDecoration(labelText: "Tipo")),
                TextField(controller: _colorController, decoration: const InputDecoration(labelText: "Color")),
                TextField(controller: _precioController, decoration: const InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
                TextField(controller: _stockController, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _agregarTela, child: const Text("Agregar Tela"))
              ],
            ),
          ),
          // --- LEER (Lista de telas) ---
          Expanded(
            child: StreamBuilder(
              stream: _telasCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(data['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tipo: ${data['tipo']} - Stock: ${data['stock']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Text('\$${data['precio'] ?? 0}', style: TextStyle(color: Colors.green[700], fontSize: 16)),
                             const SizedBox(width: 8),
                            // Botón para editar
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _mostrarDialogoEditar(doc),
                            ),
                            // Botón para eliminar
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarTela(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
