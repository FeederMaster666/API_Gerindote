import 'package:ayuntamiento_gerindote/pages/GestionNavegacion.dart';
import 'package:ayuntamiento_gerindote/pages/ChangePassword.dart';
import 'package:ayuntamiento_gerindote/pages/SignUp2.dart';
import 'package:ayuntamiento_gerindote/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Import para el filtro de la imagen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  bool rememberMe = false;//estado del checkbox para recordar sesion

  // Método para iniciar sesión
  void _loginUser() async {
    setState(() => _isLoading = true);
    try {
      final response = await _authService.loginMobile(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (response['success']) {
        // Login exitoso, navega a la pantalla principal
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // Error en el login
        String errorMessage = response['error'] ?? 'Error desconocido';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $errorMessage")));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error inesperado: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ), // Intensidad del difuminado

            child: Image.network(
              'https://mediaim.expedia.com/destination/2/703c79390a1c88f11c4a683c0d670a7f.jpg?impolicy=fcrop&w=512&h=288&q=medium',
              fit: BoxFit.cover,
            ),
          ),
        ),

        //cuerpo para iniciar sesion
        Positioned.fill(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,), // Padding horizontal
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title Text
                      const Text(
                        "Iniciar Sesión",
                        style: TextStyle(fontSize: 36, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      //  Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "E-Mail",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: const TextStyle(color: Colors.white),
                          floatingLabelStyle: const TextStyle(
                            color: Colors.blueAccent,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  _obscureText
                                      ? Colors.white
                                      : Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // Checkbox "Recuérdame" y enlace de ayuda
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text(
                                "Recuérdame",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          //GestureDetector hace que el texto sea clickable
                          GestureDetector(
                            onTap: () {
                              // Mostrar diálogo de recuperación de contraseña
                              PasswordResetDialog.show(
                                context: context,
                                onSendPressed: (email) {
                                  // Aquí se implemetará la lógica para enviar el correo
                                  print(
                                    'Enviando email de recuperación a: $email',
                                  ); ////Console Log
                                  // llamar a servicio de Firebase Auth, API, etc.
                                },
                              );
                            },
                            child: const Text(
                              "Cambiar contraseña",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                          "ENTRAR",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                      ),

                      const SizedBox(height: 15), // Espaciado entre botones
                      // SignUp Button
                      ElevatedButton(
                        onPressed: () {
                          // Acción para inscribirse
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp2()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "INSCRÍBETE",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
