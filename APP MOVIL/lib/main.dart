import 'package:ayuntamiento_gerindote/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // 👈 Añadir esta línea

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Stripe: aquí el cliente solo necesita cambiar esta clave pública
  Stripe.publishableKey =
      'pk_test_XXXXXXXXXXXXXXXXXXXXXXXX'; // CAMBIAR POR CLAVE DEL CLIENTE
  await Stripe.instance.applySettings(); // 👈 Aplica la configuración

  runApp(MiApp());
}

// Clase principal de la aplicación
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.lightBlueAccent,
          selectionHandleColor: Colors.lightBlueAccent,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStatePropertyAll(Colors.white),
          side: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Mi App",
      home: Home(),
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
    return Scaffold(resizeToAvoidBottomInset: true, body: Login());
  }
}
