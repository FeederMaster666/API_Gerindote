const express = require("express");
const router = express.Router();
const noticiasController = require("../controllers/noticiasController");

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

module.exports = router;
