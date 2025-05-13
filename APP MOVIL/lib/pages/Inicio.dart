import 'package:ayuntamiento_gerindote/pages/PaginaActividades.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';
import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/pages/ActividadAyto.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 1; // Inicio está en el centro

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Noticias
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Noticias()),
        );
        break;
      case 1: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio()),
        );
        break;
      case 2: // Eventos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventosAyto()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Reservas Ayuntamiento de Gerindote",
          style: TextStyle(color: Colors.white),
        ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
        ],
      ),
    );
  }

  Widget _buildInstallationCard(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaginaActividades(title: title),
          ),
        );
      },
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black87,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Reservar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
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
