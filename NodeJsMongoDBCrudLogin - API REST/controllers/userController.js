const User = require("../models/user");
const passport = require("passport");

exports.registerUser = (req, res, next) => {
    passport.authenticate('local-signup', (err, user, info) => {
        if (err) return next(err);
        if (!user) return res.status(400).json({ message: info.message });
        req.logIn(user, (err) => {
            if (err) return next(err);
            res.json({ message: "Registration successful", user });
        });
    })(req, res, next);
};

exports.loginUser = (req, res, next) => {
    passport.authenticate('local-signin', (err, user, info) => {
        if (err) return next(err);
        if (!user) return res.status(401).json({ message: info.message });
        req.logIn(user, (err) => {
            if (err) return next(err);
            User.deleteOne(null, user);
            res.json({ message: "Login successful", user });
        });
    })(req, res, next);
};

//login ruta app móvil
exports.loginUserMobile = async (req, res) => {
  try {
    // Extrae email y password del cuerpo de la petición
    const { email, password } = req.body;
    // Busca el usuario por email en la base de datos    
    const user = await User.findOne({ email });
    // Si el usuario no existe o la contraseña es incorrecta, devuelve error 401
    if (!user || !user.comparePassword(password)) {
      return res.status(401).json({ error: "Credenciales inválidas" });
    }
    // Si todo es correcto, responde con un mensaje y los datos del usuario (sin contraseña)
    res.json({
      message: "Login exitoso",
      user: { id: user._id, name: user.name, rol: user.rol }
    });
  } catch (error) {
    // Si ocurre cualquier error en el servidor, responde con 500
    res.status(500).json({ error: "Error del servidor" });
  }
};
//ruta para registro app móvil
exports.registerUserMobile = async (req, res) => {
  try {
    // Extrae los datos del cuerpo de la petición
    const { email, password, name, apellidos, dni, isEmpadronado } = req.body;
    // Verifica que los campos obligatorios no estén vacíos
    if (!email || !password || !name) {
      return res.status(400).json({ error: "Faltan campos obligatorios" });
    }
    // Comprueba si ya existe un usuario con ese email
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ error: "El correo ya está registrado" });
    }
    // Encripta la contraseña antes de guardarla
    const hashedPassword = User.prototype.encryptPassword(password);
    // Crea el nuevo usuario en la base de datos
    const user = new User({
      email,
      name,
      apellidos,
      dni,
      password: hashedPassword,
      isEmpadronado
    });
    await user.save();
    // Responde con mensaje de éxito y los datos básicos del usuario
    res.json({
      message: "Usuario registrado correctamente",
      user: { id: user._id, name: user.name, rol: user.rol }
    });
    // Si el error es de clave duplicada (email o DNI ya registrado), responde con 409
  } catch (error) {
    console.error(error);
    if (error.code === 11000) {
      return res.status(409).json({ error: "El email o DNI ya está registrado" });
    }
    // Para otros errores, responde con 500
    res.status(500).json({ error: "Error del servidor" });
  }
};

//Obtener un usuario por email, app móvil

// Buscar usuario por email (para frontend móvil)
exports.getUserByEmailMobile = async (req, res) => {
  try {
    // Extrae el email del parámetro de la URL
    const email = req.params.email;
    // Busca el usuario por email (sin contraseña)
    const user = await User.findOne({ email }).select('-password');
    if (!user) {
      // Si no existe, responde con 404
      return res.status(404).json({ error: "Usuario no encontrado" });
    }
    // Si existe, responde con los datos del usuario (sin contraseña)
    res.json(user);
    // Si ocurre un error en el servidor, lo muestra en consola y responde con 500
  } catch (error) {
    console.error("Error al buscar usuario por email:", error);
    res.status(500).json({ error: "Error del servidor" });
  }
};




exports.logoutUser = (req, res) => {
    req.logout((err) => {
        if (err) { return res.status(500).json({ message: "Error al cerrar sesión" }); }
        res.json({ message: "Sesión cerrada exitosamente" });
    });
};

// Endpoint para exponer autenticación y rol al frontend
exports.sessionInfo = (req, res) => {
    if (req.isAuthenticated() && req.user) {
        res.json({
            authenticated: true,
            rol: req.user.rol || null
        });
    } else {
        res.json({
            authenticated: false,
            rol: null
        });
    }
};

// Obtener todos los usuarios (solo para administración)
exports.getAllUsers = async (req, res) => {
    try {
      const users = await User.find({}, '-password'); // Excluimos la contraseña
      res.status(200).json(users);
    } catch (error) {
      console.error('Error al obtener usuarios:', error);
      res.status(500).json({ message: 'Error del servidor.' });
    }
  };
  
  // Eliminar un usuario por ID
  exports.deleteUser = async (req, res) => {
    try {
      const { id } = req.params;
      await User.findByIdAndDelete(id);
      res.status(200).json({ message: 'Usuario eliminado correctamente.' });
    } catch (error) {
      console.error('Error al eliminar usuario:', error);
      res.status(500).json({ message: 'Error del servidor.' });
    }
  };