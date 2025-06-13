import 'dart:convert';

import 'package:ayuntamiento_gerindote/pages/ReservaActividadDialog.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:http/http.dart' as http;
// Importa tu AuthService o método para obtener usuario logueado

class DetalleActividadScreen extends StatelessWidget {
  final Map<String, dynamic> actividad;

  const DetalleActividadScreen({Key? key, required this.actividad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String titulo = actividad['titulo'] ?? 'Sin título';
    final String descripcion = actividad['descripcion'] ?? 'Sin descripción';
    final String? imagenUrl = actividad['imagen'];
    final List<dynamic> imagenesCarrusel = actividad['imagenes'] ?? [];
    final int plazasOcupadas = actividad['plazasOcupadas'] ?? 0;
    final int plazasTotales = actividad['plazasTotales'] ?? 0;
    final String ubicacion = actividad['ubicacion'] ?? 'Sin ubicación';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: imagen de portada, ubicación y plazas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    color: Colors.grey[200],
                    width: 70,
                    height: 70,
                    child: imagenUrl != null && imagenUrl.isNotEmpty
                        ? Image.network(
                            imagenUrl.startsWith('http')
                                ? imagenUrl
                                : 'http://10.0.2.2:3000$imagenUrl',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 30),
                          )
                        : const Icon(Icons.image, size: 30, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ubicación de la actividad
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
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Plazas ocupadas y totales
                      Row(
                        children: [
                          Icon(Icons.people, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            '$plazasOcupadas/$plazasTotales plazas',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Botones de reservar y contacto
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.event_available),
                    label: const Text("RESERVAR"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      // 1. Obtener email del usuario logueado
                      final authService = AuthService();
                      final email = await authService.getUserEmail();
                      if (email == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debes iniciar sesión para reservar'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // 2. Obtener datos completos del usuario por email
                      final userResponse = await http.get(
                        Uri.parse('${AuthService.baseUrl}/users/mobile/email/$email'),
                        headers: {'Content-Type': 'application/json'},
                      );
                      if (userResponse.statusCode != 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo cargar el usuario'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final userData = json.decode(userResponse.body);

                      // 3. Abrir el diálogo de reserva con los datos reales
                      showDialog(
                        context: context,
                        builder: (context) => ReservaActividadDialog(
                          actividad: actividad,
                          usuarioId: userData['_id'],
                          nombre: userData['name'] ?? '',
                          apellidos: userData['apellidos'] ?? '',
                          email: userData['email'] ?? '',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.mail_outline),
                    label: const Text("CONTACTO"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.black26),
                      minimumSize: const Size(0, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      // Modal con opciones de contacto
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        backgroundColor: Colors.grey[900],
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Vías de contacto",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.phone, color: Colors.white70),
                                        SizedBox(width: 12),
                                        Text("925234567", style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.email, color: Colors.white70),
                                        SizedBox(width: 12),
                                        Text("ayuntamientogerindote@gobEspaña.com", style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Recuadro azul con la descripción de la actividad
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Text(
                    descripcion,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Carrusel de imágenes reales de la actividad (si existen)
            if (imagenesCarrusel.isNotEmpty)
              cs.CarouselSlider(
                options: cs.CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: imagenesCarrusel.map<Widget>((img) {
                  final imgUrl = (img as String).startsWith('http')
                      ? img
                      : 'http://10.0.2.2:3000$img';
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                                ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}