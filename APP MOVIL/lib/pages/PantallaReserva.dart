// Importación de paquetes necesarios para la interfaz, el calendario y las páginas internas
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/ActividadAyto.dart';

// Definición del widget con estado que representa la pantalla de reservas
class PantallaReserva extends StatefulWidget {
  final String
  nombreActividad; // Nombre de la actividad que se mostrará en el AppBar

  // Constructor con parámetro obligatorio
  const PantallaReserva({Key? key, required this.nombreActividad})
    : super(key: key);

  @override
  _PantallaReservaState createState() => _PantallaReservaState();
}

// Estado del widget PantallaReserva
class _PantallaReservaState extends State<PantallaReserva> {
  // Fecha actualmente seleccionada en el calendario
  DateTime _fechaSeleccionada = DateTime.now();

  // Lista de horas disponibles para reservar
  List<String> horasDisponibles = [];

  @override
  void initState() {
    super.initState();
    // Cargar las horas al iniciar el widget con la fecha actual
    _cargarHoras(_fechaSeleccionada);
  }

  // Simula la carga de horas disponibles para la fecha seleccionada
  void _cargarHoras(DateTime fecha) {
    setState(() {
      // Aquí podrías cargar dinámicamente desde una base de datos
      horasDisponibles = ['10:00', '11:00', '12:00', '17:00', '18:00', '19:00'];
    });
  }

  // Función que gestiona la navegación inferior entre páginas
  void _onBottomNavTapped(int index) {
    if (index == 0) {
      // Ir a Noticias
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventosAyto()),
      );
    } else if (index == 1) {
      // Ir a Inicio
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inicio()),
      );
    } else if (index == 2) {
      // Ir a ActividadAyto (Eventos del Ayuntamiento)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Noticias()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estructura visual de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Color de fondo
      // AppBar con el nombre de la actividad
      appBar: AppBar(
        title: Text('Reservar - ${widget.nombreActividad}'),
        backgroundColor: Colors.blueAccent,
      ),

      // Cuerpo principal de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado externo
        child: Column(
          children: [
            // Tarjeta con el calendario
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4, // Sombra de la tarjeta
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Espaciado interno
                child: TableCalendar(
                  // Día central mostrado
                  focusedDay: _fechaSeleccionada,
                  // Día mínimo seleccionable: hoy
                  firstDay: DateTime.now(),
                  // Día máximo seleccionable: 30 días después
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  // Formato del calendario
                  calendarFormat: CalendarFormat.month,
                  // Acción al seleccionar un día
                  onDaySelected: (selectedDay, _) {
                    setState(() {
                      _fechaSeleccionada = selectedDay;
                    });
                    _cargarHoras(selectedDay); // Recarga las horas disponibles
                  },
                  // Define si el día actual está seleccionado
                  selectedDayPredicate: (day) {
                    return isSameDay(_fechaSeleccionada, day);
                  },
                  // Estilo del calendario
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

            const SizedBox(height: 20), // Espacio vertical
            // Título para la sección de horas disponibles
            const Text(
              'Horas disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Lista desplazable de horas disponibles
            Expanded(
              child: ListView.builder(
                itemCount: horasDisponibles.length, // Total de horas
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      // Icono de reloj
                      leading: const Icon(
                        Icons.access_time,
                        color: Colors.blueAccent,
                      ),
                      // Texto con la hora disponible
                      title: Text(
                        horasDisponibles[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Botón de "Reservar"
                      trailing: ElevatedButton(
                        onPressed: () {
                          final TextEditingController nombreController =
                              TextEditingController();
                          final TextEditingController correoController =
                              TextEditingController();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Datos de la reserva'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nombreController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre completo',
                                      ),
                                    ),
                                    TextField(
                                      controller: correoController,
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
                                          nombreController.text.trim();
                                      final correo =
                                          correoController.text.trim();

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

                                      Navigator.of(
                                        context,
                                      ).pop(); // Cerrar el diálogo

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

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
        ],
        currentIndex: 0, // Pestaña activa por defecto
        onTap: _onBottomNavTapped, // Controlador de pulsaciones
        selectedItemColor: Colors.blueAccent, // Color al seleccionar
        unselectedItemColor: Colors.grey, // Color cuando no está seleccionado
      ),
    );
  }
}
