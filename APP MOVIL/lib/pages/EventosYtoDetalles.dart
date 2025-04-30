import 'package:ayuntamiento_gerindote/Clases/Eventos.dart';
import 'package:flutter/material.dart';

// Pantalla de detalle de un evento/actividad
class DetalleEventoScreen extends StatelessWidget {
  final Evento evento; // Recibe el evento a mostrar
  final String descripcion = '''Aprovecha esta actividad para que los niños disfruten de talleres, juegos y dinámicas mientras los adultos participan en las jornadas. Incluye monitores titulados, materiales y seguro de responsabilidad civil. ¡Plazas limitadas!
  Aprovecha esta actividad para que los niños disfruten de talleres, juegos y dinámicas mientras los adultos participan en las jornadas. Incluye monitores titulados, materiales y seguro de responsabilidad civil. ¡Plazas limitadas!.
  Aprovecha esta actividad para que los niños disfruten de talleres, juegos y dinámicas mientras los adultos participan en las jornadas. Incluye monitores titulados, materiales y seguro de responsabilidad civil. ¡Plazas limitadas!''';
  const DetalleEventoScreen({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el título del evento
      appBar: AppBar(
        title: Text(evento.titulo),
      ),
      // Cuerpo principal scrollable con margen lateral
      body: SingleChildScrollView(
        // Margen de 16px en todos los lados (izquierda, derecha, arriba, abajo)
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea todo a la izquierda
          children: [
            // Fila: Imagen a la izquierda, ubicación y aforo a la derecha
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen cuadrada con bordes redondeados
                //utilizamos el widget ClipRRect para recortar la imagen y añadirle bordes redondeados
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    color: Colors.grey[200], // Fondo gris claro si la imagen no carga
                    width: 70,
                    height: 70,
                    child: evento.imagenUrl != null
                        ? Image.network(
                            evento.imagenUrl!,
                            fit: BoxFit.cover, // La imagen cubre todo el contenedor
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 30), // Icono si falla la imagen
                          )
                        : const Icon(Icons.image, size: 30, color: Colors.grey), // Icono si no hay imagen
                  ),
                ),
                const SizedBox(width: 12), // Espacio entre imagen y texto
                // Columna: Ubicación (arriba) y aforo (abajo)
                //Se utiliza el widget Expanded para que el contenido ocupe todo el espacio disponible en la pantalla
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ubicación del evento (puede ocupar dos líneas)
                      Text(
                        evento.ubicacion,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      // Fila con icono de personas y aforo
                      Row(
                        children: [
                          Icon(Icons.people, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            '${evento.aforo}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18), // Espacio vertical entre filas

            // Fila de botones: "RESERVAR" y "CONTACTO"
            Row(
              children: [
                // Botón rojo de reservar, ocupa la mitad del ancho
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.event_available),
                    label: const Text("RESERVAR"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Color de fondo rojo
                      foregroundColor: Colors.white, // Texto e icono en blanco
                      minimumSize: const Size(0, 45), // Altura mínima
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)), // Bordes suaves
                      elevation: 0, // Sin sombra
                    ),
                    onPressed: () {
                      // Acción de reservar (por implementar)
                    },
                  ),
                ),
                const SizedBox(width: 10), // Espacio entre botones
                // Botón de contacto, ocupa la otra mitad
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.mail_outline),
                    label: const Text("CONTACTO"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87, // Color del texto e icono
                      side: const BorderSide(color: Colors.black26), // Borde gris claro
                      minimumSize: const Size(0, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    onPressed: () {
                      // Acción de contacto (por implementar)
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // --- Recuadro azul con descripción del evento ---
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.15), // Fondo azul claro
                borderRadius: BorderRadius.circular(10),
              ),
              // Scrollbar visible para la descripción si es larga
              child: Scrollbar(
                //thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Text(
                    descripcion,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- Línea fina divisoria (Divider) ---
            const Divider(),

            // --- Datos de contacto: teléfono ---
            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  925234567.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // --- Datos de contacto: email ---
            Row(
              children: [
                const Icon(Icons.email, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'ayuntamientogerindote@gobEspaña.com',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}