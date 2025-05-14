// Importamos el paquete de Flutter necesario para crear interfaces gráficas
import 'package:flutter/material.dart';

// Declaramos un widget con estado llamado Noticias
class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

// Clase que gestiona el estado del widget Noticias
class _NoticiasState extends State<Noticias> {
  // Lista de noticias, cada una representada como un mapa con título, descripción e imagen
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
    // Retorna un Scaffold, que es la estructura visual básica de una pantalla
    return Scaffold(
      appBar: AppBar(
        // Evita que aparezca la flecha de "volver" automáticamente
        automaticallyImplyLeading: false,
        // Centra el título en el AppBar
        centerTitle: true,
        // Título del AppBar con estilo personalizado
        title: const Text(
          "Noticias y Eventos",
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 20, // Tamaño del texto
            fontWeight: FontWeight.bold, // Negrita
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45, // Color de la sombra
                offset: Offset(1, 2), // Desplazamiento de la sombra
                blurRadius: 4, // Difuminado de la sombra
              ),
            ],
          ),
        ),
        // Color de fondo del AppBar
        backgroundColor: Colors.blueAccent,
        // Iconos en la parte derecha del AppBar
        actions: [
          // Icono de usuario (sin funcionalidad definida aún)
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción que se ejecutará al presionar el icono (por implementar)
            },
          ),
        ],
      ),
      // Cuerpo de la pantalla
      body: Padding(
        // Espaciado alrededor del contenido
        padding: const EdgeInsets.all(16),
        // Lista desplazable de widgets generados dinámicamente
        child: ListView.builder(
          itemCount: noticias.length, // Número de elementos a mostrar
          itemBuilder: (context, index) {
            // Accedemos a cada noticia según el índice actual
            final noticia = noticias[index];
            // Retornamos una tarjeta (Card) por cada noticia
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8), // Espaciado vertical
              elevation: 3, // Sombra de la tarjeta
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Espaciado interno
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineación izquierda
                  children: [
                    // Imagen destacada de la noticia con bordes redondeados
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        noticia["imagen"]!, // URL de la imagen
                        height: 180, // Altura fija
                        width:
                            double.infinity, // Ocupa todo el ancho disponible
                        fit:
                            BoxFit
                                .cover, // Cubre el espacio manteniendo la relación de aspecto
                      ),
                    ),
                    SizedBox(height: 10), // Espacio entre la imagen y el texto
                    // Título de la noticia
                    Text(
                      noticia["titulo"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), // Espacio entre título y descripción
                    // Descripción de la noticia
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
