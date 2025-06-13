import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ActividadesMunicipalesService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/actividades';

  /// Obtener todas las actividades
  Future<List<dynamic>> getAllActividades() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener actividades');
    }
  }

  /// Crear actividad (sin imágenes)
  Future<Map<String, dynamic>> crearActividad({
    required String titulo,
    String? descripcion,
    required int plazasTotales,
    required int plazasOcupadas,
    required String ubicacion,
    String? espacio, // id del espacio, opcional
    required String fechaInicio, // formato ISO 8601
    required String fechaFin,    // formato ISO 8601
  }) async {
    final body = {
      'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      'plazasTotales': plazasTotales,
      'plazasOcupadas': plazasOcupadas,
      'ubicacion': ubicacion,
      if (espacio != null) 'espacio': espacio,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear actividad: ${response.body}');
    }
  }

  /// Subir imagen de portada (multipart/form-data)
  Future<Map<String, dynamic>> subirImagenPortada({
    required String actividadId,
    required File imagen,
  }) async {
    final uri = Uri.parse('$baseUrl/$actividadId/portada');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al subir imagen de portada: ${response.body}');
    }
  }

  /// Subir imágenes de carrusel (multipart/form-data, varias imágenes)
  Future<Map<String, dynamic>> subirImagenesCarrusel({
    required String actividadId,
    required List<File> imagenes,
  }) async {
    final uri = Uri.parse('$baseUrl/$actividadId/carrusel');
    final request = http.MultipartRequest('POST', uri);

    for (final imagen in imagenes) {
      request.files.add(
        await http.MultipartFile.fromPath('imagenes', imagen.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al subir imágenes de carrusel: ${response.body}');
    }
  }

  /// Eliminar actividad
  Future<void> eliminarActividad(String actividadId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$actividadId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la actividad: ${response.body}');
    }
  }
}
