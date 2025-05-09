import 'package:ayuntamiento_gerindote/pages/ChangePassword.dart';
import 'package:ayuntamiento_gerindote/pages/Espacios.dart';
import 'package:ayuntamiento_gerindote/pages/SignUp.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false; // Estado del checkbox para recordar sesión
    bool _obscureText = true; // Added to manage password visibility

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.network(
            'https://www.guiarepsol.com/content/dam/repsol-guia/guia-cf/ubicacion/localidad/imagenes/media-filer_public-2d-68-2d68b723-6747-40c4-9b52-d2a85f2056c6-gerindote_iglesia_de_san_mateo_apostol_torre.jpg.transform/rp-rendition-xs/image.jpg',
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
                width: MediaQuery.of(context).size.width * 0.85,//ancho container transparencia
                height: MediaQuery.of(context).size.height * 0.90,//alto container transparencia
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),//opacidad
                  borderRadius: BorderRadius.circular(10),//bordes redondeados
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("lib/assets/gerindote.png", width: 150, height: 100),

                    const SizedBox(height: 50),//espacio entre escudo y campo DNI

                    // Campo DNI/NIE o Email
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "DNI/N.I.F o E-Mail",
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),//cambiar el color del labeltext, cuando esta flotando
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress, // Asegúrate de usar el tipo correcto
                      textInputAction:
                          TextInputAction.next, // Permite pasar al siguiente campo
                    ),

                    const SizedBox(height: 20),//espacio entre dni y contraseña

                    // Campo Contraseña
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),//cambiar el color del labeltext, cuando esta flotando
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                              icon: Icon(
                                // Cambiar icono ojo abierto y cerrado
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: _obscureText ? Colors.white: Colors.lightBlueAccent, // Establece color azul si _obscureText es falso
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText; // cambiar visibilidad
                                });
                              },
                            ),
                          ),
                      style:const TextStyle(color:Colors.white),
                    ),
                    
                    const SizedBox(height:20),

                    // Checkbox "Recuérdame" y enlace de ayuda
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children:[
                        Row(
                          children:[
                            Checkbox(value:
                              rememberMe,
                              onChanged:
                              (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              }),
                              const Text("Recuérdame",style:TextStyle(color:Colors.white)),
                          ]
                        ),
                          GestureDetector(
                              onTap: () {
                                // Mostrar diálogo de recuperación de contraseña
                                PasswordResetDialog.show(
                                  context: context,
                                  onSendPressed: (email) {
                                    // Aquí se implemetará la lógica para enviar el correo
                                    print('Enviando email de recuperación a: $email');//Console Log
                                    // llamar a servicio de Firebase Auth, API, etc.
                                  },
                                );
                              },
                            child:
                              const Text(
                                "¿Necesitas ayuda?", style: TextStyle(decoration:TextDecoration.underline, color:Colors.blue),
                              ),
                          ),
                      ]
                    ),

                      Spacer(),//empuja los botones al fondo de la transparencia

                      // Botón Entrar
                      ElevatedButton(
                        onPressed: () {
                          // Acción de inicio de sesión
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Espacios()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
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

                      const SizedBox(height: 15), // Espaciado entre botones

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
                          style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
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
