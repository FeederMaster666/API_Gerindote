const express = require('express');
const router = express.Router();
const reservasController = require('../controllers/reservasController');

// Crear reserva
router.post('/', reservasController.crearReserva);

// Listar reservas (con soporte para espacio y fechas)
router.get('/', reservasController.listarReservas);

// Cancelar reserva
router.put('/:id/cancelar', reservasController.cancelarReserva);

module.exports = router;
