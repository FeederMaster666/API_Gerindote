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
