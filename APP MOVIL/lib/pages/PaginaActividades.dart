// Importa los paquetes necesarios de Flutter y una pantalla personalizada
import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/PantallaReserva.dart';

// Define un widget sin estado (StatelessWidget) llamado PaginaActividades
class PaginaActividades extends StatelessWidget {
  // Variable final para el título, se recibe por constructor
  final String title;

  // Constructor con parámetro requerido 'title'
  const PaginaActividades({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con título y botón de perfil
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Color de fondo del AppBar
        title: Text(
          "Actividades en $title", // Muestra el título dinámico
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
      // Cuerpo de la pantalla: una lista de tarjetas (Cards) con actividades
      body: ListView(
        children: [
          // Cada tarjeta representa una actividad con su imagen y botón
          _buildActivityCard(
            context,
            "Pista de Tenis y/o baloncesto",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0006.jpg",
          ),
          _buildActivityCard(
            context,
            "Pista de Padel Nº 1",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0026.jpg",
          ),
          _buildActivityCard(
            context,
            "Pista de Padel Nº 2",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0009.jpg",
          ),
          _buildActivityCard(
            context,
            "Campo Fútbol 7 Nº 1",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0012.jpg",
          ),
          _buildActivityCard(
            context,
            "Campo Fútbol 7 Nº 2",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0014.jpg",
          ),
          _buildActivityCard(
            context,
            "Parque Calistenia",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0025.jpg",
          ),
          _buildActivityCard(
            context,
            "Mesa ping pong Nº 1",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0013.jpg",
          ),
          _buildActivityCard(
            context,
            "Mesa ping pong Nº 2",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0011.jpg",
          ),
          _buildActivityCard(
            context,
            "Campo Voley Playa",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200708-wa0004.jpg",
          ),
        ],
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
