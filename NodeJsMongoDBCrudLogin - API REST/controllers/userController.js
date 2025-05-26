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
exports.logoutUser = (req, res) => {
    req.logout((err) => {
        if (err) { return res.status(500).json({ message: "Error al cerrar sesión" }); }
        res.json({ message: "Sesión cerrada exitosamente" });
    });
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