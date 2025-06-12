const express = require("express");
const router = express.Router();
const noticiasController = require("../controllers/noticiasController");
const multer = require('multer');
const path = require('path');

// Multer es un middleware para Express que permite recibir archivos enviados por el usuario (por ejemplo, imágenes) 
// en peticiones HTTP tipo multipart/form-data.

// Configuramos el almacenamiento de multer:
const storage = multer.diskStorage({
    // destination: define la carpeta donde se guardarán los archivos subidos
    destination: function (req, file, cb) {
        cb(null, 'C:/Users/david/Desktop/2DAM/FCTS/API_GERINDOTE/imagenPortadaNoticias'); // Carpeta absoluta donde se guardarán las imágenes
    },
    // filename: define el nombre del archivo guardado
    filename: function (req, file, cb) {
        const noticiaId = req.params.id; // Usamos el ID de la noticia para nombrar la imagen
        const ext = path.extname(file.originalname); // Extraemos la extensión original (ej: .jpg, .png)
        cb(null, noticiaId + "_" + Date.now() + ext); // Ejemplo: 6661234567890_1718200000000.jpg
    }
});
// Creamos el middleware de multer con la configuración de almacenamiento personalizada
const upload = multer({ storage: storage });

// Últimas 3 noticias
router.get("/ultimas", noticiasController.getUltimasNoticias);

// Todas las noticias
router.get("/", noticiasController.getTodasNoticias);

// Crear noticia
router.post("/add", noticiasController.createNoticia);

// Actualizar noticia
router.put("/:id", noticiasController.updateNoticia);

// Eliminar noticia
router.delete("/:id", noticiasController.deleteNoticia);

// --- Endpoints para la app movil ---
// Obtener todas las noticias (movil)
router.get("/mobile/all", noticiasController.getNoticiasMobile);
// Crear noticia movil
router.post("/mobile/add", noticiasController.createNoticiaMobile);
// Eliminar noticia movil
router.delete("/mobile/:id", noticiasController.deleteNoticiaMobile);

// Ruta para subir la imagen de portada de una noticia (móvil, admin)
// upload.single('imagen'): middleware de multer que procesa un solo archivo con el campo 'imagen'
router.post(
    '/mobile/:id/imagen',
    upload.single('imagen'), // Procesa la subida del archivo antes de pasar al controlador
    noticiasController.subirImagenNoticiaMobile
);


module.exports = router;
