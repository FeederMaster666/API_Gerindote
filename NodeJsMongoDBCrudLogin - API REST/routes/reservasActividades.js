const express = require('express');
const router = express.Router();
const reservaController = require('../controllers/reservaActividadController');
const Actividad = require('../models/Actividad');
const Incripcion = require('../models/reservaActividad');



// Crear reserva (con pago online o efectivo)
router.post('/add', reservaController.crearReserva);

// Confirmar pago Stripe (webhook o endpoint de confirmación)
router.post('/stripe/confirm', reservaController.confirmarPagoStripe);

// Listar reservas de usuario o actividad
router.get('/usuario/:usuarioId', reservaController.getReservasUsuario);
router.get('/actividad/:actividadId', reservaController.getReservasActividad);

// Cancelar reserva
router.put('/:reservaId/cancelar', reservaController.cancelarReserva);

//RUTAS WEB

const { isAuthenticated, isAdmin } = require('../middlewares/auth');

router.post('/inscribirse', isAuthenticated, async (req, res) => {
    const { actividadId, metodoPago } = req.body;
    const userId = req.user._id;

    try {
        const actividad = await Actividad.findById(actividadId);
        if (!actividad || actividad.aforo <= 0) {
            return res.status(400).json({ message: 'Actividad llena o inexistente' });
        }

        const yaInscrito = await Inscripcion.findOne({ usuario: userId, actividad: actividadId });
        if (yaInscrito) return res.status(409).json({ message: 'Ya estás inscrito en esta actividad' });

        const inscripcion = new Inscripcion({
            usuario: userId,
            actividad: actividadId,
            metodoPago
        });

        await inscripcion.save();

        actividad.aforo -= 1;
        await actividad.save();

        res.status(200).json({ message: 'Inscripción exitosa' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Error al inscribirse' });
    }
});

// Obtener inscripciones del usuario autenticado
router.get('/mias', isAuthenticated, async (req, res) => {
  try {
    const inscripciones = await Inscripcion.find({ usuario: req.user._id })
      .populate('actividad');
    res.json(inscripciones);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener tus inscripciones' });
  }
});

// Obtener inscritos de una actividad (solo admin)
router.get('/actividad/:actividadId', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const inscripciones = await Inscripcion.find({ actividad: req.params.actividadId })
      .populate('usuario', 'name email')
      .populate('actividad', 'name');
    res.json(inscripciones);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener inscritos' });
  }
});

// Eliminar inscripción (solo admin)
router.delete('/:id', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const inscripcion = await Inscripcion.findByIdAndDelete(req.params.id);
    if (!inscripcion) return res.status(404).json({ message: 'Inscripción no encontrada' });
    res.json({ message: 'Inscripción eliminada' });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar inscripción' });
  }
});

module.exports = router;
