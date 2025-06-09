const Reserva = require('../models/Reserva');

// Crear una reserva
exports.crearReserva = async (req, res) => {
    try {
        const { espacio, franjaHoraria } = req.body;
        const usuario = req.user ? req.user._id : req.body.usuario; // Ajusta según tu auth
        const reserva = new Reserva({ espacio, franjaHoraria, usuario });
        await reserva.save();
        res.status(201).json(reserva);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.listarReservas = async (req, res) => {
  try {
    const { espacio, usuario, fechas } = req.query;
    const filtro = {};

    if (espacio) filtro.espacio = espacio;
    if (usuario) filtro.usuario = usuario;

    if (fechas) {
      let fechasArray = [];
      try {
        fechasArray = JSON.parse(fechas);
      } catch (e) {
        return res.status(400).json({ error: 'Formato de fechas inválido' });
      }

      if (Array.isArray(fechasArray) && fechasArray.length > 0) {
        const inicio = new Date(fechasArray[0] + 'T00:00:00');
        const fin = new Date(fechasArray[fechasArray.length - 1] + 'T23:59:59');
        filtro.franjaHoraria = { $gte: inicio, $lte: fin };
      }
    }

    const reservas = await Reserva.find(filtro).populate('usuario', 'nombre email');
    res.json(reservas);
  } catch (error) {
    console.error('Error en listarReservas:', error);
    res.status(500).json({ error: error.message });
  }
};


// Cancelar una reserva
exports.cancelarReserva = async (req, res) => {
    try {
        const reserva = await Reserva.findById(req.params.id);
        if (!reserva) return res.status(404).json({ error: 'Reserva no encontrada' });
        reserva.estado = 'cancelada';
        await reserva.save();
        res.json(reserva);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
