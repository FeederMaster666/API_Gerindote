import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/PantallaReserva.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart'; // Asumo que AuthService está aquí
import 'package:shared_preferences/shared_preferences.dart';

class PaginaActividades extends StatefulWidget {
  final String title;

  const PaginaActividades({Key? key, required this.title}) : super(key: key);

  @override
  _PaginaActividadesState createState() => _PaginaActividadesState();
}

class _PaginaActividadesState extends State<PaginaActividades> {
  final AuthService _authService = AuthService();

  List<dynamic> espacios = [];
  bool isLoading = true;
  String? errorMessage;

  String? usuarioId;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchEspacios();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email');
      usuarioId = prefs.getString(
        'user_id',
      ); // <-- Necesitas guardar el id en SharedPreferences cuando inicies sesión
    });
  }

  Future<void> _fetchEspacios() async {
    try {
      final data = await _authService.getEspaciosPorTipo(widget.title);
      setState(() {
        espacios = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
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
              // Acción futura (a definir)
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : espacios.isEmpty
              ? const Center(child: Text("No hay actividades disponibles."))
              : ListView.builder(
                itemCount: espacios.length,
                itemBuilder: (context, index) {
                  final espacio = espacios[index];
                  return _buildActivityCard(
                    context,
                    espacio['nombre'] ?? 'Nombre desconocido',
                    espacio['imagen'] ?? '',
                  );
                },
              ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    String activityName,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey.shade200, width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              radius: 30,
              child:
                  imageUrl.isEmpty
                      ? const Icon(Icons.image_not_supported)
                      : null,
            ),
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
                if (usuarioId == null || userEmail == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario no autenticado')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PantallaReserva(
                          nombreActividad: activityName,
                          espacio: {'nombre': widget.title},
                          usuarioId: usuarioId!,
                          email: userEmail!,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              child: const Text(
                "Seleccionar",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
