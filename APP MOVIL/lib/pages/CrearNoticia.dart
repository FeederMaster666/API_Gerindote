import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/NoticiasService.dart';

class AdminCrearNoticiaScreen extends StatefulWidget {
  const AdminCrearNoticiaScreen({Key? key}) : super(key: key);

  @override
  State<AdminCrearNoticiaScreen> createState() => _AdminCrearNoticiaScreenState();
}

class _AdminCrearNoticiaScreenState extends State<AdminCrearNoticiaScreen> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final enlaceController = TextEditingController();
  final fechaController = TextEditingController();

  File? _imagenPortada;
  bool _isLoading = false;

  final NoticiasService _noticiasService = NoticiasService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Crear Noticia",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          const SizedBox(height: 16),
          // Selector de foto de portada
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent.shade100,
                    backgroundImage: _imagenPortada != null ? FileImage(_imagenPortada!) : null,
                    child: _imagenPortada == null
                        ? Icon(Icons.add, size: 48, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Seleccionar portada de la noticia",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Campo Título
          TextField(
            controller: tituloController,
            decoration: const InputDecoration(
              labelText: "Título",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Campo Descripción
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(
              labelText: "Descripción",
              border: UnderlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 18),
          // Campo Enlace
          TextField(
            controller: enlaceController,
            decoration: const InputDecoration(
              labelText: "Enlace a la noticia web",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 18),
          // Campo Fecha (opcional)
          TextField(
            controller: fechaController,
            decoration: const InputDecoration(
              labelText: "Fecha (opcional, formato YYYY-MM-DD)",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 32),
          // Botón crear noticia
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _crearNoticia,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Crear Noticia",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _crearNoticia() async {
    // Validación básica
    if (tituloController.text.trim().isEmpty ||
        descripcionController.text.trim().isEmpty ||
        enlaceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título, descripción y enlace son obligatorios')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Crear la noticia (sin imagen)
      final noticia = await _noticiasService.createNews(
        titulo: tituloController.text.trim(),
        descripcion: descripcionController.text.trim(),
        enlace: enlaceController.text.trim(),
        fecha: fechaController.text.trim().isNotEmpty ? fechaController.text.trim() : null,
      );
      final noticiaId = noticia['noticia']['_id'];

      // 2. Si se seleccionó una imagen, súbela
      if (_imagenPortada != null) {
        await _noticiasService.uploadNewsImage(
          noticiaId: noticiaId,
          imageFile: _imagenPortada!,
        );
      }

      // 3. Vuelve a la pantalla anterior y muestra éxito
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text("Noticia creada con éxito"),
            ],
          ),
          backgroundColor: Colors.green[700],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear noticia: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Seleccionar imagen de la galería
  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenPortada = File(pickedFile.path);
      });
    }
  }
}
