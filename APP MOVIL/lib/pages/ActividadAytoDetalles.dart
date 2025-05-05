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
                      //Acción para reservar plazas en la actividad
                      showDialog(
                        context: context,
                        builder: (context) {
                          int plazas = 1; // Valor inicial
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text("Reservar plaza", 
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Plazas disponibles: 26", //obviamente aqui habria que coger el Nº de plazas real en una variable
                                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("Nº de plazas:", 
                                          style: TextStyle(fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 15),
                                        // Selector numérico
                                        Row(
                                          children: [
                                            //icono para restar plazas
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline,
                                                color: Colors.redAccent),
                                              onPressed: () {
                                                //condicional de que las plazas tienen que ser superior a 1
                                                if(plazas > 1) {
                                                  setState(() => plazas--);
                                                }
                                              },
                                            ),
                                            //Selección Nº plazas
                                            Text(" $plazas ", 
                                              style: const TextStyle(fontSize: 18)),
                                            //aumentar Nº Plazas
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline,
                                                color: Colors.green),
                                              onPressed: () {
                                                //Limitar Nº plazas(a elegir por el ayuntamiento)
                                                if(plazas < 5) { // Límite máximo de 5 plazas
                                                  setState(() => plazas++);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text("Persona a cargo de la reserva:", 
                                      style: TextStyle(fontSize: 15, color: Colors.black54)),
                                    const SizedBox(height: 8),
                                    // Datos ficticios (vendrían del perfil del usuario, a implementar con la lógica)
                                    //Usamos ListTile ya que es un widget perfecto para mostrar un icono a la izquierda 
                                    //y a la derecha una o varias filas de titulo y subtitulos
                                    const ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.person, size: 22),
                                      title: Text("Juan Pérez", 
                                        style: TextStyle(fontSize: 15)),
                                      subtitle: Text("juan.perez@email.com\nTel: 611 22 33 44",
                                        style: TextStyle(fontSize: 13)),
                                    ),
                                  ],
                                ),
                                //Botones cancelar y confirmar Reserva
                                actions: [
                                  //boton cancelar
                                  TextButton(
                                    //al presionar te devuelve a la pantalla, sin más
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("CANCELAR",
                                      style: TextStyle(color: Colors.grey)),
                                  ),
                                  //botón confirmar reserva
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                  // Al simular la confirmación lanza un snackBar que da una confirmación al usuario de que la reserva se ha realizado
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
                                          backgroundColor: Colors.green[700],
                                        ),
                                      );
                                    },
                                    child: const Text("CONFIRMAR RESERVA", 
                                      style: TextStyle(color: Colors.white)),
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
                const SizedBox(width: 10), // Espacio entre botones
                // Botón de contacto, ocupa la otra mitad
                // En tu archivo de pantalla de detalle

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
                      //modal bottom sheet con las opciones de contacto
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        backgroundColor: Colors.grey[900],
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                                // Teléfono
                                InkWell(
                                  onTap: () {
                                    // Aquí se podría hacer que te llevara a llamar por teléfono 
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.phone, color: Colors.white70),
                                        SizedBox(width: 12),
                                        Text(
                                          "925234567",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                                const SizedBox(height: 10),
                                // Email
                                InkWell(
                                  onTap: () {
                                    // Aquí se podría hacer que te llevara a enviar un mail
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.email, color: Colors.white70),
                                        SizedBox(width: 12),
                                        Text(
                                          "ayuntamientogerindote@gobEspaña.com",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
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