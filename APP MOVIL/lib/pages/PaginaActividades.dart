import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/PantallaReserva.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';

class PaginaActividades extends StatelessWidget {
  final String title;

  const PaginaActividades({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Actividades en $title",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción futura
            },
          ),
        ],
      ),
      body: ListView(
        children: [
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Inicio()),
              );
              break;
            case 1:
              break; // Ya estamos en Actividades
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Noticias()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Actividades',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    String activityName,
    String imageUrl,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                activityName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                "Seleccionar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
