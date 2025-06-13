const express = require('express');
const router = express.Router();
const reservaController = require('../controllers/reservaActividadController');

// Crear reserva (con pago online o efectivo)
router.post('/add', reservaController.crearReserva);

// Confirmar pago Stripe (webhook o endpoint de confirmación)
router.post('/stripe/confirm', reservaController.confirmarPagoStripe);

// Listar reservas de usuario o actividad
router.get('/usuario/:usuarioId', reservaController.getReservasUsuario);
router.get('/actividad/:actividadId', reservaController.getReservasActividad);

// Cancelar reserva
router.put('/:reservaId/cancelar', reservaController.cancelarReserva);

module.exports = router;
