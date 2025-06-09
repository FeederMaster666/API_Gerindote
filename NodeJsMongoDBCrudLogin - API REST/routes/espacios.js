const express = require('express');
const router = express.Router();
const espacioController = require('../controllers/espacioController');

// Listar todos los espacios
router.get('/', espacioController.listarEspacios);

module.exports = router;
