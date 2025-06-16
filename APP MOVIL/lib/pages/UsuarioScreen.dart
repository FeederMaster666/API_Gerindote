import 'package:ayuntamiento_gerindote/pages/Login.dart';
import 'package:ayuntamiento_gerindote/pages/ProximamenteScreen.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart';
import 'package:flutter/material.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({super.key});
  //las imagenes importadas y el logout en assets dan error, no entiendo porque. En otro proyecto si funcionan
  // Lista de apartados con su imagen de asset y widget destino.
  static final List<_AjusteItem> items = [
    _AjusteItem('Mi cuenta', "lib/assets/icon_editarUsuario.png", ProximamenteScreen()),
    _AjusteItem('Mis reservas', "lib/assets/icon_historialCitasUsuario.png", ProximamenteScreen()),
    _AjusteItem('Pagos', "lib/assets/icon_pagosUsuario.png", ProximamenteScreen()),
    _AjusteItem('Mis acitividades', "lib/assets/icon_historialCitasUsuario.png", ProximamenteScreen()),
    _AjusteItem('Notificaciones', "lib/assets/icon_notificacionUsuario.png", ProximamenteScreen()),
    _AjusteItem('Ajustes', "lib/assets/icon_ajustesUsuario.png", ProximamenteScreen()),
    _AjusteItem('Ayuda', "lib/assets/icon_ayudaUsuario.png", ProximamenteScreen()),
    _AjusteItem('Cerrar sesión', "lib/assets/icon_cerrarSesion.png", null), // null para cerrar sesión
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Fondo de pantalla con imagen
          image: DecorationImage(
          image: NetworkImage("https://img.freepik.com/vector-gratis/fondo-tecnologia-abstracta-azul-degradado_23-2149213765.jpg?semt=ais_hybrid&w=740"),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Aquí podrías setear un fondo alternativo o loguear el error
              print("error con imagen de fondo");
            },
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    children: items.map((item) {
                      return _AjusteTile(item: item);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AjusteItem {
  final String titulo;
  final String assetIcono;
  final Widget? destino; // Widget destino, null si es cerrar sesión
  const _AjusteItem(this.titulo, this.assetIcono, this.destino);
}

class _AjusteTile extends StatelessWidget {
  final _AjusteItem item;
  _AjusteTile({required this.item});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        //si la ruta es null
        if (item.destino == null) {
          //muestra ventana emergente
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cerrar sesión'),
              content: const Text('¿Seguro que quieres cerrar sesión?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cerrar sesión')),
              ],
            ),
          );
          //si responde Cerrar Sesión
          if (confirmed == true) {
            try {
              // Borrar datos de sesión (SharedPreferences)
              _authService.logout();
              // Navegar al login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al cerrar sesión: $e')),
              );
            }
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.destino!),
          );
        }
      },
      //icono de cada secion y su titulo
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*Image.asset(
            item.assetIcono,
            width: 72, // Más grande, ajústalo a tu gusto
            height: 72,
            fit: BoxFit.contain,
          ),*/
          const SizedBox(height: 10),
          Text(
            item.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 3, color: Colors.black54, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
