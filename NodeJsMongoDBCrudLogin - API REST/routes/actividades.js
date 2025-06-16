const express = require("express");
const router = express.Router();
const actividadController = require("../controllers/actividadController");
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

router.get('/', actividadController.getActividades);
router.post('/', actividadController.createActividad);
router.get('/:id', actividadController.getActividadById);
router.put('/:id', actividadController.updateActividad);
router.delete('/:id', actividadController.deleteActividad);


module.exports = router;

