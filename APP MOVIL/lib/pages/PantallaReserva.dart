import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/services/reservaEspacios.dart';

class PantallaReserva extends StatefulWidget {
  final Map<String, dynamic> espacio;
  final String usuarioId;
  final String email;

  const PantallaReserva({
    Key? key,
    required this.espacio,
    required this.usuarioId,

    required this.email,
    required String nombreActividad,
  }) : super(key: key);

  @override
  State<PantallaReserva> createState() => _PantallaReservaState();
}

class _PantallaReservaState extends State<PantallaReserva> {
  DateTime _fechaSeleccionada = DateTime.now();
  String _horaSeleccionada = '10:00';
  bool _isLoading = false;
  String _metodoPago = 'metalico';

  final List<String> horasDisponibles = [
    '10:00',
    '11:00',
    '12:00',
    '17:00',
    '18:00',
    '19:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservar espacio")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Selecciona fecha:"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaSeleccionada,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _fechaSeleccionada = picked);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Selecciona hora:"),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _horaSeleccionada,
              items:
                  horasDisponibles.map((String hora) {
                    return DropdownMenuItem<String>(
                      value: hora,
                      child: Text(hora),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _horaSeleccionada = value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text("Método de pago:"),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _metodoPago,
              items: const [
                DropdownMenuItem(value: 'metalico', child: Text('En metálico')),
                DropdownMenuItem(
                  value: 'stripe',
                  child: Text('Stripe (tarjeta)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _metodoPago = value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Reservado por:",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person, size: 22),
              title: Text(
                widget.usuarioId,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.email,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              _isLoading
                  ? null
                  : () async {
                    setState(() => _isLoading = true);
                    try {
                      final reservaService = ReservaEspaciosService();

                      if (_metodoPago == 'metalico') {
                        await reservaService.crearReservaEspacio(
                          usuarioId: widget.usuarioId,
                          espacioId: widget.espacio['_id'],
                          fecha: _fechaSeleccionada,
                          hora: _horaSeleccionada,
                          metodoPago: 'metalico',
                        );

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reserva confirmada."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }

                      // Aquí podrías insertar la lógica para Stripe si lo necesitas más adelante
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error al reservar: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
          child:
              _isLoading
                  ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                  : const Text(
                    "CONFIRMAR RESERVA",
                    style: TextStyle(color: Colors.white),
                  ),
        ),
      ),
    );
  }
}
