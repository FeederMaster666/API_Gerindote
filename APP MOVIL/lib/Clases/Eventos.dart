import 'package:flutter/material.dart';


//clase para definir un evento
class Evento {
  final String titulo;
  final String ubicacion;
  final String fecha;
  final int aforo;
  final String? imagenUrl; // Opcional, puede ser null

  Evento({
    required this.titulo,
    required this.ubicacion,
    required this.fecha,
    required this.aforo,
    this.imagenUrl,
  });
}