import 'package:ayuntamiento_gerindote/pages/ActividadAyto.dart';
import 'package:ayuntamiento_gerindote/pages/Espacios.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';
import 'package:flutter/material.dart';
//Esta clase gestion la navegación de la App por índices para optimizar el rendimiento
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Devuelve el body según la pestaña seleccionada
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Noticias();
      case 1:
        return Espacios();
      case 2:
        return EventosAyto();
      case 3:
        return Noticias();//Por ahora no hay nada. Posible lugares de interés?
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Actividades'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Proximamente'),
        ],
      ),
    );
  }
}