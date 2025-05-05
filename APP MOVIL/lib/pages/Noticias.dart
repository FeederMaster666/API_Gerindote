import 'package:flutter/material.dart';

class Noticias extends StatelessWidget {
  final List<Map<String, String>> noticias = [
    {
      "titulo": "La Romería de Gerindote ya cuenta con página web",
      "categoria": "Festejos",
      "imagen": "APP MOVIL\lib\assets\gerindote.png",
    },
    {
      "titulo": "Entrega de diplomas a la Asociación de Vecinos",
      "categoria": "General",
      "imagen": "APP MOVIL\lib\assets\gerindote.png",
    },
    {
      "titulo": "Nuevo programa cultural en marcha",
      "categoria": "Cultura",
      "imagen": "APP MOVIL\lib\assets\gerindote.png",
    },
    {
      "titulo": "Subvenciones para jóvenes emprendedores",
      "categoria": "Economía",
      "imagen": "APP MOVIL\lib\assets\gerindote.png",
    },
    {
      "titulo": "Plan municipal de sostenibilidad en marcha",
      "categoria": "Medio Ambiente",
      "imagen": "APP MOVIL\lib\assets\gerindote.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ayuntamiento de Gerindote")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            SizedBox(height: 12),
            Expanded(child: buildVerticalNewsList()),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Últimas noticias",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          "Ver todo",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget buildVerticalNewsList() {
    return ListView.builder(
      itemCount: noticias.length,
      itemBuilder: (context, index) {
        final noticia = noticias[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    noticia["imagen"]!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noticia["categoria"]!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        noticia["titulo"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
