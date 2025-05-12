import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/PaginaActividades.dart';

class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final List<Map<String, String>> noticias = [
    {
      "titulo": "La Romería de Gerindote ya cuenta con página web",
      "descripcion":
          "Ya está disponible la web oficial del evento para consultas y actividades.",
    },
    {
      "titulo": "Entrega de diplomas a la Asociación de Vecinos",
      "descripcion": "Reconocimiento a los miembros por su labor comunitaria.",
    },
    {
      "titulo": "Nuevo programa cultural en marcha",
      "descripcion": "Iniciativas culturales semanales para todas las edades.",
    },
    {
      "titulo": "Subvenciones para jóvenes emprendedores",
      "descripcion": "Se abre el plazo para solicitar ayudas municipales.",
    },
    {
      "titulo": "Plan municipal de sostenibilidad en marcha",
      "descripcion": "Acciones para un pueblo más verde y eficiente.",
    },
  ];
  int _selectedIndex = 1;

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inicio()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noticias"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return Card(
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
                    Text(
                      noticia["titulo"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      noticia["descripcion"]!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
        ],
      ),
    );
  }
}
