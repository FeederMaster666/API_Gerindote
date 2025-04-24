import 'package:ayuntamiento_gerindote/pages/PaginaActividades.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Reservas Ayuntamiento de Gerindote", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Acción al presionar el icono de usuario
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Primera instalación
          _buildInstallationCard(
            context,
            "Campo de fútbol",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/06/50876777_2089506224504444_8161060804456611840_n.jpg",
          ),
          _buildInstallationCard(
            context,
            "Gimnasio Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/06/51163570_2099973423457724_7665774040694390784_o.jpg?w=436&h=898",
          ),
          _buildInstallationCard(
            context,
            "Pabellón Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2015/08/45069012.jpg?w=600",
          ),
          _buildInstallationCard(
            context,
            "Piscina Municipal",
            "https://gerindote.wordpress.com/wp-content/uploads/2015/08/20150811_082033.jpg?w=600",
          ),
          _buildInstallationCard(
            context,
            "Pistas Exteriores",
            "https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0026.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildInstallationCard(BuildContext context, String title, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaginaActividades(title: title)),
        );
      },
      child: SizedBox(
        height: 131,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Contenedor centrado con el nombre y el botón
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Reservar",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}