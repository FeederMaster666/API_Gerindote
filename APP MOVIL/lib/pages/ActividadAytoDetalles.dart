import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

// Pantalla de detalle de una actividad municipal
class DetalleActividadScreen extends StatelessWidget {
  final Map<String, dynamic> actividad; // Recibe la actividad del backend

  const DetalleActividadScreen({Key? key, required this.actividad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extrae los datos necesarios de la actividad
    final String titulo = actividad['titulo'] ?? 'Sin título';
    final String descripcion = actividad['descripcion'] ?? 'Sin descripción';
    final String? imagenUrl = actividad['imagen'];
    final List<dynamic> imagenesCarrusel = actividad['imagenes'] ?? [];
    final int plazasOcupadas = actividad['plazasOcupadas'] ?? 0;
    final int plazasTotales = actividad['plazasTotales'] ?? 0;
    final espacio = actividad['espacio'];
    final String ubicacion = actividad['ubicacion'] ?? 'Sin ubicación';
    final String fechaInicio = actividad['fechaInicio'] ?? '';
    // Puedes formatear la fecha a tu gusto

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
            // Fila: imagen de portada, ubicación y plazas
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
            // Botones de reservar y contacto (puedes adaptar la lógica)
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
                    onPressed: () {
                      // Aquí iría la lógica real de reserva
                      showDialog(
                        context: context,
                        builder: (context) {
                          int plazas = 1;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text(
                                  "Reservar plaza",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Plazas ocupadas: $plazasOcupadas",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text(
                                          "Nº de plazas:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () {
                                                if (plazas > 1) {
                                                  setState(() => plazas--);
                                                }
                                              },
                                            ),
                                            Text(
                                              " $plazas ",
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                if (plazas < plazasOcupadas) {
                                                  setState(() => plazas++);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Persona a cargo de la reserva:",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Aquí deberías mostrar los datos reales del usuario logueado
                                    const ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.person, size: 22),
                                      title: Text(
                                        "Juan Pérez",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      subtitle: Text(
                                        "juan.perez@email.com\nTel: 611 22 33 44",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "CANCELAR",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                              const SizedBox(width: 8),
                                              Text("Reserva confirmada para $plazas personas"),
                                            ],
                                          ),
                                          backgroundColor: Colors.blueAccent[700],
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "CONFIRMAR RESERVA",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
            // Recuadro azul con la descripción real de la actividad
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
            // Carrusel de imágenes reales de la actividad
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
