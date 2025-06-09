import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  /// Registro de usuario móvil
  Future<Map<String, dynamic>> registerMobile({
    required String name,
    required String apellidos,
    required String email,
    required String dni,
    required String password,
    required bool isEmpadronado,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/mobile/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'apellidos': apellidos,
          'email': email,
          'dni': dni,
          'password': password,
          'isEmpadronado': isEmpadronado,
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': result};
      } else {
        return {'success': false, 'error': result['error'] ?? 'Error desconocido'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}