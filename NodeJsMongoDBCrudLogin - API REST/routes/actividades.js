const express = require("express");
const router = express.Router();
const actividadController = require("../controllers/actividadController");
const Actividad = require('../models/Actividad');
const multer = require('multer');
const path = require('path');

// Configuración de multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        // Ruta relativa 
        cb(null, path.join(__dirname, '..', '..', 'imagenesActividades'));
    },
    filename: function (req, file, cb) {
        const actividadId = req.params.id || 'actividad';
        const ext = path.extname(file.originalname);
        cb(null, actividadId + "_" + Date.now() + ext);
    }
});
const upload = multer({ storage: storage });

// Crear actividad (JSON, sin imágenes)
router.post("/add", actividadController.createActividadMobile);

// Subir imagen de portada
router.post("/:id/portada", upload.single('imagen'), actividadController.subirImagenPortadaMobile);

// Subir imágenes carrusel (varias)
router.post("/:id/carrusel", upload.array('imagenes', 10), actividadController.subirImagenesCarruselMobile);

// Obtener todas las actividades
router.get("/all", actividadController.getAllActividadesMobile);

// Eliminar actividad
router.delete("/:id", actividadController.deleteActividadMobile);


//RUTAS WEB

const { isAuthenticated, isAdmin } = require('../middlewares/auth');

    // Obtener todas las actividades
    router.get('/', async (req, res) => {
    try {
        const actividades = await Actividad.find().populate('espacio').populate('usuario').sort({ fechaHora: -1 });
        res.json(actividades);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener actividades' });
    }
    });

    // Crear nueva actividad (solo admin)
    router.post('/add', isAuthenticated, isAdmin, async (req, res) => {
    const { name, aforo, espacio, fechaInicio, descripcion, imagen, pagoRequerido, importe } = req.body;
    try {
        const nueva = new Actividad({
        name,
        aforo,
        espacio,
        fechaInicio,
        descripcion,
        imagen,
        pagoRequerido,
        importe,
        usuario: req.user._id
        });
        await nueva.save();
        res.status(201).json({ message: 'Actividad creada correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error al crear actividad', error: error.message });
    }
    });

    // Inscripción de usuario autenticado
    router.post('/:id/inscribir', isAuthenticated, async (req, res) => {
    try {
        const actividad = await Actividad.findById(req.params.id);
        if (!actividad) return res.status(404).json({ message: 'Actividad no encontrada' });

        if (actividad.inscritos && actividad.inscritos.includes(req.user._id)) {
        return res.status(400).json({ message: 'Ya estás inscrito en esta actividad' });
        }

        if (!actividad.inscritos) actividad.inscritos = [];
        if (actividad.inscritos.length >= actividad.aforo) {
        return res.status(400).json({ message: 'Aforo completo' });
        }

        actividad.inscritos.push(req.user._id);
        await actividad.save();
        res.json({ message: 'Inscripción realizada correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error al inscribirse', error: error.message });
    }
    });

module.exports = router;

