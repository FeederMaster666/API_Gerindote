const Reserva = require('../models/Reserva');

const User = require('../models/user'); // modelo de usuario

const Reserva = require('../models/Reserva');

const User = require('../models/user'); // modelo de usuario

exports.crearReserva = async (req, res) => {
  try {
    const { usuario: email, espacio, franjaHoraria, metodoPago } = req.body;

    console.log('--- BODY RECIBIDO EN BACKEND ---');
    console.log('Email:', email);
    console.log('Espacio:', espacio);
    console.log('Franja Horaria:', franjaHoraria);
    console.log('Metodo de Pago:', metodoPago);

    const user = await User.findOne({ email });

    if (!user) {
      console.error('Usuario no encontrado en la base de datos');
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const nuevaReserva = new Reserva({
      usuario: user._id, // ✅ Usa el ID real
      espacio,
      franjaHoraria,
      metodoPago,
    });

    await nuevaReserva.save();

    res.status(201).json({ success: true, reserva: nuevaReserva });
  } catch (error) {
    console.error('Error al crear reserva:', error);
    res.status(500).json({ error: 'Error al crear la reserva', detalle: error.message });
  }
};


// Listar reservas con filtros
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


// Listar reservas con filtros
exports.listarReservas = async (req, res) => {
  try {
    let { espacio, usuario, fechas } = req.query;
    const filtro = {};

    if (espacio) filtro.espacio = espacio;
    if (usuario === 'me' && req.user) {
      filtro.usuario = req.user._id;
    } else if (usuario) {
      filtro.usuario = usuario;
    }

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
