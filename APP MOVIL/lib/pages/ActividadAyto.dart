import 'package:ayuntamiento_gerindote/services/ActividadesMunicipalesService.dart';
import 'package:ayuntamiento_gerindote/pages/ActividadAytoDetalles.dart';
import 'package:flutter/material.dart';

class EventosAyto extends StatefulWidget {
  const EventosAyto({super.key});

  @override
  _EventosAytoState createState() => _EventosAytoState();
}

class _EventosAytoState extends State<EventosAyto> {
  final ActividadesMunicipalesService _service = ActividadesMunicipalesService();

  late Future<List<dynamic>> _actividadesFuture;

  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, pide las actividades al backend
    _actividadesFuture = _service.getAllActividades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "Actividades Municipales",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario (por implementar)
            },
          ),
        ],
      ),
      // Usamos FutureBuilder para mostrar las actividades reales desde el backend
      body: FutureBuilder<List<dynamic>>(
        future: _actividadesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras llegan los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si la petición falla
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay actividades
            return Center(child: Text('No hay actividades disponibles.'));
          } else {
            // Si hay datos, construye la lista de actividades
            final actividades = snapshot.data!;
            return ListView.builder(
              itemCount: actividades.length,
              itemBuilder: (context, index) {
                final actividad = actividades[index];
                return _buildActividadCard(actividad);
              },
            );
          }
        },
      ),
    );
  }

  /// Construye la tarjeta para cada actividad usando los datos del backend
  Widget _buildActividadCard(Map<String, dynamic> actividad) {
    // Extraemos los campos necesarios
    final String titulo = actividad['titulo'] ?? 'Sin título';
    final String descripcion = actividad['descripcion'] ?? '';
    final String? imagenUrl = actividad['imagen'];
    final int plazasDisponibles = actividad['plazasDisponibles'] ?? 0;
    final int plazasTotales = actividad['plazasTotales'] ?? 0;
    final String ubicacion = actividad['ubicacion'] ?? 'Sin ubicación';
    final espacio = actividad['espacio'];
    final String fechaInicio = actividad['fechaInicio'] ?? '';
    // Puedes formatear la fecha a tu gusto

    return InkWell(
      onTap: () {
        // Navega a la pantalla de detalle pasando toda la actividad
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleActividadScreen(actividad: actividad),
          ),
        );
      },
      borderRadius: BorderRadius.circular(0),
      splashColor: Colors.blueAccent.withOpacity(0.1),
      highlightColor: Colors.blueAccent.withOpacity(0.05),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _getColorForAforo(plazasDisponibles, plazasTotales),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de portada de la actividad
                if (imagenUrl != null && imagenUrl.isNotEmpty)
                  Container(
                    width: 65,
                    height: 65,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        // Si la imagen es relativa, añade el host
                        imagenUrl.startsWith('http')
                            ? imagenUrl
                            : 'http://10.0.2.2:3000$imagenUrl',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.broken_image, size: 30),
                            ),
                      ),
                    ),
                  ),
                // Contenido principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Ubicación
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red[400],
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              ubicacion,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Fila inferior: plazas y fecha
                      Row(
                        children: [
                          Icon(Icons.people, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '$plazasDisponibles/$plazasTotales plazas',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formateaFecha(fechaInicio),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Devuelve un color según el porcentaje de plazas disponibles
  Color _getColorForAforo(int disponibles, int totales) {
    if (totales == 0) return Colors.grey;
    final porcentaje = disponibles / totales;
    if (porcentaje < 0.2) return Colors.red;
    if (porcentaje < 0.5) return Colors.orange;
    return Colors.green;
  }

  // Formatea la fecha ISO a dd/MM/yyyy (puedes mejorar este método)
  String _formateaFecha(String iso) {
    if (iso.isEmpty) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

