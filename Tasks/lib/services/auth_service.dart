import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String baseUrl = 'http://localhost:3000/api';
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// 🔹 **Registrar un nuevo usuario**
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      } else {
        print('Error en el registro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión en el registro: $e');
      return false;
    }
  }

  /// 🔹 **Iniciar sesión**
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['message'] == 'Login successful') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', result['user']['_id']);

          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error de conexión en el login: $e');
      return false;
    }
  }

  /// 🔹 **Cerrar sesión**
  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  /// 🔹 **Comprobar autenticación al abrir la app**
  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId != null && !_isAuthenticated) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  /// 🔹 **Obtener las tareas del usuario**
  Future<List<Map<String, dynamic>>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId == null) return [];

    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/$userId'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      print('Error al obtener tareas: $e');
    }
    return [];
  }

  /// 🔹 **Añadir una nueva tarea**
  Future<bool> addTask(String title, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks/add/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'description': description}),
      );

      if (response.statusCode == 201) {
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al añadir tarea: $e');
    }
    return false;
  }

  /// 🔹 **Editar una tarea existente**
  Future<bool> editTask(String taskId, String title, String description, bool status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/edit/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'description': description, 'status': status}),
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al editar tarea: $e');
    }
    return false;
  }

  /// 🔹 **Eliminar una tarea**
  Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/delete/$taskId'));
      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al eliminar tarea: $e');
    }
    return false;
  }
}
