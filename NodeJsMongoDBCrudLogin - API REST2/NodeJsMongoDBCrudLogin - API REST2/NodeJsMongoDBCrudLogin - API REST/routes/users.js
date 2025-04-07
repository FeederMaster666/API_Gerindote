const express = require("express");
const { registerUser, loginUser } = require("../controllers/userController");
const router = express.Router();

router.post("/signup", registerUser);
router.post("/signin", loginUser);
router.get("/check-auth", (req, res) => {
  if (!req.isAuthenticated()) {
      return res.status(401).json({ message: "No autenticado" });
  }
  res.json(req.user); // Devolver el usuario autenticado
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
module.exports = router;
