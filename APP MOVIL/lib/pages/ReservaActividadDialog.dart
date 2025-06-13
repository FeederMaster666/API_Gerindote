import 'package:ayuntamiento_gerindote/services/reservaActividades.dart';
import 'package:flutter/material.dart';

class ReservaActividadDialog extends StatefulWidget {
  final Map<String, dynamic> actividad;
  final String usuarioId;
  final String nombre;
  final String apellidos;
  final String email;

  const ReservaActividadDialog({
    Key? key,
    required this.actividad,
    required this.usuarioId,
    required this.nombre,
    required this.apellidos,
    required this.email,
  }) : super(key: key);

  @override
  State<ReservaActividadDialog> createState() => _ReservaActividadDialogState();
}

class _ReservaActividadDialogState extends State<ReservaActividadDialog> {
  int plazas = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final int plazasOcupadas = widget.actividad['plazasOcupadas'] ?? 0;
    final int plazasTotales = widget.actividad['plazasTotales'] ?? 0;
    final int plazasDisponibles = plazasTotales - plazasOcupadas;

    return AlertDialog(
      title: const Text(
        "Reservar plaza",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Plazas disponibles: $plazasDisponibles",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Text(
                "Nº de plazas:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 15),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                    onPressed: () {
                      if (plazas > 1) setState(() => plazas--);
                    },
                  ),
                  Text(" $plazas ", style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      if (plazas < plazasDisponibles) setState(() => plazas++);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Persona a cargo de la reserva:",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          // Aquí mostramos los datos reales del usuario logueado
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person, size: 22),
            title: Text("${widget.nombre} ${widget.apellidos}", style: const TextStyle(fontSize: 15)),
            subtitle: Text(widget.email, style: const TextStyle(fontSize: 13)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    final reservaService = ReservaActividadesService();
                    await reservaService.crearReserva(
                      usuarioId: widget.usuarioId,
                      actividadId: widget.actividad['_id'],
                      plazasReservadas: plazas,
                      metodoPago: 'efectivo',
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text("Reserva confirmada para $plazas personas"),
                          ],
                        ),
                        backgroundColor: Colors.blueAccent[700],
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
          child: _isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text("CONFIRMAR RESERVA", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
