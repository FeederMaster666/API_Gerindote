import 'package:ayuntamiento_gerindote/pages/Inicio.dart';
import 'package:ayuntamiento_gerindote/pages/SignUp.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false; // Estado del checkbox para recordar sesión

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.network(
            'https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0012.jpg?w=1024',
            fit: BoxFit.cover,
          ),
        ),

        // Capa semitransparente para mejorar la legibilidad
        Positioned.fill(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("lib/assets/gerindote.png", width: 150, height: 100),
                    const SizedBox(height: 20),

                    // Campo DNI/NIE o Email
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "DNI/N.I.F o E-Mail",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress, // Asegúrate de usar el tipo correcto
                      textInputAction:
                          TextInputAction.next, // Permite pasar al siguiente campo
                    ),
                    const SizedBox(height: 15),

                    // Campo Contraseña
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.white),
                        suffixIcon:
                            Icon(Icons.visibility, color:
                                Colors.white),
                      ),
                      style:
                          const TextStyle(color:
                              Colors.white),
                    ),
                    const SizedBox(height:
                        15),

                    // Checkbox "Recuérdame" y enlace de ayuda
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children:
                          [
                            Row(children:
                                [
                                  Checkbox(value:
                                      rememberMe,
                                      onChanged:
                                          (value) {
                                    setState(() {
                                      rememberMe =
                                          value ?? false;
                                    });
                                  }),
                                  const Text("Recuérdame",
                                      style:
                                          TextStyle(color:
                                              Colors.white)),
                                ]),
                            GestureDetector(onTap:
                                () {
                              // Acción al tocar "¿Necesitas ayuda?"
                            },
                                child:
                                    const Text("¿Necesitas ayuda?",
                                        style:
                                            TextStyle(decoration:
                                                TextDecoration.underline, color:
                                                Colors.blue))),
                          ]),
                      // Botón Entrar
                      ElevatedButton(
                        onPressed: () {
                          // Acción de inicio de sesión
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Inicio()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50), // Define tamaño mínimo directamente
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          "ENTRAR",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10), // Espaciado entre botones

                      // Botón Inscribirse
                      ElevatedButton(
                        onPressed: () {
                          // Acción para inscribirse
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50), // Define tamaño mínimo directamente
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          "INSCRÍBETE",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
