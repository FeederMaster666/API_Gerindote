import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        return {
          'success': false,
          'error': result['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginMobile({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Login
      final response = await http.post(
        Uri.parse('$baseUrl/users/mobile/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        // 2. Obtener datos del usuario por email, desde backend a través de endpoint
        final infoResponse = await http.get(
          Uri.parse('$baseUrl/users/mobile/email/$email'),
          headers: {'Content-Type': 'application/json'},
        );

        if (infoResponse.statusCode == 200) {
          final data = jsonDecode(infoResponse.body);
          final email = data['email'];
          final rol = data['rol'];

          // 3. Guardar datos en SharedPreferences
          await saveUserData(email, rol);

          return {'success': true, 'data': result};
        } else {
          return {
            'success': false,
            'error': 'No se pudo obtener la información del usuario',
          };
        }
      } else {
        return {
          'success': false,
          'error': result['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      //print para depuracion
      print(e);
      return {'success': false, 'error': e.toString()};
    }
  }

  // Guardar datos del usuario
  Future<void> saveUserData(String email, String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('user_rol', rol);
  }

  // Obtener email del usuario
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Obtener rol del usuario
  Future<String?> getUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_rol');
  }

  // Cerrar sesión (eliminar datos)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_rol');
  }

  //Para obtener los espacios por tipo
  Future<List<dynamic>> getEspaciosPorTipo(String tipo) async {
    final response = await http.get(
      Uri.parse('$baseUrl/espacios/tipo/$tipo'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['espacios'];
    } else {
      throw Exception(data['error'] ?? 'Error al cargar espacios');
    }
  }

  //para crear una reserva
  Future<Map<String, dynamic>> crearReserva({
    required String espacioId,
    required String usuarioId,
    required DateTime franjaHoraria,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'espacioId': espacioId,
        'usuarioId': usuarioId,
        'franjaHoraria': franjaHoraria.toIso8601String(),
      }),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'data': data['reserva']};
    } else {
      return {'success': false, 'error': data['error']};
    }
  }
}
