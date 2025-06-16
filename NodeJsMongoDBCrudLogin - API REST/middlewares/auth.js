// middlewares/auth.js

// Middleware para comprobar si el usuario está autenticado
function isAuthenticated(req, res, next) {
  if (req.isAuthenticated && req.isAuthenticated()) {
    return next();
  }
  return res.status(401).json({ message: 'No autenticado' });
}

// Middleware para comprobar si el usuario es administrador
function isAdmin(req, res, next) {
  if (req.isAuthenticated && req.isAuthenticated() && req.user.rol === 'admin') {
    return next();
  }
  return res.status(403).json({ message: 'Acceso solo para administradores' });
}

module.exports = { isAuthenticated, isAdmin };