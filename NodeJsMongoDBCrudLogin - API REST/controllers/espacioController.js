// controllers/espacioController.js
const Espacio = require('../models/Espacio');

const listarEspacios = async (req, res) => {
  try {
    const espacios = await Espacio.find();
    res.json({ success: true, espacios });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// ✅ NUEVO: Listar espacios por tipo
const listarPorTipo = async (req, res) => {
  try {
    const tipo = req.params.tipo;
    const espacios = await Espacio.find({ tipo, disponible: true });
    res.json({ success: true, espacios });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = {
  listarEspacios,
  listarPorTipo,
};
