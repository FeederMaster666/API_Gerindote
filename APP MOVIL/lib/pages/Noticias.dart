import 'package:ayuntamiento_gerindote/pages/CrearNoticia.dart';
import 'package:ayuntamiento_gerindote/pages/UsuarioScreen.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart';
import 'package:ayuntamiento_gerindote/services/NoticiasService.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Widget principal de la pantalla de noticias
class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  // Instancia del servicio para acceder a los endpoints de noticias
  final NoticiasService _newsService = NoticiasService();
  final AuthService _authService = AuthService();

  String? userRol;
  late Future<List<dynamic>> noticiasFuture;

  @override
  void initState() {
    super.initState();
    // Carga el rol del usuario y la lista de noticias al iniciar la pantalla
    _loadUserRol();
    _reloadNoticias();
  }

  // Obtiene el rol del usuario desde SharedPreferences
  Future<void> _loadUserRol() async {
    final rol = await _authService.getUserRol();
    setState(() {
      userRol = rol;
    });
  }

  // Recarga la lista de noticias (útil tras eliminar/crear)
  void _reloadNoticias() {
    setState(() {
      noticiasFuture = _newsService.fetchAllNews();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No muestra la flecha de "volver"
        centerTitle: true, // Centra el título
        title: const Text(
          "Noticias y Eventos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción futura para el icono de usuario
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsuarioScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // FutureBuilder permite construir la UI en función del estado de la petición asíncrona
        child: FutureBuilder<List<dynamic>>(
          future: _newsService.fetchAllNews(), // Llama al método que obtiene las noticias del backend
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras espera la respuesta
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Muestra un mensaje si ocurre un error en la petición
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Muestra un mensaje si no hay noticias disponibles
              return Center(child: Text('No hay noticias disponibles.'));
            } else {
              // Si hay datos, construye la lista de noticias
              final noticias = snapshot.data!;
              return ListView.builder(
                itemCount: noticias.length,
                itemBuilder: (context, index) {
                  final noticia = noticias[index];
                  return _buildNoticiaCard(noticia); // Construye cada card de noticia
                },
              );
            }
          },
        ),
      ),
      // Botón flotante solo visible para admin
      floatingActionButton: userRol == 'admin'
          ? FloatingActionButton(
            onPressed: () async {
              // Navega a la pantalla de creación de noticia y recarga si vuelve con éxito
              final creado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminCrearNoticiaScreen()),
              );
              if (creado == true) {
                _reloadNoticias();
              }
            },
            child: Icon(Icons.add),
            tooltip: 'Crear noticia',
          )
          : null,
    );
  }

  /// Construye la tarjeta visual de una noticia a partir de un mapa dinámico recibido del backend.
  /// Si la noticia no tiene imagen, muestra el icono de error.
  /// Al pulsar la card, abre el enlace de la noticia en el navegador.
  Widget _buildNoticiaCard(Map<String, dynamic> noticia) {
    // Comprueba si hay imagen
    final String? imagenPath = noticia["imagen"];
    //comprueba si hay url
    final bool tieneImagen = imagenPath != null && imagenPath.isNotEmpty;
    final String imagenUrl = tieneImagen
        ? 'http://10.0.2.2:3000$imagenPath' // Construye la URL completa de la imagen
        : "";

    // Función para abrir el enlace de la noticia en el navegador externo
    void _abrirEnlace() async {
      final String? url = noticia["enlace"];
      if (url != null && url.isNotEmpty) {
        final uri = Uri.parse(url);
        try {
          final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!launched) {
            // Si no se pudo abrir, muestra un mensaje
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo abrir el enlace')),
            );
          }
        } catch (e) {
          // Si ocurre una excepción, muestra un mensaje
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo abrir el enlace')),
          );
        }
      }
    }

    // Acción para eliminar la noticia (solo admin)
    void _eliminarNoticia() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eliminar noticia'),
          content: Text('¿Estás seguro de que quieres eliminar esta noticia?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
      if (confirm == true) {
        try {
          await _newsService.deleteNews(noticia['_id']);
          _reloadNoticias();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Noticia eliminada')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la noticia')),
          );
        }
      }
    }

    return GestureDetector(
      onTap: _abrirEnlace, // Al pulsar la card, intenta abrir el enlace
      child: Card(
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
              // Imagen de portada de la noticia o icono de error si no hay imagen
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen o icono de error
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: tieneImagen
                          ? Image.network(
                              imagenUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: Center(child: Icon(Icons.broken_image, size: 48)),
                              ),
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(child: Icon(Icons.broken_image, size: 48)),
                            ),
                    ),
                  ),
                  // Botón de eliminar solo si el usuario es admin
                  if (userRol == 'admin')
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar noticia',
                      onPressed: _eliminarNoticia,
                    ),
                ],
              ),
              SizedBox(height: 10),
              // Título de la noticia
              Text(
                noticia["titulo"] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Descripción de la noticia
              Text(
                noticia["descripcion"] ?? '',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
