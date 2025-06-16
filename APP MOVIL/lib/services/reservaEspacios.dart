import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservaEspaciosService {
  static const _baseUrl = 'http://10.0.2.2:3000/api/reservas';

  Future<void> crearReservaEspacio({
    required String email, // 👈 Agregado para enviar el email del usuario
    required String nombre,
    required DateTime fecha,
    required String hora,
    required String metodoPago,
  }) async {
    print('--- DATOS A ENVIAR ---');
    print('nombre: $nombre');
    print('fecha: $fecha');
    print('hora: $hora');
    print('metodoPago: $metodoPago');

    final DateTime fechaHora = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(hora.split(':')[0]),
      int.parse(hora.split(':')[1]),
    );

    final body = {
      'usuario': email, // 👈 Lo importante
      'espacio': nombre,
      'franjaHoraria': fechaHora.toIso8601String(),
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
