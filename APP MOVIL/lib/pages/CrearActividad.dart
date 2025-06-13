import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ActividadesMunicipalesService.dart';

/// Pantalla de formulario para crear una nueva actividad municipal.
/// Permite introducir los datos básicos y subir imágenes de portada y carrusel.
class CrearActividadScreen extends StatefulWidget {
  const CrearActividadScreen({super.key});

  @override
  State<CrearActividadScreen> createState() => _CrearActividadScreenState();
}

class _CrearActividadScreenState extends State<CrearActividadScreen> {
  // Controladores para los campos de texto
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final ubicacionController = TextEditingController();
  final plazasTotalesController = TextEditingController();
  final plazasOcupadasController = TextEditingController();
  final fechaInicioController = TextEditingController();
  final fechaFinController = TextEditingController();

  // Imagen de portada seleccionada
  File? _imagenPortada;
  // Lista de imágenes seleccionadas para el carrusel
  List<File> _imagenesCarrusel = [];
  // Estado de carga para mostrar indicador mientras se guarda
  bool _isLoading = false;

  // Servicio para interactuar con el backend
  final ActividadesMunicipalesService _service = ActividadesMunicipalesService();

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
          "Crear Actividad",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // El formulario se muestra en un ListView para permitir scroll si hay teclado
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          const SizedBox(height: 16),
          // Selector de foto de portada
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _seleccionarImagenPortada,
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
                  "Seleccionar portada de la actividad",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Selector de imágenes de carrusel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Imágenes del carrusel (puedes seleccionar varias)",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  // Botón para añadir imágenes al carrusel
                  GestureDetector(
                    onTap: _seleccionarImagenesCarrusel,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 32),
                    ),
                  ),
                  // Miniaturas de imágenes seleccionadas
                  ..._imagenesCarrusel.map((img) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4, right: 4),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(img, fit: BoxFit.cover),
                        ),
                      ),
                      // Botón para eliminar imagen del carrusel
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _imagenesCarrusel.remove(img);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          // Campo Ubicación
          TextField(
            controller: ubicacionController,
            decoration: const InputDecoration(
              labelText: "Ubicación",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Campo Plazas Totales
          TextField(
            controller: plazasTotalesController,
            decoration: const InputDecoration(
              labelText: "Plazas totales",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Campo Plazas Ocupadas
          TextField(
            controller: plazasOcupadasController,
            decoration: const InputDecoration(
              labelText: "Plazas ocupadas",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Campo Fecha Inicio
          TextField(
            controller: fechaInicioController,
            decoration: const InputDecoration(
              labelText: "Fecha inicio (YYYY-MM-DDTHH:MM:SS)",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 18),
          // Campo Fecha Fin
          TextField(
            controller: fechaFinController,
            decoration: const InputDecoration(
              labelText: "Fecha fin (YYYY-MM-DDTHH:MM:SS)",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 32),
          // Botón crear actividad
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _crearActividad,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Crear Actividad",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Permite seleccionar una imagen de portada desde la galería
  Future<void> _seleccionarImagenPortada() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenPortada = File(pickedFile.path);
      });
    }
  }

  /// Permite seleccionar varias imágenes para el carrusel desde la galería
  Future<void> _seleccionarImagenesCarrusel() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _imagenesCarrusel.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  /// Envía el formulario para crear la actividad y subir las imágenes
  /// Incluye validación básica de campos obligatorios
  Future<void> _crearActividad() async {
    // Validación básica de campos obligatorios
    if (tituloController.text.trim().isEmpty ||
        descripcionController.text.trim().isEmpty ||
        ubicacionController.text.trim().isEmpty ||
        plazasTotalesController.text.trim().isEmpty ||
        plazasOcupadasController.text.trim().isEmpty ||
        fechaInicioController.text.trim().isEmpty ||
        fechaFinController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Crear la actividad (sin imágenes)
      final actividad = await _service.crearActividad(
        titulo: tituloController.text.trim(),
        descripcion: descripcionController.text.trim(),
        ubicacion: ubicacionController.text.trim(),
        plazasTotales: int.tryParse(plazasTotalesController.text.trim()) ?? 0,
        plazasOcupadas: int.tryParse(plazasOcupadasController.text.trim()) ?? 0,
        fechaInicio: fechaInicioController.text.trim(),
        fechaFin: fechaFinController.text.trim(),
      );
      final actividadId = actividad['actividad']['_id'];

      // 2. Subir imagen de portada si se seleccionó
      if (_imagenPortada != null) {
        await _service.subirImagenPortada(
          actividadId: actividadId,
          imagen: _imagenPortada!,
        );
      }

      // 3. Subir imágenes del carrusel si se seleccionaron
      if (_imagenesCarrusel.isNotEmpty) {
        await _service.subirImagenesCarrusel(
          actividadId: actividadId,
          imagenes: _imagenesCarrusel,
        );
      }

      // Si todo sale bien, vuelve atrás y muestra mensaje de éxito
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text("Actividad creada con éxito"),
            ],
          ),
          backgroundColor: Colors.green[700],
        ),
      );
    } catch (e) {
      // Si ocurre un error, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear actividad: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

