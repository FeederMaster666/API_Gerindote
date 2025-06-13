import 'package:flutter/material.dart';

class ProximamenteScreen extends StatelessWidget {
  final String mensaje;
  final String? assetIcono; // Se puede pasar el path de un icono personalizado

  const ProximamenteScreen({
    Key? key,
    this.mensaje = "¡Próximamente!",
    this.assetIcono,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      //Color fondo
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            assetIcono != null
                ? Image.asset(
                    assetIcono!,
                    width: 100,
                    height: 100,
                    color: Colors.green[700],
                  )
                : Icon(Icons.build, size: 100, color: Colors.green[700]),
            const SizedBox(height: 24),
            Text(
              mensaje,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Esta sección estará disponible en una próxima actualización.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
