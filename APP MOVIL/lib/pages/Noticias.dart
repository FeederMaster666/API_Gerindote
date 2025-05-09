import 'package:flutter/material.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final List<Map<String, String>> noticias = [
    {
      "titulo": "La Romería de Gerindote ya cuenta con página web",
      "categoria": "Festejos",
    },
    {
      "titulo": "Entrega de diplomas a la Asociación de Vecinos",
      "categoria": "General",
    },
    {"titulo": "Nuevo programa cultural en marcha", "categoria": "Cultura"},
    {
      "titulo": "Subvenciones para jóvenes emprendedores",
      "categoria": "Economía",
    },
    {
      "titulo": "Plan municipal de sostenibilidad en marcha",
      "categoria": "Medio Ambiente",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Ayuntamiento de Gerindote",
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
        actions: [
          // IconButton para el icono de usuario
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario (por implementar)
            },
          ),
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Últimas noticias",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: noticias.length,
                itemBuilder: (context, index) {
                  final noticia = noticias[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        noticia["titulo"]!,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(noticia["categoria"]!),
                      leading: Icon(
                        Icons.article_outlined,
                        color: Colors.lightBlueAccent,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Acción futura: navegar a detalle de noticia
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
