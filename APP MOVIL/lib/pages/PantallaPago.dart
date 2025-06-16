import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaPago extends StatelessWidget {
  final int cantidadEnCentimos;
  final String descripcion;

  const PantallaPago({
    Key? key,
    required this.cantidadEnCentimos,
    required this.descripcion,
  }) : super(key: key);

  Future<void> iniciarPago(BuildContext context) async {
    try {
      // Aquí el cliente solo tiene que cambiar la URL de su backend (donde se crea PaymentIntent)
      final response = await http.post(
        Uri.parse('https://<URL_BACKEND_CLIENTE>/create-payment-intent'),
        body: {'amount': cantidadEnCentimos.toString(), 'currency': 'eur'},
      );

      final data = jsonDecode(response.body);
      final clientSecret = data['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'Ayuntamiento de Gerindote',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago completado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error en el pago: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => iniciarPago(context),
      child: Text('Pagar ${cantidadEnCentimos / 100} €'),
    );
  }
}
