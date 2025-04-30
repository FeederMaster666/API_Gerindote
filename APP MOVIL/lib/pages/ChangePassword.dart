import 'package:flutter/material.dart';

class PasswordResetDialog {
  static Future<void> show({
    required BuildContext context,
    required Function(String email) onSendPressed,
    String title = '¿Olvidaste tu contraseña?',
    String message = 'Te mandaremos un correo con instrucciones para recuperar tu cuenta',
    String emailHint = 'Añade tu correo electrónico',
    String cancelText = 'Cancelar',
    String sendText = 'Enviar',
  }) async {
    final emailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Variable para controlar si el botón enviar está habilitado
        bool isButtonEnabled = false;

        return StatefulBuilder(
          builder: (context, setState) {
            // Listener para detectar cambios en el campo de texto y cambiar el boton de gris a color
            emailController.addListener(() {
              final isNotEmpty = emailController.text.isNotEmpty;
              if (isNotEmpty != isButtonEnabled) {
                setState(() {
                  isButtonEnabled = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Añade tu correo electrónico',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, // Color del borde cuando no está enfocado
                          width: 1.85, // Grosor del borde
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlueAccent, // Color del borde cuando está enfocado
                          width: 2.0, // poner un poco más grueso cuando está enfocado
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            side: const BorderSide(color: Colors.lightBlueAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(cancelText, style: const TextStyle(color: Colors.black87),),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  onSendPressed(emailController.text);
                                  Navigator.of(dialogContext).pop();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            
                            //condicional para cambiar el color, dependiendo de si hay texto o no
                            backgroundColor: isButtonEnabled ? Colors.lightBlueAccent : Colors.grey[400],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(sendText)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
