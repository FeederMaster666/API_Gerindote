import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Servicio para gestionar las peticiones HTTP relacionadas con noticias
class NoticiasService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/noticias';

  /// Obtiene todas las noticias usando el endpoint GET del backend
  Future<List<dynamic>> fetchAllNews() async {
    final response = await http.get(Uri.parse('$baseUrl/mobile/all'));
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON y la retorna como lista
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener las noticias');
    }
  }

  /// Crea una noticia (sin imagen) usando el endpoint POST
  Future<Map<String, dynamic>> createNews({
    required String titulo,
    required String descripcion,
    required String enlace,
    String? fecha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mobile/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': titulo,
        'descripcion': descripcion,
        'enlace': enlace,
        if (fecha != null) 'fecha': fecha,
      }),
    );
    if (response.statusCode == 201) {
      // Devuelve el objeto noticia creado
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear la noticia: ${response.body}');
    }
  }

  /// Sube la imagen de portada de una noticia usando POST multipart/form-data
  Future<Map<String, dynamic>> uploadNewsImage({
    required String noticiaId,
    required File imageFile,
  }) async {
    var uri = Uri.parse('$baseUrl/mobile/$noticiaId/imagen');
    var request = http.MultipartRequest('POST', uri);

    // Adjunta la imagen al campo 'imagen'
    request.files.add(
      await http.MultipartFile.fromPath('imagen', imageFile.path),
    );

    // Envía la petición y espera la respuesta
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Devuelve la respuesta del backend (noticia actualizada)
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al subir la imagen: ${response.body}');
    }
  }

  /// Elimina una noticia por su ID usando el endpoint DELETE
  Future<void> deleteNews(String noticiaId) async {
    final response = await http.delete(Uri.parse('$baseUrl/mobile/$noticiaId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la noticia: ${response.body}');
    }
  }
}

