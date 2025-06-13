import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservaActividadesService {
  // URL base del endpoint de reservas
  static const String baseUrl = 'http://10.0.2.2:3000/api/reservas-actividades';

  /// Crear una reserva
  /// [usuarioId], [actividadId], [plazasReservadas], [metodoPago] ('efectivo' o 'online')
  /// Retorna el JSON con la reserva creada y, si es pago online, el client_secret de Stripe
  Future<Map<String, dynamic>> crearReserva({
    required String usuarioId,
    required String actividadId,
    required int plazasReservadas,
    required String metodoPago,
  }) async {
    final body = {
      'usuario': usuarioId,
      'actividad': actividadId,
      'plazasReservadas': plazasReservadas,
      'metodoPago': metodoPago,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear reserva: ${response.body}');
    }
  }

  /// Confirmar pago Stripe (puede usarse para webhook o endpoint manual)
  /// [paymentIntentId] es el ID del PaymentIntent de Stripe
  Future<Map<String, dynamic>> confirmarPagoStripe(String paymentIntentId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stripe/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'paymentIntentId': paymentIntentId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al confirmar pago Stripe: ${response.body}');
    }
  }

  /// Cancelar una reserva por su ID
  Future<void> cancelarReserva(String reservaId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$reservaId/cancelar'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cancelar reserva: ${response.body}');
    }
  }

  /// Obtener reservas de un usuario
  Future<List<dynamic>> getReservasUsuario(String usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener reservas del usuario');
    }
  }

  /// Obtener reservas de una actividad
  Future<List<dynamic>> getReservasActividad(String actividadId) async {
    final response = await http.get(Uri.parse('$baseUrl/actividad/$actividadId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener reservas de la actividad');
    }
  }
}
