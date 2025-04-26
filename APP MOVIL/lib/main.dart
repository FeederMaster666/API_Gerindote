import 'package:ayuntamiento_gerindote/pages/Login.dart';
import 'package:ayuntamiento_gerindote/pages/Login2.dart';
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
theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlueAccent, // Cambia esto a tu color principal
          ),
          useMaterial3: true, // Si usas Material 3
        // Personaliza el color del cursor y selección de texto
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, // Color del cursor
          selectionColor: Colors.lightBlueAccent, // Color de selección de texto
          selectionHandleColor: Colors.lightBlueAccent, // Color del "handle"
        ),
        // Personaliza el color de los checkbox
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStatePropertyAll(Colors.white),
          //modificar borde cehckbox
          side: const BorderSide(
            color: Colors.black, // Border color
            width: 1.5,
          ),
        ),
      ),
        
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
body: Login2(), // Carga la pantalla de login
);
}
}
