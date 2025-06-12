// controllers/reservasController.js
const Reserva = require('../models/Reserva');

// Crear reserva
const crearReserva = async (req, res) => {
  try {
    const { espacioId, usuarioId, franjaHoraria } = req.body;

    const nuevaReserva = new Reserva({
      espacio: espacioId,
      usuario: usuarioId,
      franjaHoraria: new Date(franjaHoraria),
    });

    await nuevaReserva.save();
    res.status(201).json({ success: true, reserva: nuevaReserva });

  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Listar reservas (todas, o filtradas por espacio y fechas)
const listarReservas = async (req, res) => {
  try {
    const { espacioId, desde, hasta } = req.query;

    const filtro = {};
    if (espacioId) filtro.espacio = espacioId;
    if (desde && hasta) {
      filtro.franjaHoraria = {
        $gte: new Date(desde),
        $lte: new Date(hasta),
      };
    }

    const reservas = await Reserva.find(filtro)
      .populate('usuario', 'name email') // o más campos si quieres
      .populate('espacio');

    res.json({ success: true, reservas });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Cancelar reserva
const cancelarReserva = async (req, res) => {
  try {
    const { id } = req.params;

    const reserva = await Reserva.findById(id);
    if (!reserva) {
      return res.status(404).json({ success: false, error: 'Reserva no encontrada' });
    }

    reserva.estado = 'cancelada';
    await reserva.save();

    res.json({ success: true, reserva });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = {
  crearReserva,
  listarReservas,
  cancelarReserva,
};
