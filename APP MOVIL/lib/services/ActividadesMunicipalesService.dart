import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ActividadesMunicipalesService {
  // URL base del endpoint de actividades
  static const String baseUrl = 'http://10.0.2.2:3000/api/actividades';

  /// Obtiene todas las actividades disponibles desde el backend
  /// Retorna una lista dinámica con todas las actividades
  /// Lanza una excepción si ocurre un error en la petición
  Future<List<dynamic>> getAllActividades() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener actividades');
    }
  }

  /// Crea una nueva actividad en el sistema (sin imágenes)
  /// [titulo]: Título de la actividad (obligatorio)
  /// [descripcion]: Descripción detallada (opcional)
  /// [plazasTotales]: Número total de plazas disponibles
  /// [plazasOcupadas]: Plazas inicialmente ocupadas (generalmente 0)
  /// [ubicacion]: Dirección física o lugar de realización
  /// [espacio]: ID del espacio relacionado (opcional)
  /// [fechaInicio]: Fecha y hora de inicio en formato ISO 8601
  /// [fechaFin]: Fecha y hora de finalización en formato ISO 8601
  /// Retorna el objeto de la actividad creada
  /// Lanza excepción si hay errores de validación o del servidor
  Future<Map<String, dynamic>> crearActividad({
    required String titulo,
    String? descripcion,
    required int plazasTotales,
    required int plazasOcupadas,
    required String ubicacion,
    String? espacio,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    // Construye el cuerpo de la petición con los parámetros
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

  /// Sube una imagen de portada para una actividad existente
  /// [actividadId]: ID de la actividad a actualizar
  /// [imagen]: Archivo de imagen a subir
  /// Retorna la actividad actualizada con la nueva imagen
  /// Lanza excepción si falla la subida
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

  /// Sube múltiples imágenes para el carrusel de una actividad
  /// [actividadId]: ID de la actividad a actualizar
  /// [imagenes]: Lista de archivos de imágenes a subir
  /// Retorna la actividad actualizada con las nuevas imágenes
  /// Lanza excepción si falla la subida
  Future<Map<String, dynamic>> subirImagenesCarrusel({
    required String actividadId,
    required List<File> imagenes,
  }) async {
    final uri = Uri.parse('$baseUrl/$actividadId/carrusel');
    final request = http.MultipartRequest('POST', uri);

    // Añade cada imagen al request
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

  /// Elimina una actividad permanentemente del sistema
  /// [actividadId]: ID de la actividad a eliminar
  /// Lanza excepción si falla la eliminación
  Future<void> eliminarActividad(String actividadId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$actividadId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la actividad: ${response.body}');
    }
  }
}

