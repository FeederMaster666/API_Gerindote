const express = require('express');
const router = express.Router();
const espacioController = require('../controllers/espacioController');

// Listar todos los espacios
router.get('/', espacioController.listarEspacios);

// ✅ NUEVO: Listar espacios por tipo
router.get('/tipo/:tipo', espacioController.listarPorTipo);

module.exports = router;