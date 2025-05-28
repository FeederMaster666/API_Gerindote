import 'package:ayuntamiento_gerindote/Clases/Eventos.dart';

import 'package:ayuntamiento_gerindote/pages/ActividadAytoDetalles.dart';
import 'package:flutter/material.dart';

class EventosAyto extends StatefulWidget {
  const EventosAyto({super.key});

  @override
  _EventosAytoState createState() => _EventosAytoState();
}

class _EventosAytoState extends State<EventosAyto> {
  //lista eventos
  final List<Evento> eventos = [
    Evento(
      titulo: 'Padel Club Parque San José STRP',
      ubicacion: 'San José, Uruguay',
      fecha: '28 Abr, 2025',
      aforo: 3,
      imagenUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Sasso_lungo_da_passo_pordoi.jpg/270px-Sasso_lungo_da_passo_pordoi.jpg',
    ),
    Evento(
      titulo: 'Centros DEMO en San José de Mayo',
      ubicacion: 'San José, Uruguay',
      fecha: '30 Abr, 2025',
      aforo: 2,
      imagenUrl:
          'https://plus.unsplash.com/premium_photo-1677347335105-1bd16607a25e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bmF0dXJhbGV6YSUyMHBhaXNhamV8ZW58MHx8MHx8fDA%3D',
    ),
    Evento(
      titulo: 'Aulas de Conciliación Aracena. Colaboratorias',
      ubicacion: 'Aracena (Huelva)',
      fecha: '5 May, 2025',
      aforo: 26,
      imagenUrl:
          'https://www.dzoom.org.es/wp-content/uploads/2017/07/seebensee-2384369-810x540.jpg',
    ),
    Evento(
      titulo: 'C.D Tenis Pádel Sevilla',
      ubicacion: 'Alcalá de Guadaíra (Sevilla)',
      fecha: '12 May, 2025',
      aforo: 3016,
      imagenUrl:
          'https://plus.unsplash.com/premium_photo-1709579654090-3f3ca8f8416b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bmF0dXJhbGV6YSUyMHBhaXNhamV8ZW58MHx8MHx8fDA%3D',
    ),
    Evento(
      titulo: 'Club Pádel Rosario',
      ubicacion: 'Villanueva del Rosario (Málaga)',
      fecha: '15 May, 2025',
      aforo: 150,
      imagenUrl:
          'https://definicion.de/wp-content/uploads/2009/12/paisaje-1.jpg',
    ),
    Evento(
      titulo: 'Club Pádel Rosario',
      ubicacion: 'Villanueva del Rosario (Málaga)',
      fecha: '15 May, 2025',
      aforo: 150,
      imagenUrl:
          'https://concepto.de/wp-content/uploads/2015/03/paisaje-e1549600034372.jpg',
    ),
    Evento(
      titulo: 'Club Pádel Rosario',
      ubicacion: 'Villanueva del Rosario (Málaga)',
      fecha: '15 May, 2025',
      aforo: 150,
      imagenUrl:
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgeFsqiCZ9dqC9CCNb3vqhLOyWcdU0PV0UtYiVs_PuanxtUaGsDxcL-1nJdA2zTY2tztBPzup8mp4ZejXZkIs0ZioYBVYGxk8E8XLxUhmSJIKYgKWbIMutaH0uDYJfvdnpNJn_gXTyGJJ0/w1200-h630-p-k-no-nu/02273+paisajes01.jpg',
    ),
    Evento(
      titulo: 'Club Pádel Rosario',
      ubicacion: 'Villanueva del Rosario (Málaga)',
      fecha: '15 May, 2025',
      aforo: 150,
      imagenUrl:
          'https://s1.significados.com/foto/paisaje-og.jpg?class=ogImageWide',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //quitar la backArrow
        automaticallyImplyLeading: false,
        // Color de fondo azul claro
        backgroundColor: Colors.blueAccent,
        // Título del AppBar con estilo de texto
        centerTitle: true,
        title: const Text(
          "Actividades Municipales",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        // Acciones en la parte derecha del AppBar
        actions: [
          // IconButton para el icono de usuario
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario (por implementar)
            },
          ),
        ],
      ),
      //recorremos la lista de eventos y devolvemos una tarjeta por cada uno
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];
          return _buildEventCard(evento);
        },
      ),
    );
  }

  //Widget para construir la tarjeta de cada evento
  Widget _buildEventCard(Evento evento) {
    //InWell hace que sea clickable y con animación
    return InkWell(
      onTap: () {
        // Navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleEventoScreen(evento: evento),
          ),
        );
      },
      borderRadius: BorderRadius.circular(0),
      splashColor: Colors.blueAccent.withOpacity(0.1),
      highlightColor: Colors.blueAccent.withOpacity(0.05),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ), //margen tarjeta
        //forma, tarjeta con bordes redondos
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Container(
          //barra lateral segun el color de aforo, prescindible. Podría quedar como decoración sino.
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _getColorForAforo(evento.aforo),
                width: 4,
              ),
            ),
          ),
          //padding tarjeta
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con borde sutil
                if (evento.imagenUrl != null)
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
                        evento.imagenUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 30),
                            ),
                      ),
                    ),
                  ),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título con máximo 2 líneas
                      Text(
                        evento.titulo,
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

                      // Ubicación con icono mejorado
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
                              evento.ubicacion,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Fila inferior
                      Row(
                        children: [
                          // Aforo
                          Icon(Icons.people, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${evento.aforo} personas',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),

                          const Spacer(),

                          // Fecha
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            evento.fecha,
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

  // Método auxiliar para colores según aforo, en un futuro iría con porcentajes para indicar actividades a punto de llenarse
  Color _getColorForAforo(int aforo) {
    if (aforo < 50) return Colors.red;
    if (aforo < 200) return Colors.orange;
    return Colors.green;
  }
}
