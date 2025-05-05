import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';

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

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inicio()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Noticias()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar - ${widget.nombreActividad}'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _fechaSeleccionada,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 30)),
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
            ),
            const SizedBox(height: 20),
            Text(
              'Horas disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: horasDisponibles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(horasDisponibles[index]),
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
                      child: Text('Reservar'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
        ],
      ),
    );
  }
}
