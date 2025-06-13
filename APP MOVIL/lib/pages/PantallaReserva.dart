// Importación de paquetes necesarios para la interfaz, el calendario y el envío HTTP
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Widget de pantalla con estado para la reserva de actividades
class PantallaReserva extends StatefulWidget {
  final String nombreActividad;

  const PantallaReserva({Key? key, required this.nombreActividad})
    : super(key: key);

  @override
  _PantallaReservaState createState() => _PantallaReservaState();
}

class _PantallaReservaState extends State<PantallaReserva> {
  DateTime _fechaSeleccionada = DateTime.now();
  List<String> horasDisponibles = [];

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarHoras(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _cargarHoras(DateTime fecha) {
    setState(() {
      horasDisponibles = ['10:00', '11:00', '12:00', '17:00', '18:00', '19:00'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Reservar - ${widget.nombreActividad}',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  focusedDay: _fechaSeleccionada,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, _) {
                    setState(() {
                      _fechaSeleccionada = selectedDay;
                    });
                    _cargarHoras(selectedDay);
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
            Expanded(
              child: ListView.builder(
                itemCount: horasDisponibles.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.access_time,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        horasDisponibles[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _nombreController.clear();
                          _correoController.clear();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Datos de la reserva'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _nombreController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre completo',
                                      ),
                                    ),
                                    TextField(
                                      controller: _correoController,
                                      decoration: const InputDecoration(
                                        labelText: 'Correo electrónico',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final nombre =
                                          _nombreController.text.trim();
                                      final correo =
                                          _correoController.text.trim();

                                      if (nombre.isEmpty || correo.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Por favor, completa todos los campos.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Reserva hecha para $nombre a las ${horasDisponibles[index]}.\nSe enviará confirmación a $correo.',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: const Text(
                                      'Confirmar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reservar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
