import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ayuntamiento_gerindote/services/reservaEspacios.dart';

class PantallaReserva extends StatefulWidget {
  final Map<String, dynamic> espacio;
  final String nombre;
  final String email;
  final String nombreActividad;

  const PantallaReserva({
    super.key,
    required this.espacio,
    required this.nombre,
    required this.email,
    required this.nombreActividad,
  });

  @override
  State<PantallaReserva> createState() => _PantallaReservaState();
}

class _PantallaReservaState extends State<PantallaReserva> {
  DateTime _fechaSeleccionada = DateTime.now();
  String _horaSeleccionada = '10:00';
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
          'Reservar ${widget.nombreActividad}',
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
                      onSelected: (_) {
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
                  widget.nombre,
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
                onPressed: () async {
                  final espacioNombre = widget.espacio['nombre'];

                  final confirmado = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => ReservaEspacioDialog(
                          espacio: espacioNombre,
                          email: widget.email,
                          nombre: widget.nombre,
                          fecha: _fechaSeleccionada,
                          hora: _horaSeleccionada,
                          metodoPago: _metodoPago,
                        ),
                  );

                  if (confirmado == true) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Reserva confirmada."),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
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

class ReservaEspacioDialog extends StatefulWidget {
  final String espacio;
  final String email;
  final String nombre;
  final DateTime fecha;
  final String hora;
  final String metodoPago;

  const ReservaEspacioDialog({
    Key? key,
    required this.espacio,
    required this.email,
    required this.nombre,
    required this.fecha,
    required this.hora,
    required this.metodoPago,
  }) : super(key: key);

  @override
  State<ReservaEspacioDialog> createState() => _ReservaEspacioDialogState();
}

class _ReservaEspacioDialogState extends State<ReservaEspacioDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Confirmar reserva",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Espacio: ${widget.espacio}"),
          const SizedBox(height: 10),
          Text("Fecha: ${widget.fecha.toLocal().toString().split(' ')[0]}"),
          Text("Hora: ${widget.hora}"),
          const SizedBox(height: 20),
          const Text(
            "Persona a cargo de la reserva:",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person),
            title: Text(widget.nombre),
            subtitle: Text(widget.email),
          ),
          const SizedBox(height: 10),
          Text(
            "Método de pago: ${widget.metodoPago == 'metalico' ? 'En metálico' : 'Stripe (tarjeta)'}",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
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
                      await reservaService.crearReservaEspacio(
                        email: widget.email,
                        nombre: widget.espacio,
                        fecha: widget.fecha,
                        hora: widget.hora,
                        metodoPago: widget.metodoPago,
                      );

                      Navigator.pop(context, true);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al reservar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pop(context, false);
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
          child:
              _isLoading
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    "CONFIRMAR RESERVA",
                    style: TextStyle(color: Colors.white),
                  ),
        ),
      ],
    );
  }
}
