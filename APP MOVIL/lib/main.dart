import 'package:ayuntamiento_gerindote/pages/Login.dart';
import 'package:flutter/material.dart';

// Punto de entrada de la aplicación
void main() => runApp(MiApp());

// Clase principal de la aplicación
class MiApp extends StatelessWidget {
const MiApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false, // Oculta la etiqueta de "debug" en la app
title: "Mi App", // Título de la aplicación
home: Home(), // Página principal que se mostrará al iniciar
);
}
}

// Widget de estado mutable para la pantalla principal
class Home extends StatefulWidget {
const Home({super.key});

@override
_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
@override
Widget build(BuildContext context) {
return Scaffold(
resizeToAvoidBottomInset: true, // Ajusta el diseño cuando aparece el teclado
body: Login(), // Carga la pantalla de login
);
}
}
