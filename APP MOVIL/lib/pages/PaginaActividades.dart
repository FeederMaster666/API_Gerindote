import 'package:flutter/material.dart';

// StatelessWidget para la página de actividades
class PaginaActividades extends StatelessWidget {
  // Título de la página, recibido como parámetro
  final String title;

  // Constructor que requiere el título
  const PaginaActividades({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona la estructura básica de la pantalla
    return Scaffold(
      // AppBar es la barra superior de la aplicación
      appBar: AppBar(
        // Color de fondo verde
        backgroundColor: Colors.green,
        // Título del AppBar con estilo de texto
        title: Text("Actividades en $title", style: const TextStyle(color: Colors.white, fontSize: 18)),
        // Acciones en la parte derecha del AppBar
        actions: [
          // IconButton para el icono de usuario
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario (por implementar)
            },
          ),
        ],
      ),
      // Cuerpo de la pantalla
      body: ListView(
        // Lista de tarjetas de actividades
        children: [
          // Llamadas a _buildActivityCard para crear cada tarjeta
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

  // Widget para construir una tarjeta de actividad
  Widget _buildActivityCard(BuildContext context, String activityName, String imageUrl) {
    // Container principal que contiene la tarjeta
    return Container(
      // Margen horizontal de 16 y vertical de 8 para separar las tarjetas
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // BoxDecoration para dar estilo al contenedor
      decoration: BoxDecoration(
        // Color de fondo blanco
        color: Colors.white,
        // Bordes redondeados con radio de 10
        borderRadius: BorderRadius.circular(10),
        // Sombra alrededor del contenedor
        boxShadow: [
          BoxShadow(
            // Color de la sombra gris con opacidad
            color: Colors.grey.withOpacity(0.3),
            // Radio de expansión de la sombra
            spreadRadius: 2,
            // Radio de desenfoque de la sombra
            blurRadius: 5,
            // Desplazamiento de la sombra
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Padding interno del contenedor
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Fila para organizar los elementos horizontalmente
        child: Row(
          children: [
            // CircleAvatar para mostrar la imagen de la actividad
            CircleAvatar(
              // Imagen de fondo obtenida de la URL
              backgroundImage: NetworkImage(imageUrl),
              // Radio del círculo
              radius: 30,
            ),
            // Espacio horizontal entre la imagen y el texto
            const SizedBox(width: 16),
            // Expanded para que el texto ocupe el espacio restante
            Expanded(
              // Widget de texto para mostrar el nombre de la actividad
              child: Text(
                activityName,
                // Estilo del texto
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ElevatedButton para seleccionar la actividad
            ElevatedButton(
              onPressed: () {
                // Acción al presionar "Seleccionar" (por implementar)
              },
              // Estilo del botón
              style: ElevatedButton.styleFrom(
                // Color de fondo verde
                backgroundColor: Colors.green,
                // Estilo del texto
                textStyle: const TextStyle(fontSize: 16),
              ),
              // Texto del botón
              child: const Text("Seleccionar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}