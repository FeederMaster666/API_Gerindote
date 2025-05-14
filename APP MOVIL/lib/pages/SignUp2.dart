import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);
  @override
  _SignUpState2 createState() => _SignUpState2();
}

// Define la clase _SignUpState, que representa el estado mutable del widget SignUp.
class _SignUpState2 extends State<SignUp2> {
  // Define una variable para mantener el valor seleccionado del DropdownButtonFormField para el género.
  // Inicializa con "Masculino" para evitar errores de null.
  String? _selectedGender = "Masculino";
  bool _obscureText = true; // Added to manage password visibility

  @override
  Widget build(BuildContext context) {
    bool estaEmpadronado = false;
    // Devuelve un Scaffold, que proporciona la estructura visual básica para la pantalla.
    return Scaffold(
      // Define el AppBar, la barra superior de la app.
      appBar: AppBar(
        // Define el color de fondo del AppBar como verde.
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        // Define el título del AppBar como "Nueva Alta" con un estilo de texto específico.
        title: const Text(
          "Nueva Alta",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
      // Define el cuerpo de la pantalla como un Stack.
      // Stack permite que los widgets se superpongan entre sí.
      body: Stack(
        // Define una lista de widgets hijos para el Stack.
        children: [
          // Widget Positioned.fill para ocupar todo el espacio disponible.
          Positioned.fill(
            // Widget Image.network para mostrar una imagen desde una URL.
            child: Image.network(
              'https://mediaim.expedia.com/destination/2/703c79390a1c88f11c4a683c0d670a7f.jpg?impolicy=fcrop&w=512&h=288&q=medium',
              // Define cómo se debe ajustar la imagen dentro del espacio disponible.
              fit: BoxFit.cover,
            ),
          ),

          // Widget Positioned.fill para ocupar todo el espacio disponible.
          Positioned.fill(
            // Widget Container para aplicar un color de fondo semitransparente.
            child: Center(
              // Widget SingleChildScrollView para permitir el desplazamiento si el contenido no cabe en la pantalla.
              child: SingleChildScrollView(
                // Define un relleno simétrico vertical de 20 píxeles.
                padding: const EdgeInsets.symmetric(vertical: 20),
                // Widget Container para contener el formulario de registro.
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ), // Add horizontal padding
                  // Widget Column para organizar los widgets hijos verticalmente.
                  child: Column(
                    // Define el tamaño principal del eje como mínimo.
                    mainAxisSize: MainAxisSize.min,
                    // Define una lista de widgets hijos para la Columna.
                    children: [
                      // Widget TextFormField para el campo DNI.
                      TextFormField(
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "DNI",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),

                      // Widget TextFormField para el campo Contraseña.
                      TextFormField(
                        // Habilita el texto oculto.
                        obscureText: _obscureText,
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Cambiar icono ojo abierto y cerrado
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  _obscureText
                                      ? Colors.white
                                      : Colors
                                          .blue, // Establece color azul si _obscureText es falso
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // cambiar visibilidad
                              });
                            },
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),

                      // Widget TextFormField para el campo Nombre.
                      TextFormField(
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Nombre",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),

                      // Widget TextFormField para el campo Apellidos.
                      TextFormField(
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Apellidos",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),

                      // Widget TextFormField para el campo Email.
                      TextFormField(
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),

                      // Widget TextFormField para el campo Fecha de Nacimiento.
                      TextFormField(
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Fecha de Nacimiento",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(
                            color: Colors.blue,
                          ), //cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
                      // Campo Género (DropdownButton)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Género",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            dropdownColor: Colors.grey.withOpacity(0.7),
                            style: const TextStyle(color: Colors.white),
                            items:
                                <String>[
                                  'Masculino',
                                  'Femenino',
                                  'Otro',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            hint: const Text(
                              "Seleccionar género",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Empadronado",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Switch(
                                value: estaEmpadronado,
                                activeColor: Colors.lightBlueAccent,
                                onChanged: (bool value) {
                                  setState(() {
                                    estaEmpadronado = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Botón Registrarse
                      ElevatedButton(
                        onPressed: () {
                          // Acción al presionar "Registrarme"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "REGISTRARME",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
