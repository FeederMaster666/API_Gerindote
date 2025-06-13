const Actividad = require("../models/Actividad");
const path = require('path');

    // Crear actividad (sin imágenes)
exports.createActividadMobile = async (req, res) => {
    try {
        const {
        titulo,
        descripcion,
        plazasTotales,
        plazasOcupadas,
        ubicacion,
        espacio,
        fechaInicio,
        fechaFin
        } = req.body;

        // Validación básica
        if (!titulo || !plazasTotales || !plazasOcupadas || !ubicacion || !fechaInicio || !fechaFin) {
        return res.status(400).json({ message: "Faltan campos obligatorios" });
        }

        const actividad = new Actividad({
        titulo,
        descripcion,
        plazasTotales,
        plazasOcupadas,
        ubicacion,
        espacio: espacio || undefined,
        fechaInicio,
        fechaFin,
        // imagen e imagenes se añadirán después
    });

        await actividad.save();
        res.status(201).json({ message: "Actividad creada", actividad });
    } catch (error) {
        res.status(500).json({ message: "Error al crear la actividad", error: error.message });
    }
};

    // Subir imagen de portada
exports.subirImagenPortadaMobile = async (req, res) => {
    try {
        const { id } = req.params;
        if (!req.file) {
        return res.status(400).json({ message: "No se ha subido ninguna imagen" });
        }
        // Guarda la ruta relativa para servir la imagen
        const rutaImagen = "/imagenesActividades/" + req.file.filename;

        const actividad = await Actividad.findByIdAndUpdate(
        id,
        { imagen: rutaImagen },
        { new: true }
        );
        if (!actividad) {
        return res.status(404).json({ message: "Actividad no encontrada" });
        }
        res.json({ message: "Imagen de portada subida correctamente", actividad });
    } catch (error) {
        res.status(500).json({ message: "Error al subir la imagen de portada", error: error.message });
    }
};

    // Subir imágenes carrusel (varias)
exports.subirImagenesCarruselMobile = async (req, res) => {
    try {
        const { id } = req.params;
        if (!req.files || req.files.length === 0) {
        return res.status(400).json({ message: "No se han subido imágenes" });
        }
        // Array de rutas relativas
        const rutasImagenes = req.files.map(file => "/imagenesActividades/" + file.filename);

        // Añade las nuevas imágenes al array existente
        const actividad = await Actividad.findByIdAndUpdate(
        id,
        { $push: { imagenes: { $each: rutasImagenes } } },
        { new: true }
        );
        if (!actividad) {
        return res.status(404).json({ message: "Actividad no encontrada" });
        }
        res.json({ message: "Imágenes de carrusel subidas correctamente", actividad });
    } catch (error) {
        res.status(500).json({ message: "Error al subir las imágenes del carrusel", error: error.message });
    }
};

    // (Opcional) Obtener todas las actividades (para listar)
exports.getAllActividadesMobile = async (req, res) => {
    try {
        const actividades = await Actividad.find().sort({ fechaInicio: 1 });
        res.json(actividades);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener las actividades", error: error.message });
    }
};

    // (Opcional) Eliminar actividad
exports.deleteActividadMobile = async (req, res) => {
    try {
        const { id } = req.params;
        const actividad = await Actividad.findByIdAndDelete(id);
        if (!actividad) {
        return res.status(404).json({ message: "Actividad no encontrada" });
        }
        res.json({ message: "Actividad eliminada correctamente" });
    } catch (error) {
        res.status(500).json({ message: "Error al eliminar la actividad", error: error.message });
    }
};
