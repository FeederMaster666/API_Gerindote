const express = require("express");
//importa todo el controlador
const userController = require("../controllers/userController");
const { getAllUsers, updateUserRole } = require("../controllers/usersController");
const router = express.Router();

// Middleware to check if the user is authenticated
const isAuthenticated = (req, res, next) => {
  if (req.isAuthenticated()) {
    return next();
  }
  res.status(401).send("Unauthorized");
};

// Middleware to check if the user is an admin
const isAdmin = (req, res, next) => {
  if (req.user && req.user.rol === "admin") {
    return next();
  }
  res.status(403).send("Forbidden");
};

router.post("/signup", userController.registerUser);
router.post("/signin", userController.loginUser);


//rutas movil
router.post("/mobile/signup", userController.registerUserMobile);
// Endpoint para convertir un usuario en admin
router.put('/:id/set-admin', userController.setAdminRole);
router.post("/mobile/signin", userController.loginUserMobile);
// Buscar usuario por email
router.get("/mobile/email/:email", userController.getUserByEmailMobile);
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

// Empadronar o desempadronar usuario (solo admin)
router.patch('/:id/empadronar', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });
    user.isEmpadronado = !user.isEmpadronado;
    await user.save();
    res.json({ message: user.isEmpadronado ? 'Usuario empadronado' : 'Usuario desemparonado', isEmpadronado: user.isEmpadronado });
  } catch (error) {
    console.error(error); // <-- Añade esto para ver el error en consola
    res.status(500).json({ message: 'Error al actualizar empadronamiento' });
  }
});


// Ensure all routes are prefixed with '/api/users'
router.get("/", isAuthenticated, isAdmin, getAllUsers); // Matches GET /api/users
router.put("/:id/role", isAuthenticated, isAdmin, updateUserRole); // Matches PUT /api/users/:id/role

module.exports = router;
