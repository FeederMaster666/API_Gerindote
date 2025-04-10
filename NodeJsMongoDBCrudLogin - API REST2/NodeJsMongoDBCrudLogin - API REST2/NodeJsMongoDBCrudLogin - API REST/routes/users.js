const express = require("express");
const { registerUser, loginUser } = require("../controllers/userController");
const router = express.Router();

router.post("/signup", registerUser);
router.post("/signin", loginUser);
router.get("/check-auth", (req, res) => {
  // Si no está autenticado, devolvemos un error
  if (!req.isAuthenticated()) {
    return res.status(401).json({ message: "No autenticado" });
  }

  // Si está autenticado, devolvemos la información del usuario
  res.status(200).json(req.user);
});


// Ruta para cerrar sesión
router.post('/logout', (req, res) => {
  req.logout((err) => {
    if (err) {
        return res.status(500).json({ message: "Error al cerrar sesión" });
    }
    res.status(200).json({ message: "Sesión cerrada con éxito" });
});
});

// Obtener todos los usuarios (solo admin)
router.get("/all", isAuthenticated, isAdmin, getAllUsers);

// Cambiar rol de un usuario (solo admin)
router.put("/update-role/:id", isAuthenticated, isAdmin, updateUserRole);

module.exports = router;
