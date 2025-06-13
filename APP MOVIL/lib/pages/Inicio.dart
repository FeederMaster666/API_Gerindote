// Importa la pantalla de actividades específicas
import 'package:ayuntamiento_gerindote/pages/PaginaActividades.dart';
// Importa el paquete principal de Flutter para usar widgets de interfaz
import 'package:flutter/material.dart';

// Clase principal del widget de la página de inicio, que es un StatefulWidget porque su estado puede cambiar
class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

// Clase del estado del widget Inicio
class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar en la parte superior de la pantalla
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Evita que se muestre el botón de "volver" por defecto
        backgroundColor: Colors.blueAccent, // Color de fondo del AppBar
        centerTitle: true, // Centra el título en el AppBar
        title: const Text(
          "Reservas Ayuntamiento", // Título del AppBar
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 20, // Tamaño del texto
            fontWeight: FontWeight.bold, // Grosor del texto
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45, // Sombra negra semitransparente
                offset: Offset(1, 2), // Posición de la sombra
                blurRadius: 4, // Difuminado de la sombra
              ),
            ],
          ),
        ),
        // Acciones en la parte derecha del AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario (a implementar)
              
            },
          ),
        ],
      ),
      // Cuerpo principal de la pantalla: una lista desplazable de instalaciones
      body: ListView(
        children: [
          // Tarjetas de instalaciones disponibles con sus imágenes y nombres
          _buildInstallationCard(
            context,
            "Campo de fútbol",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/06/50876777_2089506224504444_8161060804456611840_n.jpg",
          ),
          _buildInstallationCard(
            context,
            "Gimnasio Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/06/51163570_2099973423457724_7665774040694390784_o.jpg?w=436&h=898",
          ),
          _buildInstallationCard(
            context,
            "Pabellón Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2015/08/45069012.jpg?w=600",
          ),
          _buildInstallationCard(
            context,
            "Piscina Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2015/08/20150811_082033.jpg?w=600",
          ),
          _buildInstallationCard(
            context,
            "Pistas Exteriores",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0026.jpg",
          ),
        ],
      ),
    );
  }

  // Método que construye una tarjeta interactiva para cada instalación
  Widget _buildInstallationCard(
    BuildContext context,
    String title, // Título de la instalación
    String imageUrl, // URL de la imagen de la instalación
  ) {
    return GestureDetector(
      // Al tocar la tarjeta, navega a la pantalla PaginaActividades con el nombre de la instalación
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaginaActividades(title: title),
          ),
        );
      },
      child: SizedBox(
        height: 200, // Altura de la tarjeta
        width: double.infinity, // Ocupa todo el ancho posible
        child: Stack(
          fit: StackFit.expand, // Hace que los hijos ocupen todo el espacio
          children: [
            // Imagen de fondo de la tarjeta
            Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
            // Capa de sombra con degradado para mejorar legibilidad del texto
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4), // Parte inferior más oscura
                    Colors.black.withOpacity(0.1), // Parte superior más clara
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Texto centrado con el nombre de la instalación y botón "Reservar"
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrado vertical
                children: [
                  Text(
                    title, // Nombre de la instalación
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black87,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ), // Espaciado entre el título y el botón
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.8,
                      ), // Fondo blanco semitransparente
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Bordes redondeados
                    ),
                    child: const Text(
                      "Reservar", // Texto del botón
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
