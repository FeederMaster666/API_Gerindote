import 'package:ayuntamiento_gerindote/pages/ActividadAyto.dart';
import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/Noticias.dart';
import 'package:flutter/material.dart';

// Esta clase gestiona la navegación de la App por índices para optimizar el rendimiento
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Inicio será la pantalla predeterminada

  // Devuelve el body según la pestaña seleccionada
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Inicio(); // Ahora es el primer índice
      case 1:
        return EventosAyto();
      case 2:
        return Noticias();
      default:
        return Inicio(); // Fallback a Inicio
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
        ],
      ),
    );
  }
}
