import 'package:ayuntamiento_gerindote/pages/CrearActividad.dart';
import 'package:ayuntamiento_gerindote/pages/UsuarioScreen.dart';
import 'package:ayuntamiento_gerindote/services/ActividadesMunicipalesService.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart';
import 'package:ayuntamiento_gerindote/pages/ActividadAytoDetalles.dart';
import 'package:flutter/material.dart';

/// Pantalla principal que lista todas las actividades municipales.
/// Permite a los usuarios ver las actividades y, si tienen rol admin,
/// pueden añadir nuevas actividades o eliminar existentes.
class EventosAyto extends StatefulWidget {
  const EventosAyto({super.key});

  @override
  _EventosAytoState createState() => _EventosAytoState();
}

class _EventosAytoState extends State<EventosAyto> {
  final ActividadesMunicipalesService _service = ActividadesMunicipalesService();
  final AuthService _authService = AuthService();
  late Future<List<dynamic>> _actividadesFuture;
  String? _userRol;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _reloadActividades();
  }

  /// Obtiene el rol del usuario logueado desde SharedPreferences
  void _loadUserRole() async {
    final rol = await _authService.getUserRol();
    setState(() {
      _userRol = rol;
    });
  }

  /// Recarga la lista de actividades desde el backend
  void _reloadActividades() {
    setState(() {
      _actividadesFuture = _service.getAllActividades();
    });
  }

  /// Elimina una actividad por su ID y recarga la lista
  Future<void> _eliminarActividad(String actividadId) async {
    try {
      await _service.eliminarActividad(actividadId);
      _reloadActividades();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actividad eliminada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsuarioScreen()),
              );
            },
          ),
        ],
      ),
      // Botón flotante de añadir actividad, solo visible para admin
      floatingActionButton: _userRol == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                // Navega a la pantalla de creación de actividad
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrearActividadScreen(),
                  ),
                ).then((_) => _reloadActividades()); // Recarga al volver
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            )
          : null,
      // Muestra la lista de actividades usando FutureBuilder
      body: FutureBuilder<List<dynamic>>(
        future: _actividadesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Indicador de carga mientras llegan los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Mensaje de error si falla la petición
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Mensaje si no hay actividades
            return const Center(child: Text('No hay actividades disponibles.'));
          } else {
            // Construye la lista de tarjetas de actividades
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

  /// Construye la tarjeta visual para cada actividad
  Widget _buildActividadCard(Map<String, dynamic> actividad) {
    final String titulo = actividad['titulo'] ?? 'Sin título';
    final String? imagenUrl = actividad['imagen'];
    final int plazasOcupadas = actividad['plazasOcupadas'] ?? 0;
    final int plazasTotales = actividad['plazasTotales'] ?? 0;
    final String ubicacion = actividad['ubicacion'] ?? 'Sin ubicación';
    final String fechaInicio = actividad['fechaInicio'] ?? '';

    return InkWell(
      onTap: () {
        // Navega a la pantalla de detalle de la actividad
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleActividadScreen(actividad: actividad),
          ),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _getColorForAforo(plazasOcupadas, plazasTotales),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de portada de la actividad, si existe
                if (imagenUrl != null && imagenUrl.isNotEmpty)
                  _buildImagenActividad(imagenUrl),
                // Contenido textual de la tarjeta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderActividad(titulo, actividad['_id']),
                      const SizedBox(height: 6),
                      _buildUbicacion(ubicacion),
                      const SizedBox(height: 8),
                      _buildInfoPlazasYFecha(plazasOcupadas, plazasTotales, fechaInicio),
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

  /// Construye la miniatura de la imagen de portada
  Widget _buildImagenActividad(String imagenUrl) {
    return Container(
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
          imagenUrl.startsWith('http') 
              ? imagenUrl 
              : 'http://10.0.2.2:3000$imagenUrl',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, size: 30)),
        ),
      ),
    );
  }

  /// Construye la cabecera de la tarjeta (título y botón eliminar si es admin)
  Widget _buildHeaderActividad(String titulo, String actividadId) {
    return Row(
      children: [
        Expanded(
          child: Text(
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
        ),
        // Botón de eliminar solo visible para admin
        if (_userRol == 'admin')
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmarEliminacion(actividadId),
          ),
      ],
    );
  }

  /// Muestra la ubicación de la actividad
  Widget _buildUbicacion(String ubicacion) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 18, color: Colors.red[400]),
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
    );
  }

  /// Muestra la información de plazas y la fecha de inicio
  Widget _buildInfoPlazasYFecha(int ocupadas, int totales, String fecha) {
    return Row(
      children: [
        Icon(Icons.people, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$ocupadas/$totales plazas',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          _formateaFecha(fecha),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Diálogo de confirmación antes de eliminar una actividad
  void _confirmarEliminacion(String actividadId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar actividad'),
        content: const Text('¿Estás seguro de que quieres eliminar esta actividad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _eliminarActividad(actividadId);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  /// Devuelve un color según el porcentaje de plazas ocupadas
  Color _getColorForAforo(int ocupadas, int totales) {
    if (totales == 0) return Colors.grey;
    final porcentaje = ocupadas / totales;
    if (porcentaje < 0.2) return Colors.red;
    if (porcentaje < 0.5) return Colors.orange;
    return Colors.green;
  }

  /// Formatea la fecha ISO a dd/MM/yyyy
  String _formateaFecha(String iso) {
    if (iso.isEmpty) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}



