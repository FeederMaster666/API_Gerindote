import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/ActividadAyto.dart';

class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final List<Map<String, String>> noticias = [
    {
      "titulo": "La Romería de Gerindote ya cuenta con página web",
      "descripcion":
          "Ya está disponible la web oficial del evento para consultas y actividades.",
      "imagen": "https://picsum.photos/id/1015/600/300",
    },
    {
      "titulo": "Entrega de diplomas a la Asociación de Vecinos",
      "descripcion": "Reconocimiento a los miembros por su labor comunitaria.",
      "imagen": "https://picsum.photos/id/1027/600/300",
    },
    {
      "titulo": "Nuevo programa cultural en marcha",
      "descripcion": "Iniciativas culturales semanales para todas las edades.",
      "imagen": "https://picsum.photos/id/1035/600/300",
    },
    {
      "titulo": "Subvenciones para jóvenes emprendedores",
      "descripcion": "Se abre el plazo para solicitar ayudas municipales.",
      "imagen": "https://picsum.photos/id/1049/600/300",
    },
    {
      "titulo": "Plan municipal de sostenibilidad en marcha",
      "descripcion": "Acciones para un pueblo más verde y eficiente.",
      "imagen": "https://picsum.photos/id/1060/600/300",
    },
    {
      "titulo": "Inauguración del nuevo parque infantil",
      "descripcion":
          "El nuevo parque cuenta con juegos inclusivos y áreas verdes.",
      "imagen": "https://picsum.photos/id/1074/600/300",
    },
    {
      "titulo": "Feria de empleo y formación",
      "descripcion": "Oportunidades laborales y formativas para los jóvenes.",
      "imagen": "https://picsum.photos/id/1081/600/300",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        //quitar la backArrow
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Noticias y Eventos",
          style: TextStyle(
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
        backgroundColor: Colors.blueAccent,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        noticia["imagen"]!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      noticia["titulo"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      noticia["descripcion"]!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
