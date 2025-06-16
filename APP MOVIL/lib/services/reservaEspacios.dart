// lib/services/reserva_espacios_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservaEspaciosService {
  static const _baseUrl = 'http://10.0.2.2:3000/api/reservas';

  /// Crea la reserva en tu API una vez el pago ha sido exitoso.
  Future<void> crearReservaEspacio({
    required String email,
    required String espacioId,
    required DateTime fecha,
    required String hora,
    required String metodoPago, // 'stripe'
  }) async {
    final body = {
      'usuario': email,
      'espacio': espacioId,
      'franjaHoraria': '${fecha.toIso8601String().split('T')[0]}T$hora:00.000Z',
      'metodoPago': metodoPago,
    };
    final resp = await http.post(
      Uri.parse('$_baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw Exception('Error al crear reserva: ${resp.body}');
    }
  }
}
