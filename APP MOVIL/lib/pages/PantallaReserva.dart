import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Reservar - ${widget.espacio['nombre'] ?? 'Espacio'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  focusedDay: _fechaSeleccionada,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, _) {
                    setState(() {
                      _fechaSeleccionada = selectedDay;
                    });
                  },
                  selectedDayPredicate:
                      (day) => isSameDay(_fechaSeleccionada, day),
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Horas disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children:
                  horasDisponibles.map((hora) {
                    final bool selected = hora == _horaSeleccionada;
                    return ChoiceChip(
                      label: Text(hora),
                      selected: selected,
                      selectedColor: Colors.blueAccent,
                      onSelected: (bool selected) {
                        setState(() {
                          _horaSeleccionada = hora;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Método de pago',
                    border: InputBorder.none,
                  ),
                  value: _metodoPago,
                  items: const [
                    DropdownMenuItem(
                      value: 'metalico',
                      child: Text('En metálico'),
                    ),
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
              ),
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: 28,
                ),
                title: Text(
                  widget.usuarioId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(widget.email),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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
                                email: widget.email,
                                espacioId: widget.espacio['_id'],
                                fecha: _fechaSeleccionada,
                                hora: _horaSeleccionada,
                                metodoPago: 'metalico',
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reserva confirmada."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }

                            // Aquí puedes implementar pago con Stripe si quieres
                          } catch (e) {
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
                          'CONFIRMAR RESERVA',
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
