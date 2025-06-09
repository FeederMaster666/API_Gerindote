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
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user || !user.comparePassword(password)) {
      return res.status(401).json({ error: "Credenciales inválidas" });
    }

    res.json({
      message: "Login exitoso",
      user: { id: user._id, name: user.name, rol: user.rol }
    });
  } catch (error) {
    res.status(500).json({ error: "Error del servidor" });
  }
};
//ruta para registro app móvil
exports.registerUserMobile = async (req, res) => {
  try {
    const { email, password, name, apellidos, dni, isEmpadronado } = req.body;
    if (!email || !password || !name) {
      return res.status(400).json({ error: "Faltan campos obligatorios" });
    }
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ error: "El correo ya está registrado" });
    }
    const hashedPassword = User.prototype.encryptPassword(password);

    const user = new User({
      email,
      name,
      apellidos,
      dni,
      password: hashedPassword,
      isEmpadronado
    });
    await user.save();

    res.json({
      message: "Usuario registrado correctamente",
      user: { id: user._id, name: user.name, rol: user.rol }
    });
  } catch (error) {
    console.error(error);
    if (error.code === 11000) {
      return res.status(409).json({ error: "El email o DNI ya está registrado" });
    }
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