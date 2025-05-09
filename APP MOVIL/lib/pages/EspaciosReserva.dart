import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarHoras(_fechaSeleccionada);
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
        title: Text('Reservar - ${widget.nombreActividad}'),
        backgroundColor: Colors.green,
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
                  selectedDayPredicate: (day) {
                    return isSameDay(_fechaSeleccionada, day);
                  },
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
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
                        color: Colors.green,
                      ),
                      title: Text(
                        horasDisponibles[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reservado a las ${horasDisponibles[index]}',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
