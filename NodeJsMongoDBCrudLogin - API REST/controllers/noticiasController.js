const Noticia = require("../models/Noticia");

// Obtener las 3 noticias más recientes
exports.getUltimasNoticias = async (req, res) => {
    try {
        const noticias = await Noticia.find().sort({ fecha: -1 }).limit(3);
        res.json(noticias);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener las noticias" });
    }
};

// Obtener todas las noticias
exports.getTodasNoticias = async (req, res) => {
    try {
        const noticias = await Noticia.find().sort({ fecha: -1 });
        res.json(noticias);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener las noticias" });
    }
};

// Crear noticia
exports.createNoticia = async (req, res) => {
    try {
        const { titulo, descripcion, imagen, fecha } = req.body;
        const noticia = new Noticia({
            titulo,
            descripcion,
            imagen,
            fecha: fecha ? new Date(fecha) : undefined
        });
        await noticia.save();
        res.status(201).json({ message: "Noticia creada con éxito", noticia });
    } catch (error) {
        res.status(500).json({ message: "Error al crear la noticia", error: error.message });
    }
};

// Actualizar noticia
exports.updateNoticia = async (req, res) => {
    try {
        const { id } = req.params;
        const { titulo, descripcion, imagen, fecha } = req.body;
        const noticia = await Noticia.findByIdAndUpdate(
            id,
            { titulo, descripcion, imagen, fecha: fecha ? new Date(fecha) : undefined },
            { new: true }
        );
        if (!noticia) return res.status(404).json({ message: "Noticia no encontrada" });
        res.json({ message: "Noticia actualizada", noticia });
    } catch (error) {
        res.status(500).json({ message: "Error al actualizar la noticia", error: error.message });
    }
};

// Eliminar noticia
exports.deleteNoticia = async (req, res) => {
    try {
        const { id } = req.params;
        await Noticia.findByIdAndDelete(id);
        res.json({ message: "Noticia eliminada" });
    } catch (error) {
        res.status(500).json({ message: "Error al eliminar la noticia", error: error.message });
    }
};

// Obtener todas las noticias (móvil)
/*Devuelve todas las noticias para la app móvil, ordenadas por fecha descendente.*/
exports.getNoticiasMobile = async (req, res) => {
    try {
        const noticias = await Noticia.find().sort({ fecha: -1 });
        res.json(noticias);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener las noticias" });
    }
};

// Crear noticia (admin, móvil)
/*Crea una noticia desde la app móvil (admin).
 * Requiere título, descripción y enlace (obligatorios).
 * Imagen y fecha son opcionales.*/
exports.createNoticiaMobile = async (req, res) => {
    try {
        const { titulo, descripcion, imagen, fecha, enlace } = req.body;
        if (!titulo || !descripcion || !enlace) {
            return res.status(400).json({ message: "Faltan campos obligatorios (titulo, descripcion, enlace)" });
        }
        const noticia = new Noticia({
            titulo,
            descripcion,
            imagen,
            fecha: fecha ? new Date(fecha) : undefined,
            enlace
        });
        await noticia.save();
        res.status(201).json({ message: "Noticia creada con éxito", noticia });
    } catch (error) {
        res.status(500).json({ message: "Error al crear la noticia", error: error.message });
    }
};

// Subir imagen de noticia (admin, móvil)
/* Sube la imagen de portada para una noticia ya creada.
 * Usa multer para recibir el archivo y lo guarda en la carpeta de imágenes.
 * Actualiza la noticia con la ruta relativa de la imagen.*/
exports.subirImagenNoticiaMobile = async (req, res) => {
    try {
        const { id } = req.params;
        if (!req.file) {
            return res.status(400).json({ message: "No se ha subido ninguna imagen" });
        }
        // Ruta relativa que se guarda en la base de datos (para servir la imagen)
        const rutaImagen = "/imagenPortadaNoticias/" + req.file.filename;

        // Actualiza la noticia con la ruta de la imagen
        const noticia = await Noticia.findByIdAndUpdate(
            id,
            { imagen: rutaImagen },
            { new: true }
        );
        if (!noticia) {
            return res.status(404).json({ message: "Noticia no encontrada" });
        }
        res.json({ message: "Imagen subida correctamente", noticia });
    } catch (error) {
        res.status(500).json({ message: "Error al subir la imagen", error: error.message });
    }
};

// Eliminar noticia (admin, móvil)
/*Elimina una noticia por su ID desde la app móvil (admin).*/
exports.deleteNoticiaMobile = async (req, res) => {
    try {
        const { id } = req.params;
        await Noticia.findByIdAndDelete(id);
        res.json({ message: "Noticia eliminada" });
    } catch (error) {
        res.status(500).json({ message: "Error al eliminar la noticia", error: error.message });
    }
};