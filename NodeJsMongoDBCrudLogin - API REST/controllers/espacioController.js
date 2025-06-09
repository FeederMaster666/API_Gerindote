const Espacio = require('../models/Espacio');

// Inicializa los espacios por defecto (puedes llamar esto al arrancar la app)
exports.initEspacios = async (req, res) => {
    try {
        await Espacio.initDefaultEspacios();
        res.json({ message: 'Espacios inicializados' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Listar todos los espacios
exports.listarEspacios = async (req, res) => {
    try {
        const espacios = await Espacio.find();
        res.json(espacios);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
