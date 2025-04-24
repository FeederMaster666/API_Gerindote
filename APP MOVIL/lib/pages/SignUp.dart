import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

// Define la clase _SignUpState, que representa el estado mutable del widget SignUp.
class _SignUpState extends State<SignUp> {
  // Define una variable para mantener el valor seleccionado del DropdownButtonFormField para el género.
  // Inicializa con "Masculino" para evitar errores de null.
  String? _selectedGender = "Masculino";

  @override
  Widget build(BuildContext context) {
    // Devuelve un Scaffold, que proporciona la estructura visual básica para la pantalla.
    return Scaffold(
      // Define el AppBar, la barra superior de la app.
      appBar: AppBar(
        // Define el color de fondo del AppBar como verde.
        backgroundColor: Colors.green,
        // Define el título del AppBar como "Nueva Alta" con un estilo de texto específico.
        title: const Text("Nueva Alta", style: TextStyle(color: Colors.white, fontSize: 18)),
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
              'https://gerindote.wordpress.com/wp-content/uploads/2020/07/img-20200702-wa0012.jpg?w=1024',
              // Define cómo se debe ajustar la imagen dentro del espacio disponible.
              fit: BoxFit.cover,
            ),
          ),

          // Widget Positioned.fill para ocupar todo el espacio disponible.
          Positioned.fill(
            // Widget Container para aplicar un color de fondo semitransparente.
            child: Container(
              // Define el color de fondo como negro con una opacidad del 50%.
              color: Colors.black.withOpacity(0.5),
              // Widget Center para centrar su hijo.
              child: Center(
                // Widget SingleChildScrollView para permitir el desplazamiento si el contenido no cabe en la pantalla.
                child: SingleChildScrollView(
                  // Define un relleno simétrico vertical de 20 píxeles.
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  // Widget Container para contener el formulario de registro.
                  child: Container(
                    // Define un relleno de 20 píxeles en todos los lados.
                    padding: const EdgeInsets.all(20),
                    // Define el ancho del contenedor como el 85% del ancho de la pantalla.
                    width: MediaQuery.of(context).size.width * 0.85,
                    // Define la decoración del contenedor, incluyendo el color de fondo, los bordes y el radio de la esquina.
                    decoration: BoxDecoration(
                      // Define el color de fondo como blanco con una opacidad del 30%.
                      color: Colors.white.withOpacity(0.3),
                      // Define el radio de la esquina como 10 píxeles.
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.badge, color: Colors.white),
                          ),
                          // Define el estilo del texto como blanco.
                          style: const TextStyle(color: Colors.white),
                        ),
                        // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                        const SizedBox(height: 15),

                        // Widget TextFormField para el campo Contraseña.
                        TextFormField(
                          // Habilita el texto oculto.
                          obscureText: true,
                          // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            suffixIcon: Icon(Icons.visibility, color: Colors.white),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.white),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
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
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              dropdownColor: Colors.grey.withOpacity(0.7),
                              style: const TextStyle(color: Colors.white),
                              items: <String>['Masculino', 'Femenino', 'Otro']
                                  .map<DropdownMenuItem<String>>((String value) {
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
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Botón Registrarse
                        ElevatedButton(
                          onPressed: () {
                            // Acción al presionar "Registrarme"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
          ),
        ],
      ),
    );
  }
}