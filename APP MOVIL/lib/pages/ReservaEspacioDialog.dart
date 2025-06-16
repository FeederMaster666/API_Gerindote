import 'package:flutter/material.dart';
import 'package:ayuntamiento_gerindote/services/reservaEspacios.dart';

class ReservaEspacioDialog extends StatefulWidget {
  final String espacio;
  final String email;
  final String nombre;
  final String apellidos;
  final DateTime fecha;
  final String hora;

  const ReservaEspacioDialog({
    Key? key,
    required this.espacio,
    required this.email,
    required this.nombre,
    required this.apellidos,
    required this.fecha,
    required this.hora,
  }) : super(key: key);

  @override
  State<ReservaEspacioDialog> createState() => _ReservaEspacioDialogState();
}

class _ReservaEspacioDialogState extends State<ReservaEspacioDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Confirmar reserva",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Espacio: ${widget.espacio}"),
          const SizedBox(height: 10),
          Text("Fecha: ${widget.fecha.toLocal().toString().split(' ')[0]}"),
          Text("Hora: ${widget.hora}"),
          const SizedBox(height: 20),
          const Text(
            "Persona a cargo de la reserva:",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person),
            title: Text("${widget.nombre} ${widget.apellidos}"),
            subtitle: Text(widget.email),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              _isLoading
                  ? null
                  : () async {
                    setState(() => _isLoading = true);
                    try {
                      final reservaService = ReservaEspaciosService();
                      await reservaService.crearReservaEspacio(
                        email: widget.email,
                        nombre: widget.espacio,
                        fecha: widget.fecha,
                        hora: widget.hora,
                        metodoPago: 'metalico',
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text("Reserva confirmada"),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al reservar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
          child:
              _isLoading
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    "CONFIRMAR RESERVA",
                    style: TextStyle(color: Colors.white),
                  ),
        ),
      ],
    );
  }
}
