// Importa los paquetes necesarios de Flutter y una pantalla personalizada
import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/PantallaReserva.dart';

// Define un widget sin estado (StatelessWidget) llamado PaginaActividades
class PaginaActividades extends StatelessWidget {
  // Variable final para el título, se recibe por constructor
  final String title;

  // Constructor con parámetro requerido 'title'
  PaginaActividades({Key? key, required this.title}) : super(key: key);
  // Lista de actividades por instalación (simulación de datos)
  final Map<String, List<Map<String, String>>> actividadesPorInstalacion = {
    "Pistas Exteriores": [
      {
        "nombre": "Pista de Padel Nº 1",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0026.jpg",
      },
      {
        "nombre": "Pista de Padel Nº 2",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0009.jpg",
      },
      {
        "nombre": "Pista de Tenis y/o baloncesto",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0006.jpg",
      },
      {
        "nombre": "Mesa ping pong Nº 1",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0013.jpg",
      },
      {
        "nombre": "Mesa ping pong Nº 2",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0011.jpg",
      },
      {
        "nombre": "Campo Voley Playa",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200708-wa0004.jpg",
      },
    ],
    "Campo de fútbol": [
      {
        "nombre": "Campo Fútbol 7 Nº 1",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0012.jpg",
      },
      {
        "nombre": "Campo Fútbol 7 Nº 2",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0014.jpg",
      },
    ],
    "Gimnasio Municipal": [
      {
        "nombre": "Parque Calistenia",
        "imagen":
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0025.jpg",
      },
    ],
    // Puedes añadir más según tus categorías...
  };

  @override
  Widget build(BuildContext context) {
    final actividades = actividadesPorInstalacion[title] ?? [];
    return Scaffold(
      // AppBar con título y botón de perfil
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Color de fondo del AppBar
        centerTitle: true,
        title: Text(
          "$title", // Muestra el título dinámico
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción futura (a definir)
            },
          ),
        ],
      ),
      body:
          actividades.isEmpty
              ? const Center(child: Text("No hay actividades disponibles."))
              : ListView.builder(
                itemCount: actividades.length,
                itemBuilder: (context, index) {
                  final actividad = actividades[index];
                  return _buildActivityCard(
                    context,
                    actividad["nombre"]!,
                    actividad["imagen"]!,
                  );
                },
              ),
    );
  }

  // Método auxiliar para construir una tarjeta (Card) de actividad
  Widget _buildActivityCard(
    BuildContext context,
    String activityName,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        side: BorderSide(
          color: Colors.blueGrey.shade200, // Color del borde
          width: 1,
        ), // Borde visible
      ),
      elevation: 2, // Sombra suave
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Espaciado interno
        child: Row(
          children: [
            // Avatar circular con la imagen de la actividad
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 30),
            const SizedBox(width: 16), // Espacio entre imagen y texto
            Expanded(
              // Nombre de la actividad
              child: Text(
                activityName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Botón para seleccionar la actividad
            ElevatedButton(
              onPressed: () {
                // Navega a la pantalla de reserva, pasando el nombre de la actividad
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PantallaReserva(nombreActividad: activityName),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Color del botón
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ), // Tamaño interno del botón
              ),
              child: const Text(
                "Seleccionar", // Texto del botón
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
